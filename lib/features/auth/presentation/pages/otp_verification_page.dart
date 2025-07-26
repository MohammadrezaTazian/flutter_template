import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/core/constants/colors.dart';
import 'package:my_app/core/constants/routes.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:my_app/features/auth/utils/mobile_number_cache.dart'; // اضافه کردن این خط
import 'package:my_app/features/auth/presentation/widgets/app_logo_widget.dart';
import 'package:my_app/features/auth/presentation/widgets/input_field_widget.dart';

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print('OTP Verification - Auth State Changed: ${state.runtimeType}');
          if (state is OtpVerified) {
            print('OTP Verified - Navigating to Home');
            // پاک کردن Cache بعد از تایید موفق
            MobileNumberCache.clear();
            Navigator.pushNamedAndRemoveUntil(
              context, 
              Routes.home, 
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          String otpCode = '';
          String mobileNumber = '';
          
          // دریافت شماره موبایل از Cache
          mobileNumber = MobileNumberCache.getMobileNumber();
          
          if (state is AuthInitial) {
            otpCode = state.otpCode;
          }
          
          print('OTP Verification Page - Mobile from Cache: "$mobileNumber", OTP: "$otpCode"');
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogoWidget(),
                const SizedBox(height: 32),

                // نمایش شماره موبایل برای تایید
                if (mobileNumber.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'کد ارسال شده به: $mobileNumber',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),

                // کد تایید
                InputFieldWidget(
                  label: 'کد تایید 5 رقمی',
                  hintText: '12345',
                  keyboardType: TextInputType.number,
                  initialValue: otpCode,
                  maxLength: 5,
                  onChanged: (value) {
                    print('OTP Input Changed: $value');
                    context.read<AuthBloc>().add(OtpCodeChanged(value));
                  },
                ),
                const SizedBox(height: 24),

                // دکمه تایید
                ElevatedButton(
                  onPressed: state is Loading
                      ? null
                      : () {
                          // گرفتن state مستقیم از bloc
                          final authBloc = context.read<AuthBloc>();
                          final currentState = authBloc.state;
                          
                          String currentOtpCode = '';
                          String currentMobileNumber = MobileNumberCache.getMobileNumber();
                          
                          if (currentState is AuthInitial) {
                            currentOtpCode = currentState.otpCode.trim();
                          }
                          
                          print('Verify Button - Mobile: "$currentMobileNumber", OTP: "$currentOtpCode"');
                          
                          if (currentMobileNumber.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('شماره موبایل یافت نشد. لطفاً دوباره وارد شوید.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            // بازگشت به صفحه لاگین
                            Future.microtask(() {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.login,
                                (route) => false,
                              );
                            });
                            return;
                          }
                          
                          if (currentOtpCode.length == 5 && RegExp(r'^[0-9]+$').hasMatch(currentOtpCode)) {
                            authBloc.add(VerifyOtp());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('لطفا کد 5 رقمی را وارد کنید'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: state is Loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'تایید',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                // دکمه ارسال مجدد کد
                TextButton(
                  onPressed: state is Loading
                      ? null
                      : () {
                          final currentMobileNumber = MobileNumberCache.getMobileNumber();
                          
                          print('Send Again Button - Mobile: "$currentMobileNumber"');
                          
                          if (currentMobileNumber.isNotEmpty) {
                            context.read<AuthBloc>().add(SendOtpAgain());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('شماره موبایل یافت نشد. لطفاً دوباره وارد شوید.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            // بازگشت به صفحه لاگین
                            Future.microtask(() {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.login,
                                (route) => false,
                              );
                            });
                          }
                        },
                  child: const Text(
                    'ارسال مجدد کد',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
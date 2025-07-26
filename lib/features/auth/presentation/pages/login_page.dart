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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print('Login Page - State Changed: ${state.runtimeType}');
          if (state is OtpSent) {
            print('OTP Sent - Navigating to Verification');
            Navigator.pushNamed(context, Routes.otpVerification);
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
          String mobileNumber = '';
          if (state is AuthInitial) {
            mobileNumber = state.mobileNumber;
            print('Login Page - Current Mobile in State: "$mobileNumber"');
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogoWidget(),
                const SizedBox(height: 32),

                // شماره موبایل
                InputFieldWidget(
                  label: 'شماره موبایل',
                  hintText: '09123456789',
                  keyboardType: TextInputType.phone,
                  initialValue: mobileNumber,
                  maxLength: 11,
                  onChanged: (value) {
                    print('Mobile Number Changed - Input: $value');
                    // ذخیره در Cache
                    MobileNumberCache.setMobileNumber(value);
                    context.read<AuthBloc>().add(MobileNumberChanged(value));
                  },
                ),
                const SizedBox(height: 24),

                // دکمه ارسال کد تایید
                ElevatedButton(
                  onPressed: state is Loading
                      ? null
                      : () {
                          // گرفتن شماره موبایل از Cache یا state
                          final currentState = context.read<AuthBloc>().state;
                          String currentMobile = '';
                          
                          if (currentState is AuthInitial) {
                            currentMobile = currentState.mobileNumber;
                          }
                          
                          // اگر از state خالی بود، از Cache بگیر
                          if (currentMobile.isEmpty) {
                            currentMobile = MobileNumberCache.getMobileNumber();
                          }
                          
                          print('Send OTP Button - Current Mobile: "$currentMobile"');
                          
                          if (currentMobile.isNotEmpty && currentMobile.length >= 10) {
                            // ذخیره در Cache قبل از ارسال
                            MobileNumberCache.setMobileNumber(currentMobile);
                            context.read<AuthBloc>().add(SendOtp());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('لطفا شماره موبایل معتبر وارد کنید'),
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
                          'ارسال کد تایید',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
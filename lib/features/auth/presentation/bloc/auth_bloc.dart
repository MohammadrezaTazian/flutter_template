import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:my_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:my_app/features/auth/domain/usecases/save_tokens_usecase.dart';
import 'package:my_app/features/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:my_app/features/auth/utils/mobile_number_cache.dart'; // اضافه کردن این خط
import 'package:my_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final SaveTokensUseCase saveTokensUseCase;
  final IsUserLoggedInUseCase isUserLoggedInUseCase;

  AuthBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.saveTokensUseCase,
    required this.isUserLoggedInUseCase,
  }) : super(const AuthInitial()) {
    on<MobileNumberChanged>(_onMobileNumberChanged);
    on<SendOtp>(_onSendOtp);
    on<OtpCodeChanged>(_onOtpCodeChanged);
    on<VerifyOtp>(_onVerifyOtp);
    on<SendOtpAgain>(_onSendOtpAgain);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  void _onMobileNumberChanged(MobileNumberChanged event, Emitter<AuthState> emit) {
    final currentState = state is AuthInitial ? state as AuthInitial : const AuthInitial();
    print('AuthBloc - Mobile Number Changed: ${event.mobileNumber}');
    print('AuthBloc - Previous State Mobile: ${currentState.mobileNumber}');
    
    // ذخیره در Cache
    MobileNumberCache.setMobileNumber(event.mobileNumber);
    
    final newState = currentState.copyWith(mobileNumber: event.mobileNumber);
    print('AuthBloc - New State Mobile: ${newState.mobileNumber}');
    emit(newState);
  }

  void _onSendOtp(SendOtp event, Emitter<AuthState> emit) async {
    final currentState = state is AuthInitial ? state as AuthInitial : const AuthInitial();
    // استفاده از شماره موبایل از state یا Cache
    String mobileNumber = currentState.mobileNumber;
    if (mobileNumber.isEmpty) {
      mobileNumber = MobileNumberCache.getMobileNumber();
      print('AuthBloc - Send OTP - Mobile from Cache: $mobileNumber');
    } else {
      print('AuthBloc - Send OTP - Mobile from State: $mobileNumber');
    }
    
    if (mobileNumber.isNotEmpty && mobileNumber.length >= 10) {
      emit(Loading());
      try {
        await sendOtpUseCase(mobileNumber);
        // حفظ state با شماره موبایل
        emit(currentState.copyWith(mobileNumber: mobileNumber));
        print('AuthBloc - OTP Sent - State Mobile: $mobileNumber');
        emit(OtpSent());
      } catch (e) {
        print('AuthBloc - Send OTP Error: $e');
        // حفظ state با شماره موبایل
        emit(currentState.copyWith(mobileNumber: mobileNumber));
        emit(AuthError(message: 'ارسال کد تایید با خطا مواجه شد'));
      }
    } else {
      emit(AuthError(message: 'لطفا شماره موبایل معتبر وارد کنید'));
    }
  }

  void _onOtpCodeChanged(OtpCodeChanged event, Emitter<AuthState> emit) {
    final currentState = state is AuthInitial ? state as AuthInitial : const AuthInitial();
    print('AuthBloc - OTP Code Changed: ${event.otpCode}');
    print('AuthBloc - Current Mobile in State: ${currentState.mobileNumber}');
    final newState = currentState.copyWith(otpCode: event.otpCode);
    print('AuthBloc - New State Mobile: ${newState.mobileNumber}');
    emit(newState);
  }

  void _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    final currentState = state is AuthInitial ? state as AuthInitial : const AuthInitial();
    final trimmedOtpCode = currentState.otpCode.trim();
    
    // استفاده از شماره موبایل از state یا Cache
    String mobileNumber = currentState.mobileNumber;
    if (mobileNumber.isEmpty) {
      mobileNumber = MobileNumberCache.getMobileNumber();
      print('AuthBloc - Verify OTP - Mobile from Cache: $mobileNumber');
    } else {
      print('AuthBloc - Verify OTP - Mobile from State: $mobileNumber');
    }
    
    print('AuthBloc - Verifying OTP - Mobile: $mobileNumber, OTP: $trimmedOtpCode');
    
    if (mobileNumber.isEmpty) {
      print('AuthBloc - ERROR: Mobile number is empty!');
      emit(AuthError(message: 'شماره موبایل یافت نشد'));
      return;
    }
    
    if (trimmedOtpCode.length == 5 && RegExp(r'^[0-9]+$').hasMatch(trimmedOtpCode)) {
      emit(Loading());
      try {
        print('AuthBloc - Calling verifyOtpUseCase with Mobile: $mobileNumber, OTP: $trimmedOtpCode');
        final token = await verifyOtpUseCase(mobileNumber, trimmedOtpCode);
        await saveTokensUseCase(token);
        // پاک کردن Cache بعد از تایید موفق
        MobileNumberCache.clear();
        emit(OtpVerified());
      } catch (e) {
        print('AuthBloc - Verify OTP Error: $e');
        String errorMessage = 'کد تایید اشتباه است یا منقضی شده است';
        if (e.toString().contains('OTP expired')) {
          errorMessage = 'کد تایید منقضی شده است';
        } else if (e.toString().contains('OTP already used')) {
          errorMessage = 'کد تایید قبلا استفاده شده است';
        } else if (e.toString().contains('Invalid OTP')) {
          errorMessage = 'کد تایید اشتباه است';
        }
        emit(AuthError(message: errorMessage));
      }
    } else {
      emit(AuthError(message: 'کد تایید باید 5 رقم باشد'));
    }
  }

  void _onSendOtpAgain(SendOtpAgain event, Emitter<AuthState> emit) async {
    final currentState = state is AuthInitial ? state as AuthInitial : const AuthInitial();
    // استفاده از شماره موبایل از state یا Cache
    String mobileNumber = currentState.mobileNumber;
    if (mobileNumber.isEmpty) {
      mobileNumber = MobileNumberCache.getMobileNumber();
      print('AuthBloc - Send OTP Again - Mobile from Cache: $mobileNumber');
    } else {
      print('AuthBloc - Send OTP Again - Mobile from State: $mobileNumber');
    }
    
    if (mobileNumber.isNotEmpty && mobileNumber.length >= 10) {
      emit(Loading());
      try {
        await sendOtpUseCase(mobileNumber);
        // حفظ state با شماره موبایل
        emit(currentState.copyWith(mobileNumber: mobileNumber));
        emit(OtpSent());
      } catch (e) {
        // حفظ state با شماره موبایل
        emit(currentState.copyWith(mobileNumber: mobileNumber));
        emit(AuthError(message: 'ارسال مجدد کد تایید با خطا مواجه شد'));
      }
    } else {
      emit(AuthError(message: 'لطفا شماره موبایل معتبر وارد کنید'));
    }
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(Loading());
    try {
      final isLoggedIn = await isUserLoggedInUseCase();
      if (isLoggedIn) {
        emit(UserLoggedIn());
      } else {
        emit(UserLoggedOut());
      }
    } catch (e) {
      emit(UserLoggedOut());
    }
  }
}
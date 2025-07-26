import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  final String mobileNumber;
  final String otpCode;

  const AuthInitial({
    this.mobileNumber = '',
    this.otpCode = '',
  });

  AuthInitial copyWith({
    String? mobileNumber,
    String? otpCode,
  }) {
    return AuthInitial(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      otpCode: otpCode ?? this.otpCode,
    );
  }

  @override
  List<Object> get props => [mobileNumber, otpCode];
}

class Loading extends AuthState {}

class OtpSent extends AuthState {}

class OtpVerified extends AuthState {}

class UserLoggedIn extends AuthState {}

class UserLoggedOut extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class MobileNumberChanged extends AuthEvent {
  final String mobileNumber;

  const MobileNumberChanged(this.mobileNumber);

  @override
  List<Object> get props => [mobileNumber];
}

class SendOtp extends AuthEvent {}

class OtpCodeChanged extends AuthEvent {
  final String otpCode;

  const OtpCodeChanged(this.otpCode);

  @override
  List<Object> get props => [otpCode];
}

class VerifyOtp extends AuthEvent {}

class SendOtpAgain extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
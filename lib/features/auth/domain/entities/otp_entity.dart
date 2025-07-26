import 'package:equatable/equatable.dart';

class OtpEntity extends Equatable {
  final String mobileNumber;
  final String otpCode;
  final DateTime expiryTime;

  const OtpEntity({
    required this.mobileNumber,
    required this.otpCode,
    required this.expiryTime,
  });

  @override
  List<Object?> get props => [mobileNumber, otpCode, expiryTime];
}
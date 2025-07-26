import 'package:dio/dio.dart';

abstract class OtpRemoteDataSource {
  Future<void> verifyOtp(String mobileNumber, String otpCode);
}

class OtpRemoteDataSourceImpl implements OtpRemoteDataSource {
  final Dio dio;

  OtpRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> verifyOtp(String mobileNumber, String otpCode) async {
    try {
      // ارسال درخواست به API برای تایید کد تایید
      await dio.post('/verify-otp', data: {
        'mobile_number': mobileNumber,
        'otp_code': otpCode,
      });
    } catch (e) {
      throw Exception('Failed to verify OTP');
    }
  }
}
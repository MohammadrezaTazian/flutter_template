abstract class OtpRepository {
  Future<void> verifyOtp(String mobileNumber, String otpCode);
}
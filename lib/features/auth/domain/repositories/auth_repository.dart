import 'package:my_app/features/auth/domain/entities/token_entity.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String mobileNumber);
  Future<TokenEntity> verifyOtp(String mobileNumber, String otpCode);
}
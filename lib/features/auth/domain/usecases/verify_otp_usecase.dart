import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';

class VerifyOtpUseCase {
  final AuthRepository authRepository;

  VerifyOtpUseCase(this.authRepository);

  Future<TokenEntity> call(String mobileNumber, String otpCode) async {
    return await authRepository.verifyOtp(mobileNumber, otpCode);
  }
}
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository authRepository;

  SendOtpUseCase(this.authRepository);

  Future<void> call(String mobileNumber) async {
    return await authRepository.sendOtp(mobileNumber);
  }
}
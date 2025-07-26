import 'package:my_app/features/auth/domain/repositories/otp_repository.dart';
import 'package:my_app/features/auth/data/datasources/otp_remote_data_source.dart';

class OtpRepositoryImpl implements OtpRepository {
  final OtpRemoteDataSource remoteDataSource;

  OtpRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> verifyOtp(String mobileNumber, String otpCode) async {
    return await remoteDataSource.verifyOtp(mobileNumber, otpCode);
  }
}
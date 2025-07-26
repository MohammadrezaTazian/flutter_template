import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';
import 'package:my_app/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendOtp(String mobileNumber) async {
    return await remoteDataSource.sendOtp(mobileNumber);
  }

  @override
  Future<TokenEntity> verifyOtp(String mobileNumber, String otpCode) async {
    return await remoteDataSource.verifyOtp(mobileNumber, otpCode);
  }
}
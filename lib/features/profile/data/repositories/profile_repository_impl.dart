import 'package:my_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';
import 'package:my_app/features/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> getProfile(int userId) async {
    return await remoteDataSource.getProfile(userId);
  }

  @override
  Future<ProfileEntity> updateProfile(int userId, ProfileEntity profile) async {
    return await remoteDataSource.updateProfile(userId, profile);
  }
}
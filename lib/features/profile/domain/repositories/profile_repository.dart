import 'package:my_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile(int userId);
  Future<ProfileEntity> updateProfile(int userId, ProfileEntity profile);
}
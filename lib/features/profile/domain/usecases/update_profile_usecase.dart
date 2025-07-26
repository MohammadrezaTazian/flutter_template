import 'package:my_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<ProfileEntity> call(int userId, ProfileEntity profile) async {
    return await repository.updateProfile(userId, profile);
  }
}
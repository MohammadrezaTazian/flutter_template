import 'package:my_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<ProfileEntity> call(int userId) async {
    return await repository.getProfile(userId);
  }
}
import 'package:my_app/features/auth/domain/repositories/token_repository.dart';

class IsUserLoggedInUseCase {
  final TokenRepository repository;

  IsUserLoggedInUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isUserLoggedIn();
  }
}
import 'package:my_app/features/auth/domain/repositories/token_repository.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';

class SaveTokensUseCase {
  final TokenRepository repository;

  SaveTokensUseCase(this.repository);

  Future<void> call(TokenEntity token) async {
    return await repository.saveTokens(token);
  }
}
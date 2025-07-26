import 'package:my_app/features/auth/domain/repositories/token_repository.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';

class GetTokensUseCase {
  final TokenRepository repository;

  GetTokensUseCase(this.repository);

  Future<TokenEntity?> call() async {
    return await repository.getTokens();
  }
}
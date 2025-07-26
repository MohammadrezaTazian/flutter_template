import 'package:my_app/features/auth/domain/entities/token_entity.dart';

abstract class TokenRepository {
  Future<void> saveTokens(TokenEntity token);
  Future<TokenEntity?> getTokens();
  Future<void> clearTokens();
  Future<bool> isUserLoggedIn();
}
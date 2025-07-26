import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';

abstract class TokenLocalDataSource {
  Future<void> saveTokens(TokenEntity token);
  Future<TokenEntity?> getTokens();
  Future<void> clearTokens();
  Future<bool> isTokenValid();
}

class TokenLocalDataSourceImpl implements TokenLocalDataSource {
  final SharedPreferences sharedPreferences;

  TokenLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveTokens(TokenEntity token) async {
    await sharedPreferences.setString('access_token', token.accessToken);
    await sharedPreferences.setString('refresh_token', token.refreshToken);
    await sharedPreferences.setInt('user_id', token.userId);
    await sharedPreferences.setString('token_expires_at', token.expiresAt.toIso8601String());
  }

  @override
  Future<TokenEntity?> getTokens() async {
    final accessToken = sharedPreferences.getString('access_token');
    final refreshToken = sharedPreferences.getString('refresh_token');
    final userId = sharedPreferences.getInt('user_id');
    final expiresAt = sharedPreferences.getString('token_expires_at');

    if (accessToken != null && refreshToken != null && userId != null && expiresAt != null) {
      return TokenEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        expiresAt: DateTime.parse(expiresAt),
      );
    }
    return null;
  }

  @override
  Future<void> clearTokens() async {
    await sharedPreferences.remove('access_token');
    await sharedPreferences.remove('refresh_token');
    await sharedPreferences.remove('user_id');
    await sharedPreferences.remove('token_expires_at');
  }

  @override
  Future<bool> isTokenValid() async {
    final tokens = await getTokens();
    if (tokens != null) {
      return tokens.expiresAt.isAfter(DateTime.now());
    }
    return false;
  }
}
import 'package:my_app/features/auth/domain/repositories/token_repository.dart';
import 'package:my_app/features/auth/domain/entities/token_entity.dart';
import 'package:my_app/features/auth/data/datasources/token_local_data_source.dart';

class TokenRepositoryImpl implements TokenRepository {
  final TokenLocalDataSource localDataSource;

  TokenRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveTokens(TokenEntity token) async {
    return await localDataSource.saveTokens(token);
  }

  @override
  Future<TokenEntity?> getTokens() async {
    return await localDataSource.getTokens();
  }

  @override
  Future<void> clearTokens() async {
    return await localDataSource.clearTokens();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await localDataSource.isTokenValid();
  }
}
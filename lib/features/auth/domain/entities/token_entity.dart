import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final DateTime expiresAt;

  const TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, userId, expiresAt];
}
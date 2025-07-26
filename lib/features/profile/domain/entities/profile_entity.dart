import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final int id;
  final String mobileNumber;
  final String? fullName;
  final String? username;
  final String? avatarUrl;
  final String? email;
  final DateTime createdAt;

  const ProfileEntity({
    required this.id,
    required this.mobileNumber,
    this.fullName,
    this.username,
    this.avatarUrl,
    this.email,
    required this.createdAt,
  });

  ProfileEntity copyWith({
    int? id,
    String? mobileNumber,
    String? fullName,
    String? username,
    String? avatarUrl,
    String? email,
    DateTime? createdAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    mobileNumber,
    fullName,
    username,
    avatarUrl,
    email,
    createdAt,
  ];
}
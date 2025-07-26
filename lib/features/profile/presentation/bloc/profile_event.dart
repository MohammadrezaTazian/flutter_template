import 'package:equatable/equatable.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {
  final int userId;

  const LoadProfile(this.userId);

  @override
  List<Object> get props => [userId];
}

class LoadProfileFromToken extends ProfileEvent {
  const LoadProfileFromToken();

  @override
  List<Object> get props => [];
}

class UpdateProfile extends ProfileEvent {
  final int userId;
  final ProfileEntity profile;

  const UpdateProfile(this.userId, this.profile);

  @override
  List<Object> get props => [userId, profile];
}

class UpdateProfileField extends ProfileEvent {
  final String field;
  final String value;

  const UpdateProfileField(this.field, this.value);

  @override
  List<Object> get props => [field, value];
}
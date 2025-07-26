import 'package:equatable/equatable.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  final ProfileEntity editedProfile;

  const ProfileLoaded({
    required this.profile,
    required this.editedProfile,
  });

  ProfileLoaded copyWith({
    ProfileEntity? profile,
    ProfileEntity? editedProfile,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      editedProfile: editedProfile ?? this.editedProfile,
    );
  }

  @override
  List<Object> get props => [profile, editedProfile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserLoggedOut extends ProfileState {}
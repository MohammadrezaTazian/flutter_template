import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/auth/domain/usecases/get_tokens_usecase.dart';
import 'package:my_app/features/profile/domain/entities/profile_entity.dart';
import 'package:my_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:my_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetTokensUseCase getTokensUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.getTokensUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfileField>(_onUpdateProfileField);
    on<LoadProfileFromToken>(_onLoadProfileFromToken);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      print('Loading profile for user ID: ${event.userId}');
      final profile = await getProfileUseCase(event.userId);
      print('Profile loaded: ${profile.fullName}, Mobile: ${profile.mobileNumber}');
      emit(ProfileLoaded(
        profile: profile,
        editedProfile: profile,
      ));
    } catch (e) {
      print('Error loading profile: $e');
      emit(ProfileError(message: 'خطا در بارگذاری پروفایل: $e'));
    }
  }

  void _onLoadProfileFromToken(LoadProfileFromToken event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // دریافت توکن‌ها
      final tokens = await getTokensUseCase();
      print('Tokens retrieved: $tokens');
      if (tokens != null) {
        print('Loading profile for user ID from token: ${tokens.userId}');
        final profile = await getProfileUseCase(tokens.userId);
        print('Profile loaded from token: ${profile.fullName}, Mobile: ${profile.mobileNumber}');
        emit(ProfileLoaded(
          profile: profile,
          editedProfile: profile,
        ));
      } else {
        print('No tokens found');
        emit(ProfileError(message: 'کاربر لاگین نشده است'));
      }
    } catch (e) {
      print('Error loading profile from token: $e');
      emit(ProfileError(message: 'خطا در بارگذاری پروفایل: $e'));
    }
  }

  void _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoaded) {
      emit(ProfileLoading());
      try {
        print('Updating profile for user ID: ${event.userId}');
        final updatedProfile = await updateProfileUseCase(event.userId, event.profile);
        print('Profile updated: ${updatedProfile.fullName}');
        emit(ProfileLoaded(
          profile: updatedProfile,
          editedProfile: updatedProfile,
        ));
      } catch (e) {
        print('Error updating profile: $e');
        emit(ProfileError(message: 'خطا در به‌روزرسانی پروفایل: $e'));
      }
    }
  }

  void _onUpdateProfileField(UpdateProfileField event, Emitter<ProfileState> emit) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      ProfileEntity updatedEditedProfile;

      switch (event.field) {
        case 'fullName':
          updatedEditedProfile = currentState.editedProfile.copyWith(fullName: event.value);
          break;
        case 'username':
          updatedEditedProfile = currentState.editedProfile.copyWith(username: event.value);
          break;
        case 'avatarUrl':
          updatedEditedProfile = currentState.editedProfile.copyWith(avatarUrl: event.value);
          break;
        case 'email':
          updatedEditedProfile = currentState.editedProfile.copyWith(email: event.value);
          break;
        default:
          updatedEditedProfile = currentState.editedProfile;
      }

      emit(currentState.copyWith(editedProfile: updatedEditedProfile));
    }
  }
}
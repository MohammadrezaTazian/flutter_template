import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:my_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_app/features/auth/domain/repositories/otp_repository.dart';
import 'package:my_app/features/auth/domain/repositories/token_repository.dart';
import 'package:my_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
// اضافه کردن importهای مربوط به Auth
import 'package:my_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:my_app/features/auth/data/datasources/otp_remote_data_source.dart';
import 'package:my_app/features/auth/data/datasources/token_local_data_source.dart';
import 'package:my_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_app/features/auth/data/repositories/otp_repository_impl.dart';
import 'package:my_app/features/auth/data/repositories/token_repository_impl.dart';
import 'package:my_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:my_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:my_app/features/auth/domain/usecases/save_tokens_usecase.dart';
import 'package:my_app/features/auth/domain/usecases/get_tokens_usecase.dart'; // اضافه کردن این خط
import 'package:my_app/features/auth/domain/usecases/is_user_logged_in_usecase.dart';
import 'package:my_app/features/auth/presentation/bloc/auth_bloc.dart';
// اضافه کردن importهای مربوط به Settings
import 'package:my_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:my_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:my_app/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:my_app/features/settings/domain/usecases/get_theme_mode.dart';
import 'package:my_app/features/settings/domain/usecases/get_language.dart';
import 'package:my_app/features/settings/domain/usecases/set_theme_mode.dart';
import 'package:my_app/features/settings/domain/usecases/set_language.dart';
import 'package:my_app/features/settings/domain/usecases/get_font_size.dart';
import 'package:my_app/features/settings/domain/usecases/set_font_size.dart';
import 'package:my_app/features/settings/presentation/bloc/settings_bloc.dart';
// اضافه کردن importهای مربوط به Profile
import 'package:my_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:my_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:my_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:my_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:my_app/features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      saveTokensUseCase: sl(),
      isUserLoggedInUseCase: sl(),
    ),
  );

  // Settings Bloc
  sl.registerFactory(
    () => SettingsBloc(
      getThemeMode: sl(),
      getLanguage: sl(),
      getFontSizeScale: sl(),
      setThemeMode: sl(),
      setLanguage: sl(),
      setFontSizeScale: sl(),
    ),
  );

  // Profile Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      getTokensUseCase: sl(), // اضافه کردن این خط
    ),
  );

  // Auth Use cases
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => SaveTokensUseCase(sl()));
  sl.registerLazySingleton(() => GetTokensUseCase(sl())); // اضافه کردن این خط
  sl.registerLazySingleton(() => IsUserLoggedInUseCase(sl()));

  // Settings Use cases
  sl.registerLazySingleton(() => GetThemeMode(sl()));
  sl.registerLazySingleton(() => GetLanguage(sl()));
  sl.registerLazySingleton(() => GetFontSizeScale(sl()));
  sl.registerLazySingleton(() => SetThemeMode(sl()));
  sl.registerLazySingleton(() => SetLanguage(sl()));
  sl.registerLazySingleton(() => SetFontSizeScale(sl()));

  // Profile Use cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Auth Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  
  sl.registerLazySingleton<OtpRepository>(
    () => OtpRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<TokenRepository>(
    () => TokenRepositoryImpl(localDataSource: sl()),
  );

  // Settings Repositories
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Profile Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  // Auth Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );
  
  sl.registerLazySingleton<OtpRemoteDataSource>(
    () => OtpRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<TokenLocalDataSource>(
    () => TokenLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Settings Data sources
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Profile Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl()),
  );

  // External
  sl.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
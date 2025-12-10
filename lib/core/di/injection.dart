import 'package:app_builder_mobile/data/datasources/auth_local_datasource.dart';
import 'package:app_builder_mobile/data/datasources/device_info_datasource.dart';
import 'package:app_builder_mobile/data/repositories/auth_repository_impl.dart';
import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';
import 'package:app_builder_mobile/services/tts_service.dart';
import 'package:get_it/get_it.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize all dependencies
/// Call this method once at app startup in main()
Future<void> initializeDependencies() async {
  // ===== Data Sources =====
  // Singleton: AuthLocalDataSource
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  // Singleton: DeviceInfoDataSource
  getIt.registerLazySingleton<DeviceInfoDataSource>(
    () => DeviceInfoDataSourceImpl(),
  );

  // ===== Repositories =====
  // Singleton: AuthRepository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // ===== Services =====
  // Singleton: TTSService
  getIt.registerLazySingleton<TTSService>(
    () => TTSService(),
  );

  // Note: Cubits are NOT registered here as they should be provided
  // via BlocProvider in the widget tree for proper lifecycle management
}

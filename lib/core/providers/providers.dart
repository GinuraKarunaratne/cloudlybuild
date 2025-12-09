import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/api_service.dart';
import '../../data/services/location_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/repositories/weather_alerts_repository.dart';
import '../../data/repositories/uv_repository.dart';
import '../../data/repositories/user_alert_repository.dart';

// Services
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

// Repositories
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return WeatherRepository(apiService);
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final locationService = ref.read(locationServiceProvider);
  return LocationRepository(locationService);
});

final weatherAlertsRepositoryProvider = Provider<WeatherAlertsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return WeatherAlertsRepository(apiService);
});

final uvRepositoryProvider = Provider<UVRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return UVRepository(apiService);
});

final userAlertRepositoryProvider = Provider<UserAlertRepository>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return UserAlertRepository(storageService);
});

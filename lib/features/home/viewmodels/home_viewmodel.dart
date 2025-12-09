import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/forecast_model.dart';
import '../../../data/models/uv_data_model.dart';
import '../../../core/providers/providers.dart';

class HomeState {
  final bool isLoading;
  final WeatherModel? weather;
  final ForecastModel? forecast;
  final LocationModel? currentLocation;
  final UVDataModel? uvData;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.weather,
    this.forecast,
    this.currentLocation,
    this.uvData,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    WeatherModel? weather,
    ForecastModel? forecast,
    LocationModel? currentLocation,
    UVDataModel? uvData,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      weather: weather ?? this.weather,
      forecast: forecast ?? this.forecast,
      currentLocation: currentLocation ?? this.currentLocation,
      uvData: uvData ?? this.uvData,
      error: error,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;

  HomeNotifier(this.ref) : super(HomeState());

  Future<void> loadCurrentLocationWeather() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final locationRepo = ref.read(locationRepositoryProvider);
      final weatherRepo = ref.read(weatherRepositoryProvider);
      final uvRepo = ref.read(uvRepositoryProvider);

      final location = await locationRepo.getCurrentLocation();

      // Load current weather and forecast first
      final results = await Future.wait([
        weatherRepo.getCurrentWeather(location.lat, location.lon),
        weatherRepo.getForecast(location.lat, location.lon),
      ]);

      final weather = results[0] as WeatherModel;
      final forecast = results[1] as ForecastModel;

      // Now load UV data using the weather data
      final uvData = await uvRepo.getUVData(location.lat, location.lon, weather);

      state = state.copyWith(
        isLoading: false,
        weather: weather,
        forecast: forecast,
        uvData: uvData,
        currentLocation: location,
      );

      await _checkUserAlerts(weather);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadWeatherForLocation(double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final weatherRepo = ref.read(weatherRepositoryProvider);
      final uvRepo = ref.read(uvRepositoryProvider);

      // Load current weather and forecast first
      final results = await Future.wait([
        weatherRepo.getCurrentWeather(lat, lon),
        weatherRepo.getForecast(lat, lon),
      ]);

      final weather = results[0] as WeatherModel;
      final forecast = results[1] as ForecastModel;

      // Now load UV data using the weather data
      final uvData = await uvRepo.getUVData(lat, lon, weather);

      state = state.copyWith(
        isLoading: false,
        weather: weather,
        forecast: forecast,
        uvData: uvData,
      );

      await _checkUserAlerts(weather);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> _checkUserAlerts(WeatherModel weather) async {
    try {
      final userAlertRepo = ref.read(userAlertRepositoryProvider);
      await userAlertRepo.checkAlerts(weather);
    } catch (e) {
      // Silently handle alert checking errors
    }
  }

  Future<void> refreshWeather() async {
    if (state.currentLocation != null) {
      await loadWeatherForLocation(
        state.currentLocation!.lat,
        state.currentLocation!.lon,
      );
    } else {
      await loadCurrentLocationWeather();
    }
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});


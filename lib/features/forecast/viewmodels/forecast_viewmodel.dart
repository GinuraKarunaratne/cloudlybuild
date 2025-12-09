import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/forecast_model.dart';
import '../../../core/providers/providers.dart';

class ForecastState {
  final bool isLoading;
  final ForecastModel? forecast;
  final String? error;

  ForecastState({
    this.isLoading = false,
    this.forecast,
    this.error,
  });

  ForecastState copyWith({
    bool? isLoading,
    ForecastModel? forecast,
    String? error,
  }) {
    return ForecastState(
      isLoading: isLoading ?? this.isLoading,
      forecast: forecast ?? this.forecast,
      error: error,
    );
  }
}

class ForecastNotifier extends StateNotifier<ForecastState> {
  final Ref ref;

  ForecastNotifier(this.ref) : super(ForecastState());

  Future<void> loadForecast(double lat, double lon) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final weatherRepo = ref.read(weatherRepositoryProvider);
      final forecast = await weatherRepo.getForecast(lat, lon);

      state = state.copyWith(
        isLoading: false,
        forecast: forecast,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final forecastProvider = StateNotifierProvider<ForecastNotifier, ForecastState>((ref) {
  return ForecastNotifier(ref);
});

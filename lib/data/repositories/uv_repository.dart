import '../services/api_service.dart';
import '../models/uv_data_model.dart';
import '../models/weather_model.dart';

class UVRepository {
  final ApiService _apiService;

  UVRepository(this._apiService);

  Future<UVDataModel?> getUVData(double lat, double lon, WeatherModel weather) async {
    try {
      print('UVRepository: Fetching UV data for lat=$lat, lon=$lon');
      final data = await _apiService.getUVIndexData(lat, lon);
      print('UVRepository: API response data: $data');

      if (data != null) {
        final uvData = UVDataModel.fromJson(data);
        print('UVRepository: Created UVDataModel with UV index: ${uvData.uvIndex}');
        return uvData;
      }

      print('UVRepository: API returned null, using estimated UV based on time');
      // Fallback: estimate UV index based on time of day
      final uvIndex = _estimateUVIndex(weather);
      return UVDataModel(
        uvIndex: uvIndex,
        sunrise: weather.sunrise,
        sunset: weather.sunset,
      );
    } catch (e) {
      print('UV Repository Error: $e, using estimated UV');
      // Fallback: estimate UV index based on time of day
      final uvIndex = _estimateUVIndex(weather);
      return UVDataModel(
        uvIndex: uvIndex,
        sunrise: weather.sunrise,
        sunset: weather.sunset,
      );
    }
  }

  double _estimateUVIndex(WeatherModel weather) {
    final now = DateTime.now();
    final hour = now.hour;

    // If it's night, UV is 0
    if (!weather.isDay()) {
      return 0.0;
    }

    // Peak UV is around solar noon (12-2 PM)
    // UV increases from sunrise to solar noon, then decreases to sunset
    double baseUV = 0.0;

    if (hour >= 10 && hour <= 14) {
      // Peak hours - UV 5-8 depending on cloud cover
      baseUV = weather.condition.toLowerCase() == 'clear' ? 7.0 : 5.0;
    } else if (hour >= 8 && hour < 10 || hour > 14 && hour <= 16) {
      // Morning/afternoon - UV 3-5
      baseUV = weather.condition.toLowerCase() == 'clear' ? 4.5 : 3.0;
    } else {
      // Early morning or late afternoon - UV 1-2
      baseUV = weather.condition.toLowerCase() == 'clear' ? 2.0 : 1.0;
    }

    // Adjust for cloud cover
    if (weather.condition.toLowerCase() == 'clouds') {
      baseUV *= 0.7;
    } else if (weather.condition.toLowerCase() == 'rain') {
      baseUV *= 0.4;
    }

    return baseUV;
  }
}


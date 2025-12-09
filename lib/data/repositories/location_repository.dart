import '../models/location_model.dart';
import '../services/location_service.dart';

class LocationRepository {
  final LocationService _locationService;

  LocationRepository(
    this._locationService,
  );

  Future<LocationModel> getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      return LocationModel(
        name: cityName,
        lat: position.latitude,
        lon: position.longitude,
        country: '',
      );
    } catch (e) {
      rethrow;
    }
  }
}


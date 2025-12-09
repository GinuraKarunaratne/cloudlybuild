import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/services/storage_service.dart';
import '../../../core/providers/providers.dart';
import 'settings_state.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return SettingsNotifier(storageService);
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storageService;

  SettingsNotifier(this._storageService) : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final tempUnit = await _storageService.getSetting('temperature_unit');
    final windUnit = await _storageService.getSetting('wind_speed_unit');
    final timeFormatStr = await _storageService.getSetting('time_format');
    final animations = await _storageService.getBoolSetting('animations_enabled', defaultValue: true);

    state = state.copyWith(
      temperatureUnit: _parseTemperatureUnit(tempUnit),
      windSpeedUnit: _parseWindSpeedUnit(windUnit),
      timeFormat: _parseTimeFormat(timeFormatStr),
      animationsEnabled: animations,
    );
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    await _storageService.saveSetting('temperature_unit', unit.toString());
    state = state.copyWith(temperatureUnit: unit);
  }

  Future<void> setWindSpeedUnit(WindSpeedUnit unit) async {
    await _storageService.saveSetting('wind_speed_unit', unit.toString());
    state = state.copyWith(windSpeedUnit: unit);
  }

  Future<void> setTimeFormat(TimeFormat format) async {
    await _storageService.saveSetting('time_format', format.toString());
    state = state.copyWith(timeFormat: format);
  }

  Future<void> setAnimationsEnabled(bool enabled) async {
    await _storageService.saveBoolSetting('animations_enabled', enabled);
    state = state.copyWith(animationsEnabled: enabled);
  }

  TemperatureUnit _parseTemperatureUnit(String? value) {
    if (value == null) return TemperatureUnit.celsius;
    return TemperatureUnit.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => TemperatureUnit.celsius,
    );
  }

  WindSpeedUnit _parseWindSpeedUnit(String? value) {
    if (value == null) return WindSpeedUnit.metersPerSecond;
    return WindSpeedUnit.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => WindSpeedUnit.metersPerSecond,
    );
  }

  TimeFormat _parseTimeFormat(String? value) {
    if (value == null) return TimeFormat.twentyFourHour;
    return TimeFormat.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => TimeFormat.twentyFourHour,
    );
  }
}


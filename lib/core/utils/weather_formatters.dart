import '../../../features/settings/viewmodels/settings_state.dart';

extension TemperatureFormatter on double {
  String formatTemperature(SettingsState settings) {
    final converted = settings.convertTemperature(this);
    return '${converted.round()}${settings.temperatureSymbol}';
  }

  String formatTemperatureDecimal(SettingsState settings) {
    final converted = settings.convertTemperature(this);
    return '${converted.toStringAsFixed(1)}${settings.temperatureSymbol}';
  }
}

extension WindSpeedFormatter on double {
  String formatWindSpeed(SettingsState settings) {
    final converted = settings.convertWindSpeed(this);
    return '${converted.toStringAsFixed(1)} ${settings.windSpeedUnitString}';
  }
}

extension TimeFormatter on DateTime {
  String formatTime(SettingsState settings) {
    return settings.formatTime(this);
  }
}


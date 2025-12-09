enum TemperatureUnit {
  celsius,
  fahrenheit,
  kelvin,
}

enum WindSpeedUnit {
  metersPerSecond,
  kilometersPerHour,
  milesPerHour,
}

enum TimeFormat {
  twentyFourHour,
  twelveHour,
}

class SettingsState {
  final TemperatureUnit temperatureUnit;
  final WindSpeedUnit windSpeedUnit;
  final TimeFormat timeFormat;
  final bool animationsEnabled;

  SettingsState({
    this.temperatureUnit = TemperatureUnit.celsius,
    this.windSpeedUnit = WindSpeedUnit.metersPerSecond,
    this.timeFormat = TimeFormat.twentyFourHour,
    this.animationsEnabled = true,
  });

  SettingsState copyWith({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
    TimeFormat? timeFormat,
    bool? animationsEnabled,
  }) {
    return SettingsState(
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      windSpeedUnit: windSpeedUnit ?? this.windSpeedUnit,
      timeFormat: timeFormat ?? this.timeFormat,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
    );
  }

  String get temperatureUnitString {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return 'Celsius';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit';
      case TemperatureUnit.kelvin:
        return 'Kelvin';
    }
  }

  String get windSpeedUnitString {
    switch (windSpeedUnit) {
      case WindSpeedUnit.metersPerSecond:
        return 'm/s';
      case WindSpeedUnit.kilometersPerHour:
        return 'km/h';
      case WindSpeedUnit.milesPerHour:
        return 'mph';
    }
  }

  String get timeFormatString {
    switch (timeFormat) {
      case TimeFormat.twentyFourHour:
        return '24-hour';
      case TimeFormat.twelveHour:
        return '12-hour';
    }
  }

  String get temperatureSymbol {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
      case TemperatureUnit.kelvin:
        return 'K';
    }
  }

  double convertTemperature(double celsius) {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
      case TemperatureUnit.kelvin:
        return celsius + 273.15;
    }
  }

  double convertWindSpeed(double metersPerSecond) {
    switch (windSpeedUnit) {
      case WindSpeedUnit.metersPerSecond:
        return metersPerSecond;
      case WindSpeedUnit.kilometersPerHour:
        return metersPerSecond * 3.6;
      case WindSpeedUnit.milesPerHour:
        return metersPerSecond * 2.237;
    }
  }

  String formatTime(DateTime dateTime) {
    if (timeFormat == TimeFormat.twelveHour) {
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
    } else {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

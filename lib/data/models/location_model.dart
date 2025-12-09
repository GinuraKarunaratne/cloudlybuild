class LocationModel {
  final String name;
  final double lat;
  final double lon;
  final String country;
  final String? state;
  final String? customName;

  LocationModel({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
    this.state,
    this.customName,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      country: json['country'] ?? '',
      state: json['state'],
      customName: json['custom_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'country': country,
      'state': state,
      'custom_name': customName,
    };
  }

  LocationModel copyWith({
    String? name,
    double? lat,
    double? lon,
    String? country,
    String? state,
    String? customName,
  }) {
    return LocationModel(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      country: country ?? this.country,
      state: state ?? this.state,
      customName: customName ?? this.customName,
    );
  }

  String get displayName {
    if (customName != null && customName!.isNotEmpty) {
      return customName!;
    }
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  String get fullLocationName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }
}

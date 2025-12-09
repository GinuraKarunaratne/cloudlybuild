import 'package:uuid/uuid.dart';

class Activity {
  final String id;
  final String name;
  final double minTemp;
  final double maxTemp;
  final double maxWind;
  final double minVisibility;
  final double maxUV;
  final DateTime createdAt;

  Activity({
    String? id,
    required this.name,
    required this.minTemp,
    required this.maxTemp,
    required this.maxWind,
    required this.minVisibility,
    required this.maxUV,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Activity copyWith({
    String? id,
    String? name,
    double? minTemp,
    double? maxTemp,
    double? maxWind,
    double? minVisibility,
    double? maxUV,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      maxWind: maxWind ?? this.maxWind,
      minVisibility: minVisibility ?? this.minVisibility,
      maxUV: maxUV ?? this.maxUV,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'maxWind': maxWind,
      'minVisibility': minVisibility,
      'maxUV': maxUV,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      maxWind: (json['maxWind'] as num).toDouble(),
      minVisibility: (json['minVisibility'] as num).toDouble(),
      maxUV: (json['maxUV'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

enum ActivityStatus {
  perfect,
  caution,
  notRecommended,
}

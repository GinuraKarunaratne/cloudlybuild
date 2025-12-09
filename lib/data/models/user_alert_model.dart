import 'package:uuid/uuid.dart';

enum AlertConditionType {
  temperature,
  feelsLike,
  humidity,
  windSpeed,
  precipitation,
}

enum AlertOperator {
  lessThan,
  greaterThan,
  equals,
}

class UserAlertModel {
  final String id;
  final String name;
  final AlertConditionType conditionType;
  final AlertOperator operator;
  final double threshold;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime? lastTriggered;

  UserAlertModel({
    String? id,
    required this.name,
    required this.conditionType,
    required this.operator,
    required this.threshold,
    this.isEnabled = true,
    DateTime? createdAt,
    this.lastTriggered,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory UserAlertModel.fromJson(Map<String, dynamic> json) {
    return UserAlertModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      conditionType: AlertConditionType.values.firstWhere(
        (e) => e.toString() == json['condition_type'],
        orElse: () => AlertConditionType.temperature,
      ),
      operator: AlertOperator.values.firstWhere(
        (e) => e.toString() == json['operator'],
        orElse: () => AlertOperator.lessThan,
      ),
      threshold: (json['threshold'] as num).toDouble(),
      isEnabled: json['is_enabled'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      lastTriggered: json['last_triggered'] != null
          ? DateTime.parse(json['last_triggered'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'condition_type': conditionType.toString(),
      'operator': operator.toString(),
      'threshold': threshold,
      'is_enabled': isEnabled,
      'created_at': createdAt.toIso8601String(),
      'last_triggered': lastTriggered?.toIso8601String(),
    };
  }

  UserAlertModel copyWith({
    String? id,
    String? name,
    AlertConditionType? conditionType,
    AlertOperator? operator,
    double? threshold,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? lastTriggered,
  }) {
    return UserAlertModel(
      id: id ?? this.id,
      name: name ?? this.name,
      conditionType: conditionType ?? this.conditionType,
      operator: operator ?? this.operator,
      threshold: threshold ?? this.threshold,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }

  String get conditionDescription {
    final unit = _getUnit();
    final operatorSymbol = _getOperatorSymbol();
    final conditionName = _getConditionName();

    return '$conditionName $operatorSymbol ${threshold.toStringAsFixed(1)}$unit';
  }

  String _getConditionName() {
    switch (conditionType) {
      case AlertConditionType.temperature:
        return 'Temperature';
      case AlertConditionType.feelsLike:
        return 'Feels Like';
      case AlertConditionType.humidity:
        return 'Humidity';
      case AlertConditionType.windSpeed:
        return 'Wind Speed';
      case AlertConditionType.precipitation:
        return 'Precipitation';
    }
  }

  String _getOperatorSymbol() {
    switch (operator) {
      case AlertOperator.lessThan:
        return '<';
      case AlertOperator.greaterThan:
        return '>';
      case AlertOperator.equals:
        return '=';
    }
  }

  String _getUnit() {
    switch (conditionType) {
      case AlertConditionType.temperature:
      case AlertConditionType.feelsLike:
        return '°C';
      case AlertConditionType.humidity:
      case AlertConditionType.precipitation:
        return '%';
      case AlertConditionType.windSpeed:
        return ' m/s';
    }
  }

  bool checkCondition(double value) {
    switch (operator) {
      case AlertOperator.lessThan:
        return value < threshold;
      case AlertOperator.greaterThan:
        return value > threshold;
      case AlertOperator.equals:
        return (value - threshold).abs() < 0.5;
    }
  }
}

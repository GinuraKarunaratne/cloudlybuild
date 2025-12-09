/// Weather alert model for severe weather warnings
class WeatherAlertModel {
  final String event;
  final String description;
  final int startTime;
  final int endTime;
  final String senderName;
  final List<String> tags;

  WeatherAlertModel({
    required this.event,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.senderName,
    required this.tags,
  });

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      event: json['event'] ?? 'Weather Alert',
      description: json['description'] ?? '',
      startTime: json['start'] ?? 0,
      endTime: json['end'] ?? 0,
      senderName: json['sender_name'] ?? 'Weather Service',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => tag.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event,
      'description': description,
      'start': startTime,
      'end': endTime,
      'sender_name': senderName,
      'tags': tags,
    };
  }

  /// Get alert severity level based on tags and event type
  AlertSeverity getSeverity() {
    final eventLower = event.toLowerCase();
    final tagsLower = tags.map((t) => t.toLowerCase()).toList();

    if (eventLower.contains('extreme') ||
        eventLower.contains('severe') ||
        tagsLower.contains('extreme') ||
        tagsLower.contains('red')) {
      return AlertSeverity.extreme;
    } else if (eventLower.contains('warning') ||
        tagsLower.contains('orange') ||
        tagsLower.contains('amber')) {
      return AlertSeverity.severe;
    } else if (eventLower.contains('watch') || tagsLower.contains('yellow')) {
      return AlertSeverity.moderate;
    } else {
      return AlertSeverity.minor;
    }
  }

  /// Check if alert is currently active
  bool isActive() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= startTime && now <= endTime;
  }

  /// Get formatted time until alert starts or ends
  String getTimeUntil() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final targetTime = now < startTime ? startTime : endTime;
    final diff = targetTime - now;

    if (diff < 0) return 'Ended';

    final hours = diff ~/ 3600;
    final minutes = (diff % 3600) ~/ 60;

    if (hours > 24) {
      final days = hours ~/ 24;
      return 'in ${days}d';
    } else if (hours > 0) {
      return 'in ${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return 'in ${minutes}m';
    } else {
      return 'Now';
    }
  }

  /// Get formatted start time
  String getStartTimeFormatted() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(startTime * 1000);
    return _formatDateTime(dateTime);
  }

  /// Get formatted end time
  String getEndTimeFormatted() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(endTime * 1000);
    return _formatDateTime(dateTime);
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final alertDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    if (alertDay == today) {
      return 'Today $timeStr';
    } else if (alertDay == tomorrow) {
      return 'Tomorrow $timeStr';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} $timeStr';
    }
  }
}

/// Alert severity levels
enum AlertSeverity {
  minor,
  moderate,
  severe,
  extreme,
}


import 'package:flutter/material.dart';
import '../../../core/theme/skye_theme.dart';

/// WeatherHeroCard - Modern hero section widget
/// Reusable card component following the specified design
class WeatherHeroCard extends StatelessWidget {
  final String cityName;
  final double temperature;
  final String conditionText;
  final String summaryText;
  final double minTemp;
  final double maxTemp;
  final double humidity;
  final double pressure;
  final double dewPoint;
  final IconData? conditionIcon;

  const WeatherHeroCard({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.conditionText,
    required this.summaryText,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.pressure,
    required this.dewPoint,
    this.conditionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlphaFromOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE - City, temp, condition, summary
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: city name (left) and summary (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City name
                    Text(
                      cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Summary text (right-aligned)
                    Expanded(
                      child: Text(
                        summaryText,
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 11,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Large temperature
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${temperature.round()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const Text(
                      '°',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Condition row with icon
                Row(
                  children: [
                    Icon(
                      conditionIcon ?? Icons.cloud,
                      size: 20,
                      color: const Color(0xFFB0B0B0),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      conditionText,
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Min/Max row with arrows
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      size: 12,
                      color: Color(0xFFB0B0B0),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${maxTemp.round()}°',
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.arrow_downward,
                      size: 12,
                      color: Color(0xFFB0B0B0),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${minTemp.round()}°',
                      style: const TextStyle(
                        color: Color(0xFFB0B0B0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // RIGHT SIDE - Three vertical metric pills
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: MetricPillCard(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: '${humidity.toStringAsFixed(1)}%',
                    backgroundColor: const Color(0xFF2E8BFF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MetricPillCard(
                    icon: Icons.waves,
                    label: 'Pressure',
                    value: '${pressure.toStringAsFixed(2)}in',
                    backgroundColor: const Color(0xFF3B9EFF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MetricPillCard(
                    icon: Icons.opacity,
                    label: 'Dew Point',
                    value: '${dewPoint.round()}',
                    backgroundColor: const Color(0xFF47C96B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// MetricPillCard - Individual metric card for the hero section
class MetricPillCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color backgroundColor;

  const MetricPillCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon at top
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlphaFromOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Label
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Value
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}


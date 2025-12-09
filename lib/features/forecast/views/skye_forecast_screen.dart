import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodels/forecast_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';

/// COMPLETELY REDESIGNED Forecast Screen
/// Modern dark theme with new visual layout
class SkyeForecastScreen extends ConsumerStatefulWidget {
  const SkyeForecastScreen({super.key});

  @override
  ConsumerState<SkyeForecastScreen> createState() =>
      _SkyeForecastScreenState();
}

class _SkyeForecastScreenState extends ConsumerState<SkyeForecastScreen> {
  bool _showHourly = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeState = ref.read(homeProvider);
      if (homeState.currentLocation != null) {
        ref.read(forecastProvider.notifier).loadForecast(
              homeState.currentLocation!.lat,
              homeState.currentLocation!.lon,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final forecastState = ref.watch(forecastProvider);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.90,
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A), // Black background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF232125),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Forecast',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFAFAFA),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF232125),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFFFFFFFF),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Toggle between hourly and daily
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF232125),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      'Hourly',
                      _showHourly,
                      () => setState(() => _showHourly = true),
                    ),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                      'Daily',
                      !_showHourly,
                      () => setState(() => _showHourly = false),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Content
          Expanded(
            child: forecastState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3B82F6),
                    ),
                  )
                : forecastState.error != null
                    ? _buildErrorState(forecastState.error!)
                    : forecastState.forecast == null
                        ? _buildEmptyState()
                        : _showHourly
                            ? _buildHourlyForecast(forecastState.forecast!)
                            : _buildDailyForecast(forecastState.forecast!),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1C1A1F) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: const Color(0xFFFFFFFF), width: 1)
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? const Color(0xFFFAFAFA) : const Color(0xFFF6F6F6),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast(dynamic forecast) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: forecast.hourlyForecasts.length,
      itemBuilder: (context, index) {
        final hourly = forecast.hourlyForecasts[index];
        final time = DateTime.fromMillisecondsSinceEpoch(hourly.dt * 1000);
        final now = DateTime.now();
        final isNow = time.hour == now.hour && time.day == now.day;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF232125),
            borderRadius: BorderRadius.circular(18),
            border: isNow
                ? Border.all(color: const Color(0xFFFFFFFF), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time and day
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isNow ? 'Now' : DateFormat('HH:mm').format(time),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFAFAFA),
                        ),
                      ),
                      if (!isNow)
                        Text(
                          DateFormat('EEE').format(time),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFF6F6F6),
                          ),
                        ),
                    ],
                  ),
                  // Weather Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1A1F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getHourlyIcon(hourly.condition, hourly.icon),
                      color: const Color(0xFFFFFFFF),
                      size: 24,
                    ),
                  ),
                ],
              ),

              // Temperature and precipitation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Temperature
                  Text(
                    '${hourly.temperature.round()}°',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFAFAFA),
                    ),
                  ),
                  // Precipitation
                  Row(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 14,
                        color: Color(0xFFFFFFFF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(hourly.pop * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF6F6F6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyForecast(dynamic forecast) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.8,
        mainAxisSpacing: 12,
      ),
      itemCount: forecast.dailyForecasts.length,
      itemBuilder: (context, index) {
        final daily = forecast.dailyForecasts[index];
        final isToday = daily.getDayName() == 'Today';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF232125),
            borderRadius: BorderRadius.circular(20),
            border: isToday
                ? Border.all(color: const Color(0xFFFFFFFF), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Day name and icon in column
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    // Weather Icon
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1A1F),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        _getHourlyIcon(daily.condition, daily.icon),
                        color: const Color(0xFFFFFFFF),
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Day name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            daily.getDayName(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFAFAFA),
                            ),
                          ),
                          if (daily.pop > 0)
                            Row(
                              children: [
                                const Icon(
                                  Icons.water_drop,
                                  size: 14,
                                  color: Color(0xFFFFFFFF),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${(daily.pop * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFF6F6F6),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Temperature range
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1A1F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Min temp with down arrow
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_downward,
                          size: 14,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${daily.minTemp.round()}°',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 1,
                      height: 36,
                      color: const Color(0xFF232125),
                    ),
                    const SizedBox(width: 16),
                    // Max temp with up arrow
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          size: 14,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${daily.maxTemp.round()}°',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getHourlyIcon(String condition, String icon) {
    final isNight = icon.endsWith('n');

    switch (condition.toLowerCase()) {
      case 'clear':
        return isNight ? Icons.nightlight_round : Icons.wb_sunny_rounded;
      case 'clouds':
        return Icons.cloud_rounded;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      case 'thunderstorm':
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFAFAFA),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFF6F6F6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No forecast data available',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFF6F6F6),
        ),
      ),
    );
  }
}

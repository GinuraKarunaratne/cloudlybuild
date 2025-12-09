import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../forecast/views/skye_forecast_screen.dart';
import '../../settings/views/skye_settings_screen.dart';
import '../../alerts/views/skye_alerts_screen.dart';
import '../../search/views/search_screen.dart';
import '../../alerts/viewmodels/alerts_viewmodel.dart';
import '../../../core/utils/skye_weather_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/forecast_model.dart';
import '../../../core/theme/skye_theme.dart';

/// REDESIGNED Home Screen
/// Complete UI overhaul with new hero section and card-based layout
/// NO animations, NO glassmorphism, NO blur effects
class SkyeHomeScreen extends ConsumerStatefulWidget {
  const SkyeHomeScreen({super.key});

  @override
  ConsumerState<SkyeHomeScreen> createState() => _SkyeHomeScreenState();
}

class _SkyeHomeScreenState extends ConsumerState<SkyeHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(homeProvider.notifier).loadCurrentLocationWeather();
      final weather = ref.read(homeProvider).weather;
      if (weather != null) {
        ref.read(alertsProvider.notifier).loadWeatherAlerts(
              weather.lat,
              weather.lon,
            );
      }
    });
  }

  void _openForecast() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SkyeForecastScreen(),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkyeSettingsScreen()),
    );
  }

  void _openAlerts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkyeAlertsScreen()),
    );
  }

  void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: SkyeColors.blackDeep, // Black background
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeState.error != null
              ? _buildErrorState(homeState.error!)
              : homeState.weather == null
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(homeProvider.notifier).refreshWeather();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // NEW HERO SECTION - 35% of screen height
                            _buildHeroSection(context, size, homeState.weather!),

                            // Content below hero - card-based layout
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Hourly Forecast Card - NOW AT TOP (moved before sun times)
                                  if (homeState.forecast != null &&
                                      homeState.forecast!.hourlyForecasts.isNotEmpty)
                                    _buildHourlyForecastCard(homeState.forecast!),

                                  const SizedBox(height: 16),

                                  // Sun Times Card
                                  _buildSunTimesCard(homeState.weather!),

                                  const SizedBox(height: 16),

                                  // Metrics Card (replaced old animated metrics section)
                                  _buildMetricsCard(homeState.weather!),

                                  const SizedBox(height: 16),

                                  // Daily Forecast Card (new card layout for existing data)
                                  if (homeState.forecast != null &&
                                      homeState.forecast!.dailyForecasts.isNotEmpty)
                                    _buildDailyForecastCard(homeState.forecast!),

                                  const SizedBox(height: 80),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
      // Floating action buttons at top - LEFT AND RIGHT
      floatingActionButton: homeState.weather != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side - Search button
                    _buildActionButton(
                      icon: Icons.search,
                      onTap: _openSearch,
                    ),
                    // Right side - Alerts and Settings
                    Row(
                      children: [
                        _buildAlertActionButton(),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          icon: Icons.settings,
                          onTap: _openSettings,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  /// NEW HERO SECTION - 35% screen height, 2-column layout
  /// Left: City/Country, Date/Time, Condition
  /// Right: Big Temperature + Weather Icon
  Widget _buildHeroSection(BuildContext context, Size size, WeatherModel weather) {
    final condition = weather.getWeatherCondition();
    SkyeWeatherUtils.getWeatherGradient(condition);

    return Container(
      height: size.height * 0.45, // Increased from 35% to 45%
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF242424), Color(0xFF0A0A0A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // LEFT SIDE - Big Temperature + Icon (SWAPPED)
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Big Weather Icon
                    Icon(
                      SkyeWeatherUtils.getWeatherIcon(condition),
                      size: 72,
                      color: SkyeColors.whitePure,
                    ),
                    const SizedBox(height: 8),

                    // Big Temperature
                    Text(
                      '${weather.temperature.round()}°',
                      style: const TextStyle(
                        color: SkyeColors.whitePure,
                        fontSize: 70,
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Feels Like
                    Text(
                      'Feels like ${weather.feelsLike.round()}°',
                      style: const TextStyle(
                        color: SkyeColors.whitePure,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // RIGHT SIDE - Text Information (SWAPPED)
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // City + Country
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            weather.cityName,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Today's Date
                    Text(
                      DateFormat('EEEE, MMM dd').format(DateTime.now()),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Current Time
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        color: SkyeColors.whitePure,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weather Condition Description
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: SkyeColors.whitePure.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        SkyeWeatherUtils.getConditionText(weather.description),
                        style: const TextStyle(
                          color: SkyeColors.whitePure,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// METRICS CARD - Grid layout with all weather metrics
  /// Replaces the old animated metrics section
  Widget _buildMetricsCard(WeatherModel weather) {
    return Container(
      decoration: BoxDecoration(
          color: SkyeColors.cardColor, // New card color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: SkyeColors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2x3 Grid of metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '${weather.humidity}%',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.air,
                  label: 'Wind Speed',
                  value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.compress,
                  label: 'Pressure',
                  value: '${weather.pressure} hPa',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.visibility_outlined,
                  label: 'Visibility',
                  value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Individual metric item
  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SkyeColors.behindContainer, // Behind container color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFFFFFFF), size: 28),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: SkyeColors.whiteFA,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: SkyeColors.whiteF6,
            ),
          ),
        ],
      ),
    );
  }

  /// HOURLY FORECAST CARD - Simple horizontal list
  /// Replaces the old animated hourly strip
  Widget _buildHourlyForecastCard(ForecastModel forecast) {
    final hours = forecast.hourlyForecasts.take(8).toList();

    return Container(
      decoration: BoxDecoration(
        color: SkyeColors.cardColor, // New card color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SkyeColors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today / Hourly',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFAFAFA),
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal scrollable list
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: hours.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final hour = hours[index];
                return _buildHourlyItem(hour);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Individual hourly forecast item
  Widget _buildHourlyItem(HourlyForecast hour) {
    final time = DateTime.fromMillisecondsSinceEpoch(hour.dt * 1000);
    final now = DateTime.now();
    final isNow = time.hour == now.hour && time.day == now.day;

    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: SkyeColors.cardColor, // New card color
        border: isNow
            ? Border.all(color: const Color(0xFFFFFFFF), width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isNow ? 'Now' : DateFormat('HH:mm').format(time),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF6F6F6),
            ),
          ),
          const SizedBox(height: 4),
          Icon(
            _getHourlyIcon(hour.condition, hour.icon),
            size: 26,
            color: SkyeColors.whitePure,
          ),
          const SizedBox(height: 4),
          Text(
            '${hour.temperature.round()}°',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFAFAFA),
            ),
          ),
        ],
      ),
    );
  }

  /// DAILY FORECAST CARD - Vertical list of daily forecasts
  /// New card layout for existing daily forecast data
  Widget _buildDailyForecastCard(ForecastModel forecast) {
    final days = forecast.dailyForecasts.take(7).toList();

    return Container(
      decoration: BoxDecoration(
        color: SkyeColors.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SkyeColors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '7-Day Forecast',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFAFAFA),
                ),
              ),
              GestureDetector(
                onTap: _openForecast,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: SkyeColors.behindContainer, // Behind container color
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFAFAFA),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of daily forecasts
          ...days.map((day) => _buildDailyItem(day)),
        ],
      ),
    );
  }

  /// Individual daily forecast item
  Widget _buildDailyItem(DailyForecast day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Day name
          SizedBox(
            width: 80,
            child: Text(
              day.getDayName(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFAFAFA),
              ),
            ),
          ),

          // Weather icon
          Icon(
            _getHourlyIcon(day.condition, day.icon),
            size: 28,
            color: const Color(0xFFFFFFFF),
          ),

          const Spacer(),

          // Precipitation
          if (day.pop > 0) ...[
            const Icon(
              Icons.water_drop,
              size: 14,
              color: Color(0xFFFFFFFF),
            ),
            const SizedBox(width: 4),
            Text(
              '${(day.pop * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFF6F6F6),
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Min/Max temperature
          Text(
            '${day.minTemp.round()}° / ${day.maxTemp.round()}°',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFAFAFA),
            ),
          ),
        ],
      ),
    );
  }

  /// SUN TIMES CARD - Sunrise and sunset
  /// Replaces old sunrise/sunset section in metrics
  Widget _buildSunTimesCard(WeatherModel weather) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF232125), // New card color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
            children: [
              Expanded(
                child: _buildSunTimeItem(
                  icon: Icons.wb_sunny_rounded,
                  label: 'Sunrise',
                  time: AppDateUtils.getTimeFromTimestamp(weather.sunrise),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSunTimeItem(
                  icon: Icons.nightlight_round,
                  label: 'Sunset',
                  time: AppDateUtils.getTimeFromTimestamp(weather.sunset),
                ),
              ),
            ],
          ),
    );
  }

  /// Individual sun time item
  Widget _buildSunTimeItem({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A1F), // Behind container color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFFFFFF), size: 28),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFAFAFA),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF6F6F6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper to get icon for hourly/daily forecast
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

  /// Action button (search, settings, alerts)
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF232125),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFFFFFF),
          size: 22,
        ),
      ),
    );
  }

  /// Alert action button with badge
  Widget _buildAlertActionButton() {
    final alertsState = ref.watch(alertsProvider);
    final hasAlerts = alertsState.hasActiveAlerts;
    final alertCount = alertsState.activeAlertsCount;

    return GestureDetector(
      onTap: _openAlerts,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF232125),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.warning_rounded,
              color: hasAlerts ? const Color(0xFFEF4444) : const Color(0xFFFFFFFF),
              size: 22,
            ),
          ),
          if (hasAlerts && alertCount > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    alertCount > 9 ? '9+' : alertCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Error state widget
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
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFAFAFA),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFF6F6F6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(homeProvider.notifier).refreshWeather();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF232125),
                foregroundColor: const Color(0xFFFAFAFA),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty state widget
  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No weather data available',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFF6F6F6),
        ),
      ),
    );
  }
}

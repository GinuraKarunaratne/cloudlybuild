import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../forecast/views/cloudly_forecast_screen.dart';
import '../../settings/views/cloudly_settings_screen.dart';
import '../../alerts/views/cloudly_alerts_screen.dart';
import '../../search/views/search_screen.dart';
import '../widgets/weather_quality_section.dart';
import '../../alerts/viewmodels/alerts_viewmodel.dart';
import '../../activities/views/activities_list_screen.dart';
import '../../activities/providers/activities_provider.dart';
import '../../activities/utils/activity_status_evaluator.dart';
import '../../activities/models/activity_model.dart';
import '../../../core/utils/cloudly_weather_utils.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/models/forecast_model.dart';
import '../../../core/theme/cloudly_theme.dart';

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

  void _openActivities() {
    final homeState = ref.read(homeProvider);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivitiesListScreen(
          weather: homeState.weather,
          uvData: homeState.uvData,
        ),
      ),
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

                                  // Weather Quality card placed below the forecast card
                                  if (homeState.forecast != null)
                                    const SizedBox(height: 12),
                                  if (homeState.forecast != null)
                                    WeatherQualitySection(
                                      weather: homeState.weather,
                                      forecast: homeState.forecast,
                                      uvData: homeState.uvData,
                                    ),

                                  const SizedBox(height: 16),

                                  // Activities Preview Card
                                  _buildActivitiesPreviewCard(homeState),

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
                padding: const EdgeInsets.fromLTRB(5, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side - Search button
                    _buildActionButton(
                      icon: Icons.search,
                      onTap: _openSearch,
                    ),
                    // Right side - Activities, Alerts and Settings
                    Row(
                      children: [
                        _buildActionButton(
                          icon: Icons.calendar_today,
                          onTap: _openActivities,
                        ),
                        const SizedBox(width: 12),
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
          colors: [SkyeColors.surfaceMid, SkyeColors.deepSpace],
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
                          color: SkyeColors.whitePure,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            weather.cityName,
                            style: const TextStyle(
                              color: SkyeColors.whitePure,
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
                          color: SkyeColors.whitePure,
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
                        color: SkyeColors.whitePure.withAlphaFromOpacity(0.15),
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
              color: SkyeColors.black.withAlphaFromOpacity(0.3),
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
          Icon(icon, color: SkyeColors.whitePure, size: 28),
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
            color: SkyeColors.black.withAlphaFromOpacity(0.3),
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
              color: SkyeColors.whiteFA,
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
        color: SkyeColors.surfaceMid,
        border: isNow
            ? Border.all(color: SkyeColors.whitePure, width: 2)
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
              color: SkyeColors.whiteF6,
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
              color: SkyeColors.whiteFA,
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
        color: SkyeColors.surfaceMid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SkyeColors.black.withAlphaFromOpacity(0.3),
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
                  color: SkyeColors.whiteFA,
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
                      color: SkyeColors.whiteFA,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List of daily forecasts
          ...days.map((day) => _buildDailyItem(day)),
          const SizedBox(height: 24),
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
                color: SkyeColors.whiteFA,
              ),
            ),
          ),

          // Weather icon
          Icon(
            _getHourlyIcon(day.condition, day.icon),
            size: 28,
            color: SkyeColors.whitePure,
          ),

          const Spacer(),

          // Precipitation
          if (day.pop > 0) ...[
            const Icon(
              Icons.water_drop,
              size: 14,
              color: SkyeColors.whitePure,
            ),
            const SizedBox(width: 4),
            Text(
              '${(day.pop * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: SkyeColors.whiteF6,
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Min/Max temperature
          Text(
            '${day.minTemp.round()}° / ${day.maxTemp.round()}°',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: SkyeColors.whiteFA,
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
        color: SkyeColors.surfaceMid, // Card color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlphaFromOpacity(0.3),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SkyeColors.surfaceMid,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: SkyeColors.whitePure, size: 28),
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
                    color: SkyeColors.whiteFA,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: SkyeColors.whiteF6,
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
          color: SkyeColors.surfaceMid,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlphaFromOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: SkyeColors.whitePure,
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
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: SkyeColors.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlphaFromOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.crisis_alert_rounded,
              color: hasAlerts ? const Color(0xFFEF4444) : SkyeColors.whitePure,
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
                color: SkyeColors.whiteFA,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: SkyeColors.whiteF6,
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
                backgroundColor: SkyeColors.cardColor,
                foregroundColor: SkyeColors.whiteFA,
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
          color: SkyeColors.whiteF6,
        ),
      ),
    );
  }

  /// Activities Preview Card
  Widget _buildActivitiesPreviewCard(HomeState homeState) {
    return Consumer(
      builder: (context, ref, child) {
        final activities = ref.watch(activitiesProvider);
        
        if (activities.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: SkyeColors.surfaceMid,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: SkyeColors.glassBorder),
              boxShadow: [
                BoxShadow(
                  color: SkyeColors.black.withAlphaFromOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Activities', style: SkyeTypography.subtitle),
                    const SizedBox(height: 4),
                    Text('No activities yet', style: SkyeTypography.caption.copyWith(color: SkyeColors.textMuted)),
                  ],
                ),
                GestureDetector(
                  onTap: _openActivities,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: SkyeColors.behindContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Add', style: SkyeTypography.label.copyWith(color: SkyeColors.textPrimary)),
                  ),
                ),
              ],
            ),
          );
        }

        // Compute activity statuses and collect perfect names for banner
        int perfect = 0, caution = 0, notRecommended = 0;
        final List<String> perfectNames = [];
        
        for (var activity in activities) {
          final status = ActivityStatusEvaluator.evaluateStatus(
            activity,
            currentTemp: homeState.weather?.feelsLike ?? 0,
            currentWind: homeState.weather?.windSpeed ?? 0,
            currentVisibility: (homeState.weather?.visibility ?? 0) / 1000.0,
            currentUV: homeState.uvData?.uvIndex ?? 0,
          );
          
          switch (status) {
            case ActivityStatus.perfect:
              perfect++;
              perfectNames.add(activity.name);
              break;
            case ActivityStatus.caution:
              caution++;
              break;
            case ActivityStatus.notRecommended:
              notRecommended++;
              break;
          }
        }

        // If perfect activities exist, show prominent banner first
        if (perfect > 0) {
          final namesToShow = perfectNames.take(2).toList();
          final more = perfectNames.length - namesToShow.length;

          return Column(
            children: [
              // Ideal Weather Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SkyeColors.surfaceMid,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: SkyeColors.glassBorder),
                  boxShadow: [
                    BoxShadow(color: SkyeColors.black.withAlphaFromOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: SkyeColors.success.withAlphaFromOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                      child: const Text('🏆', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ideal Weather', style: SkyeTypography.subtitle),
                          const SizedBox(height: 6),
                          Text(
                            '${namesToShow.join(', ')}${more > 0 ? ' +$more more' : ''}',
                            style: SkyeTypography.body.copyWith(color: SkyeColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _openActivities,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: SkyeColors.behindContainer, borderRadius: BorderRadius.circular(12)),
                        child: Text('View', style: SkyeTypography.label.copyWith(color: SkyeColors.textPrimary)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Compact summary below
              Container(
          decoration: BoxDecoration(
            color: SkyeColors.surfaceMid,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SkyeColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: SkyeColors.black.withAlphaFromOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Activities', style: SkyeTypography.subtitle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (perfect > 0) ...[
                        Text('🟢 $perfect', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
                        const SizedBox(width: 12),
                      ],
                      if (caution > 0) ...[
                        Text('🟡 $caution', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
                        const SizedBox(width: 12),
                      ],
                      if (notRecommended > 0) ...[
                        Text('🔴 $notRecommended', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
                      ],
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: _openActivities,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: SkyeColors.behindContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('View All', style: SkyeTypography.label.copyWith(color: SkyeColors.textPrimary)),
                ),
              ),
            ],
          ),
            ),
            ],
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: SkyeColors.surfaceMid,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SkyeColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: SkyeColors.black.withAlphaFromOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Activities', style: SkyeTypography.subtitle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (perfect > 0) ...[
                        Text('🟢 $perfect', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
                        const SizedBox(width: 12),
                      ],
                      if (caution > 0) ...[
                        Text('🟡 $caution', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
                        const SizedBox(width: 12),
                      ],
                      if (notRecommended > 0) ...[
                        Text('🔴 $notRecommended', style: SkyeTypography.caption.copyWith(color: SkyeColors.textSecondary)),
                      ],
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: _openActivities,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: SkyeColors.behindContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('View All', style: SkyeTypography.label.copyWith(color: SkyeColors.textPrimary)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/skye_theme.dart';
import '../../../data/models/weather_alert_model.dart';
import '../viewmodels/alerts_viewmodel.dart';
import '../../home/viewmodels/home_viewmodel.dart';

/// COMPLETELY REDESIGNED Alerts Screen
/// Modern dark theme with minimal alert cards
class SkyeAlertsScreen extends ConsumerStatefulWidget {
  const SkyeAlertsScreen({super.key});

  @override
  ConsumerState<SkyeAlertsScreen> createState() => _SkyeAlertsScreenState();
}

class _SkyeAlertsScreenState extends ConsumerState<SkyeAlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAlerts();
    });
  }

  void _loadAlerts() {
    final weather = ref.read(homeProvider).weather;
    if (weather != null) {
      ref.read(alertsProvider.notifier).loadWeatherAlerts(
            weather.lat,
            weather.lon,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsState = ref.watch(alertsProvider);
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: SkyeColors.deepSpace, // Black background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildBody(alertsState, homeState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: SkyeColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: SkyeColors.whitePure,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weather Alerts',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: SkyeColors.whiteFA,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ref.watch(homeProvider).weather?.cityName ?? 'Your Location',
                  style: const TextStyle(
                    fontSize: 14,
                    color: SkyeColors.whiteF6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(AlertsState alertsState, HomeState homeState) {
    if (alertsState.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            SizedBox(height: 16),
            Text(
              'Loading alerts...',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      );
    }

    if (alertsState.alerts.isEmpty) {
      return _buildNoAlerts();
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (homeState.weather != null) {
          await ref.read(alertsProvider.notifier).refreshAlerts(
                homeState.weather!.lat,
                homeState.weather!.lon,
              );
        }
      },
      color: const Color(0xFF3B82F6),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: alertsState.sortedAlerts.length,
        itemBuilder: (context, index) {
          return _buildAlertCard(alertsState.sortedAlerts[index]);
        },
      ),
    );
  }

  Widget _buildNoAlerts() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(36),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SkyeColors.cardColor,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              size: 80,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'All Clear',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: SkyeColors.whiteFA,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'No weather alerts for your location. Enjoy the calm!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: SkyeColors.whiteF6,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(WeatherAlertModel alert) {
    final severity = alert.getSeverity();
    final severityColor = _getSeverityColor(severity);
    final severityText = _getSeverityText(severity);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: SkyeColors.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: severityColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: SkyeColors.behindContainer,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.crisis_alert_rounded,
                  color: severityColor,
                  size: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    alert.event,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: SkyeColors.whiteFA,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: SkyeColors.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: severityColor,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    severityText,
                    style: TextStyle(
                      color: severityColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Caution Text
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: severityColor,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _getCautionText(severity),
                    style: const TextStyle(
                      fontSize: 13,
                      color: SkyeColors.whiteF6,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active indicator
          if (alert.isActive())
            Container(
              margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: SkyeColors.behindContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: severityColor,
                    size: 10,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ACTIVE NOW',
                    style: TextStyle(
                      color: severityColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.extreme:
        return const Color.fromARGB(255, 174, 0, 0);
      case AlertSeverity.severe:
        return const Color.fromARGB(255, 198, 82, 0);
      case AlertSeverity.moderate:
        return const Color.fromARGB(255, 176, 126, 0);
      case AlertSeverity.minor:
        return const Color.fromARGB(255, 0, 65, 169);
    }
  }

  String _getSeverityText(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.extreme:
        return 'EXTREME';
      case AlertSeverity.severe:
        return 'SEVERE';
      case AlertSeverity.moderate:
        return 'MODERATE';
      case AlertSeverity.minor:
        return 'MINOR';
    }
  }

  String _getCautionText(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.extreme:
        return 'Take immediate action to protect yourself and others from danger.';
      case AlertSeverity.severe:
        return 'Prepare for hazardous weather conditions and stay alert.';
      case AlertSeverity.moderate:
        return 'Be aware of changing weather conditions and exercise caution.';
      case AlertSeverity.minor:
        return 'Stay informed about current weather conditions in your area.';
    }
  }
}


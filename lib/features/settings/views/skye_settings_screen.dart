import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/skye_theme.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../viewmodels/settings_state.dart';

/// COMPLETELY REDESIGNED Settings Screen
/// Modern grid-based layout with visual cards and dark theme
class SkyeSettingsScreen extends ConsumerWidget {
  const SkyeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: SkyeColors.deepSpace, // Black background
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with back button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                              color: Colors.black.withAlphaFromOpacity(0.3),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: SkyeColors.whiteFA,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Customize your experience',
                            style: TextStyle(
                              fontSize: 12,
                              color: SkyeColors.whiteF6,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content - Complete redesign with grid layout
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Units Grid - 2x2 grid of big visual cards
                  _buildSectionTitle('Preferences'),
                  const SizedBox(height: 16),

                  // Temperature & Wind Speed in a row
                  Row(
                    children: [
                      Expanded(
                        child: _buildBigSettingCard(
                          icon: Icons.thermostat_rounded,
                          title: 'Temperature',
                          value: settingsState.temperatureUnitString,
                          onTap: () => _showTemperatureDialog(context, ref, settingsState),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildBigSettingCard(
                          icon: Icons.air_rounded,
                          title: 'Wind Speed',
                          value: settingsState.windSpeedUnitString,
                          onTap: () => _showWindSpeedDialog(context, ref, settingsState),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Time Format card - full width
                  _buildWideSettingCard(
                    icon: Icons.access_time_rounded,
                    title: 'Time Format',
                    value: settingsState.timeFormatString,
                    onTap: () => _showTimeFormatDialog(context, ref, settingsState),
                  ),

                  const SizedBox(height: 32),

                  // About section with app info
                  _buildSectionTitle('About'),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    icon: Icons.cloud_rounded,
                    title: 'Cloudly',
                    subtitle: 'Version 1.0.0',
                    description: 'Your personal weather companion',
                  ),

                  const SizedBox(height: 48),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: SkyeColors.whiteFA,
        letterSpacing: 0.5,
      ),
    );
  }

  // Big setting card for grid layout
  Widget _buildBigSettingCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: SkyeColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlphaFromOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 36,
                color: SkyeColors.whitePure,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: SkyeColors.whiteFA,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: SkyeColors.whiteF6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Wide setting card for full width
  Widget _buildWideSettingCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: SkyeColors.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlphaFromOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SkyeColors.behindContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: SkyeColors.whitePure,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SkyeColors.whiteF6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: SkyeColors.whiteFA,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: SkyeColors.whitePure,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  // Toggle card for switches

  // Info card for about section
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: SkyeColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlphaFromOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SkyeColors.behindContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: SkyeColors.whitePure,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SkyeColors.whiteFA,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: SkyeColors.whiteFA,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: SkyeColors.whiteF6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTemperatureDialog(BuildContext context, WidgetRef ref, SettingsState state) {
    _showOptionsDialog(
      context: context,
      title: 'Temperature Unit',
      options: ['Celsius', 'Fahrenheit', 'Kelvin'],
      currentValue: state.temperatureUnitString,
      onSelected: (value) {
        final unit = value == 'Celsius'
            ? TemperatureUnit.celsius
            : value == 'Fahrenheit'
                ? TemperatureUnit.fahrenheit
                : TemperatureUnit.kelvin;
        ref.read(settingsProvider.notifier).setTemperatureUnit(unit);
      },
    );
  }

  void _showWindSpeedDialog(BuildContext context, WidgetRef ref, SettingsState state) {
    _showOptionsDialog(
      context: context,
      title: 'Wind Speed Unit',
      options: ['m/s', 'km/h', 'mph'],
      currentValue: state.windSpeedUnitString,
      onSelected: (value) {
        final unit = value == 'm/s'
            ? WindSpeedUnit.metersPerSecond
            : value == 'km/h'
                ? WindSpeedUnit.kilometersPerHour
                : WindSpeedUnit.milesPerHour;
        ref.read(settingsProvider.notifier).setWindSpeedUnit(unit);
      },
    );
  }

  void _showTimeFormatDialog(BuildContext context, WidgetRef ref, SettingsState state) {
    _showOptionsDialog(
      context: context,
      title: 'Time Format',
      options: ['24-hour', '12-hour'],
      currentValue: state.timeFormatString,
      onSelected: (value) {
        final format = value == '24-hour'
            ? TimeFormat.twentyFourHour
            : TimeFormat.twelveHour;
        ref.read(settingsProvider.notifier).setTimeFormat(format);
      },
    );
  }

  void _showOptionsDialog({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: SkyeColors.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: SkyeColors.whiteFA,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option == currentValue;
            return GestureDetector(
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: SkyeColors.behindContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(
                          color: SkyeColors.whitePure,
                          width: 2,
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: SkyeColors.whiteFA,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: SkyeColors.whitePure,
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}


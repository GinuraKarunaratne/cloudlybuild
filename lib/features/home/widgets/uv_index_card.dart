import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/skye_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/models/uv_data_model.dart';
import '../../../core/utils/uv_utils.dart';

class UVIndexCard extends StatelessWidget {
  final UVDataModel uvData;

  const UVIndexCard({
    super.key,
    required this.uvData,
  });

  @override
  Widget build(BuildContext context) {
    final safetyLevel = uvData.getSafetyLevel();
    final isGoldenHour = uvData.isGoldenHour();
    final isPeakHours = uvData.isPeakSunHours();

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 225),
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'UV Index & Sun Safety',
                  style: SkyeTypography.bodySmall.copyWith(
                    color: SkyeColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: UVUtils.getSafetyLevelColor(safetyLevel).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    UVUtils.getSafetyLevelName(safetyLevel).toUpperCase(),
                    style: SkyeTypography.caption.copyWith(
                      color: UVUtils.getSafetyLevelColor(safetyLevel),
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Main content row
            Row(
              children: [
                // UV Index circle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: UVUtils.getSafetyLevelGradient(safetyLevel),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        uvData.uvIndex.toStringAsFixed(1),
                        style: SkyeTypography.temperature.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'UV',
                        style: SkyeTypography.caption.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Info text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UVUtils.getProtectionRecommendation(safetyLevel),
                        style: SkyeTypography.subtitle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getShortMessage(safetyLevel, isPeakHours),
                        style: SkyeTypography.bodySmall.copyWith(
                          color: SkyeColors.textSecondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Special alerts (golden hour or peak hours)
            if (isGoldenHour || (isPeakHours && safetyLevel != UVSafetyLevel.low)) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SkyeColors.glassLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SkyeColors.glassBorder,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isGoldenHour ? Icons.camera_alt_rounded : Icons.warning_amber_rounded,
                      size: 16,
                      color: isGoldenHour ? const Color(0xFFFBBF24) : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isGoldenHour
                            ? 'Golden hour - Perfect for photography!'
                            : 'Peak sun hours - Extra caution needed',
                        style: SkyeTypography.caption.copyWith(
                          color: SkyeColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getShortMessage(UVSafetyLevel level, bool isPeakHours) {
    switch (level) {
      case UVSafetyLevel.low:
        return 'Minimal sun protection required for outdoor activities';
      case UVSafetyLevel.moderate:
        return 'Wear sunscreen SPF 30+, seek shade during midday';
      case UVSafetyLevel.high:
        return 'Sunscreen, hat and sunglasses essential';
      case UVSafetyLevel.veryHigh:
        return 'Avoid sun 10 AM-4 PM, wear protective clothing';
      case UVSafetyLevel.extreme:
        return 'Minimize outdoor exposure, full protection mandatory';
    }
  }
}

import 'package:flutter/material.dart';
import '../theme/skye_theme.dart';
import 'glass_card.dart';

/// Interactive settings tile with glassmorphic design
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (iconColor ?? SkyeColors.skyBlue).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor ?? SkyeColors.skyBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: SkyeTypography.subtitle,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: SkyeTypography.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ] else if (onTap != null)
            Icon(
              Icons.chevron_right_rounded,
              color: SkyeColors.textMuted,
              size: 24,
            ),
        ],
      ),
    );
  }
}

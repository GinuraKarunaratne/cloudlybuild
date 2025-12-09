import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/skye_theme.dart';

/// Premium glassmorphism card with blur and noise texture
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final double blurStrength;
  final bool withBorder;
  final bool withShadow;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.blurStrength = 10,
    this.withBorder = false,
    this.withShadow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor ?? SkyeColors.glassLight,
            borderRadius: BorderRadius.circular(borderRadius),
            border: withBorder
                ? Border.all(
                    color: SkyeColors.glassBorder,
                    width: 1,
                  )
                : null,
            boxShadow: withShadow
                ? [
                    BoxShadow(
                      color: SkyeColors.shadowSoft,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}


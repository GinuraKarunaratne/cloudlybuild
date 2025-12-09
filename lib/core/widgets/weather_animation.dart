import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../data/models/weather_model.dart';

/// Weather animation widget with Lottie support
class WeatherAnimation extends StatelessWidget {
  final WeatherCondition condition;
  final double size;

  const WeatherAnimation({
    super.key,
    required this.condition,
    this.size = 140,
  });

  String _getLottieAsset() {
    switch (condition) {
      case WeatherCondition.sunny:
        return 'assets/animations/sunny.json';
      case WeatherCondition.clearNight:
        return 'assets/animations/night.json';
      case WeatherCondition.cloudy:
        return 'assets/animations/cloudy.json';
      case WeatherCondition.rainy:
        return 'assets/animations/rainy.json';
      case WeatherCondition.snowy:
        return 'assets/animations/snowy.json';
      case WeatherCondition.thunderstorm:
        return 'assets/animations/storm.json';
    }
  }

  IconData _getFallbackIcon() {
    switch (condition) {
      case WeatherCondition.sunny:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.clearNight:
        return Icons.nightlight_round;
      case WeatherCondition.cloudy:
        return Icons.cloud_rounded;
      case WeatherCondition.rainy:
        return Icons.water_drop_rounded;
      case WeatherCondition.snowy:
        return Icons.ac_unit_rounded;
      case WeatherCondition.thunderstorm:
        return Icons.thunderstorm_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _getLottieAsset();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: SizedBox(
            width: size,
            height: size,
            child: FutureBuilder(
              future: _checkAssetExists(assetPath),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return Lottie.asset(
                    assetPath,
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                    repeat: true,
                  );
                }
                // Fallback to animated icon
                return _AnimatedWeatherIcon(
                  icon: _getFallbackIcon(),
                  size: size,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<bool> _checkAssetExists(String path) async {
    try {
      // For now, return false to use fallback icons
      // When Lottie files are added, this can be enhanced
      return false;
    } catch (_) {
      return false;
    }
  }
}

class _AnimatedWeatherIcon extends StatefulWidget {
  final IconData icon;
  final double size;

  const _AnimatedWeatherIcon({
    required this.icon,
    required this.size,
  });

  @override
  State<_AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<_AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Only rotate sun and moon icons
    final shouldRotate = widget.icon == Icons.wb_sunny_rounded ||
        widget.icon == Icons.nightlight_round;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: shouldRotate ? _rotationAnimation.value * 6.28 : 0,
            child: Icon(
              widget.icon,
              size: widget.size,
              color: Colors.white.withOpacity(0.95),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 8),
                  blurRadius: 24,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

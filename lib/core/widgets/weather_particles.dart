import 'package:flutter/material.dart';
import '../theme/skye_theme.dart';
import 'package:newton_particles/newton_particles.dart';
import '../../data/models/weather_model.dart';

/// Full-screen weather particle effects
class WeatherParticles extends StatelessWidget {
  final WeatherCondition condition;
  final bool isDay;

  const WeatherParticles({
    super.key,
    required this.condition,
    this.isDay = true,
  });

  @override
  Widget build(BuildContext context) {
    switch (condition) {
      case WeatherCondition.rainy:
      case WeatherCondition.thunderstorm:
        return _buildRainEffect(heavy: condition == WeatherCondition.thunderstorm);
      case WeatherCondition.snowy:
        return _buildSnowEffect();
      case WeatherCondition.cloudy:
        return _buildCloudyEffect();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRainEffect({bool heavy = false}) {
    return Newton(
      activeEffects: [
        RainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: Size(heavy ? 4 : 3, heavy ? 25 : 20),
            color: SingleParticleColor(
              color: Colors.white.withAlphaFromOpacity(heavy ? 0.7 : 0.6),
            ),
          ),
          effectConfiguration: EffectConfiguration(
            particleCount: heavy ? 150 : 120,
          ),
        ),
      ],
    );
  }

  Widget _buildSnowEffect() {
    return Newton(
      activeEffects: [
        RainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(6, 6),
            color: SingleParticleColor(
              color: Colors.white.withAlphaFromOpacity(0.8),
            ),
          ),
          effectConfiguration: const EffectConfiguration(
            particleCount: 80,
          ),
        ),
      ],
    );
  }

  Widget _buildCloudyEffect() {
    // Subtle particle effect for cloudy weather
    return Newton(
      activeEffects: [
        RainEffect(
          particleConfiguration: ParticleConfiguration(
            shape: CircleShape(),
            size: const Size(2, 2),
            color: SingleParticleColor(
              color: Colors.white.withAlphaFromOpacity(0.1),
            ),
          ),
          effectConfiguration: const EffectConfiguration(
            particleCount: 30,
          ),
        ),
      ],
    );
  }
}


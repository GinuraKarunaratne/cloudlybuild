import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/skye_theme.dart';
import 'features/home/views/skye_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: SkyeColors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: SkyeColors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Enable edge-to-edge mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const ProviderScope(child: SkyeApp()));
}

class SkyeApp extends StatelessWidget {
  const SkyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skye',
      theme: SkyeTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SkyeHomeScreen(),
    );
  }
}


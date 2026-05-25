import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';
import '../widgets/splash_painter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.splashTeal,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  painter: SplashBackgroundPainter(),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                );
              },
            ),
          ),
          // Use provided PNG logo to match reference exactly
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 220,
              fit: BoxFit.contain,
            ),
          ),
          // Decorative details from provided PNGs
          Positioned(
            top: MediaQuery.of(context).padding.top + 40,
            left: 28,
            child: Image.asset('assets/images/cloud.png', width: 90),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 120,
            right: 28,
            child: Image.asset('assets/images/plane.png', width: 56),
          ),
          Positioned(
            bottom: 70,
            right: 54,
            child: Image.asset('assets/images/hat.png', width: 90),
          ),
        ],
      ),
    );
  }
}

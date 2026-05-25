import 'package:flutter/material.dart';
import 'core/di/api_module.dart';
import 'app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/check_email_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/tour_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/fellow4u_design_pages_hub_screen.dart';
import 'features/api_console/presentation/api_test_screen.dart';
import 'dart:ui' show PointerDeviceKind;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiModule.instance.initialize();
  runApp(const Fellow4UApp());
}

class Fellow4UApp extends StatelessWidget {
  const Fellow4UApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fellow4U',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primaryTeal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/sign_in': (context) => const SignInScreen(),
        '/sign_up': (context) => const SignUpScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/check_email': (context) => const CheckEmailScreen(),
        '/explore': (context) => const ExploreScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/tour_detail': (context) => const TourDetailScreen(
              title: 'Da Nang - Ba Na - Hoi An',
              imageAsset: 'assets/images/journey_danang.png',
              price: '\$400.00',
            ),
        '/fellow4u_design_pages_9_10_12': (context) =>
            const Fellow4UDesignPagesHubScreen(),
        '/api_test': (context) => const ApiTestScreen(),
      },
    );
  }
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}

import 'package:flutter/material.dart';

import '../../features/meal_details/ui/meal_details_screen.dart';
import '../../features/splash/ui/splash_screen.dart';
import '../../features/main_screen/ui/main_screen.dart';
import 'routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return _buildRoute(settings: settings, screen: const SplashScreen());
      case Routes.mainScreen:
        return _buildRoute(settings: settings, screen: const MainScreen());
      case Routes.mealDetailsScreen:
        // The meal ID is passed as the route argument.
        final String mealId = settings.arguments as String;
        return _buildRoute(
          settings: settings,
          screen: MealDetailsScreen(mealId: mealId),
        );
      default:
        return _buildRoute(settings: settings, screen: const SplashScreen());
    }
  }

  static MaterialPageRoute<void> _buildRoute({
    required RouteSettings settings,
    required Widget screen,
  }) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => screen,
    );
  }
}

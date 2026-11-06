import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/app_theme.dart';
import 'features/favorites/logic/favorites_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // FavoritesCubit lives above the whole app so both the tab
    // and the details screen share the same favorites state.
    BlocProvider<FavoritesCubit>.value(
      value: favoritesCubit..loadFavorites(),
      child: const FoodRecipeApp(),
    ),
  );
}

class FoodRecipeApp extends StatelessWidget {
  const FoodRecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Recipe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.splashScreen,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

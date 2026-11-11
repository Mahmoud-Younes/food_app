class Routes {
  Routes._();

  static const String splashScreen = '/splash';
  static const String mainScreen = '/main';
  static const String mealDetailsScreen = '/meal-details';
}

/// Arguments for [Routes.mealDetailsScreen]: the meal is still fetched fresh
/// from the API by id, and the image URL lets the details header mount its
/// destination Hero on frame 1, before the fetch answers.
typedef MealDetailsArgs = ({String mealId, String imageUrl});

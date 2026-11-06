import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/data/models/meal_model.dart';

/// Persists favorite meals locally so they survive app restarts.
class FavoritesLocalDataSource {
  static const String _favoritesKey = 'favorite_meals';

  Future<List<MealModel>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_favoritesKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
      return MealModel.fromList(list);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveFavorites(List<MealModel> favorites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString =
        jsonEncode(favorites.map((MealModel meal) => meal.toJson()).toList());
    await prefs.setString(_favoritesKey, jsonString);
  }
}

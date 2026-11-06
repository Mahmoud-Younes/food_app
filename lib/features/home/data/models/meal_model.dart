/// A single ingredient with its measurement.
class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});
}

/// A meal. The same model handles the three API shapes safely:
/// - filter.php / summary: idMeal, strMeal, strMealThumb only.
/// - lookup.php / details: every field including ingredients 1..20.
/// - search.php: full meal objects too.
class MealModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final String area;
  final String instructions;
  final String youtubeUrl;
  final List<Ingredient> ingredients;

  const MealModel({
    required this.id,
    required this.name,
    required this.image,
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.youtubeUrl = '',
    this.ingredients = const [],
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal']?.toString() ?? '',
      name: json['strMeal']?.toString() ?? '',
      image: json['strMealThumb']?.toString() ?? '',
      category: json['strCategory']?.toString() ?? '',
      area: json['strArea']?.toString() ?? '',
      instructions: json['strInstructions']?.toString() ?? '',
      youtubeUrl: json['strYoutube']?.toString() ?? '',
      ingredients: _parseIngredients(json),
    );
  }

  /// TheMealDB stores ingredients in strIngredient1..20 and
  /// strMeasure1..20. Empty entries (null or blank) are skipped.
  static List<Ingredient> _parseIngredients(Map<String, dynamic> json) {
    final List<Ingredient> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final String name =
          json['strIngredient$i']?.toString().trim() ?? '';
      if (name.isEmpty) continue;
      final String measure =
          json['strMeasure$i']?.toString().trim() ?? '';
      ingredients.add(Ingredient(name: name, measure: measure));
    }
    return ingredients;
  }

  /// Only the fields needed to render a favorite meal are persisted
  /// locally (same keys as the API for easy round-tripping).
  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': image,
    };
  }

  static List<MealModel> fromList(List<dynamic> list) {
    return list
        .map((item) => MealModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

import 'package:flutter_test/flutter_test.dart';

import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/models/meal_model.dart';

void main() {
  group('MealModel.fromJson', () {
    test('parses full meal details with ingredients safely', () {
      final Map<String, dynamic> json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strCategory': 'Chicken',
        'strArea': 'Japanese',
        'strInstructions': 'Preheat oven to 350° F.\nSpray a 9x13-inch pan.',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/x.jpg',
        'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
        'strIngredient1': 'soy sauce',
        'strMeasure1': '3/4 cup',
        'strIngredient2': null,
        'strMeasure2': null,
        'strIngredient3': '',
        'strMeasure3': '',
      };

      final MealModel meal = MealModel.fromJson(json);

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken Casserole');
      expect(meal.category, 'Chicken');
      expect(meal.area, 'Japanese');
      expect(meal.youtubeUrl, 'https://www.youtube.com/watch?v=4aZr5hZXP_s');
      expect(meal.ingredients, hasLength(1));
      expect(meal.ingredients.first.name, 'soy sauce');
      expect(meal.ingredients.first.measure, '3/4 cup');
    });

    test('handles summary JSON (filter.php) with null safety', () {
      final Map<String, dynamic> json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/x.jpg',
      };

      final MealModel meal = MealModel.fromJson(json);

      expect(meal.id, '52772');
      expect(meal.category, '');
      expect(meal.ingredients, isEmpty);
    });

    test('round-trips through toJson for local storage', () {
      final Map<String, dynamic> json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/x.jpg',
      };

      final MealModel meal = MealModel.fromJson(json);
      final MealModel restored = MealModel.fromJson(meal.toJson());

      expect(restored.id, meal.id);
      expect(restored.name, meal.name);
      expect(restored.image, meal.image);
    });
  });

  group('CategoryModel.fromJson', () {
    test('parses category fields', () {
      final Map<String, dynamic> json = {
        'idCategory': '1',
        'strCategory': 'Beef',
        'strCategoryThumb':
            'https://www.themealdb.com/images/category/beef.png',
        'strCategoryDescription': 'Beef is the culinary name for meat...',
      };

      final category = CategoryModel.fromJson(json);

      expect(category.id, '1');
      expect(category.name, 'Beef');
      expect(category.image, contains('beef.png'));
    });
  });
}

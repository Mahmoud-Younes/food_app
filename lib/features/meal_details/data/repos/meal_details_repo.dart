import '../../../../core/networking/api_service.dart';
import '../../../home/data/models/meal_model.dart';

class MealDetailsRepo {
  final ApiService _apiService;

  MealDetailsRepo(this._apiService);

  Future<MealModel> getMealDetails(String mealId) async {
    final Map<String, dynamic> data = await _apiService.getMealDetails(mealId);
    final List<dynamic>? meals = data['meals'] as List<dynamic>?;
    if (meals == null || meals.isEmpty) {
      throw Exception('Meal not found');
    }
    return MealModel.fromJson(meals.first as Map<String, dynamic>);
  }
}

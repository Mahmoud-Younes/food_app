import '../../../../core/networking/api_service.dart';
import '../models/category_model.dart';
import '../models/meal_model.dart';

class HomeRepo {
  final ApiService _apiService;

  HomeRepo(this._apiService);

  Future<List<CategoryModel>> getCategories() async {
    final Map<String, dynamic> data = await _apiService.getCategories();
    final List<dynamic>? categories = data['categories'] as List<dynamic>?;
    return CategoryModel.fromList(categories ?? []);
  }

  Future<List<MealModel>> getMealsByCategory(String category) async {
    final Map<String, dynamic> data =
        await _apiService.getMealsByCategory(category);
    final List<dynamic>? meals = data['meals'] as List<dynamic>?;
    return MealModel.fromList(meals ?? []);
  }
}

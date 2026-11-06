import '../../../../core/networking/api_service.dart';
import '../../../home/data/models/meal_model.dart';

class SearchRepo {
  final ApiService _apiService;

  SearchRepo(this._apiService);

  /// The API returns {"meals": null} when nothing matches,
  /// so we return an empty list instead of null.
  Future<List<MealModel>> searchMeals(String query) async {
    final Map<String, dynamic> data = await _apiService.searchMeals(query);
    final List<dynamic>? meals = data['meals'] as List<dynamic>?;
    return MealModel.fromList(meals ?? []);
  }
}

import 'package:dio/dio.dart';

import 'api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  /// Endpoint (1): Get all categories.
  Future<Map<String, dynamic>> getCategories() async {
    final Response response = await _dio.get(ApiConstants.categories);
    return response.data as Map<String, dynamic>;
  }

  /// Endpoint (2): Get meals inside a specific category.
  Future<Map<String, dynamic>> getMealsByCategory(String category) async {
    final Response response = await _dio.get(
      ApiConstants.filterByCategory,
      queryParameters: {ApiConstants.categoryKey: category},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Endpoint (3): Get full meal details by its ID.
  Future<Map<String, dynamic>> getMealDetails(String mealId) async {
    final Response response = await _dio.get(
      ApiConstants.mealDetails,
      queryParameters: {ApiConstants.mealIdKey: mealId},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Endpoint (4): Search for a meal by name.
  /// Returns {"meals": null} when nothing matches, the repo converts it to [].
  Future<Map<String, dynamic>> searchMeals(String query) async {
    final Response response = await _dio.get(
      ApiConstants.searchByName,
      queryParameters: {ApiConstants.searchKey: query},
    );
    return response.data as Map<String, dynamic>;
  }
}

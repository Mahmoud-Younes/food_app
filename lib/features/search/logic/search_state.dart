import '../../../../core/helpers/enums.dart';
import '../../home/data/models/meal_model.dart';

class SearchState {
  final RequestStatus status;
  final String query;
  final List<MealModel> meals;
  final String? errorMessage;

  const SearchState({
    this.status = RequestStatus.initial,
    this.query = '',
    this.meals = const [],
    this.errorMessage,
  });

  SearchState.initial() : this();

  SearchState copyWith({
    RequestStatus? status,
    String? query,
    List<MealModel>? meals,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      meals: meals ?? this.meals,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

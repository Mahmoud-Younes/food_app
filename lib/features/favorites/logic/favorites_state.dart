import '../../../../core/helpers/enums.dart';
import '../../home/data/models/meal_model.dart';

class FavoritesState {
  final RequestStatus status;
  final List<MealModel> favorites;
  final String? errorMessage;

  const FavoritesState({
    this.status = RequestStatus.initial,
    this.favorites = const [],
    this.errorMessage,
  });

  FavoritesState.initial() : this();

  FavoritesState copyWith({
    RequestStatus? status,
    List<MealModel>? favorites,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

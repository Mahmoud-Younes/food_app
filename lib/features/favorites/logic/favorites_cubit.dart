import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/enums.dart';
import '../data/repos/favorites_repo.dart';
import '../../home/data/models/meal_model.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo _favoritesRepo;

  FavoritesCubit(this._favoritesRepo) : super(FavoritesState.initial());

  bool isFavorite(String mealId) {
    return state.favorites.any((MealModel meal) => meal.id == mealId);
  }

  /// Loads favorites from local storage (called once at app start).
  Future<void> loadFavorites() async {
    emit(state.copyWith(status: RequestStatus.loading));
    try {
      final List<MealModel> favorites = await _favoritesRepo.getFavorites();
      emit(state.copyWith(
        status: RequestStatus.success,
        favorites: favorites,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: RequestStatus.error,
        errorMessage: 'Could not load your favorites.',
      ));
    }
  }

  /// Adds/removes a meal, updates the UI immediately, then persists.
  Future<void> toggleFavorite(MealModel meal) async {
    final List<MealModel> previous = state.favorites;
    final List<MealModel> updated = List<MealModel>.of(previous);

    final int index = updated.indexWhere((m) => m.id == meal.id);
    if (index >= 0) {
      updated.removeAt(index);
    } else {
      updated.insert(0, meal);
    }

    emit(state.copyWith(status: RequestStatus.success, favorites: updated));

    try {
      await _favoritesRepo.saveFavorites(updated);
    } catch (_) {
      // Persisting failed: revert to the previous list.
      emit(state.copyWith(status: RequestStatus.success, favorites: previous));
    }
  }
}

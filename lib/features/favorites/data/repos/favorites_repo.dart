import '../local/favorites_local_data_source.dart';
import '../../../home/data/models/meal_model.dart';

class FavoritesRepo {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepo(this._localDataSource);

  Future<List<MealModel>> getFavorites() {
    return _localDataSource.getFavorites();
  }

  Future<void> saveFavorites(List<MealModel> favorites) {
    return _localDataSource.saveFavorites(favorites);
  }
}

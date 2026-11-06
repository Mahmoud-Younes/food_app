import 'package:dio/dio.dart';

import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../../features/favorites/data/local/favorites_local_data_source.dart';
import '../../features/favorites/data/repos/favorites_repo.dart';
import '../../features/favorites/logic/favorites_cubit.dart';
import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/logic/home_cubit.dart';
import '../../features/meal_details/data/repos/meal_details_repo.dart';
import '../../features/search/data/repos/search_repo.dart';
import '../../features/search/logic/search_cubit.dart';

/// Simple manual dependency injection (singletons for the app lifetime).

// Networking
final Dio dio = DioFactory.getDio();
final ApiService apiService = ApiService(dio);

// Repos
final HomeRepo homeRepo = HomeRepo(apiService);
final SearchRepo searchRepo = SearchRepo(apiService);
final MealDetailsRepo mealDetailsRepo = MealDetailsRepo(apiService);
final FavoritesLocalDataSource favoritesLocalDataSource =
    FavoritesLocalDataSource();
final FavoritesRepo favoritesRepo = FavoritesRepo(favoritesLocalDataSource);

// Cubits (MealDetailsCubit is created per-screen in its BlocProvider)
final HomeCubit homeCubit = HomeCubit(homeRepo);
final SearchCubit searchCubit = SearchCubit(searchRepo);
final FavoritesCubit favoritesCubit = FavoritesCubit(favoritesRepo);

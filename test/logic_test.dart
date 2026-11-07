import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_app/core/helpers/enums.dart';
import 'package:food_app/core/networking/api_constants.dart';
import 'package:food_app/core/networking/api_service.dart';
import 'package:food_app/features/favorites/data/local/favorites_local_data_source.dart';
import 'package:food_app/features/favorites/data/repos/favorites_repo.dart';
import 'package:food_app/features/favorites/logic/favorites_cubit.dart';
import 'package:food_app/features/home/data/models/meal_model.dart';
import 'package:food_app/features/home/data/repos/home_repo.dart';
import 'package:food_app/features/home/logic/home_cubit.dart';
import 'package:food_app/features/home/logic/home_state.dart';
import 'package:food_app/features/meal_details/data/repos/meal_details_repo.dart';
import 'package:food_app/features/meal_details/logic/meal_details_cubit.dart';
import 'package:food_app/features/meal_details/logic/meal_details_state.dart';
import 'package:food_app/features/search/data/repos/search_repo.dart';
import 'package:food_app/features/search/logic/search_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ---------------------------------------------------------------------------
/// Fake Dio layer: a [HttpClientAdapter] serving static TheMealDB-shaped JSON
/// per endpoint (categories.php, filter.php, lookup.php, search.php), so the
/// real [ApiService] -> repos -> cubits chain runs without any new package.
/// ---------------------------------------------------------------------------
class _FakeMealAdapter implements HttpClientAdapter {
  /// How many times categories.php should fail with a connection error
  /// before serving data (models an offline network that recovers).
  int categoriesFailuresRemaining;

  _FakeMealAdapter({this.categoriesFailuresRemaining = 0});

  /// Every request the ApiService actually issued, in order.
  final List<RequestOptions> requests = <RequestOptions>[];

  /// The `s` query values that reached search.php, in order.
  final List<String> searchQueries = <String>[];

  List<RequestOptions> requestsTo(String endpoint) => requests
      .where((RequestOptions r) => r.uri.path.endsWith(endpoint))
      .toList();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);

    final Uri uri = options.uri;
    final Map<String, String> query = uri.queryParameters;

    if (uri.path.endsWith(ApiConstants.categories)) {
      if (categoriesFailuresRemaining > 0) {
        categoriesFailuresRemaining--;
        throw DioException.connectionError(
          requestOptions: options,
          reason: 'simulated offline network',
        );
      }
      return _json(const <String, dynamic>{
        'categories': <Map<String, dynamic>>[
          <String, dynamic>{
            'idCategory': '1',
            'strCategory': 'Beef',
            'strCategoryThumb':
                'https://www.themealdb.com/images/category/beef.png',
            'strCategoryDescription': 'Beef is meat from cattle.',
          },
          <String, dynamic>{
            'idCategory': '2',
            'strCategory': 'Seafood',
            'strCategoryThumb':
                'https://www.themealdb.com/images/category/seafood.png',
            'strCategoryDescription': 'Seafood is food from the sea.',
          },
        ],
      });
    }

    if (uri.path.endsWith(ApiConstants.filterByCategory)) {
      final String category = query[ApiConstants.categoryKey] ?? '';
      if (category == 'Beef') {
        return _json(const <String, dynamic>{
          'meals': <Map<String, dynamic>>[
            <String, dynamic>{
              'idMeal': '52835',
              'strMeal': 'Beef and Mustard Pie',
              'strMealThumb':
                  'https://www.themealdb.com/images/media/meals/sytuqu.jpg',
            },
            <String, dynamic>{
              'idMeal': '52874',
              'strMeal': 'Beef Brisket Pot Roast',
              'strMealThumb':
                  'https://www.themealdb.com/images/media/meals/ursuup.jpg',
            },
          ],
        });
      }
      if (category == 'Seafood') {
        return _json(const <String, dynamic>{
          'meals': <Map<String, dynamic>>[
            <String, dynamic>{
              'idMeal': '53000',
              'strMeal': 'Salmon Prawn Risotto',
              'strMealThumb':
                  'https://www.themealdb.com/images/media/meals/xxrxux.jpg',
            },
            <String, dynamic>{
              'idMeal': '53001',
              'strMeal': 'Fish fritters',
              'strMealThumb':
                  'https://www.themealdb.com/images/media/meals/ttpxwx.jpg',
            },
          ],
        });
      }
      // Unknown category: TheMealDB answers {"meals": null}.
      return _json(const <String, dynamic>{'meals': null});
    }

    if (uri.path.endsWith(ApiConstants.mealDetails)) {
      final String mealId = query[ApiConstants.mealIdKey] ?? '';
      if (mealId == '52772') {
        return _json(const <String, dynamic>{
          'meals': <Map<String, dynamic>>[
            <String, dynamic>{
              'idMeal': '52772',
              'strMeal': 'Teriyaki Chicken Casserole',
              'strCategory': 'Chicken',
              'strArea': 'Japanese',
              'strInstructions': 'Preheat oven to 350 F.',
              'strMealThumb':
                  'https://www.themealdb.com/images/media/meals/wvpsxy.jpg',
              'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
              'strIngredient1': 'soy sauce',
              'strMeasure1': '3/4 cup',
              'strIngredient2': 'carrots',
              'strMeasure2': '2 sliced',
              'strIngredient3': null,
              'strMeasure3': null,
            },
          ],
        });
      }
      // Unknown id: TheMealDB answers {"meals": null}.
      return _json(const <String, dynamic>{'meals': null});
    }

    if (uri.path.endsWith(ApiConstants.searchByName)) {
      final String term = query[ApiConstants.searchKey] ?? '';
      searchQueries.add(term);
      if (term == 'burger') {
        return _json(const <String, dynamic>{
          'meals': <Map<String, dynamic>>[
            <String, dynamic>{
              'idMeal': '53013',
              'strMeal': 'Smoky Burgers',
              'strMealThumb':
                  'https://www.themealdb.com/images/media/meals/xbx20u1583229801.jpg',
            },
            <String, dynamic>{
              'idMeal': '53043',
              'strMeal': 'Rock Burgers',
              'strMealThumb':
                  'https://www.themealdb.com/images/media/meals/wrssvt1559650033.jpg',
            },
          ],
        });
      }
      // Empty or unmatched search: TheMealDB answers {"meals": null}.
      return _json(const <String, dynamic>{'meals': null});
    }

    throw DioException.connectionError(
      requestOptions: options,
      reason: 'unexpected endpoint: $uri',
    );
  }

  @override
  void close({bool force = false}) {}

  static ResponseBody _json(Map<String, dynamic> body) {
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }
}

Dio _dioWith(_FakeMealAdapter adapter) {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.apiBaseUrl));
  dio.httpClientAdapter = adapter;
  return dio;
}

MealModel _meal({String id = '52772', String name = 'Teriyaki Chicken Casserole'}) {
  return MealModel(
    id: id,
    name: name,
    image: 'https://www.themealdb.com/images/media/meals/$id.jpg',
  );
}

/// Collects every state a cubit emits while [action] runs.
Future<List<T>> _collectStates<T>(
  Stream<T> stream,
  Future<void> Function() action,
) async {
  final List<T> states = <T>[];
  final StreamSubscription<T> subscription = stream.listen(states.add);
  await action();
  // Drain any emission that lands right after the action resolves.
  await Future<void>.delayed(Duration.zero);
  await subscription.cancel();
  return states;
}

void main() {
  group('ApiService (via FakeMealAdapter)', () {
    test('getCategories decodes categories.php into a map', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final ApiService apiService = ApiService(_dioWith(adapter));

      final Map<String, dynamic> data = await apiService.getCategories();

      expect(data['categories'], hasLength(2));
      expect(
        (data['categories']!.first as Map<String, dynamic>)['strCategory'],
        'Beef',
      );
      expect(adapter.requestsTo('categories.php'), hasLength(1));
    });

    test('getMealsByCategory sends the category as the "c" query', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final ApiService apiService = ApiService(_dioWith(adapter));

      await apiService.getMealsByCategory('Beef');

      expect(adapter.requestsTo('filter.php'), hasLength(1));
      expect(
        adapter.requestsTo('filter.php').first.queryParameters['c'],
        'Beef',
      );
    });

    test('getMealDetails sends the id as the "i" query', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final ApiService apiService = ApiService(_dioWith(adapter));

      await apiService.getMealDetails('52772');

      expect(adapter.requestsTo('lookup.php'), hasLength(1));
      expect(
        adapter.requestsTo('lookup.php').first.queryParameters['i'],
        '52772',
      );
    });

    test('searchMeals sends the term as the "s" query', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final ApiService apiService = ApiService(_dioWith(adapter));

      final Map<String, dynamic> data = await apiService.searchMeals('burger');

      expect(adapter.searchQueries, <String>['burger']);
      expect(data['meals'], hasLength(2));
    });

    test('searchMeals with an empty s returns {"meals": null}', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final ApiService apiService = ApiService(_dioWith(adapter));

      final Map<String, dynamic> data = await apiService.searchMeals('');

      expect(adapter.searchQueries, <String>['']);
      // TheMealDB answers null for an empty search — must reach us as null.
      expect(data['meals'], isNull);
    });
  });

  group('Repos', () {
    test('HomeRepo.getCategories maps categories.php into models', () async {
      final HomeRepo repo = HomeRepo(ApiService(_dioWith(_FakeMealAdapter())));

      final categories = await repo.getCategories();

      expect(categories, hasLength(2));
      expect(categories.first.name, 'Beef');
      expect(categories.last.name, 'Seafood');
    });

    test('HomeRepo.getMealsByCategory turns {"meals": null} into []',
        () async {
      final HomeRepo repo = HomeRepo(ApiService(_dioWith(_FakeMealAdapter())));

      final meals = await repo.getMealsByCategory('UnknownCategory');

      expect(meals, isEmpty);
    });

    test('SearchRepo.searchMeals returns meals for a matching term',
        () async {
      final SearchRepo repo =
          SearchRepo(ApiService(_dioWith(_FakeMealAdapter())));

      final meals = await repo.searchMeals('burger');

      expect(meals, hasLength(2));
      expect(meals.first.name, 'Smoky Burgers');
    });

    test('SearchRepo.searchMeals turns null meals (empty search) into []',
        () async {
      final SearchRepo repo =
          SearchRepo(ApiService(_dioWith(_FakeMealAdapter())));

      // search.php?s= (empty) answers {"meals": null} — never a crash.
      final meals = await repo.searchMeals('');

      expect(meals, isEmpty);
    });

    test('MealDetailsRepo.getMealDetails maps lookup.php into a full meal',
        () async {
      final MealDetailsRepo repo =
          MealDetailsRepo(ApiService(_dioWith(_FakeMealAdapter())));

      final meal = await repo.getMealDetails('52772');

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken Casserole');
      expect(meal.area, 'Japanese');
      expect(meal.ingredients.map((i) => i.name), <String>['soy sauce', 'carrots']);
    });

    test('MealDetailsRepo.getMealDetails throws for an unknown id', () async {
      final MealDetailsRepo repo =
          MealDetailsRepo(ApiService(_dioWith(_FakeMealAdapter())));

      await expectLater(repo.getMealDetails('999999'), throwsException);
    });
  });

  group('HomeCubit', () {
    test('loadHomeData emits loading then success for categories and meals',
        () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final HomeCubit cubit = HomeCubit(HomeRepo(ApiService(_dioWith(adapter))));

      final List<HomeState> states = await _collectStates(
        cubit.stream,
        cubit.loadHomeData,
      );

      // categories loading -> categories success -> meals loading -> meals success.
      expect(states[0].categoriesStatus, RequestStatus.loading);
      expect(states[1].categoriesStatus, RequestStatus.success);
      expect(states[2].mealsStatus, RequestStatus.loading);
      expect(states[3].mealsStatus, RequestStatus.success);

      // Final state: 2 categories, first one selected by default, its meals loaded.
      expect(cubit.state.categories, hasLength(2));
      expect(cubit.state.selectedCategoryIndex, 0);
      expect(cubit.state.mealsStatus, RequestStatus.success);
      expect(cubit.state.meals, hasLength(2));
      expect(cubit.state.meals.first.name, 'Beef and Mustard Pie');

      // It fetched categories.php once and filter.php?c=Beef once.
      expect(adapter.requestsTo('categories.php'), hasLength(1));
      expect(
        adapter.requestsTo('filter.php').single.queryParameters['c'],
        'Beef',
      );
    });

    test('adapter error yields an error state that can be retried', () async {
      // First categories.php call fails, later ones succeed.
      final _FakeMealAdapter adapter =
          _FakeMealAdapter(categoriesFailuresRemaining: 1);
      final HomeCubit cubit = HomeCubit(HomeRepo(ApiService(_dioWith(adapter))));

      await cubit.loadHomeData();

      expect(cubit.state.categoriesStatus, RequestStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
      expect(cubit.state.mealsStatus, RequestStatus.initial);

      // Retry after the network "recovers" succeeds.
      await cubit.loadHomeData();

      expect(cubit.state.categoriesStatus, RequestStatus.success);
      expect(cubit.state.categories, hasLength(2));
      expect(cubit.state.mealsStatus, RequestStatus.success);
      expect(adapter.requestsTo('categories.php'), hasLength(2));
    });

    test('selecting another category re-fetches its meals', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final HomeCubit cubit = HomeCubit(HomeRepo(ApiService(_dioWith(adapter))));
      await cubit.loadHomeData();

      await cubit.selectCategory(1);

      expect(cubit.state.selectedCategoryIndex, 1);
      expect(cubit.state.mealsStatus, RequestStatus.success);
      expect(cubit.state.meals, hasLength(2));
      expect(cubit.state.meals.first.name, 'Salmon Prawn Risotto');
      // filter.php was requested once per category, with the right c value.
      final List<String> categoryParams = adapter
          .requestsTo('filter.php')
          .map((RequestOptions r) => r.queryParameters['c'] as String)
          .toList();
      expect(categoryParams, <String>['Beef', 'Seafood']);
    });

    test('selectCategory with an out-of-range index does nothing', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final HomeCubit cubit = HomeCubit(HomeRepo(ApiService(_dioWith(adapter))));
      await cubit.loadHomeData();
      final int filterCallsBefore = adapter.requestsTo('filter.php').length;

      await cubit.selectCategory(7);

      expect(cubit.state.selectedCategoryIndex, 0);
      expect(adapter.requestsTo('filter.php'), hasLength(filterCallsBefore));
    });
  });

  group('SearchCubit', () {
    test('rapid typing produces exactly one debounced request for the '
        'final text', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final SearchCubit cubit =
          SearchCubit(SearchRepo(ApiService(_dioWith(adapter))));

      cubit.onSearchChanged('b');
      await Future<void>.delayed(const Duration(milliseconds: 120));
      cubit.onSearchChanged('bu');
      await Future<void>.delayed(const Duration(milliseconds: 120));
      cubit.onSearchChanged('burger');

      // Still inside the debounce window: nothing hit the network yet.
      expect(adapter.searchQueries, isEmpty);

      // 500ms debounce elapses; the fake adapter answers immediately.
      await Future<void>.delayed(const Duration(milliseconds: 700));

      // Exactly one call, for the last text only.
      expect(adapter.searchQueries, <String>['burger']);
      expect(cubit.state.status, RequestStatus.success);
      expect(cubit.state.query, 'burger');
      expect(cubit.state.meals, hasLength(2));
      expect(cubit.state.meals.first.name, 'Smoky Burgers');

      await cubit.close();
    });

    test('a query with no results turns {"meals": null} into an empty '
        'success state, not a crash', () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final SearchCubit cubit =
          SearchCubit(SearchRepo(ApiService(_dioWith(adapter))));

      cubit.onSearchChanged('zzz-no-such-meal');
      await Future<void>.delayed(const Duration(milliseconds: 700));

      expect(cubit.state.status, RequestStatus.success);
      expect(cubit.state.meals, isEmpty);
      expect(cubit.state.errorMessage, isNull);

      await cubit.close();
    });

    test('an empty/whitespace query resets to initial without any request',
        () async {
      final _FakeMealAdapter adapter = _FakeMealAdapter();
      final SearchCubit cubit =
          SearchCubit(SearchRepo(ApiService(_dioWith(adapter))));

      cubit.onSearchChanged('   ');
      await Future<void>.delayed(const Duration(milliseconds: 700));

      expect(cubit.state.status, RequestStatus.initial);
      expect(adapter.searchQueries, isEmpty);

      await cubit.close();
    });
  });

  group('FavoritesCubit', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('toggleFavorite adds a meal then removes it on second toggle',
        () async {
      final FavoritesCubit cubit = FavoritesCubit(
        FavoritesRepo(FavoritesLocalDataSource()),
      );
      final MealModel meal = _meal();

      await cubit.loadFavorites();
      expect(cubit.state.favorites, isEmpty);

      await cubit.toggleFavorite(meal);

      expect(cubit.state.favorites, hasLength(1));
      expect(cubit.state.favorites.first.id, '52772');
      expect(cubit.isFavorite('52772'), isTrue);

      await cubit.toggleFavorite(meal);

      expect(cubit.state.favorites, isEmpty);
      expect(cubit.isFavorite('52772'), isFalse);
    });

    test('loadFavorites reads the persisted store', () async {
      // Pre-seed storage the way a previous session would have left it.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'favorite_meals': jsonEncode(<Map<String, dynamic>>[
          _meal(id: '52772').toJson(),
          _meal(id: '52835', name: 'Beef and Mustard Pie').toJson(),
        ]),
      });
      final FavoritesCubit cubit = FavoritesCubit(
        FavoritesRepo(FavoritesLocalDataSource()),
      );

      await cubit.loadFavorites();

      expect(cubit.state.status, RequestStatus.success);
      expect(cubit.state.favorites.map((m) => m.id),
          <String>['52772', '52835']);
    });

    test('favorites survive a brand-new cubit reading the same prefs',
        () async {
      // Session 1: favorite a meal (persisted through shared_preferences).
      final FavoritesCubit firstSession = FavoritesCubit(
        FavoritesRepo(FavoritesLocalDataSource()),
      );
      await firstSession.loadFavorites();
      await firstSession.toggleFavorite(_meal());
      expect(firstSession.state.favorites, hasLength(1));

      // Session 2 ("app restart"): fresh instances, same mocked store.
      final FavoritesCubit secondSession = FavoritesCubit(
        FavoritesRepo(FavoritesLocalDataSource()),
      );
      await secondSession.loadFavorites();

      expect(secondSession.state.status, RequestStatus.success);
      expect(secondSession.state.favorites, hasLength(1));
      expect(secondSession.state.favorites.first.id, '52772');
      expect(secondSession.state.favorites.first.name,
          'Teriyaki Chicken Casserole');
      expect(secondSession.isFavorite('52772'), isTrue);
    });

    test('toggleFavorite reverts in-memory state when persisting fails',
        () async {
      // A data source whose save always throws (e.g. disk failure).
      final FavoritesLocalDataSource brokenSource =
          _BrokenSaveLocalDataSource();
      final FavoritesCubit cubit = FavoritesCubit(FavoritesRepo(brokenSource));

      final MealModel kept = _meal(id: '52772');
      final MealModel rejected = _meal(id: '99999', name: 'Broken Meal');

      await cubit.loadFavorites();
      await cubit.toggleFavorite(kept); // succeeds: save works here? No — broken.
      // With a broken source the optimistic add is reverted, so the list is
      // back to empty.

      expect(cubit.state.favorites, isEmpty);
      expect(cubit.isFavorite('52772'), isFalse);

      // Same story when something was already in the list.
      SharedPreferences.setMockInitialValues(<String, Object>{
        'favorite_meals': jsonEncode(<Map<String, dynamic>>[kept.toJson()]),
      });
      final FavoritesCubit seededCubit =
          FavoritesCubit(FavoritesRepo(brokenSource));
      await seededCubit.loadFavorites();
      await seededCubit.toggleFavorite(rejected);

      expect(seededCubit.state.favorites.map((m) => m.id), <String>['52772']);
      expect(seededCubit.isFavorite('99999'), isFalse);
    });
  });

  group('MealDetailsCubit', () {
    test('getMealDetails emits loading then success from lookup.php',
        () async {
      final MealDetailsCubit cubit = MealDetailsCubit(
        MealDetailsRepo(ApiService(_dioWith(_FakeMealAdapter()))),
      );

      final List<MealDetailsState> states = await _collectStates(
        cubit.stream,
        () => cubit.getMealDetails('52772'),
      );

      expect(states[0].status, RequestStatus.loading);
      expect(states[1].status, RequestStatus.success);

      expect(cubit.state.meal, isNotNull);
      expect(cubit.state.meal!.name, 'Teriyaki Chicken Casserole');
      expect(cubit.state.meal!.area, 'Japanese');
      expect(cubit.state.meal!.category, 'Chicken');
      expect(cubit.state.meal!.ingredients, hasLength(2));
    });

    test('an unknown meal id yields an error state with a message', () async {
      final MealDetailsCubit cubit = MealDetailsCubit(
        MealDetailsRepo(ApiService(_dioWith(_FakeMealAdapter()))),
      );

      await cubit.getMealDetails('999999');

      expect(cubit.state.status, RequestStatus.error);
      expect(cubit.state.errorMessage, isNotNull);
      expect(cubit.state.meal, isNull);
    });
  });
}

/// Favorites storage whose writes always fail (network-free persistence
/// error injection, no extra packages).
class _BrokenSaveLocalDataSource extends FavoritesLocalDataSource {
  @override
  Future<void> saveFavorites(List<MealModel> favorites) async {
    throw Exception('simulated disk failure');
  }
}

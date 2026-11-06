import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/enums.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../data/models/category_model.dart';
import '../data/models/meal_model.dart';
import '../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeState.initial());

  /// Loads categories, then selects the first one by default.
  Future<void> loadHomeData() async {
    emit(state.copyWith(categoriesStatus: RequestStatus.loading));
    try {
      final List<CategoryModel> categories =
          await _homeRepo.getCategories();
      emit(state.copyWith(
        categoriesStatus: RequestStatus.success,
        categories: categories,
      ));
      if (categories.isNotEmpty) {
        await selectCategory(0);
      }
    } catch (error) {
      emit(state.copyWith(
        categoriesStatus: RequestStatus.error,
        errorMessage: handleApiError(error),
      ));
    }
  }

  /// Selects a category and loads its meals (used on tap + first load).
  Future<void> selectCategory(int index) async {
    if (index < 0 || index >= state.categories.length) return;

    emit(state.copyWith(
      selectedCategoryIndex: index,
      mealsStatus: RequestStatus.loading,
      meals: const [],
    ));

    try {
      final List<MealModel> meals = await _homeRepo
          .getMealsByCategory(state.categories[index].name);
      emit(state.copyWith(
        mealsStatus: RequestStatus.success,
        meals: meals,
      ));
    } catch (error) {
      emit(state.copyWith(
        mealsStatus: RequestStatus.error,
        errorMessage: handleApiError(error),
      ));
    }
  }
}

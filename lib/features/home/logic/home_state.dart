import '../../../../core/helpers/enums.dart';
import '../data/models/category_model.dart';
import '../data/models/meal_model.dart';

class HomeState {
  final RequestStatus categoriesStatus;
  final RequestStatus mealsStatus;
  final String? errorMessage;
  final List<CategoryModel> categories;
  final List<MealModel> meals;
  final int selectedCategoryIndex;

  const HomeState({
    this.categoriesStatus = RequestStatus.initial,
    this.mealsStatus = RequestStatus.initial,
    this.errorMessage,
    this.categories = const [],
    this.meals = const [],
    this.selectedCategoryIndex = 0,
  });

  HomeState.initial() : this();

  HomeState copyWith({
    RequestStatus? categoriesStatus,
    RequestStatus? mealsStatus,
    String? errorMessage,
    List<CategoryModel>? categories,
    List<MealModel>? meals,
    int? selectedCategoryIndex,
  }) {
    return HomeState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      mealsStatus: mealsStatus ?? this.mealsStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      categories: categories ?? this.categories,
      meals: meals ?? this.meals,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}

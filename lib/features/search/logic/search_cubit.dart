import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/enums.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../home/data/models/meal_model.dart';
import '../data/repos/search_repo.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo _searchRepo;
  Timer? _debounceTimer;

  SearchCubit(this._searchRepo) : super(SearchState.initial());

  /// Debounces the network call: it fires 500ms after the user
  /// stops typing instead of on every keystroke (bonus point).
  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      searchMeals(query);
    });
  }

  Future<void> searchMeals(String query) async {
    final String trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _debounceTimer?.cancel();
      emit(SearchState.initial());
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading, query: trimmedQuery));
    try {
      final List<MealModel> meals =
          await _searchRepo.searchMeals(trimmedQuery);
      emit(state.copyWith(
        status: RequestStatus.success,
        query: trimmedQuery,
        meals: meals,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: RequestStatus.error,
        query: trimmedQuery,
        errorMessage: handleApiError(error),
      ));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}

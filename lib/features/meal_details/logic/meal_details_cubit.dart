import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/enums.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../home/data/models/meal_model.dart';
import '../data/repos/meal_details_repo.dart';
import 'meal_details_state.dart';

class MealDetailsCubit extends Cubit<MealDetailsState> {
  final MealDetailsRepo _mealDetailsRepo;

  MealDetailsCubit(this._mealDetailsRepo) : super(MealDetailsState.initial());

  Future<void> getMealDetails(String mealId) async {
    emit(state.copyWith(status: RequestStatus.loading));
    try {
      final MealModel meal = await _mealDetailsRepo.getMealDetails(mealId);
      emit(state.copyWith(status: RequestStatus.success, meal: meal));
    } catch (error) {
      emit(state.copyWith(
        status: RequestStatus.error,
        errorMessage: handleApiError(error),
      ));
    }
  }
}

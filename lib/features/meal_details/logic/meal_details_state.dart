import '../../../../core/helpers/enums.dart';
import '../../home/data/models/meal_model.dart';

class MealDetailsState {
  final RequestStatus status;
  final MealModel? meal;
  final String? errorMessage;

  const MealDetailsState({
    this.status = RequestStatus.initial,
    this.meal,
    this.errorMessage,
  });

  MealDetailsState.initial() : this();

  MealDetailsState copyWith({
    RequestStatus? status,
    MealModel? meal,
    String? errorMessage,
  }) {
    return MealDetailsState(
      status: status ?? this.status,
      meal: meal ?? this.meal,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

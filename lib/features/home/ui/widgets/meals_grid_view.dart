import 'package:flutter/material.dart';

import '../../../../core/helpers/enums.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/widgets/custom_empty_state_widget.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/meal_card.dart';
import '../../logic/home_state.dart';

/// Meals of the selected category (endpoint 2), in a 2-column grid
/// with Loading / Success / Error handling.
class MealsGridView extends StatelessWidget {
  final HomeState state;
  final VoidCallback onRetry;

  const MealsGridView({
    super.key,
    required this.state,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.mealsStatus) {
      case RequestStatus.initial:
        return const SizedBox.shrink();
      case RequestStatus.loading:
        return _buildLoadingGrid();
      case RequestStatus.error:
        return CustomErrorWidget(
          errorMessage: state.errorMessage ?? 'Could not load the meals.',
          onRetry: onRetry,
        );
      case RequestStatus.success:
        if (state.meals.isEmpty) {
          return const CustomEmptyStateWidget(
            icon: Icons.no_meals_rounded,
            title: 'No meals found',
            subtitle: 'This category has no meals yet.',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.82,
          ),
          itemCount: state.meals.length,
          itemBuilder: (context, index) {
            final meal = state.meals[index];
            return MealCard(
              meal: meal,
              // Hero animation for the bonus points.
              heroTag: 'meal-${meal.id}',
            );
          },
        );
    }
  }

  /// Simple skeleton placeholders while meals are being fetched.
  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: ColorsManager.lightGrey,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}

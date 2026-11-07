import 'dart:async';

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

  /// Pulsing skeletons in world colors while meals are being fetched —
  /// bone mounds that breathe until the real sacks hang in their place.
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
      itemBuilder: (context, index) => const _PulsingSkeleton(),
    );
  }
}

/// A bone skeleton card that breathes (AnimatedOpacity pulse on world
/// colors) until the real meals arrive — no third-party shimmer.
class _PulsingSkeleton extends StatefulWidget {
  const _PulsingSkeleton();

  @override
  State<_PulsingSkeleton> createState() => _PulsingSkeletonState();
}

class _PulsingSkeletonState extends State<_PulsingSkeleton> {
  bool _raised = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (mounted) setState(() => _raised = !_raised);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    final Color moundSurface = isDark
        ? ColorsManager.darkGroundRaised
        : ColorsManager.lightGrey;
    final Color imageSurface = isDark
        ? ColorsManager.darkGround
        : ColorsManager.bone.withValues(alpha: 0.65);
    final Color nameLine = isDark
        ? ColorsManager.darkGroundMuted.withValues(alpha: 0.35)
        : ColorsManager.cumin.withValues(alpha: 0.35);

    return AnimatedOpacity(
      opacity: _raised ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: moundSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: imageSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: nameLine,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/enums.dart';
import '../../../core/theming/text_styles.dart';
import '../../../core/widgets/custom_empty_state_widget.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/meal_card.dart';
import '../logic/favorites_cubit.dart';
import '../logic/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyles.font18DarkSemiBold,
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          switch (state.status) {
            case RequestStatus.initial:
            case RequestStatus.loading:
              return const SizedBox.shrink();
            case RequestStatus.error:
              return CustomErrorWidget(
                errorMessage: state.errorMessage ?? 'Something went wrong.',
                onRetry: () =>
                    context.read<FavoritesCubit>().loadFavorites(),
              );
            case RequestStatus.success:
              if (state.favorites.isEmpty) {
                return const CustomEmptyStateWidget(
                  icon: Icons.favorite_outline_rounded,
                  title: 'No favorites yet',
                  subtitle:
                      'Tap the heart on any meal to save it here. Your favorites stay saved even after closing the app.',
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.82,
                ),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final meal = state.favorites[index];
                  return MealCard(
                    meal: meal,
                    // Removing from favorites: tap the heart on the card.
                    onRemove: () =>
                        context.read<FavoritesCubit>().toggleFavorite(meal),
                  );
                },
              );
          }
        },
      ),
    );
  }
}

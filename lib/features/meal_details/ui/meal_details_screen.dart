import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/helpers/enums.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/text_styles.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../favorites/logic/favorites_cubit.dart';
import '../../favorites/logic/favorites_state.dart';
import '../../home/data/models/meal_model.dart';
import '../logic/meal_details_cubit.dart';
import '../logic/meal_details_state.dart';
import 'widgets/ingredients_section.dart';
import 'widgets/instructions_section.dart';

class MealDetailsScreen extends StatelessWidget {
  final String mealId;

  const MealDetailsScreen({super.key, required this.mealId});

  @override
  Widget build(BuildContext context) {
    // A fresh cubit is created for every visit (endpoint 3: details by ID).
    return BlocProvider<MealDetailsCubit>(
      create: (_) =>
          MealDetailsCubit(mealDetailsRepo)..getMealDetails(mealId),
      child: Scaffold(
        body: BlocBuilder<MealDetailsCubit, MealDetailsState>(
          builder: (context, state) {
            if (state.status == RequestStatus.loading ||
                state.status == RequestStatus.initial) {
              return const LoadingWidget();
            }

            if (state.status == RequestStatus.error) {
              return Scaffold(
                appBar: AppBar(),
                body: CustomErrorWidget(
                  errorMessage:
                      state.errorMessage ?? 'Could not load the meal details.',
                  onRetry: () =>
                      context.read<MealDetailsCubit>().getMealDetails(mealId),
                ),
              );
            }

            return _buildDetails(context, state.meal!);
          },
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, MealModel meal) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          leading: _buildCircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildFavoriteButton(context, meal),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: 'meal-${meal.id}',
              child: CachedNetworkImage(
                imageUrl: meal.image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: LoadingWidget()),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: ColorsManager.greyText,
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal.name, style: TextStyles.font24DarkBold),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.restaurant_rounded,
                      label: meal.category,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.public_rounded,
                      label: meal.area,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                IngredientsSection(ingredients: meal.ingredients),
                const SizedBox(height: 24),
                InstructionsSection(instructions: meal.instructions),
                if (meal.youtubeUrl.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _openYoutubeVideo(context, meal.youtubeUrl),
                    icon: const Icon(Icons.play_circle_fill_rounded),
                    label: const Text('Watch Recipe Video'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Favorite heart in the app bar, synced with the Favorites cubit.
  Widget _buildFavoriteButton(BuildContext context, MealModel meal) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favoritesState) {
        final bool isFavorite = favoritesState.favorites
            .any((MealModel m) => m.id == meal.id);
        return CircleAvatar(
          backgroundColor: ColorsManager.white,
          child: Semantics(
            // Exposes the heart to mobile e2e tests (getByTestId).
            identifier: 'favorite-toggle',
            container: true,
            button: true,
            child: IconButton(
              onPressed: () =>
                  context.read<FavoritesCubit>().toggleFavorite(meal),
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: isFavorite ? ColorsManager.red : ColorsManager.darkText,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: ColorsManager.white,
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: ColorsManager.darkText, size: 22),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    if (label.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorsManager.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: ColorsManager.primary),
          const SizedBox(width: 6),
          Text(label, style: TextStyles.font13Primary),
        ],
      ),
    );
  }

  Future<void> _openYoutubeVideo(BuildContext context, String url) async {
    try {
      final bool launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showErrorSnackBar(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showErrorSnackBar(context);
      }
    }
  }

  void _showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the video.')),
    );
  }
}

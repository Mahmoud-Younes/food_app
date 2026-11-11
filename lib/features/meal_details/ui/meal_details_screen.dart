import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/helpers/enums.dart';
import '../../../core/theming/category_colors.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/text_styles.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/favorite_stamp.dart';
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

  /// The meal image from the route argument: the header Hero shows it on
  /// frame 1 (before the fetch answers) while the meal itself is still
  /// fetched fresh from the API by id.
  final String imageUrl;

  const MealDetailsScreen({
    super.key,
    required this.mealId,
    required this.imageUrl,
  });

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
              return _buildLoadingSkeleton(context);
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

  /// Frame-1 skeleton mirroring the success chrome: the same pinned app bar
  /// and shared header render before the fetch answers, so the push-direction
  /// Hero flight finds a destination on the first frame and the Hero element
  /// stays stable across the loading -> success rebuild.
  Widget _buildLoadingSkeleton(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          leading: _buildCircleButton(
            context: context,
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          // The favorite action needs the fetched meal, so the skeleton
          // ships without it.
          actions: const [],
          flexibleSpace: FlexibleSpaceBar(
            background: _MealHeaderHero(mealId: mealId, imageUrl: imageUrl),
          ),
        ),
        const SliverFillRemaining(child: LoadingWidget()),
      ],
    );
  }

  Widget _buildDetails(BuildContext context, MealModel meal) {
    final Brightness brightness = Theme.of(context).brightness;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          leading: _buildCircleButton(
            context: context,
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
            background: _MealHeaderHero(mealId: mealId, imageUrl: imageUrl),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: TextStyles.font24DarkBold.copyWith(
                    color: ColorsManager.ink(brightness),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      context: context,
                      icon: Icons.restaurant_rounded,
                      label: meal.category,
                      accent: colorFor(meal.category),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      context: context,
                      icon: Icons.public_rounded,
                      label: meal.area,
                      accent: ColorsManager.cumin,
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
          backgroundColor: ColorsManager.raisedSurface(
            Theme.of(context).brightness,
          ),
          child: Semantics(
            // Exposes the heart to mobile e2e tests (getByTestId).
            identifier: 'favorite-toggle',
            container: true,
            button: true,
            child: IconButton(
              onPressed: () =>
                  context.read<FavoritesCubit>().toggleFavorite(meal),
              icon: _StampPress(
                stamped: isFavorite,
                child: FavoriteStamp(active: isFavorite, size: 24),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: CircleAvatar(
        backgroundColor: ColorsManager.raisedSurface(
          Theme.of(context).brightness,
        ),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            color: ColorsManager.ink(Theme.of(context).brightness),
            size: 22,
          ),
        ),
      ),
    );
  }

  /// Info chip: the category chip carries the category's own pigment,
  /// the origin chip carries cumin ink — both on a raised warm surface.
  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color accent,
  }) {
    if (label.isEmpty) return const SizedBox.shrink();

    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    // Dark pigments would sink into the raised dark surface — lift them
    // toward bone so the icon keeps its hue and stays visible.
    final Color visibleAccent = isDark
        ? Color.lerp(accent, ColorsManager.bone, 0.45)!
        : accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ColorsManager.raisedSurface(brightness),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: visibleAccent.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: visibleAccent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyles.font13Primary.copyWith(
              color: ColorsManager.ink(brightness),
            ),
          ),
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

/// The collapsible header shared by the loading skeleton and the success
/// branch: the meal photo inside the destination [Hero], melting into the
/// scaffold ground. The tag comes from the route argument, so frame 1 of the
/// pushed route already carries the tag the card's Hero flies to.
class _MealHeaderHero extends StatelessWidget {
  final String mealId;
  final String imageUrl;

  const _MealHeaderHero({required this.mealId, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Hero(
      tag: 'meal-$mealId',
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: LoadingWidget()),
            errorWidget: (context, url, error) => Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: ColorsManager.mutedInk(brightness),
              ),
            ),
          ),
          // The photo melts into the ground instead of ending in
          // a seam — cream in light, night-market ground in dark.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.72, 1.0],
                colors: <Color>[
                  Colors.transparent,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The stamp press: on activation the heart lands with a 400 ms
/// easeOutBack overshoot and is then held at rest — no fading. Removal
/// is a final act with no celebration.
class _StampPress extends StatefulWidget {
  final bool stamped;
  final Widget child;

  const _StampPress({required this.stamped, required this.child});

  @override
  State<_StampPress> createState() => _StampPressState();
}

class _StampPressState extends State<_StampPress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  )..value = 1.0;
  late final Animation<double> _scale = Tween<double>(begin: 0.72, end: 1)
      .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      );

  @override
  void didUpdateWidget(covariant _StampPress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.stamped && !oldWidget.stamped) {
      _controller.forward(from: 0);
    } else if (!widget.stamped && oldWidget.stamped) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

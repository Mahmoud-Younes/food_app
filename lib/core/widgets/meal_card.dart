import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../routing/routes.dart';
import '../theming/colors.dart';
import '../theming/text_styles.dart';
import '../../features/home/data/models/meal_model.dart';
import 'favorite_stamp.dart';

/// Reusable meal card (Home grid, Search results, Favorites grid): a
/// hanging sack — full-bleed image with warm corners, the name in the
/// serif display voice, and the strArea origin tag in cumin ink when the
/// meal carries one.
class MealCard extends StatelessWidget {
  final MealModel meal;

  /// When provided, the card image is wrapped in a [Hero] with this tag
  /// (used by the Home grid for the transition animation).
  final String? heroTag;

  /// When provided, a remove button is shown on the image (Favorites screen).
  final VoidCallback? onRemove;

  const MealCard({
    super.key,
    required this.meal,
    this.heroTag,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return GestureDetector(
      onTap: () => _openMealDetails(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: ColorsManager.raisedSurface(brightness),
        elevation: 3,
        shadowColor: ColorsManager.umber.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildImage()),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14Grey.copyWith(
                      fontFamily: 'serif',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: ColorsManager.ink(brightness),
                    ),
                  ),
                  // Origin tag sits under the name, never above it.
                  // Cumin ink on bone (light); muted bone carries it on
                  // the dark ground, where raw cumin would sink.
                  if (meal.area.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      meal.area,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        color: ColorsManager.mutedInk(brightness),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    Widget image = CachedNetworkImage(
      imageUrl: meal.image,
      fit: BoxFit.cover,
      width: double.infinity,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(color: ColorsManager.pepper),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: ColorsManager.mutedInk(Theme.of(context).brightness),
        ),
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    if (onRemove != null) {
      image = Stack(
        alignment: Alignment.topRight,
        children: [
          Positioned.fill(child: image),
          Positioned(
            top: 8,
            right: 8,
            child: _buildRemoveButton(),
          ),
        ],
      );
    }

    return image;
  }

  Widget _buildRemoveButton() {
    return Semantics(
      // Exposes the remove heart to mobile e2e tests (getByTestId).
      identifier: 'remove-favorite',
      container: true,
      button: true,
      child: GestureDetector(
        onTap: onRemove,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: ColorsManager.bone.withValues(alpha: 0.92),
            shape: BoxShape.circle,
          ),
          child: const FavoriteStamp(active: true, size: 18),
        ),
      ),
    );
  }

  void _openMealDetails(BuildContext context) {
    Navigator.pushNamed(
      context,
      Routes.mealDetailsScreen,
      arguments: meal.id,
    );
  }
}

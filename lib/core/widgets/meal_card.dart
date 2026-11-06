import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../routing/routes.dart';
import '../theming/colors.dart';
import '../theming/text_styles.dart';
import '../../features/home/data/models/meal_model.dart';

/// Reusable meal card (Home grid, Search results, Favorites grid).
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
    return GestureDetector(
      onTap: () => _openMealDetails(context),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: ColorsManager.white,
        elevation: 2,
        shadowColor: ColorsManager.greyText.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildImage()),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                meal.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font14Grey,
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
        child: CircularProgressIndicator(color: ColorsManager.primary),
      ),
      errorWidget: (context, url, error) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: ColorsManager.greyText,
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
          decoration: const BoxDecoration(
            color: ColorsManager.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite_rounded,
            size: 18,
            color: ColorsManager.red,
          ),
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

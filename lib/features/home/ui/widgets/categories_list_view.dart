import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/text_styles.dart';
import '../../data/models/category_model.dart';

/// Horizontal list of categories (endpoint 1). The active category is
/// highlighted with the primary color (Selected State).
class CategoriesListView extends StatelessWidget {
  final List<CategoryModel> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategoryTap;

  const CategoriesListView({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final CategoryModel category = categories[index];
          final bool isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onCategoryTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorsManager.primary
                    : ColorsManager.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: category.image,
                    width: 44,
                    height: 44,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorsManager.primary,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      width: 44,
                      height: 44,
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: ColorsManager.greyText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.name,
                    maxLines: 1,
                    style: isSelected
                        ? TextStyles.font14WhiteSemiBold
                        : TextStyles.font13Primary,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

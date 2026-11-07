import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theming/category_colors.dart';
import '../../../../core/theming/colors.dart';
import '../../data/models/category_model.dart';

/// Horizontal spice-pile bar (endpoint 1). Every category is a mound
/// painted with its own pigment (colorFor); the selected pile rises with
/// a 400 ms easeOutBack pulse, a pigment shadow and a slight enlargement,
/// while the others stay short, quiet mounds. The name stays a visible
/// label under every pile — in both states, in both brightness modes.
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
    final Brightness brightness = Theme.of(context).brightness;

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
          final Color pigment = colorFor(category.name);

          return GestureDetector(
            onTap: () => onCategoryTap(index),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.08 : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The pile: solid pigment when selected, a quiet tint
                  // of the same pigment otherwise. Food images are never
                  // tinted — the mound carries the color.
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    height: isSelected ? 56 : 44,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 18 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? pigment
                          : pigment.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: isSelected
                          ? <BoxShadow>[
                              BoxShadow(
                                color: pigment.withValues(alpha: 0.45),
                                offset: const Offset(0, 6),
                                blurRadius: 14,
                              ),
                            ]
                          : null,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: category.image,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          const SizedBox(width: 40, height: 40),
                      errorWidget: (context, url, error) => SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.restaurant_rounded,
                          size: 22,
                          color: ColorsManager.mutedInk(brightness),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.1,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? ColorsManager.ink(brightness)
                          : ColorsManager.mutedInk(brightness),
                    ),
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

import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/text_styles.dart';
import '../../../home/data/models/meal_model.dart';

/// Ingredients list (strIngredient1..20 with strMeasure1..20) — rows
/// pressed in one rhythm, numbered with turmeric pigment coins.
class IngredientsSection extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientsSection({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) return const SizedBox.shrink();

    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredients',
          style: TextStyles.font18DarkSemiBold.copyWith(
            fontFamily: 'serif',
            color: ColorsManager.ink(brightness),
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ingredients.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final Ingredient ingredient = ingredients[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ColorsManager.raisedSurface(brightness),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ColorsManager.turmeric
                          .withValues(alpha: isDark ? 0.22 : 0.28),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: ColorsManager.ink(brightness),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ingredient.name,
                      style: TextStyles.font16DarkSemiBold.copyWith(
                        color: ColorsManager.ink(brightness),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      ingredient.measure,
                      textAlign: TextAlign.right,
                      style: TextStyles.font14Grey.copyWith(
                        color: ColorsManager.mutedInk(brightness),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

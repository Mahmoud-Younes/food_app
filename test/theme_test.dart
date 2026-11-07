import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_app/core/theming/app_theme.dart';
import 'package:food_app/core/theming/category_colors.dart';
import 'package:food_app/core/theming/colors.dart';

void main() {
  group('AppTheme.lightTheme', () {
    test('is a fully built ThemeData with light brightness', () {
      expect(AppTheme.lightTheme, isNotNull);
      expect(AppTheme.lightTheme.brightness, Brightness.light);
      expect(AppTheme.lightTheme.colorScheme.brightness, Brightness.light);
    });

    test('scaffold ground is the bone token #F3E6D2', () {
      expect(AppTheme.lightTheme.scaffoldBackgroundColor, ColorsManager.bone);
      expect(ColorsManager.bone, const Color(0xFFF3E6D2));
    });
  });

  group('AppTheme.darkTheme', () {
    test('is a fully built ThemeData with dark brightness', () {
      expect(AppTheme.darkTheme, isNotNull);
      expect(AppTheme.darkTheme.brightness, Brightness.dark);
      expect(AppTheme.darkTheme.colorScheme.brightness, Brightness.dark);
    });

    test('scaffold ground is the dark-brown ground token #1C1410', () {
      expect(
        AppTheme.darkTheme.scaffoldBackgroundColor,
        ColorsManager.darkGround,
      );
      expect(ColorsManager.darkGround, const Color(0xFF1C1410));
    });
  });

  group('ColorsManager.primary', () {
    test('is the pepper commitment color #B33A25', () {
      expect(ColorsManager.primary, ColorsManager.pepper);
      expect(ColorsManager.pepper, const Color(0xFFB33A25));
    });
  });

  group('colorFor', () {
    // The exact 14 `strCategory` values TheMealDB `categories.php` returns.
    const List<String> themealdbCategories = <String>[
      'Beef',
      'Breakfast',
      'Chicken',
      'Dessert',
      'Goat',
      'Lamb',
      'Miscellaneous',
      'Pasta',
      'Pork',
      'Seafood',
      'Side',
      'Starter',
      'Vegan',
      'Vegetarian',
    ];

    test('covers all 14 TheMealDB categories with a real pigment', () {
      for (final String category in themealdbCategories) {
        expect(
          colorFor(category),
          isNot(ColorsManager.cumin),
          reason: '$category must have its own pigment, not the fallback',
        );
      }
    });

    test('assigns pairwise-distinct colors across the 14 categories', () {
      final Set<Color> pigments = themealdbCategories.map(colorFor).toSet();
      expect(pigments, hasLength(themealdbCategories.length));
    });

    test('falls back to cumin for an unknown category name', () {
      expect(colorFor('Mystery Dish'), ColorsManager.cumin);
      expect(colorFor(''), ColorsManager.cumin);
    });

    test('is deterministic: the same input always yields the same color', () {
      final List<String> inputs = <String>[...themealdbCategories, 'Mystery Dish'];
      for (final String category in inputs) {
        expect(
          colorFor(category),
          colorFor(category),
          reason: '$category must resolve identically on every call',
        );
      }
    });
  });
}

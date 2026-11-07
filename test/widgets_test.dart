import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_app/core/routing/routes.dart';
import 'package:food_app/core/theming/app_theme.dart';
import 'package:food_app/core/theming/category_colors.dart';
import 'package:food_app/core/widgets/custom_empty_state_widget.dart';
import 'package:food_app/core/widgets/custom_error_widget.dart';
import 'package:food_app/core/widgets/meal_card.dart';
import 'package:food_app/features/home/data/models/category_model.dart';
import 'package:food_app/features/home/data/models/meal_model.dart';
import 'package:food_app/features/home/ui/widgets/categories_list_view.dart';

void main() {
  // TheMealDB has no network in widget tests, so CachedNetworkImage ends on
  // its errorWidget branch — that branch is designed, and these tests only
  // assert on the widgets around the image.
  Widget appHost(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    );
  }

  group('MealCard', () {
    const MealModel meal = MealModel(
      id: '52771',
      name: 'Beef and Mustard Pie',
      image: 'https://www.themealdb.com/images/media/meals/sytuqu1511553755.jpg',
      area: 'British',
    );

    testWidgets('renders the meal name and its strArea origin', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        appHost(
          const SizedBox(width: 240, height: 340, child: MealCard(meal: meal)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Beef and Mustard Pie'), findsOneWidget);
      expect(find.text('British'), findsOneWidget);
      // The origin tag sits under the name, never above it (meal_card.dart:65).
      final Offset nameTopLeft =
          tester.getTopLeft(find.text('Beef and Mustard Pie'));
      final Offset areaTopLeft = tester.getTopLeft(find.text('British'));
      expect(areaTopLeft.dy, greaterThan(nameTopLeft.dy));
    });

    testWidgets('wraps the image in a Hero carrying the provided tag', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        appHost(
          SizedBox(
            width: 240,
            height: 340,
            child: MealCard(meal: meal, heroTag: 'meal-52771'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final Hero hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'meal-52771');
      // The hero must wrap the meal image, not the whole card.
      expect(hero.child, isA<CachedNetworkImage>());
    });

    testWidgets('shows no Hero when no hero tag is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        appHost(
          const SizedBox(width: 240, height: 340, child: MealCard(meal: meal)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(Hero), findsNothing);
    });

    testWidgets('pushes the meal details route with the meal id on tap', (
      WidgetTester tester,
    ) async {
      String? pushedRouteName;
      Object? pushedArguments;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          onGenerateRoute: (RouteSettings settings) {
            pushedRouteName = settings.name;
            pushedArguments = settings.arguments;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => const Scaffold(body: SizedBox()),
            );
          },
          home: const Scaffold(
            body: SizedBox(width: 240, height: 340, child: MealCard(meal: meal)),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.byType(MealCard));
      await tester.pump(const Duration(milliseconds: 400));

      expect(pushedRouteName, Routes.mealDetailsScreen);
      expect(pushedArguments, meal.id);
    });
  });

  group('CustomErrorWidget', () {
    testWidgets('renders the error message and the Retry button', (
      WidgetTester tester,
    ) async {
      int retryCalls = 0;
      await tester.pumpWidget(
        appHost(
          CustomErrorWidget(
            errorMessage: 'Oops! Something went wrong',
            onRetry: () => retryCalls++,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Oops! Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(retryCalls, 0);
    });

    testWidgets('invokes the retry callback when the button is pressed', (
      WidgetTester tester,
    ) async {
      int retryCalls = 0;
      await tester.pumpWidget(
        appHost(
          CustomErrorWidget(
            errorMessage: 'Oops! Something went wrong',
            onRetry: () => retryCalls++,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Retry'));
      await tester.pump();

      expect(retryCalls, 1);
    });
  });

  group('CustomEmptyStateWidget', () {
    testWidgets('renders the empty-state title and its icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        appHost(
          const CustomEmptyStateWidget(
            icon: Icons.search_off_rounded,
            title: 'No recipes found',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No recipes found'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });

    testWidgets('renders the subtitle when one is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        appHost(
          const CustomEmptyStateWidget(
            icon: Icons.search_off_rounded,
            title: 'No recipes found',
            subtitle: 'Try a different meal name',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Try a different meal name'), findsOneWidget);
    });

    testWidgets('omits the subtitle when none is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        appHost(
          const CustomEmptyStateWidget(
            icon: Icons.search_off_rounded,
            title: 'No recipes found',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Try a different meal name'), findsNothing);
    });
  });

  group('CategoriesListView', () {
    // The exact 14 `strCategory` values TheMealDB `categories.php` returns,
    // each with a unique image URL so its pile container is identifiable.
    final List<CategoryModel> categories = const <String>[
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
    ].map((String name) {
      return CategoryModel(
        id: name.toLowerCase(),
        name: name,
        image: 'https://img.test/${name.toLowerCase()}.png',
        description: '',
      );
    }).toList();

    Future<void> pumpStrip(
      WidgetTester tester, {
      int selectedIndex = 0,
    }) async {
      // Wide surface so all 14 lazy ListView items are actually built.
      tester.view.physicalSize = const Size(1600, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        appHost(
          CategoriesListView(
            categories: categories,
            selectedIndex: selectedIndex,
            onCategoryTap: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));
    }

    /// The pile container of a category: the AnimatedContainer whose child
    /// is that category's CachedNetworkImage (categories_list_view.dart:53-92).
    AnimatedContainer pileOf(WidgetTester tester, String categoryName) {
      final String imageUrl =
          'https://img.test/${categoryName.toLowerCase()}.png';
      return tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .firstWhere(
            (AnimatedContainer container) =>
                container.child is CachedNetworkImage &&
                (container.child! as CachedNetworkImage).imageUrl == imageUrl,
          );
    }

    testWidgets('renders every category under its visible name', (
      WidgetTester tester,
    ) async {
      await pumpStrip(tester);

      for (final CategoryModel category in categories) {
        expect(find.text(category.name), findsOneWidget,
            reason: '${category.name} must be visible in the strip');
      }
    });

    testWidgets('reports the tapped category index to the selection callback', (
      WidgetTester tester,
    ) async {
      final List<int> tapped = <int>[];
      tester.view.physicalSize = const Size(1600, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        appHost(
          CategoriesListView(
            categories: categories,
            selectedIndex: 0,
            onCategoryTap: tapped.add,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Beef'));
      await tester.pump();
      expect(tapped, <int>[0]);

      await tester.tap(find.text('Seafood'));
      await tester.pump();
      expect(tapped, <int>[0, 9]);

      await tester.tap(find.text('Vegetarian'));
      await tester.pump();
      expect(tapped, <int>[0, 9, 13]);
    });

    testWidgets(
        'paints the selected pile with its CategoryColors pigment '
        'and the others as a quiet tint of their own pigments', (
      WidgetTester tester,
    ) async {
      await pumpStrip(tester, selectedIndex: 0); // 'Beef' selected

      final AnimatedContainer beefPile = pileOf(tester, 'Beef');
      final AnimatedContainer seafoodPile = pileOf(tester, 'Seafood');

      // Selected: the full fixed pigment from CategoryColors.
      expect((beefPile.decoration! as BoxDecoration).color,
          categoryPigments['Beef']);
      // Unselected: the same pigment, dimmed to the 16% tint.
      expect((seafoodPile.decoration! as BoxDecoration).color,
          categoryPigments['Seafood']!.withValues(alpha: 0.16));

      // Deterministic pigment, not the cumin fallback.
      expect(
        (beefPile.decoration! as BoxDecoration).color,
        isNot(categoryPigments['Seafood']),
      );
    });
  });
}

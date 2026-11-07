import 'package:flutter/material.dart';

import 'colors.dart';

/// Fixed pigment per TheMealDB category — in the spice-stall world every
/// category reads as its saturated spice pile before its name.
///
/// The map is deterministic: the same name always yields the same Color,
/// on every surface and in both brightness modes. Keys match the exact
/// `strCategory` values TheMealDB returns.
const Map<String, Color> categoryPigments = <String, Color>{
  'Beef': Color(0xFF8C2A1F), // deep braise red
  'Breakfast': Color(0xFFEFB83A), // yolk gold
  'Chicken': Color(0xFFD9822B), // roast-skin amber
  'Dessert': Color(0xFFB26B36), // honey over cinnamon
  'Goat': Color(0xFF6E3F1F), // dark russet
  'Lamb': Color(0xFF9C4A36), // dusty brick
  'Miscellaneous': Color(0xFF7E8A3D), // mixed-pickle olive
  'Pasta': Color(0xFFD9B14F), // durum wheat
  'Pork': Color(0xFFC25E49), // cured rose
  'Seafood': Color(0xFF2E7E8C), // briny teal
  'Side': Color(0xFF6E8F4A), // herbed pilaf
  'Starter': Color(0xFFD4622A), // bright paprika
  'Vegan': Color(0xFF3F6B34), // deep leaf
  'Vegetarian': Color(0xFF6C9A3F), // garden green
};

/// Returns the fixed pigment for [category]; any unknown name falls back
/// to cumin so an unseen category still lands inside the palette.
Color colorFor(String category) =>
    categoryPigments[category] ?? ColorsManager.cumin;

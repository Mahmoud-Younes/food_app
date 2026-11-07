import 'package:flutter/material.dart';

import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  /// Spice-stall light: warm bone ground, pepper AppBar and pile bar,
  /// umber ink, cumin secondary text.
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorsManager.bone,
    primaryColor: ColorsManager.pepper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsManager.pepper,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.pepper,
      surfaceTintColor: ColorsManager.pepper,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorsManager.bone),
      titleTextStyle: TextStyles.font18BoneSemiBold,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.bone,
      selectedItemColor: ColorsManager.pepper,
      unselectedItemColor: ColorsManager.cumin,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.pepper,
        foregroundColor: ColorsManager.white,
        textStyle: TextStyles.font14WhiteSemiBold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.lightGrey,
      hintStyle: TextStyles.font14Grey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ColorsManager.pepper),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ColorsManager.red),
      ),
    ),
  );

  /// Night-market dark: a warm dark-brown ground — never grey — with
  /// bone text; pepper stays the commitment color, turmeric takes the
  /// secondary touches.
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorsManager.darkGround,
    primaryColor: ColorsManager.pepper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsManager.pepper,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.darkGround,
      surfaceTintColor: ColorsManager.darkGround,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ColorsManager.bone),
      titleTextStyle: TextStyles.font18BoneSemiBold,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.darkGround,
      selectedItemColor: ColorsManager.pepper,
      unselectedItemColor: ColorsManager.darkGroundMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.pepper,
        foregroundColor: ColorsManager.white,
        textStyle: TextStyles.font14WhiteSemiBold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        minimumSize: const Size(double.infinity, 52),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.darkGroundRaised,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: ColorsManager.darkGroundMuted,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ColorsManager.turmeric),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ColorsManager.red),
      ),
    ),
  );
}

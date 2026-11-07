import 'package:flutter/material.dart';

import 'colors.dart';

class TextStyles {
  TextStyles._();

  /// Display voice of the spice-stall world: system serif headlines
  /// ('serif' resolves to the platform serif, Noto Serif on Android).
  static const TextStyle font32DarkBold = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'serif',
    color: ColorsManager.darkText,
  );

  static const TextStyle font24DarkBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: 'serif',
    color: ColorsManager.darkText,
  );

  static const TextStyle font18DarkSemiBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ColorsManager.darkText,
  );

  /// AppBar titles on the pepper bar (light) and on the night-market
  /// ground (dark) — bone stays readable on both.
  static const TextStyle font18BoneSemiBold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ColorsManager.bone,
  );

  static const TextStyle font16DarkSemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ColorsManager.darkText,
  );

  static const TextStyle font16PrimarySemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ColorsManager.primary,
  );

  static const TextStyle font15Grey = TextStyle(
    fontSize: 15,
    color: ColorsManager.greyText,
    height: 1.5,
  );

  static const TextStyle font14Grey = TextStyle(
    fontSize: 14,
    color: ColorsManager.greyText,
  );

  static const TextStyle font14WhiteSemiBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: ColorsManager.white,
  );

  static const TextStyle font13Primary = TextStyle(
    fontSize: 13,
    color: ColorsManager.primary,
  );
}

import 'package:flutter/material.dart';

import '../theming/colors.dart';

/// The favorite stamp of the spice-stall world. Active: a filled pepper
/// heart with an ink rim — pressed once, then held (no fade). Inactive:
/// a quiet outline heart in the ambient ink.
class FavoriteStamp extends StatelessWidget {
  final bool active;
  final double size;

  const FavoriteStamp({
    super.key,
    required this.active,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final Color rim = ColorsManager.ink(Theme.of(context).brightness);

    if (!active) {
      return Icon(
        Icons.favorite_outline_rounded,
        size: size,
        color: rim,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.favorite_rounded, size: size, color: rim),
          Icon(
            Icons.favorite_rounded,
            size: size - 2.5,
            color: ColorsManager.pepper,
          ),
        ],
      ),
    );
  }
}

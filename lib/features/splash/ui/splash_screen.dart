import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// The one authored moment: a 400 ms overshoot pulse that settles the
  /// circle and the title once at open — then stillness until handover.
  late final AnimationController _arrivalController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> _arrival = Tween<double>(begin: 0.72, end: 1)
      .animate(
        CurvedAnimation(parent: _arrivalController, curve: Curves.easeOutBack),
      );

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _arrivalController.forward();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.mainScreen);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _arrivalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The spice market at dawn: pepper fills the whole screen — the color
    // carries, it does not decorate. Icon and text sit in bone on top.
    return Scaffold(
      backgroundColor: ColorsManager.pepper,
      body: Center(
        child: ScaleTransition(
          scale: _arrival,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorsManager.bone.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 72,
                  color: ColorsManager.bone,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Food Recipe',
                style: TextStyles.font32DarkBold.copyWith(
                  color: ColorsManager.bone,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover recipes from around the world',
                style: TextStyle(fontSize: 15, color: ColorsManager.bone),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

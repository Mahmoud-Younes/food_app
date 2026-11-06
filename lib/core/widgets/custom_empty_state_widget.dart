import 'package:flutter/material.dart';

import '../theming/colors.dart';
import '../theming/text_styles.dart';

/// Friendly empty state (e.g. search with no results, no favorites yet).
class CustomEmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const CustomEmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: ColorsManager.greyText),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkSemiBold,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyles.font14Grey,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

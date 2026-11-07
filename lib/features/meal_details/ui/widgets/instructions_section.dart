import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/text_styles.dart';

/// Full preparation steps (strInstructions), displayed in a
/// comfortable numbered layout when the text has line breaks.
class InstructionsSection extends StatelessWidget {
  final String instructions;

  const InstructionsSection({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preparation Steps',
          style: TextStyles.font18DarkSemiBold.copyWith(
            fontFamily: 'serif',
            color: ColorsManager.ink(brightness),
          ),
        ),
        const SizedBox(height: 12),
        _buildSteps(context),
      ],
    );
  }

  Widget _buildSteps(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;
    // Pepper numbers in light; gold ink on the night-market ground.
    final Color numberInk = isDark ? ColorsManager.turmeric : ColorsManager.pepper;

    final List<String> steps = instructions
        .split('\n')
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();

    // Single paragraph without line breaks: show it as plain text.
    if (steps.length <= 1) {
      return Text(
        instructions,
        style: TextStyles.font15Grey.copyWith(
          color: ColorsManager.ink(brightness),
          height: 1.6,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}.',
              style: TextStyles.font16PrimarySemiBold.copyWith(
                color: numberInk,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                steps[index],
                style: TextStyles.font15Grey.copyWith(
                  color: ColorsManager.ink(brightness),
                  height: 1.6,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

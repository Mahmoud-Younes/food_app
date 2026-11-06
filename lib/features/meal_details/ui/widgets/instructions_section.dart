import 'package:flutter/material.dart';

import '../../../../core/theming/text_styles.dart';

/// Full preparation steps (strInstructions), displayed in a
/// comfortable numbered layout when the text has line breaks.
class InstructionsSection extends StatelessWidget {
  final String instructions;

  const InstructionsSection({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preparation Steps', style: TextStyles.font18DarkSemiBold),
        const SizedBox(height: 12),
        _buildSteps(),
      ],
    );
  }

  Widget _buildSteps() {
    final List<String> steps = instructions
        .split('\n')
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();

    // Single paragraph without line breaks: show it as plain text.
    if (steps.length <= 1) {
      return Text(
        instructions,
        style: TextStyles.font15Grey,
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
              style: TextStyles.font16PrimarySemiBold,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                steps[index],
                style: TextStyles.font15Grey,
              ),
            ),
          ],
        );
      },
    );
  }
}

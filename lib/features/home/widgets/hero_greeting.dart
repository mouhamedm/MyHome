import 'package:flutter/material.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class HeroGreeting extends StatelessWidget {
  const HeroGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Trouvez un lieu\n',
                style: AppTypography.largeTitle,
              ),
              TextSpan(
                text: "d'exception.",
                style: AppTypography.largeTitleLight,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          "Découvrez des résidences et espaces d'exception à Paris.",
          style: AppTypography.subtitle.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}

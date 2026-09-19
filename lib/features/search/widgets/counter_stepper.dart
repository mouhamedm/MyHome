import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../shared/widgets/bounce_tap.dart';

class CounterStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const CounterStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: AppColors.separator, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BounceTap(
            onTap: value > min ? () => onChanged(value - 1) : null,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: value > min ? AppColors.surface : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.remove_rounded,
                size: 16,
                color: value > min ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ),
          SizedBox(
            width: 38,
            child: Text(
              value == 0 ? 'Tous' : '$value+',
              textAlign: TextAlign.center,
              style: AppTypography.tag.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          BounceTap(
            onTap: value < max ? () => onChanged(value + 1) : null,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: value < max ? AppColors.surface : Colors.transparent,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.add_rounded,
                size: 16,
                color: value < max ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

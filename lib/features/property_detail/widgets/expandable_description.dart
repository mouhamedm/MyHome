import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/animations/app_durations.dart';
import '../../../core/animations/app_curves.dart';
import '../../../shared/widgets/bounce_tap.dart';

class ExpandableDescription extends StatefulWidget {
  final String description;

  const ExpandableDescription({
    super.key,
    required this.description,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'À propos de ce bien',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.sm),
        AnimatedSize(
          duration: AppDurations.normal,
          curve: AppCurves.gentle,
          alignment: Alignment.topLeft,
          child: Text(
            widget.description,
            style: AppTypography.body.copyWith(
              fontSize: 15,
              height: 1.6,
              color: AppColors.textPrimary.withOpacity(0.85),
            ),
            maxLines: _isExpanded ? null : 3,
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        BounceTap(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Réduire' : 'Lire la suite',
                  style: AppTypography.button.copyWith(
                    color: AppColors.primaryBrown,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.primaryBrown,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

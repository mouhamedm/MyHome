import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/animations/app_durations.dart';
import '../../../core/animations/app_curves.dart';
import '../../../models/category.dart';
import '../../../shared/widgets/bounce_tap.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: PropertyCategory.categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = PropertyCategory.categories[index];
              final isSelected = cat.id == selectedCategoryId;

              return BounceTap(
                onTap: () => onCategorySelected(cat.id),
                scaleFactor: 0.95,
                child: AnimatedContainer(
                  duration: AppDurations.normal,
                  curve: AppCurves.gentle,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.textPrimary : AppColors.surface,
                    borderRadius: AppRadius.pillRadius,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.separator.withOpacity(0.9),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isSelected ? 0.08 : 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    cat.label,
                    style: AppTypography.tag.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

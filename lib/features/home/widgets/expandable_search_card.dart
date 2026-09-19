import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../data/property_repository.dart';
import '../../../models/property.dart';
import '../../../shared/widgets/bounce_tap.dart';

class ExpandableSearchCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback? onFilterTap;

  const ExpandableSearchCard({
    super.key,
    required this.onTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search_bar_hero',
      flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return Material(
          color: Colors.transparent,
          child: toHeroContext.widget,
        );
      },
      child: BounceTap(
        onTap: onTap,
        scaleFactor: 0.98,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: AppColors.separator.withOpacity(0.8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF241F1A).withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.search_rounded,
                      color: AppColors.primaryBrown,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rechercher un lieu, un bien...',
                          style: AppTypography.subtitle.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
              const Divider(color: AppColors.separator, height: 1),
              const SizedBox(height: AppSpacing.md),

              // Bottom filter pills preview
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _QuickFilterPill(
                      icon: Icons.location_on_outlined,
                      label: 'Paris 8e',
                      onTap: () {
                        PropertyRepository.instance.updateFilters(
                          PropertyRepository.instance.searchFilters.copyWith(district: 'Paris 8e'),
                        );
                        onTap();
                      },
                    ),
                    const SizedBox(width: 8),
                    _QuickFilterPill(
                      icon: Icons.villa_outlined,
                      label: 'Villas',
                      onTap: () {
                        PropertyRepository.instance.updateFilters(
                          PropertyRepository.instance.searchFilters.copyWith(type: PropertyType.villa),
                        );
                        onTap();
                      },
                    ),
                    const SizedBox(width: 8),
                    _QuickFilterPill(
                      icon: Icons.payments_outlined,
                      label: '< 3 M€',
                      onTap: () {
                        PropertyRepository.instance.updateFilters(
                          PropertyRepository.instance.searchFilters.copyWith(maxPrice: 3000000),
                        );
                        onTap();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickFilterPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickFilterPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.pillRadius,
          border: Border.all(color: AppColors.separator, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.primaryBrown),
            const SizedBox(width: 5),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

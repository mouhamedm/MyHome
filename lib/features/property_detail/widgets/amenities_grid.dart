import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class AmenitiesGrid extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesGrid({
    super.key,
    required this.amenities,
  });

  IconData _getIconForAmenity(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('pool') || lower.contains('piscine')) return Icons.pool_rounded;
    if (lower.contains('parking') || lower.contains('garage')) return Icons.directions_car_filled_outlined;
    if (lower.contains('garden') || lower.contains('park') || lower.contains('jardin')) return Icons.park_outlined;
    if (lower.contains('security') || lower.contains('monitored') || lower.contains('sécurité') || lower.contains('gardien')) return Icons.shield_outlined;
    if (lower.contains('air') || lower.contains('a/c') || lower.contains('climate') || lower.contains('clim')) return Icons.ac_unit_rounded;
    if (lower.contains('smart') || lower.contains('domotique')) return Icons.auto_mode_rounded;
    if (lower.contains('elevator') || lower.contains('ascenseur')) return Icons.elevator_outlined;
    if (lower.contains('view') || lower.contains('lagoon') || lower.contains('vue') || lower.contains('lagune')) return Icons.water_outlined;
    if (lower.contains('gym') || lower.contains('spa') || lower.contains('sport') || lower.contains('fitness')) return Icons.fitness_center_rounded;
    if (lower.contains('solar') || lower.contains('solaire')) return Icons.wb_sunny_outlined;
    if (lower.contains('fiber') || lower.contains('wifi') || lower.contains('fibre')) return Icons.wifi_rounded;
    if (lower.contains('kitchen') || lower.contains('cuisine')) return Icons.countertops_outlined;
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Équipements & Prestations',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.base),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: amenities.map((amenity) {
            final icon = _getIconForAmenity(amenity);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.pillRadius,
                border: Border.all(
                  color: AppColors.separator.withOpacity(0.8),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: AppColors.primaryBrown,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    amenity,
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

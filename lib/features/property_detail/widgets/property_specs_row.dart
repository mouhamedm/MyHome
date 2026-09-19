import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/property.dart';

class PropertySpecsRow extends StatelessWidget {
  final Property property;

  const PropertySpecsRow({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.separator.withOpacity(0.8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _SpecItem(
              icon: Icons.bed_outlined,
              title: '${property.bedrooms}',
              subtitle: 'Chambres',
            ),
          ),
          Container(width: 1, height: 32, color: AppColors.separator),
          Expanded(
            child: _SpecItem(
              icon: Icons.bathtub_outlined,
              title: '${property.bathrooms}',
              subtitle: 'Salles de bain',
            ),
          ),
          Container(width: 1, height: 32, color: AppColors.separator),
          Expanded(
            child: _SpecItem(
              icon: Icons.square_foot_rounded,
              title: Formatters.formatArea(property.area),
              subtitle: 'Surface',
            ),
          ),
          if (property.parking > 0) ...[
            Container(width: 1, height: 32, color: AppColors.separator),
            Expanded(
              child: _SpecItem(
                icon: Icons.directions_car_outlined,
                title: '${property.parking}',
                subtitle: 'Parking',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SpecItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBrown),
        const SizedBox(height: 6),
        Text(
          title,
          style: AppTypography.propertyTitle.copyWith(fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: AppTypography.caption.copyWith(fontSize: 11),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/property.dart';
import '../../../data/property_repository.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/favorite_button.dart';
import '../../../shared/widgets/app_image.dart';
import '../../property_detail/screens/property_detail_screen.dart';

class PropertyGridCard extends StatelessWidget {
  final Property property;

  const PropertyGridCard({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PropertyDetailScreen(propertyId: property.id),
          ),
        );
      },
      scaleFactor: 0.97,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.separator.withOpacity(0.7), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF241F1A).withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'property_hero_grid_${property.id}',
                    child: AppImage(
                      path: property.mainImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(
                      isFavorite: property.isFavorite,
                      size: 16,
                      onToggle: () {
                        PropertyRepository.instance.toggleFavorite(property.id);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Info Body
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.formatCurrency(property.price),
                    style: AppTypography.priceDisplay.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.title,
                    style: AppTypography.propertyTitle.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.district,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.bed_outlined, size: 13, color: AppColors.primaryBrown),
                      const SizedBox(width: 3),
                      Text(
                        '${property.bedrooms}',
                        style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.bathtub_outlined, size: 13, color: AppColors.primaryBrown),
                      const SizedBox(width: 3),
                      Text(
                        '${property.bathrooms}',
                        style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        Formatters.formatArea(property.area),
                        style: AppTypography.caption.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

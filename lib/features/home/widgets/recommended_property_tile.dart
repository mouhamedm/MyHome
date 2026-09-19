import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/property.dart';
import '../../../data/property_repository.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/favorite_button.dart';
import '../../../shared/widgets/app_image.dart';
import '../../property_detail/screens/property_detail_screen.dart';

class RecommendedPropertyTile extends StatelessWidget {
  final Property property;

  const RecommendedPropertyTile({
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
      scaleFactor: 0.98,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: AppColors.separator.withOpacity(0.7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF241F1A).withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail with Hero
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Hero(
                tag: 'property_hero_rec_${property.id}',
                child: AppImage(
                  path: property.mainImage,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.base),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        property.type.label.toUpperCase(),
                        style: AppTypography.tag.copyWith(
                          color: AppColors.primaryBrown,
                          fontSize: 11,
                          letterSpacing: 1.0,
                        ),
                      ),
                      FavoriteButton(
                        isFavorite: property.isFavorite,
                        size: 16,
                        hasBackground: false,
                        onToggle: () {
                          PropertyRepository.instance.toggleFavorite(property.id);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.title,
                    style: AppTypography.propertyTitle.copyWith(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.location,
                    style: AppTypography.metadata.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(property.price),
                        style: AppTypography.priceDisplay.copyWith(fontSize: 16),
                      ),
                      Text(
                        '${property.bedrooms} ch · ${Formatters.formatArea(property.area)}',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
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

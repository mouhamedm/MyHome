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
import '../../../shared/widgets/luxury_badge.dart';
import '../../../shared/widgets/app_image.dart';
import '../../property_detail/screens/property_detail_screen.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final double width;
  final double imageHeight;

  const PropertyCard({
    super.key,
    required this.property,
    this.width = 300,
    this.imageHeight = 220,
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
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: AppColors.separator.withOpacity(0.7),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF241F1A).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Stack with Hero, Favorite & Type Tag
            Stack(
              children: [
                Hero(
                  tag: 'property_hero_${property.id}',
                  child: AppImage(
                    path: property.mainImage,
                    fit: BoxFit.cover,
                    height: imageHeight,
                    width: double.infinity,
                  ),
                ),

                // Top Gradient for contrast
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Property Type Badge (Top Left)
                Positioned(
                  top: 14,
                  left: 14,
                  child: LuxuryBadge(
                    text: property.type.label,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),

                // Favorite Button (Top Right)
                Positioned(
                  top: 10,
                  right: 10,
                  child: FavoriteButton(
                    isFavorite: property.isFavorite,
                    onToggle: () {
                      PropertyRepository.instance.toggleFavorite(property.id);
                    },
                  ),
                ),
              ],
            ),

            // Property Information Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    property.title,
                    style: AppTypography.propertyTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: AppTypography.metadata,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Price
                  Text(
                    Formatters.formatCurrency(property.price),
                    style: AppTypography.priceDisplay,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Specs Row (Bedrooms, Bathrooms, Area)
                  const Divider(color: AppColors.separator, height: 1),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: _SpecItem(
                          icon: Icons.bed_outlined,
                          label: '${property.bedrooms} ch.',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _SpecItem(
                          icon: Icons.bathtub_outlined,
                          label: '${property.bathrooms} sdb',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: _SpecItem(
                          icon: Icons.square_foot_rounded,
                          label: Formatters.formatArea(property.area),
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

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SpecItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primaryBrown),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: AppTypography.metadata.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

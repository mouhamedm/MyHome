import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../models/property.dart';
import '../../../shared/widgets/bounce_tap.dart';
import 'property_card.dart';

class FeaturedPropertiesCarousel extends StatelessWidget {
  final List<Property> properties;
  final VoidCallback onSeeAllTap;

  const FeaturedPropertiesCarousel({
    super.key,
    required this.properties,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  "Biens d'exception",
                  style: AppTypography.sectionTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              BounceTap(
                onTap: onSeeAllTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Voir tout',
                      style: AppTypography.tag.copyWith(
                        color: AppColors.primaryBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primaryBrown,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),

        // Carousel Horizontal
        Builder(
          builder: (context) {
            final cardWidth = (MediaQuery.of(context).size.width * 0.82).clamp(300.0, 420.0);
            return SizedBox(
              height: 410,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: properties.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.base),
                itemBuilder: (context, index) {
                  return PropertyCard(
                    property: properties[index],
                    width: cardWidth,
                    imageHeight: 200,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

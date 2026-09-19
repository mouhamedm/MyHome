import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/property_repository.dart';
import '../widgets/image_gallery_slider.dart';
import '../widgets/property_specs_row.dart';
import '../widgets/expandable_description.dart';
import '../widgets/amenities_grid.dart';
import '../widgets/location_preview.dart';
import '../widgets/sticky_contact_cta.dart';

class PropertyDetailScreen extends StatelessWidget {
  final String propertyId;

  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PropertyRepository.instance,
      builder: (context, _) {
        final property = PropertyRepository.instance.getPropertyById(propertyId);

        if (property == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(),
            body: const Center(child: Text('Propriété introuvable')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Scrollable Content
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ImageGallerySlider(
                      property: property,
                      onBack: () => Navigator.of(context).pop(),
                    ),
                  ),

                  // Detail Body
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                        vertical: AppSpacing.xl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category tag & Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accentWash,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  property.type.label.toUpperCase(),
                                  style: AppTypography.tag.copyWith(
                                    color: AppColors.primaryBrown,
                                    letterSpacing: 1.2,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 18, color: Color(0xFFE5A93C)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${property.rating} (${property.reviewsCount} avis)',
                                    style: AppTypography.metadata.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // Property Title
                          Text(
                            property.title,
                            style: AppTypography.sectionTitle.copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: AppSpacing.xs),

                          // Location Subtitle
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: AppColors.primaryBrown,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  property.location,
                                  style: AppTypography.subtitle.copyWith(fontSize: 14),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.xl),

                          PropertySpecsRow(property: property),

                          const SizedBox(height: AppSpacing.xxl),

                          ExpandableDescription(description: property.description),

                          const SizedBox(height: AppSpacing.xxl),

                          AmenitiesGrid(amenities: property.amenities),

                          const SizedBox(height: AppSpacing.xxl),

                          LocationPreview(property: property),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: StickyContactCta(property: property),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/animations/app_durations.dart';
import '../../../core/animations/app_curves.dart';
import '../../../data/property_repository.dart';
import '../widgets/home_header.dart';
import '../widgets/hero_greeting.dart';
import '../widgets/expandable_search_card.dart';
import '../widgets/category_selector.dart';
import '../widgets/featured_properties_carousel.dart';
import '../widgets/recommended_property_tile.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToSearch;
  final VoidCallback onNavigateToProfile;

  const HomeScreen({
    super.key,
    required this.onNavigateToSearch,
    required this.onNavigateToProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PropertyRepository.instance,
      builder: (context, _) {
        final repo = PropertyRepository.instance;
        final featured = repo.featuredProperties;
        final currentCategoryProperties = repo.propertiesByCategory;
        final recommended = currentCategoryProperties.where((p) => !p.isFeatured).toList();
        final displayList = recommended.isNotEmpty ? recommended : currentCategoryProperties;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.screenPadding,
                      right: AppSpacing.screenPadding,
                      top: AppSpacing.md,
                      bottom: AppSpacing.base,
                    ),
                    child: HomeHeader(
                      onProfileTap: widget.onNavigateToProfile,
                    ),
                  ),
                ),

                // Hero Greeting Text
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                      vertical: AppSpacing.sm,
                    ),
                    child: HeroGreeting(),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.md),
                ),

                // Search Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: ExpandableSearchCard(
                      onTap: widget.onNavigateToSearch,
                      onFilterTap: widget.onNavigateToSearch,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),

                // Categories Title & Horizontal Selector
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explorer les espaces',
                          style: AppTypography.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        CategorySelector(
                          selectedCategoryId: repo.selectedCategoryId,
                          onCategorySelected: (catId) {
                            repo.setCategory(catId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),

                // Featured Properties Carousel
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: AppDurations.normal,
                    switchInCurve: AppCurves.gentle,
                    switchOutCurve: AppCurves.gentle,
                    child: FeaturedPropertiesCarousel(
                      key: ValueKey<String>('featured_${repo.selectedCategoryId}'),
                      properties: featured,
                      onSeeAllTap: widget.onNavigateToSearch,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),

                // Recommended / Curated Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            'Recommandés pour vous',
                            style: AppTypography.sectionTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${displayList.length} résidences',
                          style: AppTypography.metadata.copyWith(
                            color: AppColors.primaryBrown,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.base),
                ),

                // Recommended Properties List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: AppDurations.normal,
                      switchInCurve: AppCurves.gentle,
                      switchOutCurve: AppCurves.gentle,
                      child: Column(
                        key: ValueKey<String>('rec_list_${repo.selectedCategoryId}'),
                        children: displayList.map((property) {
                          return RecommendedPropertyTile(property: property);
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Bottom spacer 
                const SliverToBoxAdapter(
                  child: SizedBox(height: 110),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

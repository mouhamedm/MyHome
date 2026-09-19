import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/animations/app_durations.dart';
import '../../../core/animations/app_curves.dart';
import '../../../data/property_repository.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../home/widgets/property_card.dart';
import '../widgets/property_grid_card.dart';
import '../widgets/search_filter_sheet.dart';
import '../widgets/map_mode_view.dart';

enum SearchViewMode { list, grid, map }

class SearchScreen extends StatefulWidget {
  final VoidCallback onBackToHome;

  const SearchScreen({
    super.key,
    required this.onBackToHome,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchViewMode _viewMode = SearchViewMode.list;

  @override
  void initState() {
    super.initState();
    _searchController.text = PropertyRepository.instance.searchFilters.query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => SearchFilterSheet(
        initialCriteria: PropertyRepository.instance.searchFilters,
        onApply: (criteria) {
          PropertyRepository.instance.updateFilters(criteria);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PropertyRepository.instance,
      builder: (context, _) {
        final repo = PropertyRepository.instance;
        final results = repo.searchResults;
        final hasFilters = repo.searchFilters.hasActiveFilters;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Search Bar with Hero
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.screenPadding,
                    right: AppSpacing.screenPadding,
                    top: AppSpacing.md,
                    bottom: AppSpacing.sm,
                  ),
                  child: Hero(
                    tag: 'search_bar_hero',
                    flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                      return Material(
                        color: Colors.transparent,
                        child: toHeroContext.widget,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.cardRadius,
                        border: Border.all(
                          color: AppColors.separator.withOpacity(0.9),
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
                          const Icon(
                            Icons.search_rounded,
                            color: AppColors.primaryBrown,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: AppTypography.bodyMedium,
                              decoration: InputDecoration(
                                hintText: 'Rechercher Paris 8e, Marais, Villa...',
                                hintStyle: AppTypography.body.copyWith(
                                  color: AppColors.textSecondary.withOpacity(0.8),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              onChanged: (val) {
                                repo.updateSearchQuery(val);
                              },
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            BounceTap(
                              onTap: () {
                                _searchController.clear();
                                repo.updateSearchQuery('');
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          const SizedBox(width: 4),
                          // Filter Button
                          BounceTap(
                            onTap: _openFilterSheet,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: hasFilters ? AppColors.primaryBrown : AppColors.textPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.tune_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                if (hasFilters)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColors.favoriteActive,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.5),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Controls Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${results.length} ${results.length == 1 ? 'bien trouvé' : 'biens trouvés'}',
                          style: AppTypography.metadata.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // View Mode Switcher
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.pillRadius,
                          border: Border.all(color: AppColors.separator, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ViewModeButton(
                              icon: Icons.view_agenda_outlined,
                              label: 'Liste',
                              isSelected: _viewMode == SearchViewMode.list,
                              onTap: () => setState(() => _viewMode = SearchViewMode.list),
                            ),
                            _ViewModeButton(
                              icon: Icons.grid_view_rounded,
                              label: 'Grille',
                              isSelected: _viewMode == SearchViewMode.grid,
                              onTap: () => setState(() => _viewMode = SearchViewMode.grid),
                            ),
                            _ViewModeButton(
                              icon: Icons.map_outlined,
                              label: 'Carte',
                              isSelected: _viewMode == SearchViewMode.map,
                              onTap: () => setState(() => _viewMode = SearchViewMode.map),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Body
                Expanded(
                  child: results.isEmpty
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'Aucun bien trouvé',
                          description:
                              "Essayez d'ajuster vos critères ou d'élargir les filtres de prix et de chambres.",
                          buttonText: 'Réinitialiser les filtres',
                          onButtonPressed: () {
                            _searchController.clear();
                            repo.resetFilters();
                          },
                        )
                      : AnimatedSwitcher(
                          duration: AppDurations.normal,
                          switchInCurve: AppCurves.gentle,
                          switchOutCurve: AppCurves.gentle,
                          child: _buildResultsView(results),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsView(List results) {
    switch (_viewMode) {
      case SearchViewMode.list:
        return ListView.separated(
          key: const ValueKey<String>('list_view'),
          padding: const EdgeInsets.only(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            top: AppSpacing.sm,
            bottom: 110,
          ),
          physics: const BouncingScrollPhysics(),
          itemCount: results.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.base),
          itemBuilder: (context, index) {
            return PropertyCard(
              property: results[index],
              width: double.infinity,
              imageHeight: 210,
            );
          },
        );

      case SearchViewMode.grid:
        return GridView.builder(
          key: const ValueKey<String>('grid_view'),
          padding: const EdgeInsets.only(
            left: AppSpacing.screenPadding,
            right: AppSpacing.screenPadding,
            top: AppSpacing.sm,
            bottom: 110,
          ),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return PropertyGridCard(property: results[index]);
          },
        );

      case SearchViewMode.map:
        return MapModeView(
          key: const ValueKey<String>('map_view'),
          properties: List.from(results),
        );
    }
  }
}

class _ViewModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      scaleFactor: 0.94,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppCurves.gentle,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : Colors.transparent,
          borderRadius: AppRadius.pillRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.tag.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

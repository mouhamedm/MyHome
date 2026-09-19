import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/animations/app_durations.dart';
import '../../../core/animations/app_curves.dart';
import '../../../data/property_repository.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../home/widgets/property_card.dart';

class FavoritesScreen extends StatelessWidget {
  final VoidCallback onExploreTap;

  const FavoritesScreen({
    super.key,
    required this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PropertyRepository.instance,
      builder: (context, _) {
        final savedList = PropertyRepository.instance.savedProperties;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editorial Header
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.screenPadding,
                    right: AppSpacing.screenPadding,
                    top: AppSpacing.md,
                    bottom: AppSpacing.base,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Propriétés sauvegardées',
                        style: AppTypography.largeTitle.copyWith(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${savedList.length} ${savedList.length == 1 ? 'résidence sauvegardée' : 'résidences sauvegardées'}',
                        style: AppTypography.subtitle.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const Divider(color: AppColors.separator, height: 1),

                // Content (List or Empty State)
                Expanded(
                  child: savedList.isEmpty
                      ? EmptyState(
                          icon: Icons.favorite_border_rounded,
                          title: 'Vos résidences favorites apparaîtront ici.',
                          description:
                              "Appuyez sur l'icône cœur pour constituer votre sélection de résidences d'exception.",
                          buttonText: 'Explorer les biens',
                          onButtonPressed: onExploreTap,
                        )
                      : AnimatedSwitcher(
                          duration: AppDurations.normal,
                          switchInCurve: AppCurves.gentle,
                          switchOutCurve: AppCurves.gentle,
                          child: ListView.separated(
                            key: ValueKey<int>(savedList.length),
                            padding: const EdgeInsets.only(
                              left: AppSpacing.screenPadding,
                              right: AppSpacing.screenPadding,
                              top: AppSpacing.base,
                              bottom: 110,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: savedList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.lg),
                            itemBuilder: (context, index) {
                              final prop = savedList[index];
                              return PropertyCard(
                                property: prop,
                                width: double.infinity,
                                imageHeight: 210,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

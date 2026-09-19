import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../data/property_repository.dart';
import '../../../data/mock_properties.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/app_image.dart';
import '../../notifications/screens/notifications_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onNavigateToSaved;

  const ProfileScreen({
    super.key,
    required this.onNavigateToSaved,
  });

  void _showComingSoonDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        title: Text(title, style: AppTypography.sectionTitle.copyWith(fontSize: 20)),
        content: Text(message, style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Compris',
              style: AppTypography.button.copyWith(color: AppColors.primaryBrown),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PropertyRepository.instance,
      builder: (context, _) {
        final repo = PropertyRepository.instance;
        final savedCount = repo.savedProperties.length;
        final unreadCount = repo.unreadNotificationsCount;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.only(
                left: AppSpacing.screenPadding,
                right: AppSpacing.screenPadding,
                top: AppSpacing.md,
                bottom: 110,
              ),
              physics: const BouncingScrollPhysics(),
              children: [
                // Editorial Header
                Text(
                  'Mon profil',
                  style: AppTypography.largeTitle.copyWith(fontSize: 32),
                ),
                const SizedBox(height: AppSpacing.xl),

                // User Identity Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.cardRadius,
                    border: Border.all(color: AppColors.separator.withOpacity(0.8), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF241F1A).withOpacity(0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.separator, width: 2),
                          image: DecorationImage(
                            image: AppImage.provider(MockData.userAvatar),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Name
                      Text('Mouhamed', style: AppTypography.sectionTitle.copyWith(fontSize: 24)),
                      const SizedBox(height: 4),

                      // Location & Member tag
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primaryBrown),
                          const SizedBox(width: 4),
                          Text(
                            'Paris, France',
                            style: AppTypography.metadata.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentWash,
                          borderRadius: AppRadius.pillRadius,
                        ),
                        child: Text(
                          'CLIENT PRIVILÈGE · VIP',
                          style: AppTypography.tag.copyWith(
                            color: AppColors.primaryBrown,
                            letterSpacing: 1.2,
                            fontSize: 10,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),
                      const Divider(color: AppColors.separator, height: 1),
                      const SizedBox(height: AppSpacing.base),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            count: '$savedCount',
                            label: 'Favoris',
                            onTap: onNavigateToSaved,
                          ),
                          Container(width: 1, height: 28, color: AppColors.separator),
                          _StatItem(
                            count: '18',
                            label: 'Consultés',
                            onTap: () => _showComingSoonDialog(
                              context,
                              'Récemment consultés',
                              'Vous avez consulté 18 résidences de prestige à Paris ces 30 derniers jours.',
                            ),
                          ),
                          Container(width: 1, height: 28, color: AppColors.separator),
                          _StatItem(
                            count: '2',
                            label: 'Demandes',
                            onTap: () => _showComingSoonDialog(
                              context,
                              'Demandes en cours',
                              '2 visites programmées avec votre conseiller Christian.',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Menu Options Section
                Text(
                  'Préférences & Gestion',
                  style: AppTypography.tag.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 1.2,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.cardRadius,
                    border: Border.all(color: AppColors.separator.withOpacity(0.8), width: 1),
                  ),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.villa_outlined,
                        title: 'Mes biens',
                        subtitle: 'Portefeuille et biens en vente',
                        onTap: () => _showComingSoonDialog(
                          context,
                          'Mes biens',
                          'Confiez votre propriété d\'exception à la Conciergerie My House.',
                        ),
                      ),
                      const Divider(color: AppColors.separator, height: 1, indent: 56),
                      _ProfileMenuItem(
                        icon: Icons.favorite_border_rounded,
                        title: 'Biens sauvegardés',
                        subtitle: '$savedCount ${savedCount == 1 ? 'résidence en favoris' : 'résidences en favoris'}',
                        onTap: onNavigateToSaved,
                      ),
                      const Divider(color: AppColors.separator, height: 1, indent: 56),
                      _ProfileMenuItem(
                        icon: Icons.history_rounded,
                        title: 'Récemment consultés',
                        subtitle: 'Historique des visites de résidences',
                        onTap: () => _showComingSoonDialog(
                          context,
                          'Récemment consultés',
                          'Votre historique de navigation est synchronisé sur tous vos appareils.',
                        ),
                      ),
                      const Divider(color: AppColors.separator, height: 1, indent: 56),
                      _ProfileMenuItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notifications',
                        subtitle: unreadCount > 0
                            ? '$unreadCount nouvelle(s) alerte(s)'
                            : 'Toutes les alertes sont lues',
                        badgeCount: unreadCount,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          );
                        },
                      ),
                      const Divider(color: AppColors.separator, height: 1, indent: 56),
                      _ProfileMenuItem(
                        icon: Icons.tune_rounded,
                        title: 'Paramètres',
                        subtitle: 'Devise (€ Euro / FCFA), confidentialité & langue',
                        onTap: () => _showComingSoonDialog(
                          context,
                          'Paramètres',
                          'Langue : Français\nDevise : Euro (€)\nThème : Ivoire & Cuir Prestige',
                        ),
                      ),
                    ],
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

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final VoidCallback onTap;

  const _StatItem({
    required this.count,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count,
            style: AppTypography.propertyTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int badgeCount;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      scaleFactor: 0.98,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: AppColors.primaryBrown),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (badgeCount > 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBrown,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  '$badgeCount',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

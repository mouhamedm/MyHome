import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/property.dart';
import '../../../data/mock_properties.dart';
import '../../../shared/widgets/luxury_button.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/app_image.dart';

class StickyContactCta extends StatelessWidget {
  final Property property;

  const StickyContactCta({
    super.key,
    required this.property,
  });

  void _showContactModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _ContactAgentModal(property: property),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: bottomInset > 0 ? bottomInset + 8 : 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.separator.withOpacity(0.8),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF241F1A).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Price Column
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prix indicatif',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Formatters.formatCurrency(property.price),
                    style: AppTypography.priceDisplay.copyWith(
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Contact Agent Button
          LuxuryButton(
            text: "Contacter l'agent",
            icon: Icons.chat_bubble_outline_rounded,
            onPressed: () => _showContactModal(context),
            width: 165,
            height: 50,
          ),
        ],
      ),
    );
  }
}

class _ContactAgentModal extends StatefulWidget {
  final Property property;

  const _ContactAgentModal({required this.property});

  @override
  State<_ContactAgentModal> createState() => _ContactAgentModalState();
}

class _ContactAgentModalState extends State<_ContactAgentModal> {
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.modal),
          topRight: Radius.circular(AppRadius.modal),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: bottomInset > 0 ? bottomInset + 16 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.separator,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          if (_sent) ...[
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.accentWash,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.check_rounded, color: AppColors.primaryBrown, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Demande envoyée',
              style: AppTypography.sectionTitle.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text(
              "Votre conseiller Christian vous contactera sous 2 heures pour convenir d'une visite privée.",
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            const SizedBox(height: 24),
            LuxuryButton(
              text: 'Terminé',
              width: double.infinity,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ] else ...[
            // Agent Profile Row
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.separator, width: 1.5),
                    image: DecorationImage(
                      image: AppImage.provider(MockData.agentAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Christian Kouassi',
                        style: AppTypography.propertyTitle.copyWith(fontSize: 17),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Conseiller Prestige · My House Paris',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.separator),
            const SizedBox(height: 16),

            // Inquire Options
            _ContactOptionRow(
              icon: Icons.calendar_today_outlined,
              title: 'Planifier une visite privée',
              subtitle: 'Choisir un créneau exclusif',
              onTap: () {
                setState(() => _sent = true);
              },
            ),
            const SizedBox(height: 10),
            _ContactOptionRow(
              icon: Icons.phone_outlined,
              title: 'Appel téléphonique direct',
              subtitle: '+225 07 00 00 00 00',
              onTap: () {
                setState(() => _sent = true);
              },
            ),
            const SizedBox(height: 10),
            _ContactOptionRow(
              icon: Icons.chat_outlined,
              title: 'Conciergerie WhatsApp',
              subtitle: 'Réponse moyenne en 5 minutes',
              onTap: () {
                setState(() => _sent = true);
              },
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

class _ContactOptionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactOptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: onTap,
      scaleFactor: 0.98,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.separator, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.separator),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: AppColors.primaryBrown),
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
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
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

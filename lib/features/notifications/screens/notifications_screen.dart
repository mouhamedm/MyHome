import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../models/notification_item.dart';
import '../../../data/property_repository.dart';
import '../../../shared/widgets/bounce_tap.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PropertyRepository.instance,
      builder: (context, _) {
        final notifications = PropertyRepository.instance.notifications;
        final todayList = notifications.where((n) => n.group == NotificationGroup.today).toList();
        final yesterdayList = notifications.where((n) => n.group == NotificationGroup.yesterday).toList();
        final earlierList = notifications.where((n) => n.group == NotificationGroup.earlier).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: BounceTap(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
            title: Text('Notifications', style: AppTypography.sectionTitle.copyWith(fontSize: 20)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: BounceTap(
                  onTap: () {
                    PropertyRepository.instance.markAllNotificationsAsRead();
                  },
                  child: Center(
                    child: Text(
                      'Tout marquer comme lu',
                      style: AppTypography.tag.copyWith(
                        color: AppColors.primaryBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.base,
            ),
            physics: const BouncingScrollPhysics(),
            children: [
              if (todayList.isNotEmpty) ...[
                const _SectionHeader(title: "Aujourd'hui"),
                ...todayList.map((item) => _NotificationTile(item: item)),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (yesterdayList.isNotEmpty) ...[
                const _SectionHeader(title: 'Hier'),
                ...yesterdayList.map((item) => _NotificationTile(item: item)),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (earlierList.isNotEmpty) ...[
                const _SectionHeader(title: 'Plus tôt'),
                ...earlierList.map((item) => _NotificationTile(item: item)),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.tag.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return BounceTap(
      onTap: () {
        PropertyRepository.instance.markNotificationRead(item.id);
      },
      scaleFactor: 0.98,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.surface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: item.isRead
                ? AppColors.separator.withOpacity(0.6)
                : AppColors.primaryBrown.withOpacity(0.5),
            width: item.isRead ? 1 : 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: item.isRead ? AppColors.background : AppColors.accentWash,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                item.icon,
                size: 20,
                color: item.isRead ? AppColors.textSecondary : AppColors.primaryBrown,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTypography.propertyTitle.copyWith(
                            fontSize: 15,
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        item.time,
                        style: AppTypography.caption.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: AppTypography.body.copyWith(
                      fontSize: 13,
                      color: item.isRead
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            if (!item.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBrown,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

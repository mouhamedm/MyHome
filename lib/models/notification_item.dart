import 'package:flutter/material.dart';

enum NotificationGroup { today, yesterday, earlier }

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final NotificationGroup group;
  final IconData icon;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.group,
    required this.icon,
    this.isRead = false,
  });
}

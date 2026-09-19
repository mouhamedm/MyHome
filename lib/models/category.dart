import 'package:flutter/material.dart';

class PropertyCategory {
  final String id;
  final String label;
  final IconData? icon;

  const PropertyCategory({
    required this.id,
    required this.label,
    this.icon,
  });

  static const List<PropertyCategory> categories = [
    PropertyCategory(id: 'all', label: 'Tous'),
    PropertyCategory(id: 'apartment', label: 'Appartements'),
    PropertyCategory(id: 'house', label: 'Maisons'),
    PropertyCategory(id: 'villa', label: 'Villas'),
    PropertyCategory(id: 'land', label: 'Terrains'),
    PropertyCategory(id: 'office', label: 'Bureaux'),
  ];
}

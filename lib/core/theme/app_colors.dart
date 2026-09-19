import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Brand Colors
  static const Color background = Color(0xFFF8F5F0); 
  static const Color surface = Color(0xFFFFFFFF);    
  static const Color surfaceMuted = Color(0xFFF2ECE4);

  // Typography Colors
  static const Color textPrimary = Color(0xFF241F1A);   
  static const Color textSecondary = Color(0xFF81776D); 
  static const Color textTertiary = Color(0xFFA59A8E);

  // Brown & Warm Accents
  static const Color primaryBrown = Color(0xFF8A6A4A); 
  static const Color lightBrown = Color(0xFFB9A28C);
  static const Color subtleAccent = Color(0xFFD8C7B5);
  static const Color accentWash = Color(0xFFF3ECE4);

  // Borders, Dividers & Shadows
  static const Color separator = Color(0xFFEAE3DC);
  static const Color borderLight = Color(0xFFF0EBE5);

  // Status & Badges
  static const Color success = Color(0xFF4A7C59);
  static const Color featured = Color(0xFF241F1A);
  static const Color favoriteActive = Color(0xFFC75D4D); 

  // Shadow Colors
  static final Color shadowSubtle = const Color(0xFF241F1A).withOpacity(0.04);
  static final Color shadowMedium = const Color(0xFF241F1A).withOpacity(0.08);
  static final Color shadowElevated = const Color(0xFF241F1A).withOpacity(0.12);
}

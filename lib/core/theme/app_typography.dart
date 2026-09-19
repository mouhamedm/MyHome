import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Large Titles (32 - 38px)
  static TextStyle get largeTitle => GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.18,
        letterSpacing: -0.6,
      );

  static TextStyle get largeTitleLight => GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: AppColors.primaryBrown,
        height: 1.18,
        letterSpacing: -0.6,
      );

  // Section Titles (22 - 24px)
  static TextStyle get sectionTitle => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: -0.3,
      );

  // Property Titles (18 - 20px)
  static TextStyle get propertyTitle => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
        letterSpacing: -0.2,
      );

  // Price Display (20 - 22px)
  static TextStyle get priceDisplay => GoogleFonts.poppins(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      );

  // Subtitles & Highlights (15 - 16px)
  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.45,
      );

  // Body Text (13 - 15px)
  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 13.5,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.55,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  // Metadata & Captions (11 - 13px)
  static TextStyle get metadata => GoogleFonts.poppins(
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.1,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
        color: AppColors.textTertiary,
        letterSpacing: 0.1,
      );

  // Buttons & Tags (11 - 15px)
  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get tag => GoogleFonts.poppins(
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );
}

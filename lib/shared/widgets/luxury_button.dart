import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_radius.dart';
import 'bounce_tap.dart';

enum LuxuryButtonStyle { primary, secondary, outline }

class LuxuryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final LuxuryButtonStyle style;
  final double? width;
  final double height;
  final bool isLoading;

  const LuxuryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style = LuxuryButtonStyle.primary,
    this.width,
    this.height = 54.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    Border? border;

    switch (style) {
      case LuxuryButtonStyle.primary:
        bg = AppColors.primaryBrown;
        fg = Colors.white;
        border = null;
        break;
      case LuxuryButtonStyle.secondary:
        bg = AppColors.accentWash;
        fg = AppColors.textPrimary;
        border = null;
        break;
      case LuxuryButtonStyle.outline:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        border = Border.all(color: AppColors.separator, width: 1.2);
        break;
    }

    return BounceTap(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: width != null ? 12 : 24),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.pillRadius,
          border: border,
          boxShadow: style == LuxuryButtonStyle.primary
              ? [
                  BoxShadow(
                    color: AppColors.primaryBrown.withOpacity(0.24),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fg),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: AppTypography.button.copyWith(color: fg),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

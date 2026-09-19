import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../models/property.dart';

class LocationPreview extends StatelessWidget {
  final Property property;

  const LocationPreview({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localisation & Quartier',
          style: AppTypography.sectionTitle,
        ),
        const SizedBox(height: AppSpacing.base),

        // Stylized Map Card
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEFE9DF),
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.separator, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Stylized Map Grid / River / Land graphic
              CustomPaint(
                size: const Size(double.infinity, 180),
                painter: _StylizedMapPainter(),
              ),

              // Central Location Pin
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        borderRadius: AppRadius.pillRadius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            property.district,
                            style: AppTypography.tag.copyWith(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.textPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom gradient info overlay
              Positioned(
                bottom: 12,
                left: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.separator.withOpacity(0.8), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pin_drop_outlined, size: 16, color: AppColors.primaryBrown),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          property.location,
                          style: AppTypography.metadata.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StylizedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFDDD3C4)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final thinRoadPaint = Paint()
      ..color = const Color(0xFFE4DCD0)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final waterPaint = Paint()
      ..color = const Color(0xFFCFDCDD).withOpacity(0.65)
      ..style = PaintingStyle.fill;

    // Water body (Lagoon)
    final waterPath = Path()
      ..moveTo(0, size.height * 0.75)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.65,
        size.width * 0.7,
        size.height * 0.9,
        size.width,
        size.height * 0.8,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Primary roads
    final road1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..cubicTo(
        size.width * 0.4,
        size.height * 0.25,
        size.width * 0.6,
        size.height * 0.45,
        size.width,
        size.height * 0.4,
      );
    canvas.drawPath(road1, roadPaint);

    final road2 = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.55, size.height);
    canvas.drawPath(road2, roadPaint);

    // Secondary roads
    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.55),
      thinRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, 0),
      Offset(size.width * 0.25, size.height),
      thinRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

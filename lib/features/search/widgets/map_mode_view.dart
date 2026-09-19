import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/property.dart';
import '../../../data/property_repository.dart';
import '../../../data/mock_properties.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/favorite_button.dart';
import '../../../shared/widgets/app_image.dart';
import '../../property_detail/screens/property_detail_screen.dart';

class MapModeView extends StatefulWidget {
  final List<Property> properties;

  const MapModeView({
    super.key,
    required this.properties,
  });

  @override
  State<MapModeView> createState() => _MapModeViewState();
}

class _MapModeViewState extends State<MapModeView> {
  late Property _selectedProperty;

  @override
  void initState() {
    super.initState();
    _selectedProperty = widget.properties.isNotEmpty
        ? widget.properties.first
        : MockData.properties.first;
  }

  @override
  void didUpdateWidget(covariant MapModeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.properties.contains(_selectedProperty) && widget.properties.isNotEmpty) {
      _selectedProperty = widget.properties.first;
    }
  }

  // Helper coordinate mapper for Paris mock map
  Offset _getScreenOffset(Property property, Size mapSize) {
    double x = 0.5;
    double y = 0.5;

    switch (property.district.toLowerCase()) {
      case 'paris 8e':
        x = 0.44;
        y = 0.38;
        break;
      case 'paris 7e':
        x = 0.38;
        y = 0.58;
        break;
      case 'paris 16e':
        x = 0.22;
        y = 0.42;
        break;
      case 'le marais':
        x = 0.68;
        y = 0.46;
        break;
      case 'neuilly-sur-seine':
        x = 0.16;
        y = 0.26;
        break;
      default:
        x = 0.3 + (property.title.hashCode.abs() % 40) / 100.0;
        y = 0.3 + (property.id.hashCode.abs() % 40) / 100.0;
    }

    return Offset(mapSize.width * x, mapSize.height * y);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapSize = Size(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          children: [
            // Map Canvas and Pins
            Positioned.fill(
              child: Container(
                color: const Color(0xFFF3ECE2),
                child: Stack(
                  children: [
                    // Stylized Luxury Map Artwork
                    CustomPaint(
                      size: mapSize,
                      painter: _FullMapArtPainter(),
                    ),

                    // District Names Watermark
                    Positioned(
                      left: mapSize.width * 0.36,
                      top: mapSize.height * 0.30,
                      child: Text(
                        'PARIS 8E',
                        style: AppTypography.tag.copyWith(
                          color: AppColors.textTertiary.withOpacity(0.4),
                          letterSpacing: 4.0,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Positioned(
                      left: mapSize.width * 0.30,
                      top: mapSize.height * 0.66,
                      child: Text(
                        'PARIS 7E',
                        style: AppTypography.tag.copyWith(
                          color: AppColors.textTertiary.withOpacity(0.4),
                          letterSpacing: 4.0,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Positioned(
                      left: mapSize.width * 0.58,
                      top: mapSize.height * 0.38,
                      child: Text(
                        'LE MARAIS',
                        style: AppTypography.tag.copyWith(
                          color: AppColors.textTertiary.withOpacity(0.4),
                          letterSpacing: 4.0,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // Property Price Pins
                    ...widget.properties.map((property) {
                      final isSelected = property.id == _selectedProperty.id;
                      final pos = _getScreenOffset(property, mapSize);

                      return Positioned(
                        left: pos.dx - 40,
                        top: pos.dy - 20,
                        child: BounceTap(
                          onTap: () {
                            setState(() => _selectedProperty = property);
                          },
                          scaleFactor: 0.92,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            padding: EdgeInsets.symmetric(
                              horizontal: isSelected ? 14 : 10,
                              vertical: isSelected ? 8 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.surface,
                              borderRadius: AppRadius.pillRadius,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryBrown
                                    : AppColors.separator,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isSelected ? 0.22 : 0.08),
                                  blurRadius: isSelected ? 14 : 6,
                                  offset: Offset(0, isSelected ? 5 : 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryBrown,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                                Text(
                                  Formatters.formatCompactCurrency(property.price),
                                  style: AppTypography.tag.copyWith(
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                    fontSize: isSelected ? 13 : 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Draggable Bottom Sheet for Selected Property
            DraggableScrollableSheet(
              initialChildSize: 0.26,
              minChildSize: 0.20,
              maxChildSize: 0.44,
              snap: true,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.modal),
                      topRight: Radius.circular(AppRadius.modal),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 38,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.separator,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Selected Property Quick Card
                      BounceTap(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PropertyDetailScreen(
                                propertyId: _selectedProperty.id,
                              ),
                            ),
                          );
                        },
                        scaleFactor: 0.98,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              child: AppImage(
                                path: _selectedProperty.mainImage,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedProperty.type.label.toUpperCase(),
                                        style: AppTypography.tag.copyWith(
                                          color: AppColors.primaryBrown,
                                          fontSize: 10,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      FavoriteButton(
                                        isFavorite: _selectedProperty.isFavorite,
                                        size: 16,
                                        hasBackground: false,
                                        onToggle: () {
                                          PropertyRepository.instance.toggleFavorite(_selectedProperty.id);
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(
                                    _selectedProperty.title,
                                    style: AppTypography.propertyTitle.copyWith(fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedProperty.location,
                                    style: AppTypography.caption,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Formatters.formatCurrency(_selectedProperty.price),
                                        style: AppTypography.priceDisplay.copyWith(fontSize: 16),
                                      ),
                                      Text(
                                        '${_selectedProperty.bedrooms} ch · ${Formatters.formatArea(_selectedProperty.area)}',
                                        style: AppTypography.metadata.copyWith(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Glissez vers le haut pour plus de détails ou appuyez pour voir la galerie et réserver une visite.',
                        style: AppTypography.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _FullMapArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Water Painter (Ébrié Lagoon)
    final waterPaint = Paint()
      ..color = const Color(0xFFD4DFE0)
      ..style = PaintingStyle.fill;

    // Major Highways
    final highwayPaint = Paint()
      ..color = const Color(0xFFE2D7C8)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bridgePaint = Paint()
      ..color = const Color(0xFFCBBDAA)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    // Lagoon Path
    final lagoon = Path()
      ..moveTo(0, size.height * 0.48)
      ..cubicTo(
        size.width * 0.35,
        size.height * 0.42,
        size.width * 0.4,
        size.height * 0.65,
        size.width * 0.65,
        size.height * 0.55,
      )
      ..cubicTo(
        size.width * 0.85,
        size.height * 0.5,
        size.width * 0.95,
        size.height * 0.62,
        size.width,
        size.height * 0.58,
      )
      ..lineTo(size.width, size.height * 0.72)
      ..cubicTo(
        size.width * 0.7,
        size.height * 0.74,
        size.width * 0.3,
        size.height * 0.68,
        0,
        size.height * 0.62,
      )
      ..close();
    canvas.drawPath(lagoon, waterPaint);

    // Henri Konan Bédié Bridge
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.52),
      Offset(size.width * 0.68, size.height * 0.72),
      bridgePaint,
    );

    // De Gaulle Bridge
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.48),
      Offset(size.width * 0.45, size.height * 0.65),
      bridgePaint,
    );

    // Arterials
    final boulevardMitterrand = Path()
      ..moveTo(size.width * 0.35, size.height * 0.4)
      ..cubicTo(
        size.width * 0.5,
        size.height * 0.32,
        size.width * 0.7,
        size.height * 0.28,
        size.width,
        size.height * 0.22,
      );
    canvas.drawPath(boulevardMitterrand, highwayPaint);

    final boulevardVGE = Path()
      ..moveTo(size.width * 0.45, size.height * 0.65)
      ..lineTo(size.width * 0.8, size.height * 0.88);
    canvas.drawPath(boulevardVGE, highwayPaint);

    final voieExpress = Path()
      ..moveTo(size.width * 0.38, 0)
      ..lineTo(size.width * 0.36, size.height * 0.48);
    canvas.drawPath(voieExpress, highwayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

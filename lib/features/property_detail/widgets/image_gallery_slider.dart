import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/animations/app_durations.dart';
import '../../../core/animations/app_curves.dart';
import '../../../models/property.dart';
import '../../../data/property_repository.dart';
import '../../../shared/widgets/bounce_tap.dart';
import '../../../shared/widgets/favorite_button.dart';
import '../../../shared/widgets/app_image.dart';
import '../screens/fullscreen_gallery_screen.dart';

class ImageGallerySlider extends StatefulWidget {
  final Property property;
  final VoidCallback onBack;

  const ImageGallerySlider({
    super.key,
    required this.property,
    required this.onBack,
  });

  @override
  State<ImageGallerySlider> createState() => _ImageGallerySliderState();
}

class _ImageGallerySliderState extends State<ImageGallerySlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullscreen() async {
    final newIndex = await Navigator.of(context).push<int>(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        transitionDuration: AppDurations.uiTransition,
        pageBuilder: (context, anim1, anim2) => FullscreenGalleryScreen(
          images: widget.property.images,
          initialIndex: _currentPage,
          heroTagPrefix: widget.property.id,
        ),
        transitionsBuilder: (context, anim, _, child) => FadeTransition(
          opacity: anim,
          child: child,
        ),
      ),
    );

    if (newIndex != null && newIndex != _currentPage && mounted) {
      _pageController.jumpToPage(newIndex);
      setState(() => _currentPage = newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final galleryHeight = (screenHeight * 0.44).clamp(320.0, 480.0);

    return SizedBox(
      height: galleryHeight,
      child: Stack(
        children: [
          // PageView
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.modal),
              bottomRight: Radius.circular(AppRadius.modal),
            ),
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.property.images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final imageWidget = AppImage(
                  path: widget.property.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: galleryHeight,
                );

                return GestureDetector(
                  onTap: _openFullscreen,
                  child: index == 0
                      ? Hero(
                          tag: 'property_hero_${widget.property.id}',
                          child: imageWidget,
                        )
                      : imageWidget,
                );
              },
            ),
          ),

          // Top Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Top Floating Navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  BounceTap(
                    onTap: widget.onBack,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  // Favorite Button
                  FavoriteButton(
                    isFavorite: widget.property.isFavorite,
                    onToggle: () {
                      PropertyRepository.instance.toggleFavorite(widget.property.id);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Bottom Dots Indicator
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.property.images.length, (index) {
                final isSelected = index == _currentPage;
                return AnimatedContainer(
                  duration: AppDurations.micro,
                  curve: AppCurves.gentle,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isSelected ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

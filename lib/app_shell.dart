import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'data/property_repository.dart';
import 'features/home/screens/home_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'features/favorites/screens/favorites_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'shared/navigation/custom_nav_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PropertyRepository.instance,
      builder: (context, _) {
        final repo = PropertyRepository.instance;
        final currentIndex = repo.currentTabIndex;

        final screens = [
          HomeScreen(
            onNavigateToSearch: () => repo.setTabIndex(1),
            onNavigateToProfile: () => repo.setTabIndex(3),
          ),
          SearchScreen(
            onBackToHome: () => repo.setTabIndex(0),
          ),
          FavoritesScreen(
            onExploreTap: () => repo.setTabIndex(0),
          ),
          ProfileScreen(
            onNavigateToSaved: () => repo.setTabIndex(2),
          ),
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Screen Body
              IndexedStack(
                index: currentIndex,
                children: screens,
              ),

              // Floating Luxury Navigation Bar
              CustomNavBar(
                selectedIndex: currentIndex,
                onItemSelected: (index) {
                  repo.setTabIndex(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

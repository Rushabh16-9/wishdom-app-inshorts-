import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'feed_screen.dart';
import 'explore_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const ExploreScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows content to be visible under the floating nav
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(77),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25), // Translucent white
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withAlpha(51),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.home_outlined, Icons.home_filled, 0, 'Home'),
                      _buildNavItem(Icons.explore_outlined, Icons.explore, 1, 'Explore'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppTheme.accent.withAlpha(51) : Colors.transparent,
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppTheme.accent.withAlpha(77),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
              size: isSelected ? 28 : 24,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: AppTheme.accent,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

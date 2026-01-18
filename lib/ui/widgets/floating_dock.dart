import 'dart:ui';
import 'package:flutter/material.dart';

class FloatingDock extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const FloatingDock({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 70, // Slightly taller for better touch targets
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3), // Dark glass
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    0,
                    Icons.nights_stay_outlined,
                    Icons.nights_stay,
                  ),
                  _buildNavItem(1, Icons.book_outlined, Icons.book),
                  _buildNavItem(
                    2,
                    Icons.local_fire_department_outlined,
                    Icons.local_fire_department,
                  ),
                  _buildNavItem(3, Icons.graphic_eq, Icons.graphic_eq),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: isSelected ? 1.2 : 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? Colors.white : Colors.white60,
                  size: 26,
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

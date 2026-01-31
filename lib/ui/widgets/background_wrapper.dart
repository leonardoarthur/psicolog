import 'package:flutter/material.dart';
import 'package:animate_gradient/animate_gradient.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isDark) {
      // For light mode, just a solid or very subtle background
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      );
    }

    return Stack(
      children: [
        // Animated Background
        Positioned.fill(
          child: AnimateGradient(
            primaryBegin: const Alignment(-1.0, -1.0),
            primaryEnd: const Alignment(1.0, 1.0),
            secondaryBegin: const Alignment(1.0, 1.0),
            secondaryEnd: const Alignment(-1.0, -1.0),
            primaryColors: const [
              Color(0xFF0F0F1A), // Deepest Void
              Color(0xFF1A1A2E), // Dark Navy
              Color(0xFF0F0F1A),
            ],
            secondaryColors: const [
              Color(0xFF1E1E2C),
              Color(0xFF241538), // Very subtle purple tint
              Color(0xFF1E1E2C),
            ],
            duration: const Duration(seconds: 10),
          ),
        ),
        // Child Content
        Positioned.fill(child: child),
      ],
    );
  }
}

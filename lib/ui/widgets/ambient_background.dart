import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/material.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated Gradient Layer
        AnimateGradient(
          primaryBegin: Alignment.topLeft,
          primaryEnd: Alignment.bottomRight,
          secondaryBegin: Alignment.bottomLeft,
          secondaryEnd: Alignment.topRight,
          primaryColors: const [
            Color(0xFF0F2027), // Noir Blue
            Color(0xFF203A43), // Dream State
          ],
          secondaryColors: const [
            Color(0xFF2C5364), // Deep Ocean
            Color(0xFF203A43),
          ],
          duration: const Duration(seconds: 10),
          child: Container(),
        ),
        // Child Content
        child,
      ],
    );
  }
}

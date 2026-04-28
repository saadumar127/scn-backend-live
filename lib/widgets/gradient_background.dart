import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container( // ✅ return add kiya
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A001F), // deep base
            Color(0xFF1E0A3C), // smooth depth
            Color(0xFF4C1D95), // premium violet
            Color(0xFF9333EA), // glow highlight
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Stack(
        children: [
          // 🔥 Glow Top
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withOpacity(0.25),
              ),
            ),
          ),

          // 🔥 Glow Bottom
          Positioned(
            bottom: -140,
            right: -140,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF9333EA).withOpacity(0.20),
              ),
            ),
          ),

          // 🔥 Main UI
          SafeArea(
            child: child, // ✅ yahan fix kiya
          ),
        ],
      ),
    );
  }
}
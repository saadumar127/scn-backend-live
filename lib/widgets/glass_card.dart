import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;

  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        // 👇 blur kam rakha hai (readability ke liye)
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            // 👇 dark glass background (important fix)
            color: const Color(0xFF0F0126),

            borderRadius: BorderRadius.circular(22),

            // 👇 visible border (premium look)
            border: Border.all(
              color: const Color(0xFF6D28D9),
              width: 1.2,
            ),

            // 👇 depth / shadow
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),

          // 👇 GLOBAL TEXT FIX (sab text readable ho jayega)
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.5,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
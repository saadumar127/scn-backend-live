import 'package:flutter/material.dart';

class ScnColors {
  static const bg = Color(0xFFF7F5FF);
  static const dark = Color(0xFF19164A);
  static const muted = Color(0xFF7D7AA8);
  static const purple = Color(0xFF5A4BFF);
  static const blue = Color(0xFF36C9FF);
  static const card = Colors.white;
}

class ScnGradient {
  static const primary = LinearGradient(
    colors: [Color(0xFF5A4BFF), Color(0xFF36C9FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const hero = LinearGradient(
    colors: [Color(0xFF6657FF), Color(0xFF42C8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class ScnButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const ScnButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: ScnGradient.primary,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: ScnColors.purple.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScnCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const ScnCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: ScnColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: child,
    );

    if (onTap == null) return box;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: box,
    );
  }
}

class ScnTopBar extends StatelessWidget {
  final String title;
  final int step;
  final String subtitle;

  const ScnTopBar({
    super.key,
    required this.title,
    required this.step,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        gradient: ScnGradient.hero,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Row(
        children: [
          Text(
            '$step',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '— $subtitle',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.tune_rounded, color: Colors.white),
        ],
      ),
    );
  }
}

class ScnInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData icon;
  final bool obscureText;

  const ScnInput({
    super.key,
    this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ScnColors.muted),
          hintText: hint,
          hintStyle: const TextStyle(color: ScnColors.muted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }
}
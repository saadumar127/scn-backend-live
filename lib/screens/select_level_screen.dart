import 'package:flutter/material.dart';

import '../theme/scn_modern_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class SelectLevelScreen extends StatelessWidget {
  static const String routeName = '/select-level';

  const SelectLevelScreen({super.key});

  Widget _levelCard({
    required BuildContext context,
    required String level,
    required String subtitle,
    required IconData icon,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/select-field',
          arguments: {'educationLevel': level},
        );
      },
      child: GlassCard(
        child: Row(
          children: [
            Container(
              height: 66,
              width: 66,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9333EA), Color(0xFF38BDF8)],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      appBar: AppBar(
        title: const Text(
          'Select Level',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF070018),
        elevation: 0,
      ),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2D006B),
                    Color(0xFF7C3AED),
                    Color(0xFF38BDF8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.30),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_rounded, color: Colors.white, size: 52),
                  SizedBox(height: 18),
                  Text(
                    'Choose Your Education Level',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'SCN will suggest fields based on your current education level.',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _levelCard(
              context: context,
              level: 'Matric',
              subtitle: 'For class 9th / 10th students',
              icon: Icons.menu_book_rounded,
            ),
            const SizedBox(height: 16),
            _levelCard(
              context: context,
              level: 'Intermediate',
              subtitle: 'For FSC, FA, ICS, ICOM students',
              icon: Icons.workspace_premium_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
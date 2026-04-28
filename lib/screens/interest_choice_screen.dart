import 'package:flutter/material.dart';
import '../theme/scn_modern_theme.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class InterestChoiceScreen extends StatelessWidget {
  static const String routeName = '/interest-choice';

  const InterestChoiceScreen({super.key});

  Widget _choiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: GlassCard(
        child: Row(
          children: [
            Container(
              height: 66,
              width: 66,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9333EA),
                    Color(0xFF38BDF8),
                  ],
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
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
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
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final educationLevel =
    (args?['educationLevel'] ?? 'Intermediate').toString();
    final selectedField = (args?['selectedField'] ?? 'General').toString();
    final percentage = args?['percentage'] ?? 0;
    final dmcUploaded = args?['dmcUploaded'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      appBar: AppBar(
        title: const Text(
          'Choose Your Path',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF070018),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [

                // 🔥 Hero Section
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2D006B),
                        Color(0xFF7C3AED),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 54,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'What do you want to do next?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$educationLevel • $selectedField • $percentage%',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔥 Choice 1
                _choiceCard(
                  icon: Icons.favorite_rounded,
                  title: 'I have my own interest',
                  subtitle:
                  'Get related fields and other eligible options.',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/suggestions',
                      arguments: {
                        'educationLevel': educationLevel,
                        'selectedField': selectedField,
                        'percentage': percentage,
                        'dmcUploaded': dmcUploaded,
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // 🔥 Choice 2
                _choiceCard(
                  icon: Icons.quiz_rounded,
                  title: "I don't know what to choose",
                  subtitle:
                  'Start smart quiz and let SCN recommend a field.',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/quiz',
                      arguments: {
                        'educationLevel': educationLevel,
                        'selectedField': selectedField,
                        'percentage': percentage,
                        'flow': 'confused',
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
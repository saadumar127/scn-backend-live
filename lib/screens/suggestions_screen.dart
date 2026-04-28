import 'package:flutter/material.dart';

import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class SuggestionsScreen extends StatelessWidget {
  static const String routeName = '/suggestions';

  const SuggestionsScreen({super.key});

  List<String> _matricSuggestions(String selectedField) {
    return [
      selectedField,
      'ICS',
      'Pre-Engineering',
      'Pre-Medical',
      'ICOM',
      'FA / Arts',
    ].toSet().toList();
  }

  List<String> _relatedSuggestions(String selectedField) {
    final field = selectedField.toLowerCase();

    if (field.contains('medical')) {
      return ['MBBS', 'BDS', 'Pharm-D', 'BS Nursing', 'BS Biotechnology'];
    }

    if (field.contains('engineering')) {
      return [
        'BS Civil Engineering',
        'BS Electrical Engineering',
        'BS Mechanical Engineering',
        'BS Software Engineering'
      ];
    }

    if (field.contains('it') || field.contains('computer')) {
      return [
        'BS Software Engineering',
        'BS Computer Science',
        'BS Artificial Intelligence',
        'BS Data Science'
      ];
    }

    if (field.contains('business')) {
      return [
        'BBA',
        'BS Accounting & Finance',
        'BS Economics',
        'BS Banking & Finance'
      ];
    }

    return [
      'BS Psychology',
      'BS English',
      'BS Education',
      'BS Media Studies'
    ];
  }

  List<String> _otherSuggestions(String selectedField) {
    return [
      'BS Psychology',
      'BBA',
      'BS Media Studies',
      'BS Education',
      'BS English',
      'BS Data Science',
    ];
  }

  Widget _suggestionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/roadmap',
          arguments: {'program': title},
        );
      },
      child: GlassCard(
        child: Row(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9333EA),
                    Color(0xFF38BDF8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.school, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final educationLevel = args?['educationLevel'] ?? 'Unknown';
    final selectedField = args?['selectedField'] ?? 'General';
    final percentage = args?['percentage'] ?? 0;

    final isMatric = educationLevel == 'Matric';

    final mainSuggestions = isMatric
        ? _matricSuggestions(selectedField)
        : _relatedSuggestions(selectedField);

    final otherSuggestions =
    isMatric ? [] : _otherSuggestions(selectedField);

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [

            // 🔥 HEADER
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2D006B),
                    Color(0xFF7C3AED),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 52),
                  const SizedBox(height: 14),
                  Text(
                    isMatric
                        ? 'Recommended Intermediate Fields'
                        : 'Recommended Career Paths',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$educationLevel • $selectedField • $percentage%',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Best Matches',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ...mainSuggestions.map((e) =>
                _suggestionCard(
                  context: context,
                  title: e,
                  subtitle: '',
                  icon: Icons.school,
                )),

            if (!isMatric) ...[
              const SizedBox(height: 20),

              const Text(
                'Other Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ...otherSuggestions.map((e) =>
                  _suggestionCard(
                    context: context,
                    title: e,
                    subtitle: '',
                    icon: Icons.lightbulb,
                  )),
            ],

            const SizedBox(height: 20),

            GradientButton(
              text: 'Ask AI Chatbot',
              onPressed: () {
                Navigator.pushNamed(context, '/chatbot');
              },
            ),
          ],
        ),
      ),
    );
  }
}
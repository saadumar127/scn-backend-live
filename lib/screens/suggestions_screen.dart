import 'package:flutter/material.dart';

import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class SuggestionsScreen extends StatelessWidget {
  static const String routeName = '/suggestions';

  const SuggestionsScreen({super.key});

  List<String> _matricSuggestions(String selectedField, double percentage) {
    final field = selectedField.toLowerCase();

    final list = <String>[
      selectedField,
      'ICS',
      'ICOM',
      'FA / Arts',
    ];

    if (percentage >= 60) {
      list.add('Pre-Engineering');
      list.add('Pre-Medical');
    }

    if (field.contains('computer') || field.contains('it')) {
      list.insert(1, 'ICS');
    }

    return list.toSet().toList();
  }

  List<String> _relatedSuggestions(String selectedField, double percentage) {
    final field = selectedField.toLowerCase();

    if (field.contains('medical') || field.contains('pre-medical')) {
      final list = <String>[
        'MBBS',
        'BDS',
        'DPT',
        'Pharm-D',
        'BS Nursing',
        'BS Biotechnology',
        'BS Psychology',
      ];

      if (percentage < 85) {
        list.remove('MBBS');
        list.remove('BDS');
      }

      return list;
    }

    if (field.contains('engineering') || field.contains('pre-engineering')) {
      return [
        'BS Electrical Engineering',
        'BS Mechanical Engineering',
        'BS Civil Engineering',
        'BS Mechatronics',
        'BS Architecture',
        'BS Software Engineering',
        'BS Computer Science',
      ];
    }

    if (field.contains('it') || field.contains('computer') || field.contains('ics')) {
      return [
        'BS Software Engineering',
        'BS Computer Science',
        'BS Artificial Intelligence',
        'BS Data Science',
        'BS Cyber Security',
        'BS Information Technology',
      ];
    }

    if (field.contains('business') || field.contains('icom') || field.contains('commerce')) {
      return [
        'BBA',
        'BS Accounting & Finance',
        'BS Economics',
        'BS Banking & Finance',
      ];
    }

    return [
      'BS Psychology',
      'BS English',
      'BS Education',
      'BS Media Studies',
      'BS International Relations',
      'BS Sociology',
    ];
  }

  List<String> _otherSuggestions({
    required String selectedField,
    required double percentage,
  }) {
    final field = selectedField.toLowerCase();

    final allFields = <String>[
      'BS Software Engineering',
      'BS Computer Science',
      'BS Artificial Intelligence',
      'BS Data Science',
      'BS Cyber Security',
      'BS Information Technology',
      'BS Electrical Engineering',
      'BS Mechanical Engineering',
      'BS Civil Engineering',
      'BS Chemical Engineering',
      'BS Mechatronics',
      'BS Architecture',
      'MBBS',
      'BDS',
      'DPT',
      'Pharm-D',
      'BS Biotechnology',
      'BS Nursing',
      'BS Psychology',
      'BBA',
      'BS Accounting & Finance',
      'BS Economics',
      'BS Banking & Finance',
      'BS Media Studies',
      'BS English',
      'BS Education',
      'BS International Relations',
      'BS Political Science',
      'BS Sociology',
    ];

    final related = _relatedSuggestions(selectedField, percentage);

    var filtered = allFields.where((item) => !related.contains(item)).toList();

    if (percentage < 85) {
      filtered.remove('MBBS');
      filtered.remove('BDS');
    }

    if (percentage < 60) {
      filtered.removeWhere((item) {
        final x = item.toLowerCase();
        return x.contains('engineering') ||
            x.contains('architecture') ||
            x.contains('artificial') ||
            x.contains('data science');
      });
    }

    if (field.contains('medical') || field.contains('pre-medical')) {
      filtered.insert(0, 'BS Computer Science ⚠️ Requires Additional Math');
      filtered.insert(1, 'BS Software Engineering ⚠️ Requires Additional Math');
      filtered.insert(2, 'BS Artificial Intelligence ⚠️ Requires Additional Math');
      filtered.insert(3, 'BS Data Science ⚠️ Requires Additional Math');
    }

    return filtered.toSet().toList();
  }

  Widget _suggestionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String educationLevel,
    required String selectedField,
  }) {
    final needsBridge = title.contains('Requires Additional Math');

    final cleanTitle = title
        .replaceAll('⚠️ Requires Additional Math', '')
        .trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/roadmap',
            arguments: {
              'program': cleanTitle,
              'chosenPath': cleanTitle,
              'field': selectedField,
              'educationLevel': educationLevel,
            },
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
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cleanTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15.5,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFEDE9FE),
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                    if (needsBridge) ...[
                      const SizedBox(height: 6),
                      const Text(
                        'Bridge Required: Basic Mathematics first',
                        style: TextStyle(
                          color: Color(0xFFFBBF24),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final educationLevel = (args?['educationLevel'] ?? 'Unknown').toString();
    final selectedField = (args?['selectedField'] ?? 'General').toString();
    final percentage = _toDouble(args?['percentage'] ?? 0);

    final isMatric = educationLevel.toLowerCase() == 'matric';

    final mainSuggestions = isMatric
        ? _matricSuggestions(selectedField, percentage)
        : _relatedSuggestions(selectedField, percentage);

    final otherSuggestions = isMatric
        ? <String>[]
        : _otherSuggestions(
      selectedField: selectedField,
      percentage: percentage,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 52,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    isMatric
                        ? 'Recommended Intermediate Fields'
                        : 'Recommended Career Paths',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$educationLevel • $selectedField • ${percentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Color(0xFFEDE9FE),
                      fontWeight: FontWeight.w600,
                    ),
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
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 10),

            ...mainSuggestions.map(
                  (e) => _suggestionCard(
                context: context,
                title: e,
                subtitle: 'Recommended based on your marks and selected field',
                icon: Icons.school,
                educationLevel: educationLevel,
                selectedField: selectedField,
              ),
            ),

            if (!isMatric) ...[
              const SizedBox(height: 20),

              const Text(
                'Other Eligible Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'These are extra fields you can explore depending on university policy and eligibility.',
                style: TextStyle(
                  color: Color(0xFFEDE9FE),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              ...otherSuggestions.map(
                    (e) => _suggestionCard(
                  context: context,
                  title: e,
                  subtitle: 'Alternative option',
                  icon: Icons.lightbulb,
                  educationLevel: educationLevel,
                  selectedField: selectedField,
                ),
              ),
            ],

            const SizedBox(height: 20),

            GradientButton(
              text: 'Ask AI Chatbot',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/chatbot',
                  arguments: {
                    'educationLevel': educationLevel,
                    'selectedField': selectedField,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import 'roadmap_screen.dart';

class SelectProgramScreen extends StatefulWidget {
  static const String routeName = '/select-program';

  const SelectProgramScreen({super.key});

  @override
  State<SelectProgramScreen> createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  String? selectedProgram;

  List<String> _programsForSelection(String level, String field) {
    if (level == 'Matric Level') {
      switch (field) {
        case 'Science':
          return [
            'FSc Pre-Medical',
            'FSc Pre-Engineering',
            'ICS',
          ];
        case 'Arts':
          return [
            'FA',
            'ICOM',
            'ICS',
          ];
        default:
          return [
            'FA',
            'ICS',
          ];
      }
    }

    switch (field) {
      case 'Pre-Medical':
        return [
          'MBBS',
          'BDS',
          'Pharm-D',
          'DPT',
          'BS Nursing',
        ];
      case 'Pre-Engineering':
        return [
          'BS Civil Engineering',
          'BS Mechanical Engineering',
          'BS Electrical Engineering',
          'BS Architecture',
        ];
      case 'ICS':
        return [
          'BS Computer Science',
          'BS Software Engineering',
          'BS Information Technology',
          'BS Data Science',
          'BS Artificial Intelligence',
        ];
      case 'ICOM':
        return [
          'BBA',
          'BS Accounting and Finance',
          'BS Commerce',
          'BS Economics',
        ];
      case 'FA':
        return [
          'BS English',
          'BS Psychology',
          'BS Political Science',
          'BS Education',
          'BS Mass Communication',
        ];
      default:
        return [
          'BS Program 1',
          'BS Program 2',
        ];
    }
  }

  String _titleForLevel(String level) {
    if (level == 'Matric Level') {
      return 'Suggested Intermediate Fields';
    }
    return 'Suggested University Programs';
  }

  String _subTitleForLevel(String level, String field) {
    if (level == 'Matric Level') {
      return 'Based on your matric field: $field';
    }
    return 'Based on your intermediate field: $field';
  }

  String _buttonTextForLevel(String level) {
    if (level == 'Matric Level') {
      return 'Continue to Roadmap';
    }
    return 'Generate Roadmap';
  }

  @override
  Widget build(BuildContext context) {
    final args =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            {
              'level': 'Matric Level',
              'field': 'Science',
            };

    final String level = args['level'] as String;
    final String field = args['field'] as String;
    final programs = _programsForSelection(level, field);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suggestions',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleForLevel(level),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _subTitleForLevel(level, field),
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: programs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final program = programs[index];
                      final isSelected = selectedProgram == program;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedProgram = program;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x10000000),
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected
                                    ? AppTheme.primary
                                    : AppTheme.textSecondary,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  program,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RoadmapScreen.routeName,
                      arguments: {
                        'program': selectedProgram ?? programs.first,
                        'field': field,
                      },
                    );
                  },
                  child: const Text(
                    'Skip and Ask for Roadmap',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    text: _buttonTextForLevel(level),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        RoadmapScreen.routeName,
                        arguments: {
                          'program': selectedProgram ?? programs.first,
                          'field': field,
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
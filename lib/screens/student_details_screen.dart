import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../theme/scn_modern_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/modern_textfield.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class StudentDetailsScreen extends StatefulWidget {
  static const String routeName = '/student-details';

  const StudentDetailsScreen({super.key});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final TextEditingController percentageController = TextEditingController();

  String educationLevel = 'Unknown';
  String selectedField = 'General';
  bool dmcUploaded = false;
  bool isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      educationLevel = (args['educationLevel'] ?? 'Unknown').toString();
      selectedField = (args['selectedField'] ?? 'General').toString();
    }
  }

  Future<void> _continue() async {
    final percentageText = percentageController.text.trim();

    if (percentageText.isEmpty) {
      _showMessage('Please enter your percentage');
      return;
    }

    final double? percentage = double.tryParse(percentageText);

    if (percentage == null || percentage < 0 || percentage > 100) {
      _showMessage('Enter valid percentage (0-100)');
      return;
    }

    setState(() => isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirestoreService.instance.saveUserProfile(
        name: user?.displayName ?? 'Student',
        email: user?.email ?? '',
        educationLevel: educationLevel,
        selectedField: selectedField,
        percentage: percentage,
      );

      if (!mounted) return;

      final args = {
        'educationLevel': educationLevel,
        'selectedField': selectedField,
        'percentage': percentage,
        'dmcUploaded': dmcUploaded,
      };

      if (educationLevel == 'Intermediate') {
        Navigator.pushNamed(context, '/interest-choice', arguments: args);
      } else {
        Navigator.pushNamed(context, '/suggestions', arguments: args);
      }
    } catch (e) {
      _showMessage('Failed: $e');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  void dispose() {
    percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      appBar: AppBar(
        title: const Text(
          'Student Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF070018),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [

                // 🔥 Hero Card
                Container(
                  padding: const EdgeInsets.all(24),
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
                      const Icon(
                        Icons.assignment_rounded,
                        color: Colors.white,
                        size: 52,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Add Your Academic Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$educationLevel • $selectedField',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // 🔥 Form Card
                GlassCard(
                  child: Column(
                    children: [
                      ModernTextField(
                        controller: percentageController,
                        hint: 'Enter your percentage e.g. 85',
                      ),
                      const SizedBox(height: 16),

                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          setState(() => dmcUploaded = true);
                          _showMessage('DMC uploaded (demo)');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                dmcUploaded
                                    ? Icons.check_circle
                                    : Icons.upload_file,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  dmcUploaded
                                      ? 'DMC Uploaded'
                                      : 'Upload DMC / Marksheet',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      isSaving
                          ? const CircularProgressIndicator()
                          : GradientButton(
                        text: educationLevel == 'Intermediate'
                            ? 'Continue'
                            : 'Get Suggestions',
                        onPressed: _continue,
                      ),
                    ],
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
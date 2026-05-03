import 'package:flutter/material.dart';

import '../services/ai_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';

class QuizScreen extends StatefulWidget {
  static const String routeName = '/quiz';

  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final Map<String, dynamic> scoring;

  _QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.scoring,
  });

  Map<String, dynamic> toResultMap() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'scoring': scoring,
    };
  }
}

class _QuizScreenState extends State<QuizScreen> {
  bool isLoading = true;
  bool isSubmitting = false;

  String educationLevel = 'Intermediate';
  String selectedField = 'General';

  int currentIndex = 0;

  // IMPORTANT:
  // answers mein option text nahi, option index save hoga: "0", "1", "2", "3"
  final Map<String, String> answers = {};

  List<_QuizQuestion> questions = [];
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      educationLevel = (args['educationLevel'] ?? educationLevel).toString();
      selectedField = (args['selectedField'] ?? selectedField).toString();
    }

    if (questions.isEmpty && isLoading) {
      loadQuiz();
    }
  }

  Future<void> loadQuiz() async {
    try {
      final raw = await AiService.instance.getQuizQuestions(
        selectedField: selectedField,
        educationLevel: educationLevel,
      );

      debugPrint('TOTAL QUESTIONS FROM API: ${raw.length}');

      if (raw.isEmpty) {
        throw Exception('Quiz empty returned from backend');
      }

      questions = raw.map((q) {
        return _QuizQuestion(
          id: (q['id'] ?? DateTime.now().microsecondsSinceEpoch.toString())
              .toString(),
          question: (q['question'] ?? 'No question').toString(),
          options: List<String>.from(q['options'] ?? []),
          scoring: Map<String, dynamic>.from(q['scoring'] ?? {}),
        );
      }).where((q) {
        return q.options.length == 4 && q.question.trim().isNotEmpty;
      }).toList();

      if (questions.isEmpty) {
        throw Exception('No valid quiz questions found');
      }

      errorMessage = null;
    } catch (e) {
      debugPrint('QUIZ ERROR: $e');
      errorMessage =
      'Quiz load nahi hua.\nBackend / Gemini API check karo.\n\nError: $e';
      questions = [];
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  void nextQuestion() {
    if (questions.isEmpty) return;

    final currentQuestion = questions[currentIndex];

    if (!answers.containsKey(currentQuestion.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select one option'),
        ),
      );
      return;
    }

    if (currentIndex == questions.length - 1) {
      Navigator.pushNamed(
        context,
        '/quiz-result',
        arguments: {
          'educationLevel': educationLevel,
          'selectedField': selectedField,
          'questions': questions.map((q) => q.toResultMap()).toList(),
          'answers': answers,
        },
      );
    } else {
      setState(() => currentIndex++);
    }
  }

  Widget optionCard({
    required String option,
    required int optionIndex,
    required _QuizQuestion question,
  }) {
    final selected = answers[question.id] == optionIndex.toString();

    return InkWell(
      onTap: () {
        setState(() {
          answers[question.id] = optionIndex.toString();
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF7C3AED).withOpacity(0.32)
              : const Color(0xFF2D164F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFFC084FC)
                : const Color(0xFF4C1D95),
            width: selected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? const Color(0xFFC084FC) : Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingScreen() {
    return const Scaffold(
      backgroundColor: Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFC084FC),
          ),
        ),
      ),
    );
  }

  Widget _errorScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFFCA5A5),
                      size: 52,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Quiz Not Loaded',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFEDE9FE),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                          questions.clear();
                          currentIndex = 0;
                          answers.clear();
                        });
                        loadQuiz();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9333EA),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _loadingScreen();
    if (questions.isEmpty) return _errorScreen();

    final q = questions[currentIndex];
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                GlassCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.quiz_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Smart Career Quiz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$educationLevel • $selectedField',
                              style: const TextStyle(
                                color: Color(0xFFEDE9FE),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${currentIndex + 1}/${questions.length}',
                        style: const TextStyle(
                          color: Color(0xFFEDE9FE),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          color: const Color(0xFFC084FC),
                          backgroundColor: const Color(0xFF2D164F),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Text(
                        q.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 22),

                      ...List.generate(
                        q.options.length,
                            (index) => optionCard(
                          option: q.options[index],
                          optionIndex: index,
                          question: q,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9333EA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            currentIndex == questions.length - 1
                                ? 'Submit Quiz'
                                : 'Next',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
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
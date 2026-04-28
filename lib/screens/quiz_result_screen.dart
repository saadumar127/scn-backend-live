import 'package:flutter/material.dart';

import '../services/ai_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';
import '../services/firestore_service.dart';

class QuizResultScreen extends StatefulWidget {
  static const String routeName = '/quiz-result';

  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool isLoading = true;
  String? errorMessage;

  String educationLevel = 'Unknown';
  String selectedField = 'General';

  String recommendedField = 'No Recommendation';
  String shortReason = '';
  String careerDirection = '';
  String nextStep = '';

  List<Map<String, dynamic>> rankedFields = [];
  List<Map<String, dynamic>> alternatives = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isLoading && rankedFields.isEmpty) {
      _loadResult();
    }
  }

  Future<void> _loadResult() async {
    try {
      final args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args == null) {
        throw Exception('No quiz data received');
      }

      educationLevel = (args['educationLevel'] ?? 'Unknown').toString();
      selectedField = (args['selectedField'] ?? 'General').toString();

      final questionsRaw = args['questions'];
      final answersRaw = args['answers'];

      if (questionsRaw is! List || answersRaw is! Map) {
        throw Exception('Invalid quiz result data');
      }

      final questions = questionsRaw
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final answers = answersRaw.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
      );

      final result = await AiService.instance.getQuizResult(
        questions: questions,
        answers: answers,
      );


      final savedRecommendedField =
      (result['recommendedField'] ?? 'No Recommendation').toString();

      final savedShortReason = (result['shortReason'] ?? '').toString();

      final savedCareerDirection =
      (result['careerDirection'] ?? '').toString();

      final savedNextStep = (result['nextStep'] ?? '').toString();

      final savedRankedFields = ((result['rankedFields'] as List?) ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final savedAlternatives = ((result['alternatives'] as List?) ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      final savedScoreSummary =
      Map<String, dynamic>.from(result['scoreSummary'] ?? {});

      await FirestoreService.instance.saveQuizResult(
        educationLevel: educationLevel,
        selectedField: selectedField,
        recommendedField: savedRecommendedField,
        rankedFields: savedRankedFields,
        shortReason: savedShortReason,
        careerDirection: savedCareerDirection,
        nextStep: savedNextStep,
        matchPercent: _calculateMatchPercent(savedRankedFields),
        alternatives: savedAlternatives,
        scoreSummary: savedScoreSummary,
      );


      setState(() {
        recommendedField =
            (result['recommendedField'] ?? 'No Recommendation').toString();

        shortReason = (result['shortReason'] ??
            '$recommendedField matches your quiz answers and interests.')
            .toString();

        careerDirection = (result['careerDirection'] ??
            'Explore this field roadmap and compare it with related options.')
            .toString();

        nextStep = (result['nextStep'] ??
            'Open the roadmap and review semester-wise study plan.')
            .toString();

        rankedFields = ((result['rankedFields'] as List?) ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        alternatives = ((result['alternatives'] as List?) ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  int get matchPercent {
    if (rankedFields.isEmpty) return 0;

    final topScore = NumberParser.toDouble(rankedFields.first['score']);
    if (topScore <= 0) return 0;

    final totalScore = rankedFields.fold<double>(
      0,
          (sum, item) => sum + NumberParser.toDouble(item['score']),
    );

    if (totalScore <= 0) return 0;

    final percent = ((topScore / totalScore) * 100).round();
    return percent.clamp(0, 100);
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


  int _calculateMatchPercent(List<Map<String, dynamic>> fields) {
    if (fields.isEmpty) return 0;

    final topScore = NumberParser.toDouble(fields.first['score']);
    final totalScore = fields.fold<double>(
      0,
          (sum, item) => sum + NumberParser.toDouble(item['score']),
    );

    if (topScore <= 0 || totalScore <= 0) return 0;

    return ((topScore / totalScore) * 100).round().clamp(0, 100);
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
                      size: 54,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Result Not Loaded',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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
                        });
                        _loadResult();
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

  Widget _fieldCard(Map<String, dynamic> item, int index) {
    final field = (item['field'] ?? 'Unknown Field').toString();
    final score = item['score'] ?? 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9333EA),
                    Color(0xFF38BDF8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                field,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              '$score pts',
              style: const TextStyle(
                color: Color(0xFF22C55E),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alternativeCard(Map<String, dynamic> item) {
    final field = (item['field'] ?? 'Alternative Field').toString();
    final reason = (item['reason'] ?? 'Suitable option based on your answers.')
        .toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF9333EA).withOpacity(0.25),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    reason,
                    style: const TextStyle(
                      color: Color(0xFFEDE9FE),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _loadingScreen();
    if (errorMessage != null) return _errorScreen();

    return Scaffold(
      backgroundColor: const Color(0xFF070018),
      body: GradientBackground(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Container(
                  padding: const EdgeInsets.all(28),
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
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9333EA).withOpacity(0.35),
                        blurRadius: 35,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors.white,
                        size: 62,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your Career Result',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$educationLevel • $selectedField',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFEDE9FE),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                GlassCard(
                  child: Column(
                    children: [
                      const Text(
                        'Recommended Field',
                        style: TextStyle(
                          color: Color(0xFFEDE9FE),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        recommendedField,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 135,
                        width: 135,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF9333EA),
                              Color(0xFF38BDF8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9333EA).withOpacity(0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$matchPercent%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        shortReason,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFEDE9FE),
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'AI Career Direction',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),

                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        careerDirection,
                        style: const TextStyle(
                          color: Color(0xFFEDE9FE),
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 12),
                      const Text(
                        'Next Step',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        nextStep,
                        style: const TextStyle(
                          color: Color(0xFFEDE9FE),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Alternative Course Suggestions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),

                if (alternatives.isEmpty)
                  const GlassCard(
                    child: Text(
                      'No alternatives found.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ...alternatives.map(_alternativeCard),

                const SizedBox(height: 24),

                const Text(
                  'Score Breakdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),

                if (rankedFields.isEmpty)
                  const GlassCard(
                    child: Text(
                      'No score data found.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  ...rankedFields
                      .asMap()
                      .entries
                      .map((entry) => _fieldCard(entry.value, entry.key)),

                const SizedBox(height: 26),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white30),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/roadmap',
                            arguments: {
                              'field': recommendedField,
                              'chosenPath': recommendedField,
                              'educationLevel': educationLevel,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9333EA),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('View Roadmap'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NumberParser {
  static double toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0;
  }
}
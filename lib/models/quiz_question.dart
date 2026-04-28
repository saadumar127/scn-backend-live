class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String category;
  final Map<String, dynamic> scoring;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
    required this.scoring,
  });
}
class StudentData {
  String educationLevel;
  String selectedField;
  double percentage;
  String? dmcImagePath;
  String? interestChoice;
  String? selectedSuggestion;

  StudentData({
    required this.educationLevel,
    required this.selectedField,
    required this.percentage,
    this.dmcImagePath,
    this.interestChoice,
    this.selectedSuggestion,
  });
}
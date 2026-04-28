import 'dart:convert';
import 'package:http/http.dart' as http;

import 'firestore_service.dart';

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  static const String baseUrl = 'https://scn-backend-live.onrender.com';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'x-api-key': 'UsmanBay7223#', // 🔥 apni backend wali key
  };

  Future<String> sendChatMessage({
    required String message,
    required String educationLevel,
    required String selectedField,
  }) async {
    final response = await http
        .post(
      Uri.parse('$baseUrl/chat'),
      headers: _headers,
      body: jsonEncode({
        'message': message,
        'educationLevel': educationLevel,
        'selectedField': selectedField,
      }),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Chat failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final reply = (data['reply'] ?? data['message'] ?? 'No response').toString();

    await FirestoreService.instance.saveChatMessage(
      educationLevel: educationLevel,
      selectedField: selectedField,
      userMessage: message,
      botReply: reply,
    );

    return reply;
  }
  Future<List<Map<String, dynamic>>> getQuizQuestions({
    required String selectedField,
    required String educationLevel,
  }) async {
    final response = await http
        .post(
      Uri.parse('$baseUrl/quiz'),
      headers: _headers,
      body: jsonEncode({
        'field': selectedField,
        'selectedField': selectedField,
        'educationLevel': educationLevel,
      }),
    )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode != 200) {
      throw Exception('Quiz failed: ${response.body}');
    }

    final decoded = jsonDecode(response.body);

    // ✅ Backend agar {questions:[...]} bheje
    // ✅ ya direct [...] bheje — dono handle honge
    final rawQuestions = decoded is List ? decoded : decoded['questions'];

    if (rawQuestions is List) {
      return rawQuestions.map((e) {
        return Map<String, dynamic>.from(e as Map);
      }).toList();
    }

    throw Exception('Invalid quiz response: ${response.body}');
  }

  Future<Map<String, dynamic>> getQuizResult({
    required List<Map<String, dynamic>> questions,
    required Map<String, String> answers,
  }) async {
    final response = await http
        .post(
      Uri.parse('$baseUrl/quiz-result'),
      headers: _headers,
      body: jsonEncode({
        'questions': questions,
        'answers': answers,
      }),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Quiz result failed: ${response.body}');
    }

    return Map<String, dynamic>.from(jsonDecode(response.body));
  }

  Future<String> generateRoadmap({
    required String chosenPath,
    required String field,
    required String educationLevel,
  }) async {
    final response = await http
        .post(
      Uri.parse('$baseUrl/roadmap'),
      headers: _headers,
      body: jsonEncode({
        'chosenPath': chosenPath,
        'field': field,
        'educationLevel': educationLevel,
      }),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Roadmap failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    return (data['roadmap'] ?? 'No roadmap found').toString();
  }
}
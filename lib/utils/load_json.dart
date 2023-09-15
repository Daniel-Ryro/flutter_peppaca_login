import 'dart:convert';
import 'package:flutter/services.dart';

class SecureQuestions {
  final Map<String, String> questions;

  SecureQuestions({required this.questions});

  factory SecureQuestions.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> questionsJson = json['en'];
    final Map<String, String> questions =
        questionsJson.map((key, value) => MapEntry(key, value.toString()));

    return SecureQuestions(
      questions: questions,
    );
  }

  static Future<SecureQuestions> load() async {
    final String jsonString =
        await rootBundle.loadString('lib/assets/data/secureQuestion.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    return SecureQuestions.fromJson(data);
  }
}

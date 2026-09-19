import 'dart:convert';

import 'package:flutter/services.dart';

import 'models/question.dart';

class QuizService {
  Future<List<Question>> loadQuestions() async {
    final jsonString = await rootBundle.loadString(
      'data/questions.json',
    );

    final List<dynamic> jsonData = jsonDecode(jsonString);

    return jsonData
        .map(
          (json) => Question.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<Question>> getQuizQuestions() async {
    final questions = await loadQuestions();

    questions.shuffle();

    return questions.take(10).toList();
  }
}
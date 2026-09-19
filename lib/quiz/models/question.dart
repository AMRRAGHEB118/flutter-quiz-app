class Question {
  final int id;
  final String category;
  final String question;
  final List<String> options;
  final String correct_answer;

  const Question({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correct_answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      category: json['category'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correct_answer: json['correct_answer'],
    );
  }
}
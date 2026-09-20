import 'package:flutter/material.dart';

import 'models/question.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<Question> questions;
  final List<String?> selectedAnswers;

  const ResultsScreen({
    super.key,
    required this.questions,
    required this.selectedAnswers,
  });

  int get correctCount {
    var count = 0;

    for (var i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        count += 1;
      }
    }

    return count;
  }

  void retakeQuiz(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const _TrophyBadge(),
              const SizedBox(height: 16),
              const Text(
                'Quiz Completed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Great job! You scored',
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '$correctCount / ${questions.length}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Correct Answers',
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: questions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _ResultTile(
                      index: index,
                      question: questions[index],
                      selectedAnswer: selectedAnswers[index],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => retakeQuiz(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrophyBadge extends StatelessWidget {
  const _TrophyBadge();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/quiz_result_trophy.png',
      width: 180,
      height: 180,
      fit: BoxFit.contain,
    );
  }
}

class _ResultTile extends StatefulWidget {
  final int index;
  final Question question;
  final String? selectedAnswer;

  const _ResultTile({
    required this.index,
    required this.question,
    required this.selectedAnswer,
  });

  @override
  State<_ResultTile> createState() => _ResultTileState();
}

class _ResultTileState extends State<_ResultTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isCorrect = widget.selectedAnswer == widget.question.correctAnswer;
    final userAnswer = widget.selectedAnswer ?? 'No answer';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${widget.index + 1}. ${widget.question.question}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(42, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
                      children: [
                        const TextSpan(text: 'Your answer: '),
                        TextSpan(
                          text: userAnswer,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isCorrect ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
                      children: [
                        const TextSpan(text: 'Correct answer: '),
                        TextSpan(
                          text: widget.question.correctAnswer,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

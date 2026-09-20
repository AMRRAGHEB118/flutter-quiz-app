import 'package:flutter/material.dart';

import 'models/question.dart';
import 'quiz_service.dart';
import 'results_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizService quizService = QuizService();

  List<Question> questions = [];
  List<String?> selectedAnswers = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadQuiz();
  }

  Future<void> loadQuiz() async {
    final loadedQuestions = await quizService.getQuizQuestions();

    setState(() {
      questions = loadedQuestions;
      selectedAnswers = List<String?>.filled(loadedQuestions.length, null);
      currentIndex = 0;
      isLoading = false;
    });
  }

  void selectAnswer(String option) {
    setState(() {
      selectedAnswers[currentIndex] = option;
    });
  }

  void goToNextQuestion() {
    final isLastQuestion = currentIndex == questions.length - 1;

    if (isLastQuestion) {
      finishQuiz();
      return;
    }

    setState(() {
      currentIndex += 1;
    });
  }

  void finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(
          questions: questions,
          selectedAnswers: selectedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = questions[currentIndex];
    final selectedOption = selectedAnswers[currentIndex];
    final isLastQuestion = currentIndex == questions.length - 1;
    final progress = (currentIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: const Color(0xFF0F172A),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Question ${currentIndex + 1} of ${questions.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    final optionLetter = String.fromCharCode(65 + index);
                    final isSelected = option == selectedOption;

                    return _AnswerOption(
                      letter: optionLetter,
                      label: option,
                      isSelected: isSelected,
                      onTap: () => selectAnswer(option),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedOption == null ? null : goToNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      disabledBackgroundColor: const Color(0xFF93C5FD),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(isLastQuestion ? 'Finish' : 'Next'),
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

class _AnswerOption extends StatelessWidget {
  final String letter;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.letter,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
              child: Text(
                letter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

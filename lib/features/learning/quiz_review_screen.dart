import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';

class QuizReviewScreen extends StatefulWidget {
  const QuizReviewScreen({super.key});

  @override
  State<QuizReviewScreen> createState() => _QuizReviewScreenState();
}

class _QuizReviewScreenState extends State<QuizReviewScreen> {
  Map<String, dynamic> quizData = {};
  int selectedQuestionIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    quizData = (args is Map<String, dynamic>) ? args : {};
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Color _getIndicatorColor(int index) {
    final question = quizData['questions']?[index];
    if (question == null) return Colors.grey;
    final userAnswer = question['userAnswer'];
    final correctAnswer = question['correctAnswer'];
    if (userAnswer == null) return Colors.grey;
    return userAnswer == correctAnswer ? Colors.green : Colors.red;
  }

  int _getCorrectCount() {
    int count = 0;
    final questions = quizData['questions'] as List? ?? [];
    for (final q in questions) {
      if (q['userAnswer'] == q['correctAnswer']) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final questions = quizData['questions'] as List? ?? [];
    final totalQuestions = quizData['totalQuestion'] ?? questions.length;
    final duration = quizData['duration'] ?? 300;
    final title = quizData['title'] ?? 'Quiz Review';

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text('Quiz Review', style: TextStyle(color: Colors.white)),
        ),
        body: const Center(child: Text('Tidak ada data kuis')),
      );
    }

    final selectedQuestion = questions[selectedQuestionIndex];
    final correctCount = _getCorrectCount();
    final score = totalQuestions > 0 ? (correctCount / totalQuestions * 100).round() : 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(duration),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Skor', '$score%', Colors.blue),
                _buildSummaryItem('Benar', '$correctCount', Colors.green),
                _buildSummaryItem('Salah', '${totalQuestions - correctCount}', Colors.red),
                _buildSummaryItem('Total', '$totalQuestions', Colors.grey),
              ],
            ),
          ),
          // Question Navigation
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(totalQuestions, (index) {
                  final isSelected = index == selectedQuestionIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedQuestionIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getIndicatorColor(index),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Question Detail
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pertanyaan ${selectedQuestion['number'] ?? (selectedQuestionIndex + 1)}',
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selectedQuestion['question'] ?? 'Pertanyaan tidak tersedia',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  ...List.generate((selectedQuestion['options'] as List? ?? []).length, (index) {
                    final isUserAnswer = selectedQuestion['userAnswer'] == index;
                    final isCorrectAnswer = selectedQuestion['correctAnswer'] == index;
                    Color bgColor = Colors.white;
                    Color borderColor = Colors.grey[300]!;
                    if (isCorrectAnswer) {
                      bgColor = Colors.green.withValues(alpha: 0.1);
                      borderColor = Colors.green;
                    } else if (isUserAnswer && !isCorrectAnswer) {
                      bgColor = Colors.red.withValues(alpha: 0.1);
                      borderColor = Colors.red;
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: bgColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor),
                              color: isUserAnswer || isCorrectAnswer ? borderColor : Colors.transparent,
                            ),
                            child: (isUserAnswer || isCorrectAnswer)
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              selectedQuestion['options'][index],
                              style: TextStyle(
                                fontSize: 16,
                                color: isCorrectAnswer ? Colors.green : (isUserAnswer && !isCorrectAnswer ? Colors.red : Colors.black87),
                                fontWeight: isUserAnswer || isCorrectAnswer ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Kembali ke Halaman Review - assuming back to previous screen
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Kembali ke Halaman Review'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Selesai - back to class detail
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.classDetail, (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Selesai',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../core/utils/string_utils.dart';

class QuizPlayScreen extends StatefulWidget {
  const QuizPlayScreen({super.key});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int currentQuestionIndex = 0;
  Map<int, int> userAnswers = {};
  List<Map<String, dynamic>> questions = [];
  Map<String, dynamic> quizData = {};
  
  Timer? _timer;
  late int _remainingTime;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      quizData = (args is Map<String, dynamic>) ? args : {};
      
      final rawQuestions = quizData['soal'] as List? ?? [];
      questions = List<Map<String, dynamic>>.from(rawQuestions);
      
      _remainingTime = (quizData['durasiMenit'] ?? 5) * 60;
      _startTimer();
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        _finishQuiz();
      }
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _finishQuiz() {
    _timer?.cancel();
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i]['jawaban']) {
        correctCount++;
      }
    }

    double score = (questions.isNotEmpty) ? (correctCount / questions.length) * 100 : 0;

    // Prepare questions with user answers and correct answers for review
    final questionsWithAnswers = questions.asMap().entries.map((entry) {
      final index = entry.key;
      final question = entry.value;
      return {
        'number': index + 1,
        'question': question['pertanyaan'],
        'options': question['opsi'],
        'correctAnswer': question['jawaban'],
        'userAnswer': userAnswers[index],
      };
    }).toList();

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.quizResult,
      arguments: {
        'score': score.round(),
        'correct': correctCount,
        'total': questions.length,
        'questions': questionsWithAnswers,
        'title': quizData['title'] ?? 'Quiz',
        'duration': _remainingTime,
        'courseId': quizData['courseId'],
        'materialId': quizData['materialId'],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppTheme.primaryColor),
        body: const Center(child: Text('Tidak ada soal tersedia')),
      );
    }

    final currentQ = questions[currentQuestionIndex];

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
                safeString(quizData['title'], 'Kuis'),
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
                    _formatTime(_remainingTime),
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
          // Progress indicator
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pertanyaan ${currentQuestionIndex + 1} dari ${questions.length}',
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    safeString(currentQ['pertanyaan'], 'Soal tidak ditemukan'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  
                  // Options
                  ...List.generate((currentQ['opsi'] as List).length, (index) {
                    final isSelected = userAnswers[currentQuestionIndex] == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            userAnswers[currentQuestionIndex] = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.05) : Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppTheme.primaryColor : Colors.grey[400]!,
                                  ),
                                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                                ),
                                child: isSelected 
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  currentQ['opsi'][index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected ? AppTheme.primaryColor : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        currentQuestionIndex--;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Sebelumnya'),
                  )
                else
                  const SizedBox(),
                  
                ElevatedButton(
                  onPressed: () {
                    if (currentQuestionIndex < questions.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                      });
                    } else {
                      _finishQuiz();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    currentQuestionIndex == questions.length - 1 ? 'Selesai' : 'Selanjutnya',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

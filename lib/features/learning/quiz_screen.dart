import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _selectedOptionIndex = -1;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Apa kepanjangan dari UI?',
      'options': [
        'User Interface',
        'User Interaction',
        'User Integration',
        'User Internet',
      ],
      'answer': 0,
    },
    {
      'question':
          'Warna apakah yang digunakan sebagai warna primer aplikasi ini?',
      'options': ['Biru', 'Hijau', 'Merah', 'Kuning'],
      'answer': 2,
    },
    {
      'question': 'Widget dasar untuk membuat layout di Flutter adalah?',
      'options': ['Div', 'Container', 'Box', 'View'],
      'answer': 1,
    },
  ];

  void _submitAnswer() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = -1;
      });
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.quizResult,
        arguments: {'score': 100},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kuis'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: Text('Data kuis tidak tersedia')),
      );
    }

    // ignore: unused_local_variable
    final materiData = args['materi'] as Map<String, dynamic>?;

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis ${_currentQuestionIndex + 1}/${_questions.length}',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[200],
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 30),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(question['options'].length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedOptionIndex = index;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: _selectedOptionIndex == index
                        ? AppTheme.primaryColor.withValues(alpha: 0.1)
                        : Colors.white,
                    side: BorderSide(
                      color: _selectedOptionIndex == index
                          ? AppTheme.primaryColor
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    question['options'][index],
                    style: TextStyle(
                      color: _selectedOptionIndex == index
                          ? AppTheme.primaryColor
                          : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedOptionIndex != -1 ? _submitAnswer : null,
              child: const Text('SELANJUTNYA'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final int score;
  const QuizResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Hasil Kuis", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              "Selamat!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Kamu telah menyelesaikan kuis.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 40),
            Text("Nilai Kamu", style: TextStyle(fontSize: 18)),
            Text(
              "$score",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("KEMBALI KE MATERI"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../config/routes.dart';
import '../../services/progress_service.dart';

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  bool _scoreRecorded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recordQuizScoreIfNeeded();
  }

  Future<void> _recordQuizScoreIfNeeded() async {
    if (_scoreRecorded) return;

    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> resultData = (args is Map<String, dynamic>)
        ? args
        : {};

    final int score = resultData['score'] ?? 0;
    final String title = resultData['title'] ?? 'Quiz';
    final String? courseId = resultData['courseId'];
    final String? materialId = resultData['materialId'];

    // Generate a quiz ID from title (in a real app, this would come from the quiz data)
    final quizId = title.toLowerCase().replaceAll(' ', '_');

    try {
      await ProgressService().recordQuizScore(quizId, score / 100.0);

      // Mark the quiz material as completed with score in metadata
      if (courseId != null && materialId != null) {
        await ProgressService().markMaterialAsCompleted(
          courseId,
          materialId,
          metadata: {'score': score / 100.0},
        );
      }

      _scoreRecorded = true;
    } catch (e) {
      // Log error but don't show to user
      debugPrint('Error recording quiz score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> resultData = (args is Map<String, dynamic>)
        ? args
        : {};

    final int score = resultData['score'] ?? 0;
    final int correct = resultData['correct'] ?? 0;
    final int total = resultData['total'] ?? 0;
    final List questions = resultData['questions'] ?? [];
    final String title = resultData['title'] ?? 'Quiz';
    final int duration = resultData['duration'] ?? 0;

    final bool isPassed = score >= 70;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'Hasil Kuis',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Score visualization
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isPassed ? Colors.green : AppTheme.primaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: isPassed ? Colors.green : AppTheme.primaryColor,
                      ),
                    ),
                    const Text(
                      'Skor',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            Text(
              isPassed ? 'Luar Biasa!' : 'Tetap Semangat!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPassed
                  ? 'Anda berhasil menyelesaikan kuis dengan baik.'
                  : 'Coba lagi untuk mendapatkan hasil yang lebih baik.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Detail box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResultDetail('Benar', '$correct', Colors.green),
                  _buildResultDetail('Salah', '${total - correct}', Colors.red),
                  _buildResultDetail('Total', '$total', Colors.blue),
                ],
              ),
            ),

            const Spacer(),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.quizReview,
                        arguments: {
                          'questions': questions,
                          'title': title,
                          'duration': duration,
                          'totalQuestion': total,
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Review Quiz'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultDetail(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

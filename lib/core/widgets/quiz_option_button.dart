import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Reusable widget for displaying quiz option buttons
class QuizOptionButton extends StatelessWidget {
  final String optionText;
  final int optionIndex;
  final int correctAnswerIndex;
  final int? selectedAnswerIndex;
  final bool showResult;
  final VoidCallback onTap;

  const QuizOptionButton({
    super.key,
    required this.optionText,
    required this.optionIndex,
    required this.correctAnswerIndex,
    required this.selectedAnswerIndex,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = optionIndex == correctAnswerIndex;
    final bool isSelected = optionIndex == selectedAnswerIndex;
    final bool showCorrectIndicator = showResult && isCorrect;
    final bool showIncorrectIndicator = showResult && isSelected && !isCorrect;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.quizSpacingSmall),
      child: ElevatedButton(
        onPressed: showResult ? null : onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(AppConstants.quizButtonPadding),
          backgroundColor: _getBackgroundColor(isCorrect, isSelected),
          foregroundColor: _getForegroundColor(isCorrect, isSelected),
          side: BorderSide(color: _getBorderColor(isCorrect, isSelected)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: showResult ? 2 : 1,
        ),
        child: Row(
          children: [
            Text(
              '${String.fromCharCode(65 + optionIndex)}. ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(optionText)),
            if (showCorrectIndicator)
              const Icon(Icons.check, color: Colors.white, size: 20)
            else if (showIncorrectIndicator)
              const Icon(Icons.close, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isCorrect, bool isSelected) {
    if (showResult) {
      if (isCorrect) return const Color(0xFF4CAF50); // Green
      if (isSelected && !isCorrect) return const Color(0xFFF44336); // Red
      return Colors.white;
    }
    return isSelected ? const Color(0xFFDC143C) : Colors.white; // Primary red
  }

  Color _getForegroundColor(bool isCorrect, bool isSelected) {
    if (showResult) {
      return (isCorrect || (isSelected && !isCorrect))
          ? Colors.white
          : Colors.black;
    }
    return isSelected ? Colors.white : Colors.black;
  }

  Color _getBorderColor(bool isCorrect, bool isSelected) {
    if (showResult) {
      if (isCorrect) return const Color(0xFF4CAF50); // Green
      if (isSelected && !isCorrect) return const Color(0xFFF44336); // Red
      return Colors.grey;
    }
    return isSelected ? const Color(0xFFDC143C) : Colors.grey; // Primary red
  }
}

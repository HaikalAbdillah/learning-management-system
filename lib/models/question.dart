/// Model class representing a quiz question
class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  const Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  /// Factory constructor to create a Question from Map data
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswerIndex: map['correctAnswer'] ?? 0,
      explanation: map['explanation'],
    );
  }

  /// Check if the given answer index is correct
  bool isCorrect(int answerIndex) => answerIndex == correctAnswerIndex;

  /// Get the correct answer text
  String get correctAnswer => options[correctAnswerIndex];
}

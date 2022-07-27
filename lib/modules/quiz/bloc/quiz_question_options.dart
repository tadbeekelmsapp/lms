import 'package:flutter_application_1/modules/quiz/bloc/quiz.dart';

class QuizQuestionOption {
  const QuizQuestionOption({ 
    required this.title,
    required this.questionId,
    required this.isCorrect
  });

  final String title;
  final int questionId;
  final bool isCorrect;
}
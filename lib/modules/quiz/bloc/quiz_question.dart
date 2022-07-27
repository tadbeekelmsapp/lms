import 'package:flutter_application_1/modules/quiz/bloc/quiz_question_options.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.options,
    required this.title,
    required this.quizId
  });

  final List<QuizQuestionOption> options;
  final String title;
  final int quizId;
}
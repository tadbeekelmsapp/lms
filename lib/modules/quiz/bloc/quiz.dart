import 'package:flutter_application_1/modules/quiz/bloc/quiz_question.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz_question_options.dart';

class Quiz {
  const Quiz({
    required this.id,
    required this.questions,
    required this.time,
    required this.title
  });

  final int id;
  final List<QuizQuestion> questions;
  final int time;
  final String title;

  factory Quiz.fromJson(Map _json) {
    int _id = _json['id'] is int ? _json['id'] : int.parse(_json['id']);
    return Quiz(
      id: _id,
      time: _json['time'] is int ? _json['time'] : int.parse(_json['time']),
      title: _json['title'],
      questions: (_json['quiz_questions'] as List).map((element) {
          return QuizQuestion(
            quizId: _id,
            title: element['title'],
            options: (element['quizzes_questions_answers'] as List).map((option) {
              return QuizQuestionOption(
                title: option['title'], 
                questionId: element['id'], 
                isCorrect: option['correct'] == 1
              );
            }).toList(), 
          );
        }).toList(), 
    );
  }
}
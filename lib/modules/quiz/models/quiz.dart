import 'dart:convert';

import 'package:flutter_application_1/modules/quiz/bloc/quiz.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz_question.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz_question_options.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:http/http.dart' as http; 

class QuizModel {
  static getQuizById() async {
    Uri uri = Uri.http(
      'www.tadbeeke.com',
      '/app/quizes'
    );

    var response = await http.get(uri);
    var _body = response.body;
    var _data = jsonDecode(_body);
    return _data;
  }
  static Future<Quiz?> getQuizzes() async {
    Uri uri = Uri.http(
      'www.tadbeeke.com',
      '/app/quizes'
    );

    var response = await http.get(uri);
    var _body = response.body;
    var _data = jsonDecode(_body);
    if(_data is Map && _data.containsKey('quizes')) {
      Map firstQuiz = _data['quizes'][0];
      return Quiz(
        id: firstQuiz['id'],
        time: firstQuiz['time'],
        title: firstQuiz['title'],
        questions: (firstQuiz['quiz_questions'] as List).map((element) {
          return QuizQuestion(
            quizId: firstQuiz['id'],
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
    return _data;
  }

  static Future getByCourseId(int courseId) async {
    Uri uri = Uri.http(
      'www.tadbeeke.com',
      '/app/quizes'
    );
    http.Response response = await http.get(uri);
    String body = response.body;

    if(body.isEmpty) {
      return null;
    }

    Map _res = jsonDecode(body);

    if(!_res.containsKey('quizes') || !(_res['quizes'] is List) || (_res['quizes'] as List).isEmpty ) {
      return null;
    }

    return _res['quizes'];
  }

  static Future<Quiz?> getOneByCourseId(int courseId) async {
    try {
      List? _quizes = await QuizModel.getByCourseId(courseId);
      if(_quizes == null) {
        return null;
      }
      Map _quiz = _quizes.firstWhere((element) => element['webinar_id'] == courseId);
      var quiz = Quiz.fromJson(_quiz);
      return quiz;
    } catch(e) {
      return null;
    }
  }

  static Future<List<Quiz>?> getAllByCourseId(int courseId) async {
    try {
      List? _quizes = await QuizModel.getByCourseId(courseId);
      if(_quizes == null) {
        return null;
      }
      List<Quiz> _list = _quizes.map((_quiz) {
        Quiz _q = Quiz.fromJson(_quiz);
        return _q;
      }).toList();
      return _list;
    } catch(e) {
      return null;
    }
  }
}
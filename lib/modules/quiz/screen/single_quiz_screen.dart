import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/font_family.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_item_bloc.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz_question.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz_question_options.dart';
import 'package:flutter_application_1/modules/quiz/models/quiz.dart';
import 'package:flutter_application_1/modules/quiz/screen/single_question.dart';

class SingleQuizScreen extends StatefulWidget {
  const SingleQuizScreen({ Key? key, required this.item }) : super(key: key);

  final CourseContentItemBloc item;

  @override
  _SingleQuizScreenState createState() => _SingleQuizScreenState();
}

class _SingleQuizScreenState extends State<SingleQuizScreen> {

  late Quiz _quiz;

  late QuizQuestion currentQuestion;
  
  /// Is quiz loading?
  bool isLoading = false;

  /// Index of the current question shown
  int currentQuestionIndex = 0;
  
  /// List of all the answers of the quiz. Single element will 
  /// contain 'questionIndex', 'answerIndex' (i.e. correct option's index) 
  /// and 'answer' 
  List<Map<String, dynamic>> answers = [];

  bool isQuizFinished = false;
  
  /// Is current question being attempted by the user 
  bool? isAttempted;

  /// Time in seconds to attempt the quiz
  int time = 60;
  
  /// User's score. One correct question has 1 point
  int score = 0;

  Timer? _timer;

  bool _error = false;

  @override 
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      _quiz = widget.item.quiz!;
    });

    if(_quiz != null) {
        for(QuizQuestion question in _quiz.questions) {
          for(QuizQuestionOption option in question.options) {
            if(option.isCorrect) {
              answers.add({
                'questionIndex': _quiz.questions.indexOf(question),
                'answerIndex': question.options.indexOf(option),
                'answer': option.title,
              });
              break;
            }
          }
        }
        
        setState(() {
          isLoading = false;
          // _quiz = quiz;
          time = _quiz.time * 60;
          currentQuestion = _quiz.questions[currentQuestionIndex];
        });
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) { 
          if(time == 0 || isQuizFinished) {
            timer.cancel();
            setState(() => isQuizFinished = true);
          }
          setState(() => time--);
        });
      } else {
        setState(() => _error = true);
      }

    QuizModel.getQuizzes().then((quiz) {
      
    }).catchError((e) {
      setState(() => _error = true);
    });
  }

  @override 
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  Widget _warning({ required String text }) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.red[200],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(text, textAlign:TextAlign.center,)
    );
  }

  String _beautifyTime() {
    int minutes = 0;
    int seconds = 0;

    if(time <= 60) {
      minutes = 0;
      seconds = time;
    } else {
      minutes = (time / 60).floor();
      seconds = (time % 60).floor();
    }
  
    String _min = minutes.toString().length == 1 ? '0' + minutes.toString() : minutes.toString();
    String _sec = seconds.toString().length == 1 ? '0' + seconds.toString() : seconds.toString();

    return _min + ':' + _sec;
  }

  @override
  Widget build(BuildContext context) {

    if(_error) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Error loading quiz. Please try again')
        )
      );
    }
    
    return WillPopScope(
      onWillPop: () async {
        _timer!.cancel();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: isLoading ? 
          const Center(child: CircularProgressIndicator()) :
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: !isQuizFinished ? Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    const Text('Time: ', style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    )),
                    Text(_beautifyTime(), style: const TextStyle(color: Colors.black)),
                  ],),
                ),
                SingleQuestion(
                  question: currentQuestion,
                  questionIndex: currentQuestionIndex,
                  onSelection: (value, questionIndex) {
                    setState(() => isAttempted = value != null,);
                    if(questionIndex != null) {
                      Map answer = answers.firstWhere((element) => element['questionIndex'] == questionIndex);
                      if(answer['answer'] == value) {
                        setState(() => score++);
                      }
                    }
                  },
                ),
                isAttempted == false ? _warning(text: 'Please choose an option.') : const SizedBox.shrink(),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 5),
                  child: ElevatedButton(
                    onPressed: () {
                      if(isAttempted == null) {
                        setState(() {
                          isAttempted = false;
                        });
                      }
                      if(isAttempted == true) {
                        setState(() {
                          currentQuestionIndex++;
                          if(_quiz.questions.asMap().containsKey(currentQuestionIndex)) {
                            currentQuestion = _quiz.questions[currentQuestionIndex];
                          } else {
                            isQuizFinished = true;
                          }
                          isAttempted = null;
                        });
                      }
                    },
                    
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: const Text('SUBMIT', textAlign: TextAlign.center, style: TextStyle(
                        fontFamily: FontFamily.secondary,
                        letterSpacing: 2,
                      )),
                    )
                  ),
                )
              ]
            ) :
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 45,),
                  Text('Your score:'.toUpperCase(), style: Theme.of(context).textTheme.headline4),
                  Text((score/currentQuestionIndex * 100).floor().toString() + "%", style: TextStyle(fontSize: 16)),
                  Text("Your ${score.toString()} out of ${currentQuestionIndex.toString()} questions are correct"),
                ],
              )
            )
          )
      ),
    );
  }
}
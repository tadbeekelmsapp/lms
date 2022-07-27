import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz_question.dart';

typedef QuestionSelectionCallback = void Function(String? value, int? questionIndex);

class SingleQuestion extends StatefulWidget {
  const SingleQuestion({ 
    Key? key, 
    required this.question,
    required this.questionIndex,
    this.onSelection
  }) : super(key: key);

  final QuizQuestion question;
  final QuestionSelectionCallback? onSelection;
  final int questionIndex;

  @override
  _SingleQuestionState createState() => _SingleQuestionState();
}

class _SingleQuestionState extends State<SingleQuestion> {
  String? currentValue; 
  @override
  Widget build(BuildContext context) {
    QuizQuestion question = widget.question;
    return Container(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text((widget.questionIndex + 1).toString() + '. ' + question.title, style: const TextStyle(fontSize: 16),)
          ),
          ...question.options.map((option) {
            bool _isOptionSelected = currentValue == option.title;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff8E7AE1)),
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: _isOptionSelected ? Color(0xff8E7AE1) : null
                // gradient: _isOptionSelected ? const LinearGradient(
                //   colors: [
                //     Color(0xffffff1c),
                //     Color(0xffD66D75), 
                //     Color(0xff00c3ff)
                //   ],
                //   begin: Alignment.centerLeft,
                //   end: Alignment.centerRight,
                // ) : null,
              ),
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: RadioListTile(
                activeColor: Colors.black,
                title: Text(option.title),
                value: option.title, 
                groupValue: currentValue, 
                onChanged: (String? value) {
                  widget.onSelection!(value, widget.questionIndex);
                  setState(() {
                    currentValue = value;
                  });
                }
              ),
            );
          }).toList(),
        ],
      )
    );
  }
}
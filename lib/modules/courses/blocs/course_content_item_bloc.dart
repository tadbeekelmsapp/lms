import 'dart:convert';

import 'package:flutter_application_1/modules/quiz/bloc/quiz.dart';

class CourseContentItemBloc {
  const CourseContentItemBloc({
    required this.id,
    required this.courseId,
    required this.order,
    required this.sectionId,
    required this.title,
    required this.type,
    required this.url,
    this.meta,
    this.isPaid = true,
    this.quiz
  });

  final int id;
  final int courseId;
  final int order;
  final int sectionId;
  final String title;
  final String type;
  final String url;
  final Map? meta;
  final bool isPaid;
  final Quiz? quiz;
  

  factory CourseContentItemBloc.fromJson(Map _data, [bool isPaid = true, Quiz? quiz]) {
    bool _isPaid = true;
    if(_data.containsKey('is_paid') && _data['is_paid'] == true) {
      _isPaid = true;
    } else if (_data['type'] == 'quiz') {
      _isPaid = false;
    } else {
      _isPaid = isPaid;
    }
    return CourseContentItemBloc(
      id: _data["id"] is int ? _data['id'] : int.parse(_data['id']), 
      courseId: _data["webinar_id"] is int ? _data['webinar_id'] : int.parse(_data['webinar_id']), 
      order: _data["order"] is int ? _data['order'] : int.parse(_data['order']), 
      sectionId: _data["content_section_id"] is int ? _data['content_section_id'] : int.parse(_data['content_section_id']), 
      title: _data["title"], 
      type: _data["type"].toString().toLowerCase(), 
      url: _data["url"] != null ? _data["url"] : null,
      meta: _data['meta'] != null ? jsonDecode(_data['meta']) : null,
      isPaid: isPaid,
      quiz: _data.containsKey('quiz') ? _data['quiz'] : quiz
    );
  }
}
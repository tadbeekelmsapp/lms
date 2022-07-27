import 'dart:convert';

import 'package:flutter_application_1/modules/courses/blocs/course_content_item_bloc.dart';

class CourseContentSectionBloc {
  CourseContentSectionBloc({
    required this.id,
    required this.courseId,
    required this.order,
    required this.title,
    this.meta,
    this.children,
  });

  final int id;
  final int courseId;
  final int order;
  final String title;
  final String? meta;
  List<CourseContentItemBloc>? children;

  factory CourseContentSectionBloc.fromJson(Map _data) {
    return CourseContentSectionBloc(
      id: _data["id"] is int ? _data['id'] : int.parse(_data['id']), 
      courseId: _data["webinar_id"] is int ? _data['webinar_id'] : int.parse(_data['webinar_id']), 
      order: _data["order"] is int ? _data['order'] : int.parse(_data['order']), 
      title: _data["title"],
      meta: _data['meta'] != null ? jsonDecode(_data['meta']) : null,
    );
  }
}
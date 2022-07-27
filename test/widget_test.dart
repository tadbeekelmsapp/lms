// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_section_bloc.dart';
import 'package:flutter_application_1/modules/courses/models/course_category_model.dart';
import 'package:flutter_application_1/modules/courses/models/courses.dart';
import 'package:flutter_application_1/modules/profiles/models/profiles_model.dart';
import 'package:flutter_application_1/modules/quiz/models/quiz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  test('tests quiz api', () async {
    print(await QuizModel.getQuizzes());
  });

  test('test quiz by id', () async {
    print(await QuizModel.getQuizById());
  });

  test('test all courses', () async {
    print(await CourseModel.getAll());
  });

  test('getSubCategories', () async {
    print(await CourseCategoryModel.getSubCategories(1));
  });

  // test('getCoursesByCategoryId', () async {
  //   print(await CourseModel.getCoursesByCategoryId(1));
  // });

  test('getMainCategories', () async {
    print(await CourseCategoryModel.getSubCategories(528));
  });

  test('getCoursesByCategoryId', () async {
    print(await CourseModel.getCoursesByCategoryId(522));
  });

  test('getCourseContentByCourseId', () async {
    Map? _content = await CourseModel.getCourseContentByCourseId(5);
    print(_content);
  });

  test("getAllByCourseId", () async {
    print(await QuizModel.getAllByCourseId(19));
  });

}

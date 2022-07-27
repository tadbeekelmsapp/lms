import 'package:flutter_application_1/modules/courses/blocs/course.dart';

class CourseCategory {
  const CourseCategory({
    required this.id,
    required this.title,
    required this.hasSubCategories,
    this.subCategories
  });

  final int id;
  final String title;
  final bool hasSubCategories;
  final List<CourseCategory>? subCategories;

  factory CourseCategory.fromJson(Map _json) {
    int _id = _json['id'];
    String _title = _json['title'];
    bool _hasSubCat = _json['parent_id'] != null;
    return CourseCategory(id: _id, title: _title, hasSubCategories: _hasSubCat);
  }
}
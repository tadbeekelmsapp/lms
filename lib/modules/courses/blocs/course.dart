import 'package:flutter_application_1/modules/courses/blocs/course_category.dart';

class Course {
  Course({
    required this.id,
    required this.title,
    this.category,
    this.isPaid = false,
    this.hasUserPurchasedCourse = false,
    this.price,
    this.duration
  });

  final int id;
  final String title;
  final CourseCategory? category;
  final bool isPaid;
  bool hasUserPurchasedCourse;
  final String? price;
  final String? duration;

  factory Course.fromJson(Map _json) {
    int _id = _json['id'];
    String _title = _json['title'];
    bool _isPaid = _json.containsKey('price') && _json['price'] != null;

    CourseCategory? _category;
    if(_json.containsKey('category')) {
      _category = CourseCategory.fromJson(_json['category']);
    }

    String? _duration;
    if(_json.containsKey('duration')) {
      int _d = _json['duration'];
      if(_d <= 60) {
        _duration = _d.toString() + " min";
      } else if (_d > 60) {
        int _hours = (_d / 60).floor();
        int _minutes = (_d % 60).ceil();
        _duration = "$_hours h $_minutes m";
      }
    }

    return Course(
      id: _id, 
      title: _title,
      isPaid: _isPaid,
      category: _category,
      price: _json.containsKey('price') ? _json['price'] : null,
      duration: _duration
    );
  }
}
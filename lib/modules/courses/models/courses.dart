import 'dart:convert';

import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/courses/blocs/course.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_category.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_item_bloc.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_section_bloc.dart';
import 'package:flutter_application_1/modules/courses/models/fake_data.dart';
import 'package:flutter_application_1/modules/quiz/bloc/quiz.dart';
import 'package:flutter_application_1/modules/quiz/models/quiz.dart';
import 'package:http/http.dart' as http; 

class CourseModel {
  static Future<List<Course>?> getAll() async {
    Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/all-courses'
    );

    var _response = await http.get(_uri);
    var _body = _response.body;
    if(_body != null) {
      var _res = jsonDecode(_body);
      if(_res is Map && _res.containsKey('courses') && _res['courses'] is List && _res['courses'].isNotEmpty) {
        List<Course> _courses =_res['courses'].map<Course>((item) {
          return Course(
            id: item['id'], 
            title: item['title'], 
            category: CourseCategory(id: item['category']['id'], title: item['category']['title'], hasSubCategories: false)
          );
        }).toList();

        return _courses;
      }
    }

    return null;
  }

  static Future<List<Course>?> getCoursesByCategoryId(int categoryId) async {
    Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/get-course-by/' + categoryId.toString()
    );

    print(_uri);

    http.Response _response = await http.get(_uri);
    String _body = _response.body;
    print(_body);
    if(_body.isNotEmpty) {
      Map? _courses = jsonDecode(_body);
      if(_courses == null) return null;
      List<Course> _courses1 = _courses['courses'].map<Course>((e) => Course.fromJson(e)).toList();
      List<Course> _courses2 = [];
      await Future.forEach(_courses1, (Course element) async {
        if(element.isPaid) {
          element.hasUserPurchasedCourse = await CourseModel.hasUserPurchasedCourse(element.id);
        }
        _courses2.add(element);
      });
      return _courses2;
    }

    return null;


    // List _data = FakeData.baseCategories;
    // List _courses = [];
    // for(Map category in _data) {
    //   if(category['id'] == categoryId && category.containsKey('courses')) {
    //     _courses = category['courses'];
    //     break;
    //   }

    //   if(category.containsKey('subCategories') && category['subCategories'] is List) {
    //     for(Map subCategory in category['subCategories']) {
    //       if(subCategory.containsKey('courses') && subCategory['courses'] is List) {
    //         _courses = subCategory['courses'];
    //         break;
    //       }
    //     }
    //   }
    // }

    // return _courses;
  }

  static Future<Map?> getCourseContentByCourseId(int courseId) async {
    Uri _uri = Uri.http(
      '157.241.12.13',
      '/app/get-course-content',
      {
        "course_id": courseId.toString()
      }
    );

    print(_uri);

    http.Response _response = await http.get(_uri);
    String _body = _response.body;

    if(_body.isEmpty) {
      return null;
    }

    bool hasPurchased = await CourseModel.hasUserPurchasedCourse(courseId);
    // Quiz? quiz = await QuizModel.getOneByCourseId(courseId);
    List<Quiz>? _quizzes = await QuizModel.getAllByCourseId(19);

    Map? _course = jsonDecode(_body);

    if(_course is Map && _course.containsKey('section') && _course['section'] is List) {
      int _sectionNo = 0;
      List<CourseContentSectionBloc> _sections = _course['section'].map<CourseContentSectionBloc>((section) {
        _sectionNo++;
        CourseContentSectionBloc _sectionBloc = CourseContentSectionBloc.fromJson(section);
        int _itemNo = 0;
        _sectionBloc.children = section['item'].map<CourseContentItemBloc>((item) {
          _itemNo++;
          return CourseContentItemBloc.fromJson(item, (hasPurchased ? false : _itemNo == 1 ? false : true));
        }).toList();
        return _sectionBloc;
      }).toList();

      // if(quiz != null) {
      //   _sections.add(
      //     CourseContentSectionBloc(
      //       id: 99, 
      //       courseId: courseId, 
      //       order: 99, 
      //       title: "Quiz",
      //       children: [CourseContentItemBloc(id: 1, courseId: courseId, order: 1, sectionId: 99, title: "New Quiz", type: "quiz", url: "url", isPaid: false, quiz: quiz)]
      //     )
      //   );
      // }

      if(_quizzes != null) {
        _sections.add(
          CourseContentSectionBloc(
            courseId: courseId,
            id: 99,
            order: 99,
            title: "Quiz",
            children: _quizzes.map((q) {
              return CourseContentItemBloc(
                id: q.id, 
                courseId: courseId, 
                order: _quizzes.indexOf(q) + 1, 
                sectionId: 99, 
                title: q.title, 
                type: "quiz", 
                url: "some url",
                isPaid: false,
                quiz: q
              );
            }).toList()
          )
        );
      }
      
      _course['sections'] = _sections;

      return _course;
    }

    return null;
  }

  static Future<List<Course>?> getFeaturedCourses() async {
    List _courses = [
      {
        "id": 1,
        "title": "Test 1"
      },
      {
        "id": 2,
        "title": "Test 2"
      },
      {
        "id": 3,
        "title": "Test 3"
      },
    ];
    
    Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/get-feature-courses'
    );

    http.Response _response = await http.get(_uri);
    String _body = _response.body;

    if(_body.isEmpty) {
      return null;
    }

    Map? _data = jsonDecode(_body);

    if(_data == null || !_data.containsKey('feature_course') || (_data['feature_course'] as List).isEmpty) {
      return null;
    }

    List<Course> _res = _data['feature_course'].map<Course>((course) {
      return Course.fromJson(course);
    }).toList();

    return _res;
  }

  static Future<List?> getPurchasedCourses() async {
    int? _userId = await Auth.getUserId();
    if(_userId == null) {
      return null;
    }
    
    Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/purchase-courses/' + _userId.toString()
    );
    http.Response _response = await http.get(_uri);
    String _body = _response.body;

    if(_body.isEmpty) {
      return null;
    }

    Map? _data = jsonDecode(_body);

    if(_data == null || !_data.containsKey('purchased_courses')) {
      return null;
    }

    List _courses = _data['purchased_courses'];

    return _courses;

  }

  static Future<bool> hasUserPurchasedCourse(int courseId) async {
    try {
      List? _courses = await CourseModel.getPurchasedCourses();
      
      if(_courses == null) {
        return false;
      }

      Map? _course = _courses.firstWhere((element) => element['id'] == courseId);

      if(_course != null) {
        return true;
      }
      
      return false;
    } catch(e) {
      return false;
    }
  }

}
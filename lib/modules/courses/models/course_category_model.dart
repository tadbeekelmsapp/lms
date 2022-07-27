import 'dart:convert';

import 'package:flutter_application_1/modules/courses/blocs/course_category.dart';
import 'package:http/http.dart' as http;

class CourseCategoryModel {
  static final List<Map> baseCategories = [
      {
        "id": 1,
        "title": "Middle School",
        "image": "assets/images/rocket1.png",
        "hasSubCategories": true,
        "subCategories": [
          {
            "id": 5,
            "title": "Grade 6",
            "image": "assets/images/rocket1.png",
            "courses": [
              {
                "id": 1,
                "title": "Arabic",
                "image": "assets/images/rocket1.png"
              },
              {
                "id": 2,
                "title": "English",
                "image": "assets/images/rocket1.png"
              },
              {
                "id": 3,
                "title": "Math",
                "image": "assets/images/rocket1.png"
              }
            ]
          },
          {
            "id": 6,
            "title": "Grade 7",
            "image": "assets/images/rocket1.png",
          },
          {
            "id": 7,
            "title": "Grade 8",
            "image": "assets/images/rocket1.png",
          },
          {
            "id": 8,
            "title": "Grade 9",
            "image": "assets/images/rocket1.png",
          }
        ]
      },
      {
        "id": 2,
        "title": "High School",
        "image": "assets/images/rocket1.png",
        "hasSubCategories": true
      },
      {
        "id": 3,
        "title": "Aptitude Tests",
        "image": "assets/images/rocket1.png"
      },
      {
        "id": 4,
        "title": "University",
        "image": "assets/images/rocket1.png"
      },
    ];
  static Future<List<CourseCategory>?> getBaseCategories() async {
    List? _categories = CourseCategoryModel.baseCategories;
    if(_categories == null) return null;
    List<CourseCategory> _res = _categories.map((item) {
      return CourseCategory(
        id: item['id'], 
        title: item['title'], 
        hasSubCategories: item.containsKey('hasSubCategories'), 
        subCategories: item.containsKey('subCategories') ? 
          item['subCategories'].map<CourseCategory>((e) {
            return CourseCategory(id: e['id'], title: e['title'], hasSubCategories: false);
          }).toList() : 
          null
      );
    }).toList();
    return _res;
  }

  static Future<List<CourseCategory>?> getMainCategories() async {
    Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/categories/main'
    );

    http.Response _response = await http.get(_uri);
    String _body = _response.body;
    if(_body.isNotEmpty) {
      List? _categories = jsonDecode(_body);
      if(_categories == null) return null;
      return _categories.map<CourseCategory>((e) => CourseCategory.fromJson(e)).toList();
    }
    return null;
  }

  static Future<CourseCategory?> getBaseCategoryById(int categoryId) async {
    List<CourseCategory>? _baseCategories = await getBaseCategories();
    if(_baseCategories == null) return null;
    return _baseCategories.firstWhere((CourseCategory element) => element.id == categoryId);
  }

  static Future<List<CourseCategory>?> getSubCategories(int parentCategoryId) async {
    Uri _uri = Uri.http(
      'www.tadbeeke.com',
      '/app/categories/sub/' + parentCategoryId.toString()
    );

    http.Response _response = await http.get(_uri);
    String _body = _response.body;
    if(_body.isNotEmpty) {
      List? _categories = jsonDecode(_body);
      if(_categories == null) return null;
      return _categories.map<CourseCategory>((e) => CourseCategory.fromJson(e)).toList();
    }
    return null;


  }
}
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_paths.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/localization_helper.dart';
import 'package:flutter_application_1/modules/courses/blocs/course.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_category.dart';
import 'package:flutter_application_1/modules/courses/main_courses_screen.dart';
import 'package:flutter_application_1/modules/courses/models/course_category_model.dart';
import 'package:flutter_application_1/modules/courses/models/courses.dart';
import 'package:flutter_application_1/modules/courses/sub_category_screen.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_application_1/widgets/text.dart';

class MainCategoryScreen extends StatefulWidget {
  const MainCategoryScreen({ Key? key }) : super(key: key);
  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  Future? _categories;
  int? _parentCategoryId;

  /// This is the 'id' of that category, whose courses will be shown on main courses screen
  int? _categoryIdWithCourses;
  @override 
  void initState() {
    super.initState();
    print('api call');
    _categories = CourseCategoryModel.getMainCategories();
  }

  @override
  Widget build(BuildContext context) {
    if(_categoryIdWithCourses != null) {
      return WillPopScope(
        onWillPop: () async {
          setState(() {
            _categoryIdWithCourses = null;
          });
          return false;
        },
        child: MainCoursesScreen(categoryId: _categoryIdWithCourses!)
      );
    }

    if(_parentCategoryId != null) {
      return WillPopScope(
        onWillPop: () async {
          setState(() {
            _parentCategoryId = null;
          });
          return false;
        },
        child: SubCategoryScreen(parentCategoryId: _parentCategoryId!, onClick: (id) {
          setState(() {
            _categoryIdWithCourses = id; 
          });
        })
      );
    }
    
    return FutureBuilder(
      future: _categories,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasData) {
            List _items = snapshot.data as List<CourseCategory>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heading3(context, 'LET\'S FIND YOUR COURSES'),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: _items.map((e) {
                    print('hello world');
                    print(e.title.toString().toLowerCase());
                    return Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xff171d2a),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 0,
                              child: Text(
                                getTransalatedValue(context, e.title),
                                style: const TextStyle(fontSize: 12)
                              )
                            ),
                            Image.asset(AppPaths.categoryCardIllustration, width: 100)
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            _parentCategoryId = e.id;
                          });
                        },
                      )
                    );
                  }).toList(),
                )
              ]
            );
          }
        }
        
        return const Center(child: Text('No courses found!'));
      },
    );
  }
}
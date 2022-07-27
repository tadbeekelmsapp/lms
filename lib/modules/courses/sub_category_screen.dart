import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_paths.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_category.dart';
import 'package:flutter_application_1/modules/courses/main_courses_screen.dart';
import 'package:flutter_application_1/modules/courses/models/course_category_model.dart';
import 'package:flutter_application_1/modules/courses/single_course_screen.dart';
import 'package:flutter_application_1/utils/helpers.dart';

typedef OnClickCallback = void Function(int categoryId);

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({ Key? key, required this.parentCategoryId, this.onClick }) : super(key: key);
  final int parentCategoryId;
  final OnClickCallback? onClick;
  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late Future<List<CourseCategory>?> _subCategories;

  @override
  void initState() {
    super.initState();
    _subCategories = CourseCategoryModel.getSubCategories(widget.parentCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _subCategories,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if(snapshot.connectionState == ConnectionState.none) {
          return const Center(child: Text('No results'));
        }
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasData) {
            List _items = snapshot.data as List<CourseCategory>;
            if(_items.isEmpty) {
              return const Center(child: Text('No results'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: _items.map((e) {
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
                              child: Text(getTransalatedValue(context, e.title), style: const TextStyle(fontSize: 12))
                            ),
                            Image.asset(AppPaths.categoryCardIllustration, width: 100)
                          ],
                        ),
                        onTap: () {
                          if(widget.onClick != null) {
                            widget.onClick!(e.id);
                          }
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => MainCoursesScreen(categoryId: e.id)));
                        },
                      )
                    );
                  }).toList(),
                )
              ]
            );
          }

          return const Center(child: Text('No results'));
        }
        
        return const Center(child: Text('No courses found!'));
      },
    );
  }
}
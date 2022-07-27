import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_paths.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/localization_helper.dart';
import 'package:flutter_application_1/modules/courses/models/courses.dart';
import 'package:flutter_application_1/modules/courses/single_course_screen.dart';
import 'package:flutter_application_1/modules/webview/webview.dart';

class MainCoursesScreen extends StatefulWidget {
  const MainCoursesScreen({ Key? key, required this.categoryId }) : super(key: key);
  
  final int categoryId;

  @override
  State<MainCoursesScreen> createState() => _MainCoursesScreenState();
}

class _MainCoursesScreenState extends State<MainCoursesScreen> {

  late Future? _courses;

  @override 
  void initState() {
    super.initState();
    _courses = CourseModel.getCoursesByCategoryId(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _courses,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if(snapshot.connectionState == ConnectionState.none) {
          return const Center(child: Text('Something went wrong'));
        }

        if(snapshot.connectionState == ConnectionState.done) {
          List? courses = snapshot.data as List?;

          if(courses == null || courses.isEmpty) {
            return const Center(child: Text('No results'));
          }

          return Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                children: courses.map((e) {
                  bool _showBuyCourseBtn = false;
                  
                  if(e.isPaid) {
                    _showBuyCourseBtn = true;
                    if(e.hasUserPurchasedCourse) {
                      _showBuyCourseBtn = false;
                    }
                  }
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
                              AppLocalization.of(context).getTranslatedValue(e.title.toString().toLowerCase()) ?? e.title, 
                              style: const TextStyle(fontSize: 12)
                            )
                          ),
                          Image.asset(AppPaths.courseCardIllustration, width: 100),
                          _showBuyCourseBtn ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                                ),
                                child: const Icon(Icons.add, color: Colors.white)
                              ),
                              onTap: () async {
                                print('getting paid');
                                if(await Auth.isLoggedIn()) {
                                  int? _userId = await Auth.getUserId();
                                  showDialog(context: context, builder: (context) {
                                    return AlertDialog(
                                      title: const  Text('Do you want to purchase this course?'),
                                      actions: [
                                        ElevatedButton(onPressed: () {
                                          Navigator.of(context).pop();
                                        }, child: const Text('No')),
                                        ElevatedButton(onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                            return WebView(
                                              uri: Uri.http(
                                                '157.241.12.13',
                                                '/app/process-payment',
                                                {
                                                  'user_id': _userId.toString(),
                                                  'course_id': e.id.toString()
                                                }
                                              ),
                                              appBar: AppBar(
                                                title: Text('Purchase course: ' + e.title),
                                              ),
                                            );
                                          }));
                                        }, child: const Text('Yes, Proceed')),
                                      ],
                                    );
                                  });
                                }
                              },
                            )
                          ) : const SizedBox.shrink()
                        ],
                      ),
                      onTap: () {
                        print('********');
                        print(e.duration);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SingleCourseScreen(
                          category: '', 
                          subCategory: '', 
                          courseTitle: e.title,
                          courseId: e.id,
                          price: e.price,
                          duration: e.duration
                        )));
                      },
                    )
                  );
                }).toList(),
              )
            ]
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
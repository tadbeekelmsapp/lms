import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_paths.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_section_bloc.dart';
import 'package:flutter_application_1/modules/courses/components/single_section.dart';
import 'package:flutter_application_1/modules/courses/models/courses.dart';
import 'package:flutter_application_1/modules/webview/webview.dart';
import 'package:flutter_application_1/utils/helpers.dart';

class SingleCourseScreen extends StatefulWidget {
  const SingleCourseScreen({ 
    Key? key,
    this.category,
    this.subCategory,
    required this.courseTitle,
    required this.courseId,
    this.price,
    this.duration
  }) : super(key: key);

  final String? category;
  final String? subCategory;
  final String? courseTitle;
  final int courseId;
  final String? price;
  final String? duration;

  @override
  State<SingleCourseScreen> createState() => _SingleCourseScreenState();
}

class _SingleCourseScreenState extends State<SingleCourseScreen> {

  bool _isContentLoaded = false;
  bool _errorLoadingContent = false;
  List<CourseContentSectionBloc> _sections = [];


  @override
  void initState() {
    super.initState();
    CourseModel.getCourseContentByCourseId(widget.courseId).then((Map? course) {
      if(course != null) {
        setState(() {
          _isContentLoaded = true;
          _sections = course['sections'];
        });
      } else {
        setState(() {
          _errorLoadingContent = true;
        });
      }
    });
  }

  List<Widget> _sectionItems() {
    return [..._sections.map<SingleSection>((CourseContentSectionBloc section) {
      return SingleSection(section: section);
    }).toList()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary
                      ),
                      child: Image.asset(AppPaths.baseIllustration)
                    ),
                  ),
                  widget.category == null || widget.category!.isEmpty ? 
                    Positioned(
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(59))
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 30),
                        child: const SizedBox.shrink()
                      )
                    ) : 
                    Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(59))
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.category!,
                            style: TextStyle(letterSpacing: 2, color: Colors.grey[700])
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
            Container(
              // padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  widget.courseTitle == null ? const SizedBox.shrink() : Text(
                    widget.courseTitle.toString().toUpperCase(),
                    style: const TextStyle(
                      fontFamily: "Nasalization",
                      fontSize: 24,
                      letterSpacing: 2
                    )
                  ),
                  widget.subCategory == null || widget.subCategory!.isEmpty ? const SizedBox.shrink() : Text(
                    widget.subCategory.toString().toUpperCase(),
                    style: const TextStyle(
                      fontFamily: "Nasalization",
                      fontSize: 24,
                      letterSpacing: 2
                    )
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        if(widget.price != null) 
                          const Text(
                            "Price: ",
                            style: TextStyle(
                              // fontFamily: "Nasalization",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8E7AE1)
                              // letterSpacing: 2
                            )
                          ),
                        if(widget.price != null)
                          Text(
                            "KWD " + widget.price.toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                            )
                          ),
                        if(widget.price != null && widget.duration != null)
                          const Spacer(),
                        if(widget.duration != null) 
                          const Text(
                            "Duration: ",
                            style: TextStyle(
                              // fontFamily: "Nasalization",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff8E7AE1)
                              // letterSpacing: 2
                            )
                          ),
                        if(widget.duration != null)
                          Text(
                            widget.duration!,
                            style: const TextStyle(
                              // fontFamily: "Nasalization",
                              fontSize: 16,
                              // letterSpacing: 2
                            )
                          ),
                      ],
                    ),
                  ),
                   ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () async {
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
                                        'course_id': widget.courseId.toString()
                                      }
                                    ),
                                    appBar: AppBar(
                                      title: Text('Purchase course: ' + (widget.courseTitle != null ? widget.courseTitle! : '')),
                                    ),
                                  );
                                }));
                              }, child: const Text('Yes, Proceed')),
                            ],
                          );
                        });
                      }
                    },
                    child: const Text('SUBSCRIBE')
                  )
                ],
              )
            ),
            if(_isContentLoaded) ..._sectionItems() 
            else if(_errorLoadingContent) SizedBox(
              height: 200,
              child: Center(child: Text(tx(context, 'No results')))
            ) 
            else const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator(),)
            )
          ],
        )
      )
    );
  }
}
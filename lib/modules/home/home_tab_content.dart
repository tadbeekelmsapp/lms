import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/constants/app_paths.dart';
import 'package:flutter_application_1/constants/spaces.dart';
import 'package:flutter_application_1/core/settings.dart';
import 'package:flutter_application_1/localization_helper.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/modules/courses/blocs/course.dart';
import 'package:flutter_application_1/modules/courses/models/courses.dart';
import 'package:flutter_application_1/modules/home/home.dart';
import 'package:flutter_application_1/modules/home/single_recommended_card.dart';
import 'package:flutter_application_1/utils/helpers.dart';
import 'package:flutter_application_1/widgets/text.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeTabContent extends StatefulWidget {
  const HomeTabContent({ Key? key }) : super(key: key);

  @override
  State<HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<HomeTabContent> {

  late String _choosenLanguage = 'en';

  bool _isRecommendedCoursesLoaded = false;
  List<Course> _recommendedCourses = [];

  @override 
  void initState() {
    super.initState();
    CourseModel.getFeaturedCourses().then((List<Course>? courses) {
      setState(() {
        _isRecommendedCoursesLoaded = true;
        if(courses != null) {
          _recommendedCourses = courses;
        }
      });
    });

    UserSettings.getChoosenLanguage().then((language) {
      if(language == 'en') {
        setState(() {
          _choosenLanguage = 'en';
        });
      } else {
        setState(() {
          _choosenLanguage = 'ar';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              child: Text(_choosenLanguage == 'en' ? 'Arabic' : 'English'),
              onPressed: ()  {
                if(_choosenLanguage == 'ar') {
                  UserSettings.setChoosenLanguage('en');
                  setState(() {
                    _choosenLanguage = 'en';
                  });
                } else {
                  UserSettings.setChoosenLanguage('ar');
                  setState(() {
                    _choosenLanguage = 'ar';
                  });
                }
                MyApp.of(context)!.setLocale(Locale.fromSubtags(languageCode: _choosenLanguage));
              }
            ),
            heading(context, AppLocalization.of(context).getTranslatedValue("my_subscriptions") ?? 'MY SUBSCRIPTIONS'),
            Container(
              width: double.infinity,
              padding: SectionPadding.vertical,
              margin: SectionMargin.bottom,
              decoration: const BoxDecoration(
                color: Color(0xff171d2a),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                children: [
                  Image.asset(AppPaths.baseIllustration, width: 200),
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(selectedTabIndex: 1,)));
                    },
                    child: Text(AppLocalization.of(context).getTranslatedValue("explore_courses") ?? 'EXPLORE COURSES')
                  )
                ]
              )
            ),
            heading(context, AppLocalization.of(context).getTranslatedValue("RECOMMENDED") ?? 'RECOMMENDED'),
            if(_isRecommendedCoursesLoaded && _recommendedCourses.isEmpty) const Center(child: Text('No results'))
            else if (_isRecommendedCoursesLoaded && _recommendedCourses.isNotEmpty) Container(
              width: double.infinity,
              padding: SectionPadding.vertical,
              margin: SectionMargin.bottom,
              child: SizedBox(
                height: 200,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: _recommendedCourses.map((e) {
                    return SingleRecommendedCard(
                      courseTitle: e.title,
                      category: e.category != null ? e.category!.title : null,
                      courseId: e.id,
                    );
                  }).toList()
                ),
              )
            ) else const Center(
              child: CircularProgressIndicator()
            )
          ],
        )
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/constants/colors.dart';
import 'package:flutter_application_1/modules/courses/main_category_screen.dart';
import 'package:flutter_application_1/modules/drawer/drawer.dart';
import 'package:flutter_application_1/modules/home/home_tab_content.dart';
import 'package:flutter_application_1/modules/inbox/inbox.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({ Key? key, this.selectedTabIndex = 0 }) : super(key: key);

  int selectedTabIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static final List<Map> _tabContents = [
    {
      "title": "HOME",
      "content": const HomeTabContent(),
    },
    {
      "title": "COURSES",
      "content": const MainCategoryScreen()
    },
    {
      "title": "INBOX",
      "content": const InboxScreen(), 
    },
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: appBar(title: _tabContents[widget.selectedTabIndex]['title']),
        body: _tabContents[widget.selectedTabIndex]['content'],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.black,
          selectedLabelStyle: TextStyle(fontSize: 10, color: AppColors.blue),
          selectedItemColor: AppColors.primary,
          unselectedFontSize: 10,
          currentIndex: widget.selectedTabIndex,
          onTap: (int index) {
            setState(() {
              widget.selectedTabIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow_outlined),
              label: "COURSES",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.crop_square_outlined),
              label: "INBOX",
            ),
          ]
        ),
      ),
    );
  }
}
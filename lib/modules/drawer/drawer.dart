import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/localization_helper.dart';
import 'package:flutter_application_1/modules/customer_care/customer_care_screen.dart';
import 'package:flutter_application_1/modules/drawer/single_drawer_item.dart';
import 'package:flutter_application_1/modules/privacy/privacy_policy.dart';
import 'package:flutter_application_1/modules/privacy/terms_service_screen.dart';
import 'package:flutter_application_1/modules/profiles/login.dart';
import 'package:flutter_application_1/modules/profiles/profile.dart';
import 'package:flutter_application_1/modules/profiles/screens/edit_email.dart';
import 'package:flutter_application_1/modules/profiles/screens/edit_password.dart';
import 'package:flutter_application_1/modules/profiles/screens/edit_phone.dart';
import 'package:flutter_application_1/modules/profiles/screens/edit_profile.dart';
import 'package:flutter_application_1/modules/purchases/purchases_screen.dart';
import 'package:flutter_application_1/modules/quiz/screen/single_quiz_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({ Key? key }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  final List _menuItems = [
    {
      "title": "Account",
      "icon": const Icon(Icons.ac_unit_outlined),
      "children": <Widget>[
        AppDrawerSingleListItem(title: 'Profile', icon: const Icon(Icons.supervised_user_circle_outlined), children: null, targetScreen: const EditProfileScreen(),),
        AppDrawerSingleListItem(title: 'Password', icon: const Icon(Icons.lock_outline), children: null, targetScreen: const EditPasswordScreen(),),
        AppDrawerSingleListItem(title: 'Email', icon: const Icon(Icons.email_outlined), children: null, targetScreen: const EditEmailScreen(),),
        AppDrawerSingleListItem(title: 'Phone', icon: const Icon(Icons.phone_android_outlined), children: null, targetScreen: const EditPhoneScreen()),
      ]
    },
    {
      "title": "Customer Care",
      "icon": Icon(Icons.message_outlined),
      "targetScreen": const CustomerCareScreen()
    },
    {
      "title": "Terms of Use",
      "icon": Icon(Icons.info_outline),
      "targetScreen": const TermsServicesScreen()
    },
    {
      "title": "Privacy Policy",
      "icon": Icon(Icons.privacy_tip_outlined),
      "targetScreen": const PrivacyPolicyScreen()
    },
    {
      "title": "Purchases",
      "icon": Icon(Icons.shopping_cart_outlined),
      "targetScreen": const PurchasesScreen()
    },
  ];

  String _username = "";

  @override
  void initState() {
    super.initState();
    Auth.user().then((Map? user) {
      if(user is Map && user.containsKey('full_name') && user['full_name'].toString().isNotEmpty) {
        setState(() => _username = user['full_name']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(children: [
                Image.asset('assets/images/C.png', width: 50, height: 50),
                Text(_username)
              ],)
            ),
            ..._menuItems.map((item) {
              return AppDrawerSingleListItem(
                title: item['title'], 
                icon: item['icon'], 
                children: (item as Map).containsKey('children') ? item['children'] as List<Widget> : null,
                targetScreen: item.containsKey('targetScreen') ? item['targetScreen'] : null,
              );
            }),
          ],
        ),
      )
    );
  }
}
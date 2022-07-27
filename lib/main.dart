import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/settings.dart';
import 'package:flutter_application_1/localization_helper.dart';
import 'package:flutter_application_1/modules/home/home.dart';
import 'package:flutter_application_1/modules/profiles/login.dart';
import 'package:flutter_application_1/utils/services/oc_shared_pref.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  runApp(MyApp());
  // WidgetsFlutterBinding.ensureInitialized();
  // await EasyLocalization.ensureInitialized();
  
  // runApp(
  //   EasyLocalization(
  //     supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
  //     path: 'assets/translations', // <-- change the path of the translation files 
  //     fallbackLocale: Locale('en', 'US'),
  //     child: MyApp()
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  void setLocale(Locale value) {
    print(value);
    setState(() {
      _locale = value;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int _colorVal = 0xff8E7AE1;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        // primarySwatch: Colors.blue,
        iconTheme: IconThemeData(color: Color(_colorVal)),
        fontFamily: "Cairo",
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 18),
          // bodyText2: TextStyle(fontSize: 12, color: Color(0xff2072e0)),
          headline1: TextStyle(fontSize: 20, fontFamily: "Nasalization", color: Colors.white, letterSpacing: 4),
          headline2: TextStyle(fontSize: 19, letterSpacing: 2, color: Colors.white),
          headline3: TextStyle(fontSize: 14, letterSpacing: 2, color: Colors.white),
          headline4: TextStyle(fontSize: 16, letterSpacing: 2, color: Color(_colorVal)),
          button: TextStyle(fontFamily: "Nasalization", letterSpacing: 3, fontSize: 10),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            // Color(0xff2072e0),
            Color(0xff8E7AE1)
          ),
          padding: MaterialStateProperty.all(const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))
          )
        ))
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalization.delegate
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale!.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
             }
         }
        return supportedLocales.first;
      },
    );
  }
}

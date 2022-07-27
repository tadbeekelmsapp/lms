import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/utils/services/oc_shared_pref.dart';

class UserSettings {
  static Future<String> getChoosenLanguage() async {
    String? _lang = await Preferences.get('user.settings.language');
    if(_lang == null || !['ar', 'en'].contains(_lang)) {
      return 'en';
    }
    return _lang;
  }

  static void setChoosenLanguage([String language = 'en']) async {
    language = language.toLowerCase();
    if(language == 'english') {
      language = 'en';
    } else if(language == 'arabic') {
      language = 'ar';
    } else {
      language = 'en';
    }
    print('setting..');
    print(language);
    Preferences.set('user.settings.language', language, forceSet: true);
    // MyApp.of(context)!.setLocale(Locale.fromSubtags(languageCode: language));
  }
}
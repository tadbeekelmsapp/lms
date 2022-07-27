import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/localization_helper.dart';
import 'package:url_launcher/url_launcher.dart';

int rand(int min, int max) => min + Random().nextInt(max - min);

void launchWhatsApp([String message = ""]) async {
  String phone = "96550633207";
  String _url = "https://wa.me/$phone/?text=${Uri.parse(message)}";
  if(await canLaunch(_url)) {
    await launch(_url);
  }
}

String getTransalatedValue(BuildContext context, String text) {
  return AppLocalization.of(context).getTranslatedValue(text.toLowerCase()) != null ? 
    AppLocalization.of(context).getTranslatedValue(text.toLowerCase())! : 
    text.toString().split(' ').map((element) {
      String? _val = AppLocalization.of(context).getTranslatedValue(element.toLowerCase());
      if(_val != null) {
        return _val;
      }
      return element;
    })
    .join(' ');
}

/// Get translated value of text if present
String tx(BuildContext context, String text) {
  return AppLocalization.of(context).getTranslatedValue(text) ?? text; 
}

String getBaseIllustrationPath() {
  return 'assets/images/base_illus.svg';
}
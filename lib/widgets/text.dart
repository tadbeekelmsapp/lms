import 'package:flutter/material.dart';

Widget heading1(BuildContext context, String text, {
  TextAlign? textAlign
}) {
  return Container(
    margin: const EdgeInsets.only(top: 10, bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.headline1, textAlign: textAlign,)
  );
}

Widget heading(BuildContext context, String text) {
  return Container(
    margin: const EdgeInsets.only(top: 10, bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.headline2)
  );
}

Widget heading3(BuildContext context, String text) {
  return Container(
    margin: const EdgeInsets.only(top: 10, bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.headline3)
  );
}
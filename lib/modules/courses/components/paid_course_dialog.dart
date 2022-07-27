import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/webview/webview.dart';

AlertDialog paidDialog(BuildContext context, { 
  String text = 'Do you want to purchase this course?',
  String closeBtnText = "No",
  String acceptBtnText = "Yes, Proceed",
  required int userId,
  required int courseId,
  String? courseTitle
}) {
  return AlertDialog(
    title: Text(text, style: const TextStyle(height: 2, fontSize: 14)),
    actions: [
      ElevatedButton(onPressed: () {
        Navigator.of(context).pop();
      }, child: Text(closeBtnText)),
      ElevatedButton(onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return WebView(
            uri: Uri.http(
              '157.241.12.13',
              '/app/process-payment',
              {
                'user_id': userId.toString(),
                'course_id': courseId.toString()
              }
            ),
            appBar: AppBar(
              title: Text('Purchase course: ' + (courseTitle ?? '')),
            ),
          );
        }));
      }, child: Text(acceptBtnText)),
    ],
  );
}
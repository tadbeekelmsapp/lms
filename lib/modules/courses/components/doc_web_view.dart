import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_item_bloc.dart';
import 'package:flutter_application_1/modules/webview/webview.dart';
import 'package:flutter_application_1/widgets/widgets.dart';

class DocWebView extends StatefulWidget {
  const DocWebView({ Key? key, required this.item}) : super(key: key);

  final CourseContentItemBloc item;

  @override
  _DocWebViewState createState() => _DocWebViewState();
}

class _DocWebViewState extends State<DocWebView> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(title: widget.item.title),
      body: WebView(
        uri: Uri.parse(widget.item.url),
      )
    );
  }
}
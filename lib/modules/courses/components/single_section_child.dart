import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Auth.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_item_bloc.dart';
import 'package:flutter_application_1/modules/courses/components/doc_web_view.dart';
import 'package:flutter_application_1/modules/courses/components/paid_course_dialog.dart';
import 'package:flutter_application_1/modules/courses/video_screen.dart';
import 'package:flutter_application_1/modules/quiz/screen/single_quiz_screen.dart';

class SingleSectionChild extends StatefulWidget {
  const SingleSectionChild({ Key? key, required this.item }) : super(key: key);

  final CourseContentItemBloc item;

  @override
  State<SingleSectionChild> createState() => _SingleSectionChildState();
}

class _SingleSectionChildState extends State<SingleSectionChild> {
  late Icon _trailingIcon;
  late Widget _redirectTo;
  
  @override 
  void initState() {
    super.initState();
    switch(widget.item.type) {
      case "quiz":
        _trailingIcon = const Icon(Icons.access_time_sharp);
        _redirectTo = SingleQuizScreen(item: widget.item);
      break;
      case "video": 
        _trailingIcon = const Icon(Icons.play_arrow);
        _redirectTo = VideoScreen(item: widget.item);
      break;
      case "doc":
      case "pdf":
      default:
        _trailingIcon = const Icon(Icons.content_copy_outlined);
        _redirectTo = DocWebView(item: widget.item);
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.item.title),
      leading: Text(widget.item.order.toString()),
      trailing: widget.item.isPaid ? const Icon(Icons.lock_outlined) : _trailingIcon,
      onTap: () async {
        if(!widget.item.isPaid) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => _redirectTo));
        } else {
          int? _userId = await Auth.getUserId();
          showDialog(context: context, builder: (context) {
            return paidDialog(
              context, 
              userId: _userId!, 
              courseId: widget.item.courseId,
              text: "This item is paid. Purchase this course now to view this!"
            );
          });
        }
      },
    );
  }
}
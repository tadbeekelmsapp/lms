import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_section_bloc.dart';
import 'package:flutter_application_1/modules/courses/components/single_section_child.dart';

class SingleSection extends StatefulWidget {
  const SingleSection({ Key? key, required this.section }) : super(key: key);

  final CourseContentSectionBloc section;

  @override
  State<SingleSection> createState() => _SingleSectionState();
}

class _SingleSectionState extends State<SingleSection> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(widget.section.title),
      children: widget.section.children!.map((item) {
        return SingleSectionChild(item: item,);
      }).toList(),
    );
  }
}
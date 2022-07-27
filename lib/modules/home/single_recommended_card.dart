import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/courses/single_course_screen.dart';

class SingleRecommendedCard extends StatefulWidget {
  const SingleRecommendedCard({ 
    Key? key, 
    required this.courseTitle, 
    this.subCategory, 
    this.category,
    this.courseId
  }) : super(key: key);

  final String courseTitle;
  final String? subCategory;
  final String? category;
  final int? courseId;

  @override
  State<SingleRecommendedCard> createState() => _SingleRecommendedCardState();
}

class _SingleRecommendedCardState extends State<SingleRecommendedCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: 150,
        height: 50,
        child: Container(
          margin: const EdgeInsets.only(right: 15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // border: Border.all(color: Colors.white)
          ),
          child: Stack(
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  image: DecorationImage(image: AssetImage('assets/images/course.jpg'), fit: BoxFit.cover),
                ),
              ),
              Positioned(
                bottom: 50,
                child: Container(
                  width: 150-15,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xff171d2a),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    widget.category != null ? Text(widget.category!.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1, height: 1)) : const SizedBox.shrink(),
                    Text(widget.courseTitle, style: const TextStyle(height: 1.5)),
                    widget.subCategory != null ? Text(widget.subCategory!, style: const TextStyle(height: 1.5)) : const SizedBox.shrink()
                  ],),
                ),
              )
            ],
          ),
        )
      ),
      onTap: () {
        if(widget.courseId != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleCourseScreen(courseId: widget.courseId!, courseTitle: widget.courseTitle,)));
        }
      },
    );
  }
}
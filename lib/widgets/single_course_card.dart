import 'package:flutter/material.dart';

class SingleCourseCard extends StatefulWidget {
  const SingleCourseCard({ Key? key, required this.courseTitle, required this.category, this.onTap }) : super(key: key);

  final String courseTitle;
  final String category;
  final Function()? onTap;

  @override
  State<SingleCourseCard> createState() => _SingleCourseCardState();
}

class _SingleCourseCardState extends State<SingleCourseCard> {
  @override
  Widget build(BuildContext context) {
  
    return Container(
      height: 100,
      width: 100,
      margin: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        // border: Border.all(color: Colors.white)
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: Image.asset('assets/images/course.jpg', fit: BoxFit.cover, )
              )
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 85,
                width: (MediaQuery.of(context).size.width * 0.42),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xff171d2a),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.category.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1, height: 1)),
                    Text(widget.courseTitle, style: const TextStyle(height: 1.5)),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 60,
                        height: 30,
                        // margin: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                          
                          }, 
                          child: const Text('ADD', style: TextStyle(fontSize: 9)),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            elevation: 1
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
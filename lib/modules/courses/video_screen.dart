import 'package:flutter/material.dart';
import 'package:flutter_application_1/modules/courses/blocs/course_content_item_bloc.dart';
import 'package:flutter_application_1/modules/courses/components/video_progress_bar.dart';
import 'package:flutter_application_1/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({ Key? key, required this.item }) : super(key: key);

  final CourseContentItemBloc item;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _showError = false;

  @override 
  void initState() {
    super.initState();
    print(widget.item.url);
    _controller = VideoPlayerController.network(widget.item.url)
    ..initialize().then((_) {
      setState(() {
        _controller.play();
      });
    });
    _controller.addListener(() { 
      if(_controller.value.hasError) {
        setState(() => _showError = true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: appBar(title: widget.item.title),
      body: SingleChildScrollView(
        child: _showError ? 
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: const Center(
            child: Text("Something went wrong!"),
          ),
        ) : 
        Container(
          child: _controller.value.isInitialized ?
            Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white
                  ),
                  child: Row(
                    children: [
                      Positioned(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Center(
                            child: InkWell(
                              child: _controller.value.isPlaying ? 
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.pause,
                                  size: 30
                                ),
                              ) : 
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: const EdgeInsets.all(5),
                                child: const Icon(
                                  Icons.play_arrow,
                                  size: 30
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                                });
                              }
                            ),
                          ),
                        ),
                      ),
                      VideoProgressBar(
                        _controller, 
                        barHeight: 7, 
                        handleHeight: 7, 
                        drawShadow: false,
                        colors: ChewieProgressColors(playedColor: const Color(0xff8E7AE1)),
                      )
                    ],
                  ),
                ),
              ],
            ) :
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const Center(child: CircularProgressIndicator(color: Color(0xff8E7AE1),),),
            )
        ),
      ),
    );
  }
}
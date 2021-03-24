
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class DroneViePage extends StatefulWidget{

  final String judulVideo;
  final String urlVideo;

  DroneViePage({Key key, @required this.judulVideo, this.urlVideo}) : super(key: key);

  @override
  DroneViewState createState() => DroneViewState();
}

class DroneViewState extends State<DroneViePage> {

  FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network("${widget.urlVideo}"),
    );

    super.initState();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.judulVideo}"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black87,
        child: Center(
          child: Container(
            height: 220,
            child: FlickVideoPlayer(
                flickManager: flickManager
            ),
          ),
        ),
      ),
    );
  }
}
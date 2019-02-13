import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';

class VideoPlayers extends StatefulWidget {
  final String videoPath;
  VideoPlayers({this.videoPath});
  @override
  VideoPlayerState createState() {
    return new VideoPlayerState();
  }
}

class VideoPlayerState extends State<VideoPlayers> {
  bool _isPlaying = false;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;
  VideoPlayerController vcontroller;

  Future<void> _startVideoPlayer() async {
    if (videoController == null) {
      videoController =
          new VideoPlayerController.network('${widget.videoPath}');
      videoPlayerListener = () {
        if (videoController != null && videoController.value.size != null) {
          // Refreshing the state to update video player with the correct ratio.
          if (mounted) setState(() {});
          videoController.removeListener(videoPlayerListener);
        }
      };
      videoController.addListener(videoPlayerListener);
      await videoController.setLooping(true);
      await videoController.initialize();
      //await videoController?.dispose();
      if (mounted) {
        setState(() {
          videoController;
        });
      }
      videoController.pause();
    }
  }

  @override
  void didChangeDependencies() {
    print('video url:: ${widget.videoPath}');
    super.didChangeDependencies();
    if (videoController != null) {
      _isPlaying = false;
      videoController.setVolume(0.0);
      videoController.removeListener(videoPlayerListener);
      videoController.dispose();
      videoController = null;
    }
    if (widget.videoPath != null) {
      _startVideoPlayer();
    }
  }

  void _play() async {
    _isPlaying = !videoController.value.isPlaying;
    if (_isPlaying) {
      await videoController.play();
    } else
      await videoController.pause();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.videoPath != null
        ? Center(
            child: InkWell(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    child: videoController == null
                        ? Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 10.0,
                            ),
                          )
                        : VideoPlayer(videoController),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white12,
                    maxRadius: 30,
                    child: _isPlaying
                        ? Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 40.0,
                          )
                        : Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40.0,
                          ),
                  ),
                ],
              ),
              onTap: () {
                _play();
              },
            ),
          )
        : SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(),
          );
  }

  @override
  void deactivate() {
    if (videoController != null) {
      videoController.setVolume(0.0);
      videoController.removeListener(videoPlayerListener);
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (videoController != null) {
      videoController.dispose();
    }
    super.dispose();
  }
}

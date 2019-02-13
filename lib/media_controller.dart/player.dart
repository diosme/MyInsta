import 'dart:ui';
import 'package:duo/components/inherit.dart';
import 'package:duo/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:duo/recorder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SongPlayer extends StatefulWidget {
  final DocumentSnapshot document;
  SongPlayer({this.document});
  @override
  _SongdPlayerState createState() => new _SongdPlayerState();
}

class _SongdPlayerState extends State<SongPlayer> {
  bool isPlaying = false, isUrl = false;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';

  Duration duration;
  Duration position;
  Recorder recorder = new Recorder();
  PlayingStatus playingStatus = PlayingStatus.playing;
  @override
  void initState() {
    print('url:: ${widget.document['url']}');
    _initState();
    recorder.filePath = widget.document['url'];
    recorder.playAudio(onComplete).then((s) {
      setState(() {
        isUrl = true;
        isPlaying = true;
      });
    });
    // });
    recorder.filePath = widget.document['media_url'];

    recorder.audioPlayer.positionHandler = ((p) {
      setState(() {
        position = p;
        // print('position:: ${p.inSeconds}');
      });
    });
    recorder.audioPlayer.durationHandler = ((d) {
      // print('duration:: ${d.inMilliseconds}');
      setState(() {
        duration = d;
      });
    });
    super.initState();
  }

  void onComplete() {}
  @override
  void dispose() {
    if (!isPlaying) recorder.stopAudio();
    super.dispose();
  }

  Future _initState() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      playingStatus = PlayingStatus.playing;
    } else {
      playingStatus = PlayingStatus.noInternet;
    }
  }

  void playing(BuildContext context) async {
    if (playingStatus == PlayingStatus.noInternet) _initState();
    if (playingStatus == PlayingStatus.noInternet) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // color: Colors.red,
              title: Text('No internet '),
              content: Text('please connect to internet'),
            );
          });
    } else {
      setState(() {
        isUrl = false;
      });
      recorder.stopAudio().then((s) {
        setState(() {
          isPlaying = !isPlaying;
        });
        if (isPlaying)
          recorder.playAudio(onComplete).then((s) {
            setState(() {
              isUrl = true;
            });
          });
        else
          recorder.stopAudio();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final user = MPInheritedWidget.of(context);
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close),
          color: Colors.black,
        ),
        title: Text(
          "Now Playing",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 3.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(),
          AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 10.0, sigmaX: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          colors: [Colors.redAccent, Colors.black]),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Icon(
                    Icons.music_note,
                    size: 60,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
              height: 150.0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          colors: [Colors.redAccent, Colors.black]),
                      borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      duration == null
                          ? new Container()
                          : new Slider(
                              onChanged: (s) {
                                setState(() {
                                  recorder
                                      .seek(Duration(milliseconds: s.toInt()));
                                });
                              },
                              value: position?.inMilliseconds?.toDouble() ?? 0,
                              // onChanged: (double value) => recorder.audioPlayer
                              //     .seek((value / 1000).roundToDouble()),
                              min: 0.0,
                              max: duration.inMilliseconds.toDouble()),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 20.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              positionText,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              durationText,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Container(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {},
                              color: Theme.of(context).primaryColor,
                              icon: Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ),
                              iconSize: 40.0,
                              tooltip: String.fromEnvironment('',
                                  defaultValue: 'Prev'),
                            ),
                            durationText != ''
                                ? IconButton(
                                    icon: Icon(
                                      !isPlaying
                                          ? Icons.play_arrow
                                          : Icons.pause,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (isPlaying) {
                                        recorder.pauseAudio();
                                        setState(() {
                                          isPlaying = false;
                                        });
                                      } else {
                                        recorder.playAudio(onComplete);
                                        setState(() {
                                          isPlaying = true;
                                        });
                                      }
                                    },
                                    color: Theme.of(context).buttonColor,
                                    iconSize: 45.0,
                                  )
                                : SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Container(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.black,
                                      ),
                                    ),
                                  ),
                            IconButton(
                              onPressed: () {},
                              highlightColor: Colors.black,
                              tooltip: String.fromEnvironment('',
                                  defaultValue: 'Next'),
                              icon: Icon(
                                Icons.skip_next,
                                color: Colors.white,
                                // size: 40.0,
                              ),
                              splashColor: Colors.grey,
                              iconSize: 40.0,
                            )
                          ],
                        ),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}

enum PlayingStatus { conntected, playing, noInternet }

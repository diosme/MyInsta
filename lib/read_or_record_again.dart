import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo/create_recording.dart';
import 'package:duo/recorder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ReadDocument extends StatefulWidget {
  final DocumentSnapshot document;
  ReadDocument({
    this.document,
  }) {}
  @override
  _ReadDocumentState createState() => new _ReadDocumentState();
}

class _ReadDocumentState extends State<ReadDocument>
    with SingleTickerProviderStateMixin {
  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

//
  AudioPlayer audioPlugin = new AudioPlayer();
  Recorder recorder = new Recorder();
  DocumentSnapshot documentSnapshot;
  Stream<QuerySnapshot> stream;
  AnimationController animationController;
  Firestore firestore = Firestore();
  bool isLoading = false, isAudioPlaying = false, isRecorded = false;
  String audioUrl, str;
  RecStatus recStatus = RecStatus.play;
  RecStatus reAgainStatus = RecStatus.recAgain;
  String rec = 'Rec',
      recAg = 'Record Again',
      _play = 'Play',
      userId,
      status = 'Please wait...';
  StorageUploadTask task;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(hours: 2),
    );
    _initData();
    super.initState();
  }

  DataStatus dataStatus;
  void _initData() async {
    // await firestore.settings(timestampsInSnapshotsEnabled: false);
    setState(() {
      isLoading = false;
    });
    FirebaseAuth.instance.currentUser().then((user) {
      userId = user.uid;
    });
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${widget.document['audio_url']}');
    firebaseStorageRef.getDownloadURL().then((path) {
      audioUrl = path;
      setState(() {
        isLoading = true;
      });
    });
  }

  Future<Null> _uploadFile() async {
    animationController.reset();
    setState(() {
      isLoading = false;
      status = 'Sending..';
    });
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${widget.document['audio_url']}');
    String audioUrl = await firebaseStorageRef.getPath();
    task = firebaseStorageRef.putFile(
      File(recorder.filePath),
    );
    Firestore.instance
        .collection('data')
        .document(widget.document.documentID)
        .setData({
      'title': widget.document['title'],
      'audio_url': audioUrl,
      'userId': userId,
      'status': 'translated',
      'text': widget.document['text']
    }).then((k) {
      setState(() {
        status = 'Sent..';
      });
      new Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isLoading = true;
        });
      });
    });
  }

  Icon icons = Icon(
    Icons.play_arrow,
    color: Colors.white,
    size: 35.0,
  );
  Icon recIcon = Icon(
    Icons.mic,
    size: 35.0,
    color: Colors.white,
  );
  void _onComplete() {
    animationController.reset();
    setState(() {
      recStatus = RecStatus.play;
      _play = 'Play';
      icons = Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 35.0,
      );
    });
  }

  @override
  void didUpdateWidget(ReadDocument oldWidget) {
    print('didUpdateWidget');
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    recorder.audioPlayer.stop();
    recorder.stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == false) {
      return new Scaffold(
        appBar: AppBar(),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new SizedBox(width: 20.0),
                new Text(status),
              ],
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: new Container(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 7,
                child: Container(
                  color: Colors.grey[300],
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          '${widget.document['text']}',
                          softWrap: true,
                          textScaleFactor: 1.2,
                          style: TextStyle(fontSize: 19.0, height: 1.50),
                        ),
                      ),
                    ],
                  ),
                )),
            Container(
              color: Colors.black,
              height: 2.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget child) {
                    return new Text(
                      timerString,
                      style: TextStyle(fontSize: 20.0, color: Colors.red),
                    );
                  }),
            ),
            Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              child: RaisedButton(
                                elevation: 16.0,
                                disabledColor: Colors.grey,
                                splashColor: Colors.white,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                onPressed: () {
                                  switch (reAgainStatus) {
                                    case RecStatus.recAgain:
                                      recorder.stopAudio().then((l) {
                                        recorder.start();
                                        animationController.forward(from: 0.0);
                                      });
                                      setState(() {
                                        recIcon = Icon(
                                          Icons.stop,
                                          size: 35.0,
                                          color: Colors.white,
                                        );
                                        recAg = 'Stop Rec';
                                        _play = 'Play';
                                        isRecorded = false;
                                        audioUrl = recorder.filePath;
                                        icons = Icon(
                                          Icons.play_arrow,
                                          size: 35.0,
                                          color: Colors.white,
                                        );
                                        reAgainStatus = RecStatus.stop;
                                      });
                                      break;
                                    case RecStatus.stop:
                                      animationController.stop();
                                      recorder.stop();
                                      audioUrl = recorder.filePath;
                                      print('audio url $audioUrl');
                                      setState(() {
                                        recIcon = Icon(
                                          Icons.mic,
                                          size: 35.0,
                                          color: Colors.white,
                                        );
                                        recAg = 'Rec Again';
                                        isRecorded = !isRecorded;
                                        reAgainStatus = RecStatus.recAgain;
                                      });
                                      break;
                                  }
                                },
                                child: recIcon,
                              )),
                          Text(recAg)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: RaisedButton(
                                elevation: 16.0,
                                disabledColor: Colors.grey,
                                splashColor: Colors.white,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                onPressed: reAgainStatus != RecStatus.stop
                                    ? () {
                                        switch (recStatus) {
                                          case RecStatus.play:
                                            if (recorder.playerState ==
                                                PlayerState.stoppedAudio) {
                                              animationController.forward(
                                                  from: 0.0);
                                            } else if (recorder.playerState ==
                                                PlayerState.pauseAudio) {
                                              animationController.forward(
                                                  from: animationController
                                                      .value);
                                            }
                                            recorder.filePath = audioUrl;
                                            recorder.playAudio(_onComplete);
                                            setState(() {
                                              recStatus = RecStatus.pause;
                                              _play = 'Pause';
                                              icons = Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                                size: 35.0,
                                              );
                                            });

                                            break;
                                          case RecStatus.pause:
                                            animationController.stop();
                                            recorder.pauseAudio();
                                            setState(() {
                                              recStatus = RecStatus.play;
                                              _play = 'Play';
                                              icons = Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 35.0,
                                              );
                                            });
                                            break;
                                        }
                                      }
                                    : null,
                                child: icons),
                          ),
                          Text(_play)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35.0),
                              border: Border.all(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            child: RaisedButton(
                                elevation: 16.0,
                                disabledColor: Colors.grey,
                                splashColor: Colors.white,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                onPressed: isRecorded
                                    ? () {
                                        _uploadFile();
                                        setState(() {
                                          _play = 'Play';
                                          icons = Icon(
                                            Icons.play_arrow,
                                            size: 35.0,
                                            color: Colors.white,
                                          );
                                        });
                                      }
                                    : null,
                                child: Icon(
                                  Icons.done,
                                  size: 35.0,
                                  color: Colors.white,
                                )),
                          ),
                          Text('Send')
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

enum RecStatus { start, stop, pause, play, recAgain }

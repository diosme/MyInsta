// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:duo/recorder.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:connectivity/connectivity.dart';

class RecordingPage extends StatefulWidget {
  RecordingPage() {}
  @override
  _RecordingPageState createState() => new _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  String get timerString {
    Duration duration =
        animationController.duration * animationController.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Recorder recorder = new Recorder();
  Firestore firestore = Firestore();
  Stream<QuerySnapshot> dataStream, savedStreamData;
  StorageUploadTask task;
  String userId, loadingStatus = 'Please wait...', _text;
  PageController controller = PageController();
  bool isRecorded = false, isSent = true, isLoading = false;
  int flag = 0, count = 0;
  Status status = Status.record;
  DataStatus dataStatus;
  Icon icons = Icon(
    Icons.mic,
    color: Colors.white,
    size: 35.0,
  );
  Icon recIcon = Icon(
    Icons.mic,
    color: Colors.white,
    size: 35.0,
  );
  void setPermission() async {
    await SimplePermissions.requestPermission(Permission.RecordAudio);
    await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
  }

  @override
  initState() {
    _initBoard();
    super.initState();
  }

  void _initBoard() async {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(hours: 2),
    );
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      dataStatus = DataStatus.connected;
    } else {
      dataStatus = DataStatus.noNetwork;
    }
    if (dataStatus == DataStatus.connected) {
      FirebaseAuth.instance.currentUser().then((user) {
        userId = user.uid;
      });
      setPermission();
      _initData();
    }
  }

  Future<Null> _initData() async {
    count = 0;
    setState(() {
      dataStatus = DataStatus.loading;
    });

    dataStream =
        firestore.collection('data').snapshots().timeout(Duration(seconds: 2));
    dataStream.forEach((data) {
      for (int i = 0; i < data.documents.length; i++) {
        documentSnapshot = data.documents[i];
        if (documentSnapshot['status'] != 'translated') {
          print('done');
          _text = documentSnapshot['text'];
          setState(() {
            dataStatus = DataStatus.loaded;
          });
          break;
        } else {
          count++;
          if (count == data.documents.length) {
            setState(() {
              dataStatus = DataStatus.noTranslation;
            });
          }
        }
      }
    });
  }

  int allItem, countTranslatedItem;
  String textIcon = 'Record';
  Future<Null> _uploadFile() async {
    animationController.reset();
    setState(() {
      dataStatus = DataStatus.loading;
      loadingStatus = 'Sending...';
      isRecorded = false;
      isSent = false;
    });
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('${Uuid().v1()}.m4a');
    String audioUrl = await firebaseStorageRef.getPath();
    task = firebaseStorageRef.putFile(
      File(recorder.filePath),
    );

    Firestore.instance
        .collection('data')
        .document(documentSnapshot.documentID)
        .setData({
      'title': documentSnapshot['title'],
      'audio_url': audioUrl,
      'user_id': userId,
      'status': 'translated',
      'text': documentSnapshot['text']
    }).then((k) {
      setState(() {
        loadingStatus = 'sent';
      });
      new Future.delayed(Duration(seconds: 1), () {
        setState(() {
          dataStatus = DataStatus.loaded;
        });
      });
    });
  }

  @override
  didUpdateWidget(RecordingPage oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  void _onComplete() {
    animationController.reset();
    setState(() {
      icons = Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 35.0,
      );
      textIcon = 'play';
      status = Status.play;
    });
  }

  @override
  dispose() {
    recorder.audioPlayer.stop();
    recorder.stopAudio();
    animationController.dispose();
    super.dispose();
  }

  DocumentSnapshot documentSnapshot;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Record'),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    ThemeData themeData = Theme.of(context);
    if (dataStatus == DataStatus.loading)
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new SizedBox(width: 20.0),
              new Text(loadingStatus),
            ],
          )
        ],
      );
    else if (dataStatus == DataStatus.loaded) {
      return Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: _text != null
                ? Container(
                    color: Colors.grey[300],
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: ListView(
                          children: <Widget>[
                            Text(
                              _text,
                              style: TextStyle(fontSize: 19.0, height: 1.50),
                              textScaleFactor: 1.20,
                            ),
                          ],
                        )),
                  )
                : Container(),
          ),
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
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.red,
                    ),
                  );
                }),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            onPressed: status == Status.play
                                ? () {
                                    recorder.stopAudio().then((k) {
                                      recorder.start();
                                      animationController.forward(from: 0.0);
                                    });
                                    setState(() {
                                      status = Status.stopRecording;
                                      icons = Icon(
                                        Icons.stop,
                                        color: Colors.white,
                                        size: 35.0,
                                      );
                                      textIcon = 'stop';
                                      isRecorded = false;
                                      isSent = true;
                                    });
                                  }
                                : null,
                            child: recIcon),
                      ),
                      Text('Record again')
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
                            onPressed: isSent
                                ? () {
                                    switch (status) {
                                      case Status.record:
                                        recorder.start();
                                        if (animationController.isAnimating) {
                                          animationController.stop();
                                        } else
                                          animationController.forward(
                                              from: 0.0);
                                        setState(() {
                                          icons = Icon(
                                            Icons.stop,
                                            color: Colors.white,
                                            size: 35.0,
                                          );
                                          status = Status.stopRecording;
                                          textIcon = 'Stop';
                                        });
                                        break;
                                      case Status.stopRecording:
                                        recorder.stop();
                                        if (animationController.isAnimating) {
                                          animationController.stop();
                                        } else
                                          animationController.forward(
                                              from: 0.0);
                                        setState(() {
                                          icons = Icon(
                                            Icons.play_arrow,
                                            size: 35.0,
                                            color: Colors.white,
                                          );
                                          status = Status.play;
                                          textIcon = 'Play';
                                          isRecorded = !isRecorded;
                                        });
                                        break;
                                      case Status.play:
                                        if (recorder.playerState ==
                                            PlayerState.stoppedAudio) {
                                          animationController.forward(
                                              from: 0.0);
                                        } else if (recorder.playerState ==
                                            PlayerState.pauseAudio) {
                                          animationController.forward(
                                              from: animationController.value);
                                        }
                                        recorder.playAudio(_onComplete);
                                        setState(() {
                                          icons = Icon(
                                            Icons.pause,
                                            color: Colors.white,
                                            size: 35.0,
                                          );
                                          textIcon = 'pause';
                                          status = Status.pause;
                                        });
                                        break;
                                      case Status.pause:
                                        recorder.pauseAudio();
                                        animationController.stop();
                                        setState(() {
                                          icons = Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 35.0,
                                          );
                                          textIcon = 'play';
                                          status = Status.play;
                                        });
                                        break;
                                    }
                                  }
                                : null,
                            child: icons),
                      ),
                      Text(textIcon)
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
                                    recorder.audioPlayer.stop();
                                    _uploadFile().then((f) {
                                      _initData();
                                    });
                                    setState(() {
                                      status = Status.play;
                                      icons = Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 35.0,
                                      );
                                    });
                                  }
                                : null,
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 35.0,
                            )),
                      ),
                      Text('Send')
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    } else if (dataStatus == DataStatus.noTranslation) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.hourglass_empty,
            color: Colors.black12,
            size: 50.0,
          ),
          Text(
            'All Data Translated',
            style: TextStyle(fontSize: 25.0, color: Colors.black38),
          )
        ],
      ));
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.signal_cellular_connected_no_internet_4_bar),
            Text('Internet not connected')
          ],
        ),
      );
    }
  }
}

enum Status { record, stopRecording, play, pause, recordAgain }
enum DataStatus { loading, loaded, noTranslation, noNetwork, connected }

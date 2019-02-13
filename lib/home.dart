import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo/review.dart';
import 'package:flutter/material.dart';
import 'create_recording.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 90.0,
                      width: 90.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: FlatButton(
                          splashColor: Colors.grey,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Review()),
                            );
                          },
                          child: Icon(
                            Icons.rate_review,
                            color: Colors.black,
                            size: 40.0,
                          )),
                    ),
                    Text(
                      'Review',
                      style: TextStyle(fontSize: 24.0, color: Colors.black),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 90.0,
                      width: 90.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: FlatButton(
                          splashColor: Colors.grey,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(45.0)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecordingPage()),
                            );
                          },
                          // maxRadius: 50.0,
                          // backgroundColor: Colors.red,
                          child: Icon(
                            Icons.record_voice_over,
                            color: Colors.black,
                            size: 40.0,
                          )),
                    ),
                    Text(
                      'Record',
                      style: TextStyle(fontSize: 24.0, color: Colors.black),
                    )
                  ],
                )
              ],
            )
          ]),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FrontPage extends StatefulWidget {
  @override
  FrontPageState createState() {
    return new FrontPageState();
  }
}

class FrontPageState extends State<FrontPage> {
  Firestore firestore = new Firestore();
  Stream<QuerySnapshot> dataStream;
  DocumentSnapshot documentSnapshot;
  @override
  void initState() {
    firestore.settings(timestampsInSnapshotsEnabled: true);
    dataStream = firestore.collection('data').snapshots();
    dataStream.forEach((k) {
      for (int i = 0; i < k.documents.length; i++) {
        documentSnapshot = k.documents[0];
        if (documentSnapshot['title'] != null) {
          Navigator.of(context).pushReplacementNamed('/home');
          break;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
        child: Icon(
          Icons.audiotrack,
          size: 100,
        ),
      ),
    );
  }
}

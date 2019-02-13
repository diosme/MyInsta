import 'package:duo/components/activity_card.dart';
import 'package:duo/components/inherit.dart';
import 'package:duo/components/user_detail.dart';
import 'package:duo/create_recording.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
// import 'package:infinite_listview/infinite_listview.dart';

class Activity extends StatefulWidget {
  final UsersData logInUser;
  Activity({Key key, this.logInUser});
  @override
  _RecordState createState() => new _RecordState();
}

class _RecordState extends State<Activity> {
  bool isLoading = false;
  List<Map<String, dynamic>> user;
  String userName, imageUrl;
  DataStatus dataStatus = DataStatus.loading;
  var now;
  Animation<Colors> valuel;
  @override
  void initState() {
    _initState();
    super.initState();
  }

  int i = 0;
  Stream<QuerySnapshot> dataStream, savedStreamData;
  _initState() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        dataStatus = DataStatus.connected;
      });
    } else {
      dataStatus = DataStatus.noNetwork;
    }
  }

  String dc, url;
  var query;

  var length;
  @override
  Widget build(BuildContext context) {
    List<Widget> _build(List<DocumentSnapshot> doc) {
      final List<Widget> _children = [];
      if (doc != null)
        doc.forEach((document) {
          _children.add(ActivityCard(
            name: document['user_name'] ?? 'loading..',
            profileUrl: document['profile_photo_url'] ?? null,
            uploadedMediaUrl: document['uploaded_media_url'],
            type: document['media_type'],
            userEmaidlID: document['user_email_id'],
            documentsnapShot: document,
          ));
        });
      return _children;
    }

    Widget _buildCards(DocumentSnapshot document) {
      return ActivityCard(
        name: document['user_name'] ?? 'loading..',
        profileUrl: document['profile_photo_url'] ?? null,
        uploadedMediaUrl: document['uploaded_media_url'],
        type: document['media_type'],
        userEmaidlID: document['user_email_id'],
        documentsnapShot: document,
      );
    }

    if (dataStatus == DataStatus.connected)
      return Scaffold(
          backgroundColor: Colors.grey[100],
          body: StreamBuilder(
              stream: Firestore.instance
                  .collection('media_storage_info')
                  .orderBy('date_and_time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  );
                } else {
                  length = snapshot.data.documents.length;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      DocumentSnapshot document;
                      document = snapshot.data.documents[index];
                      return _buildCards(document);
                    },
                    itemCount: length,
                  );
                }
              }));
    else
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('No internet connection'),
            FlatButton(
              onPressed: () {
                _initState();
              },
              child: Text('Retry'),
              color: Colors.green,
            )
          ],
        ),
      );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:duo/create_recording.dart';
import 'package:duo/read_or_record_again.dart';
import 'package:flutter/material.dart';

class Review extends StatefulWidget {
  Review() {}

  @override
  ReviewState createState() {
    return new ReviewState();
  }
}

class ReviewState extends State<Review> {
  Firestore firestore = Firestore();
  DataStatus dataStatus = DataStatus.loading;
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    // await firestore.settings(timestampsInSnapshotsEnabled: false);
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        dataStatus = DataStatus.connected;
      });
    } else {
      setState(() {
        dataStatus = DataStatus.noNetwork;
      });
    }
  }

  Widget _build() {
    if (dataStatus == DataStatus.loading)
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(),
              new SizedBox(width: 20.0),
              new Text("Please wait..."),
            ],
          ),
        ],
      );
    else if (dataStatus == DataStatus.connected)
      return Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('data').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            final int messageCount = snapshot.data.documents.length;
            return ListView.builder(
              itemCount: messageCount,
              itemBuilder: (_, int index) {
                final DocumentSnapshot document =
                    snapshot.data.documents[index];
                print('document $document');
                return Container(
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          bottom:
                              BorderSide(color: Colors.black26, width: 1.40))),
                  child: document['status'] == 'translated'
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            enabled: true,
                            onTap: () {
                              print(' ${document.data.values}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReadDocument(
                                          document: document,
                                        )),
                              );
                            },
                            title: Text(
                              document['text'] ?? '<No message retrieved>',
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold
                                  // inherit: true,
                                  ),
                            ),
                            subtitle:
                                Text('Message ${index + 1} of $messageCount'),
                          ),
                        )
                      : Center(
                          child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('No Translation ${index + 1}'),
                        )),
                );
              },
            );
          },
        ),
      );
    else
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: AppBar(), body: _build());
  }
}

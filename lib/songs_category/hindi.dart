import 'package:duo/components/songs_card.dart';
import 'package:duo/components/inherit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HindiSongs extends StatefulWidget {
  HindiSongs() {}
  @override
  _HindiSongsState createState() => new _HindiSongsState();
}

class _HindiSongsState extends State<HindiSongs> {
  DatabaseReference databaseReference;
  @override
  void initState() {
    // firestore.settings(
    //     persistenceEnabled: true,
    //     sslEnabled: true,
    //     timestampsInSnapshotsEnabled: true);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('object');
    return new Scaffold(
      appBar: AppBar(
        title: Text('Hindi'),
        backgroundColor: Colors.redAccent,
        elevation: 2.0,
      ),
      body: Container(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('/songs_data/hindi_songs/hindi_collection')
              .snapshots(),
          builder: (_, snapshot) {
            if (!snapshot.hasData)
              return Center(child: const Text('Loading...'));
            else {
              final int messageCount = snapshot.data.documents.length;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  final DocumentSnapshot document =
                      snapshot.data.documents[index];
                  print("songs ::$document['title']");
                  return SongsCardWidget(
                    document: document,
                  );
                },
                itemCount: messageCount,
              );
            }
          },
        ),
      ),
    );
  }
}

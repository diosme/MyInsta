import 'package:duo/components/page_router.dart';
import 'package:duo/media_controller.dart/player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SongsCardWidget extends StatelessWidget {
  final DocumentSnapshot document;
  final Firestore firestore;
  SongsCardWidget({this.document, this.firestore});
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.black87],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomStart),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: MaterialButton(
        onPressed: document['title'] != null
            ? () {
                Navigator.of(context).push(SlideRightRouteFromBottom(
                    widget: SongPlayer(
                  document: document,
                )));
              }
            : null,
        splashColor: Colors.white,
        child: document['title'] != null
            ? Stack(
                children: <Widget>[
                  Icon(
                    Icons.audiotrack,
                    size: 50.0,
                    color: Colors.black38,
                  ),
                  Text(
                    document['title'],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 14.0),
                  )
                ],
              )
            : Container(),
        elevation: 8.0,
      ),
    );
  }
}

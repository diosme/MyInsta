import 'package:duo/components/inherit.dart';
import 'package:duo/components/page_router.dart';
import 'package:duo/songs_category/hindi.dart';
import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final String text;
  AlbumCard({this.text});
  _toCategorySongScreen(String text, BuildContext context) {
    if (text == 'Hindi') {
      Navigator.of(context)
          .push(SlideRightRoute(widget: HindiSongs(), context: context));
    } else if (text == "English") {
    } else if (text == "English") {
    } else if (text == "English") {
    } else if (text == "English") {
    } else if (text == "English") {
    } else if (text == "English") {}
  }

  var inherit;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              tileMode: TileMode.mirror,
              colors: [Colors.redAccent, Colors.black87],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomStart),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: MaterialButton(
        onPressed: () => _toCategorySongScreen(text, context),
        splashColor: Colors.white,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontSize: 20.0),
          ),
        ),
        elevation: 4.0,
      ),
    );
  }
}

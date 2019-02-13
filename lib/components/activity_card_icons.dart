import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:duo/components/comment_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:advanced_share/advanced_share.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:path_provider/path_provider.dart';

class ActivityCardIcons extends StatefulWidget {
  final Firestore firestore;
  final Function whatsAppShare;
  final DocumentSnapshot documentSnapshot;

  ActivityCardIcons(
      {this.firestore, this.whatsAppShare, this.documentSnapshot});

  @override
  ActivityCardIconsState createState() {
    return new ActivityCardIconsState();
  }
}

class ActivityCardIconsState extends State<ActivityCardIcons> {
  GlobalKey scaffoldKey = GlobalKey();

  void _share(String url) {
    print('url $url');
    // FlutterShareMe().shareToWhatsApp(
    //   msg: _base64Var,
    // );
    AdvancedShare.whatsapp(url: url).then((response) {
      handleResponse(response, appName: "Whatsapp");
    });
  }

  Future<String> _base64(String url) async {
    // final ByteData bytes = await rootBundle
    //     .load('assets/Phone-Wallpapers-iPhone-7-resolutionArtboard-1.png');
    // final Uint8List list = bytes.buffer.asUint8List();
    // final tempDir = await getTemporaryDirectory();
    // final file = await new File('${tempDir.path}/image.jpg').create();
    // file.writeAsBytesSync(list);
    (() async {
      http.Response response = await http.get(url);
      if (mounted) {
        _base64Var = base64.encode(response.bodyBytes);
      }
    })();
    return _base64Var;
  }

  String _base64Var;
  void handleResponse(response, {String appName}) {
    if (response == 0) {
      print("failed.");
    } else if (response == 1) {
      print("success");
    } else if (response == 2) {
      print("application isn't installed");
      if (appName != null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Error'),
          duration: Duration(seconds: 1),
        ));
        // scaffoldKey.currentState.
        // scaffoldKey.currentState.showSnackBar(new SnackBar(
        //   content: new Text("${appName} isn't installed."),
        //   duration: new Duration(seconds: 4),
        // ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 0),
                child: Text(
                  '0',
                  style: TextStyle(fontSize: 10, color: Colors.black38),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.share,
                ),
                onPressed: () {
                  print(
                      'media url: ${widget.documentSnapshot['uploaded_media_url']}');
                  _base64(widget.documentSnapshot['uploaded_media_url'])
                      .then((s) {
                    _share(widget.documentSnapshot['uploaded_media_url']);
                  });

                  // widget.whatsAppShare();
                },
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  '122',
                  style: TextStyle(fontSize: 10, color: Colors.black38),
                ),
              ),
              CommentIcon(),
            ],
          ),
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 4),
                child: Text(
                  '122',
                  style: TextStyle(fontSize: 10, color: Colors.black38),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                ),
                onPressed: () {
                  Firestore.instance
                      .collection('/activity_data/')
                      .document()
                      .setData({});
                },
              ),
            ],
          ),
          // Container(),
          // Container(),
          // Stack(
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.only(left: 12, top: 4),
          //       child: Text(
          //         '122',
          //         style: TextStyle(fontSize: 10, color: Colors.black38),
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () {},
          //       icon: Icon(Icons.arrow_downward),
          //     ),
          //   ],
          // ),
          // Stack(
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.only(left: 9, top: 1),
          //       child: Text(
          //         '122',
          //         style: TextStyle(fontSize: 10, color: Colors.black38),
          //       ),
          //     ),
          //     Container(
          //       padding: EdgeInsets.only(top: 12),
          //       child: InkWell(
          //         splashColor: Colors.white12,
          //         onTap: () {
          //           whatsAppShare();
          //         },
          //         child: Image.asset(
          //           'assets/whatsapp.png',
          //           scale: 1.86,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo/components/activity_card_icons.dart';
import 'package:duo/components/custom_card.dart';
import 'package:duo/components/inherit.dart';
import 'package:duo/user_profile_components/user_profile.dart';
import 'package:duo/media_controller.dart/video_player.dart';
import 'package:flutter/material.dart';
import "package:ok_image/ok_image.dart";
import 'package:spritewidget/spritewidget.dart';
import 'package:photofilters/photofilters.dart';

class ActivityCard extends StatefulWidget {
  final String profileUrl, name, uploadedMediaUrl, type, userEmaidlID;
  final PageStorageKey key;
  final DocumentSnapshot documentsnapShot;
  ActivityCard(
      {this.profileUrl,
      this.documentsnapShot,
      this.name,
      this.uploadedMediaUrl,
      this.key,
      this.type,
      this.userEmaidlID});

  @override
  ActivityCardState createState() {
    return new ActivityCardState();
  }
}

class ActivityCardState extends State<ActivityCard> {
  bool isLoading = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String url;
  @override
  void initState() {
    if (widget.type == 'image') url = widget.uploadedMediaUrl;
    super.initState();
  }

  void share() {
    print('shared whats app ${widget.documentsnapShot['media_url']}');
    // whatsAppShare(widget.uploadedMediaUrl, scaffoldKey);
  }

  Widget _buildActivity() {
    switch (widget.type) {
      case 'image':
        return Container(
          child: OKImage(
              url: widget.uploadedMediaUrl,
              errorWidget: Text('network error'),
              loadingWidget: Container(
                color: Colors.grey,
              )),
        );

        break;
      case 'video':
        return VideoPlayers(
          videoPath: widget.uploadedMediaUrl,
        );
        break;
      case 'text':
        return Text(widget.uploadedMediaUrl);
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userDetail = MPInheritedWidget.of(context);
    return SafeArea(
      key: scaffoldKey,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: CustomCard(
          // margin: EdgeInsets.only(left: 20, right: 20),
          // decoration: BoxDecoration(
          //     color: Colors.white70,
          //     border: Border(
          //         top: BorderSide(
          //             color: Colors.black12,
          //             width: 2.0,
          //             style: BorderStyle.solid),
          //         bottom: BorderSide(
          //             color: Colors.black12,
          //             width: 2.0,
          //             style: BorderStyle.solid))),

          child: Theme(
            data: ThemeData(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
            child: FutureBuilder(
              builder: (context, asyncSnapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  image: DecorationImage(
                                      image: NetworkImage(widget.profileUrl),
                                      fit: BoxFit.fill)),
                              // child: Image.network(widget.profileUrl),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserProfile(
                                      userData: userDetail.user,
                                      userID: widget
                                          .documentsnapShot['user_email_id'],
                                      documentSnapshot: widget.documentsnapShot,
                                    )));
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return AlertDialog(
                            //         shape: BeveledRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.all(Radius.circular(4))),
                            //         actions: <Widget>[],
                            //         title: AspectRatio(
                            //           aspectRatio: 1.0,
                            //           child: FittedBox(
                            //             child: Image.network(widget.profileUrl),
                            //             fit: BoxFit.fill,
                            //           ),
                            //         ),
                            //       );
                            //     });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2, top: 20),
                          child: InkWell(
                            onTap: () {
                              print(
                                  'other users ${widget.userEmaidlID}, ${userDetail.user.getEmailId},media ${widget.documentsnapShot.documentID}');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        userData: userDetail.user,
                                        userID: widget
                                            .documentsnapShot['user_email_id'],
                                        documentSnapshot:
                                            widget.documentsnapShot,
                                      )));
                            },
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: Colors.blue),
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(3.0))),
                        //     child: InkWell(
                        //       child: Text(
                        //         'Follow',
                        //         style: TextStyle(color: Colors.blueAccent),
                        //       ),
                        //       onTap: () {},
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    AspectRatio(
                      aspectRatio: .80,
                      child: widget.uploadedMediaUrl != null
                          ? _buildActivity()
                          : SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(),
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        'liked by 40 people adakjdh ahdka hdkahdksahdj dsadkadas dsahdkjsahdkhas adkjsadh kdhsakhd  dh dh ahs dhksahdhdhsa',
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: Divider(
                        height: 2.0,
                        indent: 2.0,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: ActivityCardIcons(
                        whatsAppShare: () {
                          share();
                        },
                        documentSnapshot: widget.documentsnapShot,
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: TextFormField(
                    //     onFieldSubmitted: (s) {
                    //       print('completed: ${userDetail.user.getEmailId}');
                    //       Firestore.instance
                    //           .collection(
                    //               '${widget.documentsnapShot['data_base_path']}/${widget.documentsnapShot.documentID}/like_comment_collection')
                    //           .document(userDetail.user.getEmailId)
                    //           .collection(userDetail.user.getEmailId)
                    //           .document()
                    //           .setData({
                    //         'name': widget.documentsnapShot['user_name'],
                    //         'id': userDetail.user.getEmailId,
                    //         'comment': s,
                    //         'date_and_time': DateTime.now()
                    //       });
                    //     },
                    //     scrollPadding: EdgeInsets.all(20),
                    //     maxLengthEnforced: true,
                    //     decoration: InputDecoration.collapsed(
                    //         hasFloatingPlaceholder: true,
                    //         hintText: 'comment..',
                    //         border: OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //                 width: 2,
                    //                 style: BorderStyle.solid,
                    //                 color: Colors.black),
                    //             borderRadius: BorderRadius.circular(10))),
                    //   ),
                    // )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NodeWithSized extends NodeWithSize {
  NodeWithSized(Size size) : super(size);
  Color colorTop;
  Color colorBottom;
  @override
  void paint(Canvas canvas) {
    applyTransformForPivot(canvas);

    Rect rect = Offset.zero & size;
    Paint gradientPaint = new Paint()
      ..shader = new LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomLeft,
          colors: <Color>[colorTop, colorBottom],
          stops: <double>[0.0, 1.0]).createShader(rect);

    canvas.drawRect(rect, gradientPaint);
  }
}

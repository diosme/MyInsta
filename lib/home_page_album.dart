import 'dart:io';
import 'package:duo/components/album_card.dart';
import 'package:duo/components/inherit.dart';
import 'package:duo/components/theme.dart';
import 'package:duo/components/user_detail.dart';
import 'package:duo/splash_page.dart';
import 'package:duo/main_activity_page/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'authentication.dart';

class HomePageAlbum extends StatefulWidget {
  final UsersData userDetail;
  HomePageAlbum({this.userDetail}) {
    print('users: ${userDetail.getImageUrl}');
  }

  @override
  _AlbumState createState() => new _AlbumState();
}

class _AlbumState extends State<HomePageAlbum> {
  DocumentSnapshot documentSnapshot;
  Stream<QuerySnapshot> stream;
  @override
  initState() {
    print('${widget.userDetail.getEmailId}');
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  static List<String> _album = [
    'Hindi',
    'English',
    'Punjabi',
    'Bengali',
    'songs',
    'song',
    'songs',
    'song',
  ];
  List<BoxShadow> _shadow = [
    BoxShadow(blurRadius: 1.0, spreadRadius: 2.0, color: Colors.redAccent),
  ];
  ThemeData data = ThemeData();
  FocusNode hasFocus = FocusNode();

  int _currentIndex = 0;
  StorageReference storageReference;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String str;
  Choice _selectedChoice = choices[0];
  var uuid;
  Future _upload(String media, String type) async {
    if (type == 'image') {
      str = '.jpg';
    } else if (type == 'video') {
      str = '.mp4';
    }
    uuid = Uuid().v1() + str;
    print('str $str, $media');
    StorageUploadTask task;
    if (type != 'text') {
      storageReference = FirebaseStorage.instance.ref().child(uuid);
      task = storageReference.putFile(
          File(media),
          StorageMetadata(
            contentLanguage: 'en',
          ));
      task.events.listen((s) {
        if (s.type == StorageTaskEventType.progress) {
        } else if (s.type == StorageTaskEventType.success) {
          print('success');
          storageReference.getDownloadURL().then((path) {
            Firestore.instance
                .collection('media_storage_info')
                .document()
                .setData({
              'likes': 0,
              'comments': 0,
              'shared': 0,
              'user_name': widget.userDetail.getUserName,
              'uploaded_media_url': path,
              'user_email_id': widget.userDetail.getEmailId,
              'media_type': type,
              'profile_photo_url': widget.userDetail.getImageUrl,
              'date_and_time': DateTime.now(),
              'uid': widget.userDetail.getUserUid
            }).then((s) {});
          });
        } else if (s.type == StorageTaskEventType.failure) {}
      });
    } else {
      Firestore.instance
          .collection(
              '/activity_data/${widget.userDetail.getEmailId}/${widget.userDetail.getEmailId}')
          .document()
          .setData({
        'user_name': widget.userDetail.getUserName,
        'text': media,
        'user_email_id': widget.userDetail.getEmailId,
        'media_type': type,
        'profile_photo_url': widget.userDetail.getImageUrl,
      }).then((s) {});
    }
  }

  // Widget _buildItems() {
  //   switch (_currentIndex) {
  //     case 0:
  //       return new Container(
  //         child: GridView(
  //           children: _album
  //               .map((k) => AlbumCard(
  //                     text: k,
  //                   ))
  //               .toList(),
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2, childAspectRatio: 1.0),
  //         ),
  //       );
  //       break;
  //     case 1:
  //       return Activity();
  //       break;
  //     default:
  //       return Container();
  //   }
  // }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: _currentIndex == 0 ? Text('Album') : Text('Activity'),
        backgroundColor: Colors.redAccent,
        elevation: 2.0,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Container(width: 200, child: Text(choice.title)),
                );
              }).toList();
            },
          ),
        ],
      ),
      floatingActionButton: Container(
          child: CircleAvatar(
        child: IconButton(
          icon: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            showModalBottomSheet(
                builder: (BuildContext context) {
                  return Container(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          child: IconButton(
                            icon: Icon(Icons.camera_enhance),
                            onPressed: () {
                              ImagePicker.pickImage(
                                source: ImageSource.camera,
                              ).then((s) {
                                UsersData().compressImage(s.path).then((s) {
                                  if (s != null) _upload(s, 'image');
                                });
                              });
                            },
                          ),
                          backgroundColor: circleAvtarColor,
                        ),
                        CircleAvatar(
                          child: IconButton(
                            icon: Icon(Icons.photo),
                            onPressed: () {
                              ImagePicker.pickImage(
                                source: ImageSource.gallery,
                              ).then((s) {
                                if (s != null)
                                  _upload(s.path, 'image').then((s) {});
                              });
                            },
                          ),
                          backgroundColor: circleAvtarColor,
                        ),
                        CircleAvatar(
                          child: IconButton(
                            icon: Icon(Icons.mic),
                            onPressed: () {},
                          ),
                          backgroundColor: circleAvtarColor,
                        ),
                        CircleAvatar(
                          child: IconButton(
                            icon: Icon(Icons.videocam),
                            onPressed: () {
                              ImagePicker.pickVideo(
                                source: ImageSource.camera,
                              ).then((s) {
                                if (s != null) {
                                  print('videp path:$s');
                                  _upload(s.path, 'video').then((s) {});
                                }
                              });
                            },
                          ),
                          backgroundColor: circleAvtarColor,
                        ),
                        CircleAvatar(
                          child: IconButton(
                            icon: Icon(Icons.text_fields),
                            onPressed: () {},
                          ),
                          backgroundColor: circleAvtarColor,
                        ),
                      ],
                    ),
                  );
                },
                context: context);
          },
        ),
        maxRadius: 25,
        backgroundColor: Colors.redAccent,
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.userDetail.getUserName),
              accountEmail: Text(widget.userDetail.getEmailId),
              currentAccountPicture: CircleAvatar(
                child: widget.userDetail.getImageUrl != null
                    ? Image.network(widget.userDetail.getImageUrl) ??
                        Container()
                    : Container(),
                backgroundColor: Colors.white,
              ),
              decoration: BoxDecoration(color: Colors.redAccent),
            ),
            ListTile(
              leading: Icon(Icons.blur_circular),
              isThreeLine: true,
              subtitle: Text('Night Mode'),
              onTap: () {},
              trailing: Switch(
                onChanged: (b) {},
                value: false,
              ),
            ),
            ListTile(
              leading: Icon(Icons.ac_unit),
              isThreeLine: true,
              subtitle: Text('App Theme'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              isThreeLine: true,
              subtitle: Text('Setting'),
              onTap: () {},
            ),
            Divider(
              height: 1.0,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              isThreeLine: true,
              subtitle: Text('Log Out'),
              onTap: () {
                signOutWithGoogle().then((s) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SplashPage()));
                });
              },
            ),
            FlatButton(
              onPressed: () {},
              child: Text("About"),
            ),
          ],
        ),
      ),
      body: MPInheritedWidget(
        child: Activity(
            logInUser: widget.userDetail), // child: _children[_currentIndex],
        user: widget.userDetail,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   fixedColor: Colors.redAccent,
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     print('index $index');
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.music_note,
      //         ),
      //         title: Text(
      //           'Music',
      //         ),
      //         backgroundColor: Colors.white),
      //     // BottomNavigationBarItem(
      //     //     icon: Icon(
      //     //       Icons.audiotrack,
      //     //     ),
      //     //     title: Text(
      //     //       'Record songs',
      //     //     ),
      //     //     backgroundColor: Colors.white),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.cloud_upload,
      //         ),
      //         title: Text('Upload'),
      //         backgroundColor: Colors.white)
      //   ],
      // ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

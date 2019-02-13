import 'dart:async';
import 'package:duo/home_page_album.dart';
import 'package:duo/authentication.dart';
import 'package:duo/components/inherit.dart';
import 'package:duo/components/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shimmer/shimmer.dart';

class SplashPage extends StatefulWidget {
  final Firestore firestore;
  SplashPage({this.firestore});
  @override
  State createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StatelessWidget s;
  UsersData users = new UsersData();
  @override
  void initState() {
    super.initState();
    _initState();
  }

  _initState() {
    firebaseAuth.onAuthStateChanged
        .firstWhere((user) => user != null)
        .then((user) {
      // users.userUid = user.uid;
      users.name = user.displayName;
      users.image = user.photoUrl;
      users.emaild = user.email;
      users.userUid = user.uid;

      // print('${user.uid}, ${user.email}');
      Firestore.instance
          .collection('activity_data')
          .document(user.email)
          .setData({
        'profile_photo_url': user.photoUrl,
        'user_name': user.displayName,
        'user_email_id': user.email,
        'uid': user.uid,
        'date_and_time': DateTime.now()
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePageAlbum(
                userDetail: users,
              )));
    });
    // Give the navigation animations, etc, some time to finish
    new Future.delayed(new Duration(seconds: 2))
        .then((_) => signInWithGoogle());
    // new Future.delayed(Duration(seconds: 2)).then((face) {
    //   singIntWithFacebook();
    //   FacebookLoginResult k = face;
    //   print('sadsada ${k.accessToken.userId}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MPInheritedWidget(
        user: users,
        child: new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/Phone-Wallpapers-iPhone-7-resolutionArtboard-1.png',
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * .7,
              width: MediaQuery.of(context).size.width * .7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.yellow],
                    begin: AlignmentDirectional.topCenter,
                    end: AlignmentDirectional.bottomEnd),
              ),
              child: Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow,
                  child: Text(
                    'MyInsta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // new SizedBox(width: 20.0),
          ],
        ),
      ),
    );
  }
}

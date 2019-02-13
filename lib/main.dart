import 'package:duo/home_page_album.dart';
import 'package:duo/front.dart';
import 'package:duo/home.dart';
import 'package:duo/model/model.dart';
import 'package:duo/recorder.dart';
import 'package:duo/redux/middleware.dart';
import 'package:duo/redux/reducer.dart';
import 'package:duo/splash_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

Recorder recorder = Recorder();
Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'duoapp',
    options: const FirebaseOptions(
      googleAppID: '1:207219807399:android:8238cfb40ea7b589',
      gcmSenderID: '207219807399',
      apiKey: 'AIzaSyArTU6ivl1TNoGLW_FxxqrnGdu0AYIWwCw',
      projectID: 'duoapp-6b7cb',
    ),
  );
  final Firestore firestore = Firestore(app: app);
  await firestore.settings(timestampsInSnapshotsEnabled: true);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {}
  ThemeData themeData = new ThemeData(
      canvasColor: Colors.black,
      textSelectionColor: Colors.white,
      textSelectionHandleColor: Colors.white,
      textTheme: TextTheme(
          title: TextStyle(color: Colors.white),
          subtitle: TextStyle(color: Colors.white)));
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData.light(),
      title: 'songs',
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/front': (BuildContext context) => FrontPage(),
        '/home': (BuildContext context) => HomePage(),
      },
    );
  }
}

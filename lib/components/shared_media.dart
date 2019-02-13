// import 'package:advanced_share/advanced_share.dart' show AdvancedShare;
// import 'package:flutter/material.dart';

// Future whatsAppShare(String url, GlobalKey key) async {
//   print('url:: $url');
//   AdvancedShare.whatsapp(msg: "It's okay :)", url: url).then((response) {
//     handleResponse(
//       response,
//       key,
//       appName: "Whatsapp",
//     );
//   });
// }

// void handleResponse(response, GlobalKey scaffoldKey, {String appName}) {
//   if (response == 0) {
//     print("failed.");
//   } else if (response == 1) {
//     print("success");
//   } else if (response == 2) {
//     print("application isn't installed");
//     if (appName != null) {
//       print('isnt installed');
//       // scaffoldKey.currentState.showSnackBar(new SnackBar(
//       //   content: new Text("${appName} isn't installed."),
//       //   duration: new Duration(seconds: 4),
//       // ));
//     }
//   }
// }

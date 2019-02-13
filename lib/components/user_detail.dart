import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

abstract class AbstractContainer {
  Firestore firestore = Firestore();
  ThemeData themeData;
  String name,
      image,
      emaild,
      likes,
      comments,
      shared,
      whatsAppShared,
      downlaod,
      uploadedMedaiUrl,
      mediaType,
      userUid;
  DocumentSnapshot documentSnapshot;
  Future<String> compressImage(String imagePath) async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';
    Img.Image image = Img.decodeImage(File(imagePath).readAsBytesSync());
//  print("image original ht and wid: ${image.height} , ${image.width}");
    var cp = Img.copyResize(image, 300, 600);
    var c = File(filePath)..writeAsBytesSync(Img.encodePng(cp));
//  print("compressed image:: ${cp.height}, ${cp.width}");
    return c.path;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}

class UsersData extends AbstractContainer {
  UsersData() {}
  Future<String> compressImage(String path);
  String get getUserName => name;
  String get getImageUrl => image;
  String get getEmailId => emaild;
  String get getLikes => likes;
  String get getCommnets => comments;
  String get getShared => shared;
  String get getWhatsAppShared => whatsAppShared;
  String get getDownload => downlaod;
  String get getuploadedMedaiUrl => uploadedMedaiUrl;
  String get getMediaType => mediaType;
  String get getUserUid => userUid;
  Firestore get getFirestore => firestore;
  DocumentSnapshot get getDocmentsnapShpt => documentSnapshot;
}

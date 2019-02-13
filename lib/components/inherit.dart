import 'package:duo/components/user_detail.dart';
import 'package:duo/recorder.dart';
import 'package:flutter/material.dart';

class MPInheritedWidget extends InheritedWidget {
  final Recorder recorder;
  final UsersData user;
  final bool isLoading;
  const MPInheritedWidget({this.recorder, this.isLoading, child, this.user})
      : super(child: child);

  static MPInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MPInheritedWidget);
  }

  @override
  bool updateShouldNotify(MPInheritedWidget oldWidget) =>
      // TODO: implement updateShouldNotify
      user != oldWidget.user;
}

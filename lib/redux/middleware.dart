import 'package:duo/model/model.dart';
import 'package:redux/redux.dart';

void appStateMiddleWare(Store<AppState> store, action, NextDispatcher next) {
  print('reducer::');
  next(store);
}

class MiddleWares {}

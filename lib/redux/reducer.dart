import 'package:duo/model/model.dart';
import 'package:duo/components/user_detail.dart';

AppState reducer(AppState state, action) {
  return AppState(userDetail: initReducer(state.userDetail, action));
}

UsersData initReducer(UsersData state, action) {
  return UsersData();
}

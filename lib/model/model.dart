import 'package:duo/components/user_detail.dart';
import 'package:redux/redux.dart';

class AppState {
  UsersData userDetail;
  int i = 0;
  AppState({this.i, this.userDetail});
  AppState.initialState() : i = 0;
}

class ViewModel {
  ViewModel();
  factory ViewModel.create(Store<AppState> store) {
    return ViewModel();
  }
}

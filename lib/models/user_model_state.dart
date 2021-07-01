import 'dart:async';
import 'package:bobotagram/models/firestore/user_model.dart';
import 'package:flutter/foundation.dart';

class UserModelState extends ChangeNotifier {
  UserModel _userModel;
  StreamSubscription<UserModel> _currentStreamSub;

  UserModel get userModel => _userModel; //필요할때 유저모델을 접근할수 있게 게터

  //값 변경될때마다 알려주는 역할.
  set userModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }

  set currentStreamSub(StreamSubscription<UserModel> currentStreamSub) =>
      _currentStreamSub;

  clear() async {
    if (_currentStreamSub != null) await _currentStreamSub.cancel();
    _currentStreamSub = null;
    _userModel = null;
  }

  bool amIFollowingThisUser(String otherUserKey) {
    if (_userModel == null ||
        _userModel.followings == null ||
        _userModel.followings.isEmpty)
      return false;
    else
      return _userModel.followings.contains(otherUserKey);
  }
}

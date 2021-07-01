import 'package:bobotagram/constants/duration.dart';
import 'package:bobotagram/constants/material_white.dart';
import 'package:bobotagram/home_page.dart';
import 'package:bobotagram/models/firebase_auth_state.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/repo/user_network_repository.dart';
import 'package:bobotagram/screens/auth_screen.dart';
import 'package:bobotagram/widgets/my_progress_indicator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Sth went wrong. please try again later'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }
          return MyProgressIndicator(); //로딩페이지
        });
  }
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthState>.value(
            //기존에 생성되어있는 인스턴스를 넣어
            value: _firebaseAuthState),
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        ),
      ],
      child: MaterialApp(
        home: Consumer<FirebaseAuthState>(
          builder: (BuildContext context, FirebaseAuthState firebaseAuthState,
              Widget child) {
            switch (firebaseAuthState.firebaseAuthStatus) {
              case FirebaseAuthStatus.signout:
                _clearUserModel(context);
                _currentWidget = AuthScreen();
                break;
              case FirebaseAuthStatus.signin:
                _initUserModel(firebaseAuthState, context);
                _currentWidget = HomePage();
                break;
              default:
                _currentWidget = MyProgressIndicator();
            }
            return AnimatedSwitcher(
              duration: duration,
              child: _currentWidget,
            );
          },
        ),
        theme: ThemeData(primarySwatch: white),
      ),
    );
  }

  void _initUserModel(
      FirebaseAuthState firebaseAuthState, BuildContext context) {
    UserModelState userModelState = Provider.of<UserModelState>(context,
        listen: false); //listen false는 사용하는 부분에 notifyListners가 있으면 써줌

    userModelState.currentStreamSub = userNetworkRepository
        .getUserModelStream(firebaseAuthState.user.uid)
        .listen((userModel) {
      userModelState.userModel = userModel;
    });
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState =
        Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }
}

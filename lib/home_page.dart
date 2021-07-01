import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/models/user_model_state.dart';
import 'package:bobotagram/screens/camera_screen.dart';
import 'package:bobotagram/screens/feed_screen.dart';
import 'package:bobotagram/screens/profile_screen.dart';
import 'package:bobotagram/screens/search_screen.dart';
import 'package:bobotagram/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.healing), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: ""),
  ];

  int _selectedIndex = 0;

  static List<Widget> _screens = [
    Consumer<UserModelState>(builder: (context, userModelState, child) {
      if (userModelState == null ||
          userModelState.userModel == null ||
          userModelState.userModel.followings == null ||
          userModelState.userModel.followings.isEmpty)
        return MyProgressIndicator();
      return FeedScreen(userModelState.userModel.followings);
    }),
    SearchScreen(),
    Container(
      color: Colors.greenAccent,
    ),
    Container(
      color: Colors.purpleAccent,
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: btmNavItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black87,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onBtmItemClick,
      ),
    );
  }

  void _onBtmItemClick(int index) {
    switch (index) {
      case 2:
        _openCamera();
        break;
      default:
        {
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        }
    }
  }

  void _openCamera() async {
    if (await checkIfPermissionGranted(context)) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CameraScreen()));
    } else {
      SnackBar snackBar = SnackBar(
        content: Text('사진, 파일, 마이크 접근 허용 해주셔야 카메라 사용이 가능합니다'),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            AppSettings.openAppSettings();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<bool> checkIfPermissionGranted(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Platform.isIOS ? Permission.photos : Permission.storage,
    ].request();
    bool permitted = true;

    statuses.forEach((permission, permissionstatus) {
      if (!permissionstatus.isGranted) permitted = false;
    });

    return permitted;
  }
}

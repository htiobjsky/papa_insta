import 'package:bobotagram/constants/duration.dart';
import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/widgets/profile_body.dart';
import 'package:bobotagram/widgets/profile_side_menu.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final menuWidth = size.width / 3 * 2;
  MenuStatus _menuStatus = MenuStatus.closed;
  double bodyXPos = 0;
  double menuXPos = size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          AnimatedContainer(
            duration: duration,
            child: ProfileSideMenu(menuWidth),
            transform: Matrix4.translationValues(menuXPos, 0, 0),
            curve: Curves.fastOutSlowIn,
          ),
          AnimatedContainer(
            duration: duration,
            child: ProfileBody(
              onMenuChanged: () {
                setState(() {
                  _menuStatus = (_menuStatus == MenuStatus.closed)
                      ? MenuStatus.opended
                      : MenuStatus.closed;
                  switch (_menuStatus) {
                    case MenuStatus.opended:
                      bodyXPos = -menuWidth;
                      menuXPos = size.width - menuWidth;
                      break;
                    case MenuStatus.closed:
                      bodyXPos = 0;
                      menuXPos = size.width;
                      break;
                  }
                });
              },
            ),
            transform: Matrix4.translationValues(bodyXPos, 0, 0),
            curve: Curves.fastOutSlowIn,
          ),
        ],
      ),
    );
  }
}

enum MenuStatus { opended, closed }

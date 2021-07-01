import 'package:bobotagram/constants/screen_size.dart';
import 'package:bobotagram/models/firebase_auth_state.dart';
import 'package:bobotagram/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSideMenu extends StatelessWidget {
  const ProfileSideMenu(
    this.menuWidth, {
    Key key,
  }) : super(key: key);
  final double menuWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                "Settings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                // Navigator.of(context).pushReplacement(
                //     MaterialPageRoute(builder: (context) => AuthScreen()));
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .signOut();
              },
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black87,
              ),
              title: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}

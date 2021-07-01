import 'package:bobotagram/constants/duration.dart';
import 'package:bobotagram/widgets/fade_stack.dart';
import 'package:bobotagram/widgets/sign_in_form.dart';
import 'package:bobotagram/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int selectedForm = 0;

  Widget currentWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            FadeStack(
              selectedForm: selectedForm,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40,
              child: Container(
                color: Colors.white,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (selectedForm == 0) {
                        selectedForm = 1;
                      } else {
                        selectedForm = 0;
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    //side: BorderSide(color: Colors.grey),
                    //shape: Border(top: BorderSide(color: Colors.grey)),
                  ),
                  child: RichText(
                    text: TextSpan(
                        text: selectedForm == 0
                            ? "Already have an account? "
                            : "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: selectedForm == 0 ? "Sign In" : "Sing Up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

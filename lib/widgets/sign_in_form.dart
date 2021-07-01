import 'package:bobotagram/constants/common_size.dart';
import 'package:bobotagram/home_page.dart';
import 'package:bobotagram/models/firebase_auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({Key key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: common_l_gap),
                Image.asset("assets/images/insta_text_logo.png"),
                TextFormField(
                  controller: _emailController,
                  decoration: _textInputDecor("Email"),
                  cursorColor: Colors.black54,
                  validator: (text) {
                    if (text.isNotEmpty && text.contains("@")) {
                      return null;
                    } else {
                      return "정확한 이메일 주소를 입력해주세요";
                    }
                  },
                ),
                SizedBox(
                  height: common_xs_gap,
                ),
                TextFormField(
                  controller: _pwController,
                  decoration: _textInputDecor("Password"),
                  cursorColor: Colors.black54,
                  obscureText: true,
                  validator: (text) {
                    if (text.isNotEmpty && text.length > 5) {
                      return null;
                    } else {
                      return "제대로된 비밀번호를 입력해주세요";
                    }
                  },
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgotten Password?"),
                  ),
                ),
                SizedBox(
                  height: common_s_gap,
                ),
                _submitButton(context),
                SizedBox(
                  height: common_s_gap,
                ),
                Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: common_s_gap,
                ),
                TextButton.icon(
                  onPressed: () {
                    Provider.of<FirebaseAuthState>(context, listen: false)
                        .loginWithFacebook(context);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  icon: ImageIcon(AssetImage("assets/images/google.png")),
                  label: Text(
                    "Login with Google",
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Provider.of<FirebaseAuthState>(context, listen: false)
                        .loginWithFacebook(context);
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.blueAccent,
                  ),
                  icon: ImageIcon(AssetImage("assets/images/facebook.png")),
                  label: Text(
                    "Login with Facebook",
                  ),
                ),
              ],
            )),
      ),
    );
  }

  TextButton _submitButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          print("validation success");
          Provider.of<FirebaseAuthState>(context, listen: false).login(context,
              email: _emailController.text, password: _pwController.text);
        } else {}
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(common_xxx_gap)),
      ),
      child: Text(
        "Sign In",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  InputDecoration _textInputDecor(String hintText) {
    return InputDecoration(
        hintText: hintText,
        enabledBorder: _activeInputBorder(),
        focusedBorder: _activeInputBorder(),
        errorBorder: _errorInputBorder(),
        focusedErrorBorder: _errorInputBorder(),
        filled: true,
        fillColor: Colors.grey[100]);
  }

  OutlineInputBorder _errorInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.redAccent,
      ),
      borderRadius: BorderRadius.circular(common_s_gap),
    );
  }

  OutlineInputBorder _activeInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[300],
      ),
      borderRadius: BorderRadius.circular(common_s_gap),
    );
  }
}

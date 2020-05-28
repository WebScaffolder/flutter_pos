import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _login_screen();
  }
}

class _login_screen extends State<login_screen>
    with SingleTickerProviderStateMixin {
  //email and password textfield controllers
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //init firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(context),
      ),
    );
  }

  loginBody(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields(context)],
        ),
      );

  loginHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/images/app_logo.png',
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            languages.skeleton_language_objects[config.app_language]
                ['welcome_back'],
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
                color: Colors.purple,
                fontFamily: "Roboto"),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            languages.skeleton_language_objects[config.app_language]
                ['sign_in_to_continue'],
            style: TextStyle(
                color: Colors.black38, fontSize: 12.0, fontFamily: "Roboto"),
          ),
        ],
      );

  loginFields(BuildContext context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                controller: emailController,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText:
                        languages.skeleton_language_objects[config.app_language]
                            ['enter_your_email_address'],
                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText:
                        languages.skeleton_language_objects[config.app_language]
                            ['email'],
                    labelStyle:
                        TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                controller: passwordController,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                    hintText:
                        languages.skeleton_language_objects[config.app_language]
                            ['enter_your_password'],
                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText:
                        languages.skeleton_language_objects[config.app_language]
                            ['password'],
                    labelStyle:
                        TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 45.0),
              width: double.infinity,
              height: 45,
              child: MaterialButton(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  languages.skeleton_language_objects[config.app_language]
                      ['sign_in'],
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepOrange,
                onPressed: () {
                  if (emailController.text.length > 5 &&
                      passwordController.text.length > 4) {
                    signInWithEmail(context);
                  } else {
                    Fluttertoast.showToast(
                        msg: languages
                                .skeleton_language_objects[config.app_language]
                            ['enter_all_your_fields'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 45.0),
              width: double.infinity,
              height: 45,
              child: MaterialButton(
                height: 55,
                child: Text(
                  languages.skeleton_language_objects[config.app_language]
                      ['forgot_password'],
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.deepPurple,
                minWidth: 150,
                onPressed: () {
                  navigation.goChangePassword(context);
                },
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            GestureDetector(
              child: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['terms_and_condition'],
                style: TextStyle(
                    color: Colors.grey, fontSize: 12.0, fontFamily: "Roboto"),
              ),
              onTap: () {
                _launchURL();
              },
            )
          ],
        ),
      );

  ///set user logged out  on shared pref
  void set_user_guest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_state", "guest_user");
  }

  ///set user logged in  on shared pref
  void set_user_auth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_state", "auth_user");
  }

  //func to signin
  void signInWithEmail(BuildContext context) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if (user != null) {
      navigation.goToDashboard(context);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_state", "auth_user");
      await prefs.setString("user_id", user.uid);
      await prefs.setString("email", user.email);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_state", "guest_user");

      print(prefs.get("user_state"));
    }
  }

  //this launches terms and condition page
  _launchURL() async {}
}

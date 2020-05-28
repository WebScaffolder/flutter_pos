import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/intro_screen_contents.dart';
import 'package:spree/Utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Utils/languages.dart';

class signup_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _signup_screen();
  }
}

class _signup_screen extends State<signup_screen>
    with SingleTickerProviderStateMixin {
  //fireabase init
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //email and password controller
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: signupBody(context),
      ),
    );
  }

  signupBody(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[signupHeader(), signupFields(context)],
        ),
      );

  signupHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/images/app_logo_plain.png',
            height: 100,
            width: 100,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            languages.skeleton_language_objects[config.app_language]['Spree_welcomes_you'],
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
            languages.skeleton_language_objects[config.app_language]['signin_to_manage_youre_store'],
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontFamily: "Roboto"),
          ),
        ],
      );

  signupFields(BuildContext context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                maxLength: 30,

//            keyboardType: ,
                decoration: InputDecoration(
                    hintText: languages.skeleton_language_objects[config.app_language]['enter_your_email_address'],
                    hintStyle:
                        TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText: languages.skeleton_language_objects[config.app_language]['email'],
                    labelStyle: TextStyle(
                        fontSize: 12.0, fontFamily: "Roboto")),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: languages.skeleton_language_objects[config.app_language]['enter_your_password'],
                    hintStyle:
                        TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText: languages.skeleton_language_objects[config.app_language]['password'],
                    labelStyle: TextStyle(
                        fontSize: 12.0, fontFamily: "Roboto")),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: FlatButton(
                child: Text(
                  languages.skeleton_language_objects[config.app_language]['signup'],
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                ),
                color: Colors.deepOrange,
                onPressed: () {
                  if (passwordController.text.length > 4 &&
                      emailController.text.length > 4) {
                    Fluttertoast.showToast(
                        msg: languages.skeleton_language_objects[config.app_language]['creating_your_account'],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    signUp(
                        emailController.text, passwordController.text, context);
                  } else {
                    Fluttertoast.showToast(
                        msg: languages.skeleton_language_objects[config.app_language]['enter_all_Fields'],
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
              height: 40.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: FlatButton(
                child: Text(
                  languages.skeleton_language_objects[config.app_language]['back_to_login'],
                  style: TextStyle(color: Colors.deepPurple, fontSize: 12.0),
                ),
                color: Colors.white,
                onPressed: () {
                  navigation.goToLogin(context);
                },
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              child: Text(
                languages.skeleton_language_objects[config.app_language]['terms_and_condition'],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontFamily: "Roboto"),
              ),
              onTap: () {
                _launchURL();
              },
            )
          ],
        ),
      );

  //signup func
  Future<String> signUp(String email, String password, context) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (user.uid.toString().length > 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_state", "auth_user");
      await prefs.setString("user_id", user.uid);
      await prefs.setString("email", user.email);

      Fluttertoast.showToast(
          msg: languages.skeleton_language_objects[config.app_language]['welcome_to'] + intro_screen_contents.name,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      navigation.goToDashboard(context);
    }

    return user.uid;
  }

  //launch terms page
  _launchURL() async {
  }
}

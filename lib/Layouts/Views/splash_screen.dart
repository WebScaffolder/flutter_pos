import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spree/Utils/intro_screen_contents.dart';
import 'package:spree/Utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash_screen extends StatefulWidget {
  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    get_user_state();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/app_logo.png',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        intro_screen_contents.name,
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Roboto",
                          fontSize: 18.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(strokeWidth: 2),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      intro_screen_contents.store,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 11.0,
                          color: Colors.black38),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ));
  }

  //checks user state
  void get_user_state() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String user_state = (prefs.getString('user_state') ?? '') + "///";

      if (user_state == "///") {
        Timer(Duration(seconds: 3), () => navigation.goToIntro(context));
      } else if (user_state.contains("auth_user")) {
        Timer(Duration(seconds: 3), () => navigation.goToDashboard(context));
      } else if (user_state.contains("guest_user")) {
        Timer(Duration(seconds: 3), () => navigation.goToLogin(context));
      }
    });
  }

}

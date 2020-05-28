import 'package:flutter/material.dart';
import 'package:spree/Layouts/Views/dashboard_screen.dart';
import 'package:spree/Layouts/Views/forgot_screen.dart';
import 'package:spree/Layouts/Views/intro_screen.dart';
import 'package:spree/Layouts/Views/login_screen.dart';
import 'package:spree/Layouts/Views/signup_screen.dart';
import 'package:spree/Layouts/Views/splash_screen.dart';

//routes for widget builder
var routes = <String, WidgetBuilder>{
  "/dashboard": (BuildContext context) => dashboard_screen(),
  "/intro": (BuildContext context) => intro_screen(),
  "/login": (BuildContext context) => login_screen(),
  "/signup": (BuildContext context) => signup_screen(),
  "/forgot": (BuildContext context) => forgot_screen(),
};

//change this to your desired app colors
void main() => runApp(new MaterialApp(
    theme: ThemeData(primaryColor: Colors.deepPurple, accentColor: Colors.pink),
    debugShowCheckedModeBanner: false,
    home: splash_screen(),
    routes: routes));

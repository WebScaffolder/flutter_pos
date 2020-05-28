import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/splash_screen.dart';
import 'package:spree/Layouts/Views/stall_details_screen.dart';
import 'package:spree/Layouts/Views/stalls_screen.dart';
import 'package:spree/Layouts/Views/store_tax.dart';
import 'package:spree/Utils/config.dart';

import 'customers_screen.dart';
import 'staff_screen.dart';
import 'stock_unit.dart';
import 'suppliers_screen.dart';
import 'package:spree/Utils/languages.dart';

class settings_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _settings_screenState();
  }
}

class _settings_screenState extends State<settings_screen> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(
        children: <Widget>[
          Container(
            height: 210,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.grey[200],
                  height: 200,
                ),
                Container(
                  margin: EdgeInsets.only(top: 70, left: 20, right: 20),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Container(
                      height: 100,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 15),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                ),
                              ),
                              title: Text(
                                  '${config.user_details == null ? languages.skeleton_language_objects[config.app_language]['not_loaded'] : config.user_details[0]['firstName'].toString()}',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.purple[700])),
                              subtitle: Text(
                                  '${config.user_details == null ? languages.skeleton_language_objects[config.app_language]['not_loaded'] : config.user_details[0]['email'].toString()}',
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      color: Colors.purple[300],
                                      fontSize: 12)),
                              trailing: Icon(Icons.exit_to_app),
                              onTap: () {
                                sign_out();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey[100],
            margin: EdgeInsets.only(left: 20, right: 20),
            height: 500,
            child: Card(
                elevation: 5,
                color: Colors.white,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: ListTile.divideTiles(context: context, tiles: [
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.home),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['store_detail'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['check_your_store_detail'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[300])),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new stall_details_screen(),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.account_balance, color: Colors.grey),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['merchant_outlets'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          languages.skeleton_language_objects[config
                              .app_language]['check_all_your_retail_outlets'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[300])),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new stalls_screen(),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.verified_user, color: Colors.grey),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['store_Staff'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          languages.skeleton_language_objects[config
                              .app_language]['check_all_your_store_staff'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[300])),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new staff_screen(),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.favorite, color: Colors.grey),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['title_store_customer'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          languages.skeleton_language_objects[
                                  config.app_language]
                              ['store_Check_all_your_store_sustomer'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[300])),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new customers_screen(),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.person_pin, color: Colors.grey),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['store_supplier'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          languages.skeleton_language_objects[config
                              .app_language]['check_all_your_store_supplier'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[300])),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new suppliers_screen(),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.extension, color: Colors.grey),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['product_units'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['view_your_products_units'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[300])),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new stock_unit(),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    ListTile(
                      dense: true,
                      enabled: true,
                      leading: Icon(Icons.title, color: Colors.grey),
                      title: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['tax'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[700])),
                      subtitle: Text(
                          languages.skeleton_language_objects[
                              config.app_language]['view_tax_class'],
                          style: TextStyle(
                              fontFamily: "Roboto", color: Colors.purple[300])),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) => new store_tax(),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                  ]).toList(),
                )),
          )
        ],
      ),
    ));
  }

  //this signs out user
  sign_out() async {
    await FirebaseAuth.instance.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_state", "guest_user");
    await prefs.setString("user_id", null);
    await prefs.setString("email", null);

    var route = new MaterialPageRoute(
      builder: (BuildContext context) => new splash_screen(),
    );
    Navigator.of(context).push(route);
  }
}

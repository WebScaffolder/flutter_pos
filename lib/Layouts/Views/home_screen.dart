import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/returns_screen.dart';
import 'package:spree/Layouts/Views/sales_screen.dart';
import 'package:spree/Layouts/Views/staff_screen.dart';
import 'package:spree/Layouts/Views/stock_transfer_screen.dart';
import 'package:spree/Layouts/Views/stock_unit.dart';
import 'package:spree/Layouts/Views/suppliers_screen.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

import 'brands_screen.dart';
import 'categories_screen.dart';
import 'customers_screen.dart';
import 'inventory_screen.dart';

class home_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _home_screenState();
  }
}

class _home_screenState extends State<home_screen> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 35,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Hello ${config.user_details == null ? "User" : config.user_details[0]['firstName'].toString()}",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto"),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${config.store_details == null ? "Store" : config.store_details[0]['stallName'].toString()}",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Roboto"),
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Center(
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Image.asset("assets/images/app_logo.png"),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),

          Text(
            languages.skeleton_language_objects[config.app_language]
                ['stock_management'],
            style: TextStyle(
                color: Colors.grey[800], fontSize: 18.0, fontFamily: "Roboto"),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 0.7,
            color: Colors.grey,
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.boxes,
              size: 20,
            ),
            title: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['inventory'],
                style: TextStyle(
                    fontFamily: "Roboto", color: Colors.deepPurple[700])),
            subtitle: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['check_your_store_inventory'],
                style: TextStyle(fontFamily: "Roboto", color: Colors.grey)),
            trailing: Icon(
              Icons.arrow_forward,
              size: 20,
            ),
            onTap: () {
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new inventory_screen(),
              );
              Navigator.of(context).push(route);
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.receipt,
              size: 20,
            ),
            title: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['store_sales'],
                style: TextStyle(
                    fontFamily: "Roboto", color: Colors.deepPurple[700])),
            subtitle: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['check_your_stall_sales'],
                style: TextStyle(fontFamily: "Roboto", color: Colors.grey)),
            trailing: Icon(
              Icons.arrow_forward,
              size: 20,
            ),
            onTap: () {
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new sales_screen(),
              );
              Navigator.of(context).push(route);
            },
          ),
//            ListTile(
//              leading: Icon(FontAwesomeIcons.undo, size: 20,),
//              title: Text('Stall Returns', style: TextStyle(fontFamily: "Roboto", color: Colors.deepPurple[700])),
//              subtitle: Text('Check your Stall Returns', style: TextStyle(fontFamily: "Roboto", color: Colors.grey)),
//              trailing: Icon(Icons.arrow_forward, size: 20,),
//              onTap: () {
//
//                var route = new MaterialPageRoute(
//                  builder: (BuildContext context) => new returns_screen(),
//                );
//                Navigator.of(context).push(route);
//
//                },
//            ),
//            ListTile(
//              leading: Icon(FontAwesomeIcons.random, size: 20,),
//              title: Text('Stall Stock Transfer', style: TextStyle(fontFamily: "Roboto", color: Colors.deepPurple[700])),
//              subtitle: Text('Check your Stall Stock Transfer', style: TextStyle(fontFamily: "Roboto", color: Colors.grey)),
//              trailing: Icon(Icons.arrow_forward, size: 20,),
//              onTap: () {
//
//                var route = new MaterialPageRoute(
//                  builder: (BuildContext context) => new stock_transfer_screen(),
//                );
//                Navigator.of(context).push(route);
//
//                },
//            ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.copyright,
              size: 20,
            ),
            title: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['product_brand'],
                style: TextStyle(
                    fontFamily: "Roboto", color: Colors.deepPurple[700])),
            subtitle: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['check_your_product_brands'],
                style: TextStyle(fontFamily: "Roboto", color: Colors.grey)),
            trailing: Icon(
              Icons.arrow_forward,
              size: 20,
            ),
            onTap: () {
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new brands_screen(),
              );
              Navigator.of(context).push(route);
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.cubes,
              size: 20,
            ),
            title: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['product_categories'],
                style: TextStyle(
                    fontFamily: "Roboto", color: Colors.deepPurple[700])),
            subtitle: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['check_your_product_categories'],
                style: TextStyle(fontFamily: "Roboto", color: Colors.grey)),
            trailing: Icon(
              Icons.arrow_forward,
              size: 20,
            ),
            onTap: () {
              var route = new MaterialPageRoute(
                builder: (BuildContext context) => new categories_screen(),
              );
              Navigator.of(context).push(route);
            },
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    ));
  }
}

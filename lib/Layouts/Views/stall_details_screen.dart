import 'package:flutter/material.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class stall_details_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _stall_details_screenState();
  }
}

class _stall_details_screenState extends State<stall_details_screen> {

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(config.store_details[0]['stallName'].toString().toUpperCase(), style: TextStyle(fontFamily: "Roboto", fontSize: 15, color: Colors.grey[800]),),
          actions: <Widget>[
            IconButton(
              onPressed: () {

              },
              icon: Icon(config.store_details[0]["stallStatus"] == "active" ? Icons.check_circle : Icons.remove_circle_outline, color: Colors.green[800], size: 20),
            ),
          ],
        ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            width: double.infinity,
            child: Image.network(
              config.store_details[0]['stallCover'][0]['publicUrl'],
              fit: BoxFit.fill,
            ),
          ),
          ListTile(
            title: Text(languages.skeleton_language_objects[config.app_language]['store_online_status'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
            subtitle: Text('${config.store_details[0]["stallPublic"].toString().toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
          ),
          ListTile(
            title: Text(languages.skeleton_language_objects[config.app_language]['store_visibility'], style: TextStyle(fontFamily: "Roboto", color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w700)),
            subtitle: Text('${config.store_details[0]["stallVisible"].toString().toUpperCase()}', style: TextStyle(fontFamily: "Roboto", color: Colors.grey[500], fontSize: 14)),
          ),

        ],
      )
    );
  }
}

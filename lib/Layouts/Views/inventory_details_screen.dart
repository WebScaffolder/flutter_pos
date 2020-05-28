import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spree/Utils/config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:spree/Utils/languages.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'create_purchase_screen.dart';

class inventory_details_screen extends StatefulWidget {
  inventory_details_screen(this.product_id);
  final product_id;

  @override
  _inventory_details_screenState createState() =>
      _inventory_details_screenState(product_id);
}

class _inventory_details_screenState extends State<inventory_details_screen> {
  _inventory_details_screenState(this.product_id);
  final product_id;

  @override
  void initState() {
    super.initState();
    get_product_details();
    get_product_purchase_history();
    get_product_sales_history();
  }

  var product_documents;
  var product_purchase_documents;
  var product_sales_documents;

  var product_details;

  bool loaded = false;

  //check if product exist our db
  Future<bool> get_product_details() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('products')
        .where('id', isEqualTo: product_id)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 1) {
      setState(() {
        product_documents = documents;

        if (documents[0]['productAttribute'] == "") {
          product_details = {
            "current_units": 0,
            "units_sold": 0,
            "units_bought": 0,
            "unit_value": 0,
            "units_udjusted": 0
          };
        }
        if (documents[0]['productAttribute'] != "" &&
            documents[0]['productAttribute'] != null) {
          var productAttribute = json.decode(documents[0]['productAttribute']);
          for (var x in productAttribute) {
            if (x['store'] == config.store_details[0]['id']) {
              product_details = x;
            }
          }
        }

        loaded = true;
      });
    }

    return documents.length == 1;
  }

  //get product purchase history
  Future<bool> get_product_purchase_history() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('purchases')
        .where("purchasesStallId", isEqualTo: config.store_details[0]["id"])
        .where('purchasesProductId', isEqualTo: product_id)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      product_purchase_documents = documents;
    });

    return documents.length == 1;
  }

  //get product sales history
  Future<bool> get_product_sales_history() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('sales')
        .where('salesStallId', isEqualTo: config.store_details[0]["id"])
        .where('salesItems', arrayContains: product_id)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      product_sales_documents = documents;
    });

    return documents.length == 1;
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
          title: Text(
            loaded == true
                ? product_documents[0]['productName'].toString().toUpperCase()
                : "Loading Product Details",
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 17, color: Colors.grey[800]),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                var route = new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new create_purchase_screen(product_documents),
                );
                Navigator.of(context).push(route);
              },
              icon:
                  Icon(Icons.add_to_photos, color: Colors.grey[800], size: 20),
            ),
          ],
        ),
        body: loaded == true
            ? ListView(
                children: <Widget>[
                  Container(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      product_documents[0]['productImage'][0]['publicUrl'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: Text(
                              languages.skeleton_language_objects[
                                  config.app_language]['price'],
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                          subtitle: Text(
                            '${product_details != null ? product_details['unit_value'].toString() : "0"}',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[500],
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: Text(
                              languages.skeleton_language_objects[
                                  config.app_language]['inventory'],
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                          subtitle: Text(
                            product_details != null
                                ? product_details['current_units'].toString()
                                : '0',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[500],
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: Text(
                              languages.skeleton_language_objects[
                                  config.app_language]['sold'],
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                          subtitle: Text(
                            '${product_details != null ? product_details['units_sold'].toString() : "0"}',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[500],
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: Text(
                              languages.skeleton_language_objects[
                                  config.app_language]['bought'],
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                          subtitle: Text(
                            '${product_details != null ? product_details['units_bought'].toString() : "0"}',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                color: Colors.grey[500],
                                fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_details'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(product_documents[0]['productDesc'] ?? "",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 13.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_brand'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(
                        config.get_brand_by_id(
                            product_documents[0]['productBrandId']),
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 13.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_label_type'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(product_documents[0]['productCodeType'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 14.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: 20, right: 20, left: 20, bottom: 10),
                    child: Text(
                        languages.skeleton_language_objects[config.app_language]
                            ['product_unit'],
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.deepPurple,
                          fontSize: 12.0,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
                    child: Text(
                        config.get_unit_by_id(
                            product_documents[0]['productUnit'].toString()),
                        style: TextStyle(
                          fontFamily: "Roboto",
                          color: Colors.grey[700],
                          fontSize: 13.0,
                        )),
                  ),
                ],
              )
            : Center(
                child: SpinKitChasingDots(color: Colors.deepPurple),
              ));
  }
}

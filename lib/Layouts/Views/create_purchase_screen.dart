import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/random_string.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';

class create_purchase_screen extends StatefulWidget {
  create_purchase_screen(this.param_id);
  final param_id;

  @override
  _create_purchase_screenState createState() =>
      _create_purchase_screenState(param_id);
}

class _create_purchase_screenState extends State<create_purchase_screen> {
  _create_purchase_screenState(this.param_id);
  final param_id;

  //text field
  TextEditingController refController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController unitsController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    //fetch suppliers
    get_store_suppliers();
  }

  bool loaded = false;

  List<String> payment_status_list = [
    "Choose Payment Status",
    "Paid",
    "Pending"
  ];
  List<String> purchase_status_list = [
    "Choose Purchase Status",
    "Received",
    "Pending"
  ];

  List<String> supplier_list_document = ["Choose Supplier"];
  List<String> ids_list_document = ["supplier_id"];

  String selected_supplier = "Choose Supplier";
  String purchase_status = "Choose Purchase Status";
  String payment_status = "Choose Payment Status";

  //get store suppliers
  Future<bool> get_store_suppliers() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('suppliers')
        .where("supplierStallId", arrayContains: config.store_details[0]["id"])
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      loaded = true;
      for (int i = 0; i < documents.length; i++) {
        supplier_list_document.add(documents[i]['supplierName'].toString());
        ids_list_document.add(documents[i]['id']);
      }
    });

    return documents.length == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.grey[800], //change your color here
          ),
          backgroundColor: Colors.grey[200],
          elevation: 3,
          title: Text(
            languages.skeleton_language_objects[config.app_language]['title_make_purchase'],
            style: TextStyle(
                fontFamily: "Roboto", fontSize: 15, color: Colors.grey[800]),
          ),
        ),
        body: loaded == true
            ? Container(
                height: double.infinity,
                margin: EdgeInsets.all(5),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      param_id[0]['productName'],
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 17,
                          color: Colors.deepPurpleAccent),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: Container(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: DropdownButton<String>(
                          value: selected_supplier,
                          onChanged: (String newValue) {
                            setState(() {
                              selected_supplier = newValue;
                            });
                          },
                          items: supplier_list_document
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: DropdownButton<String>(
                          value: purchase_status,
                          onChanged: (String newValue) {
                            setState(() {
                              purchase_status = newValue;
                            });
                          },
                          items: purchase_status_list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Center(
                        child: DropdownButton<String>(
                          value: payment_status,
                          onChanged: (String newValue) {
                            setState(() {
                              payment_status = newValue;
                            });
                          },
                          items: payment_status_list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 1,
                        controller: refController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText:
                            languages.skeleton_language_objects[config.app_language]['enter_ref_number'],
                            hintStyle: TextStyle(
                                fontSize: 14.0, fontFamily: "Roboto"),
                            labelText:
                            languages.skeleton_language_objects[config.app_language]['ref_no'],
                            labelStyle: TextStyle(
                                fontSize: 12.0, fontFamily: "Roboto")),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 1,
                        controller: unitsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText:
                            languages.skeleton_language_objects[config.app_language]['enter_receiving_quantity'],
                            hintStyle: TextStyle(
                                fontSize: 14.0, fontFamily: "Roboto"),
                            labelText: languages.skeleton_language_objects[config.app_language]['units'],
                            labelStyle: TextStyle(
                                fontSize: 12.0, fontFamily: "Roboto")),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      child: TextField(
                        maxLines: 1,
                        controller: totalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: languages.skeleton_language_objects[config.app_language]['enter_single_product_cost'],
                            hintStyle: TextStyle(
                                fontSize: 14.0, fontFamily: "Roboto"),
                            labelText: languages.skeleton_language_objects[config.app_language]['product_cost'],
                            labelStyle: TextStyle(
                                fontSize: 12.0, fontFamily: "Roboto")),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
                      width: double.infinity,
                      child: FlatButton(
                        child: Text(
                          languages.skeleton_language_objects[config.app_language]['create_product'],
                          style: TextStyle(color: Colors.white, fontSize: 12.0),
                        ),
                        color: Colors.deepOrange,
                        onPressed: () {
                          if (totalController.text != "" &&
                              unitsController.text != "" &&
                              refController.text != "" &&
                              !selected_supplier.contains(languages.skeleton_language_objects[config.app_language]['choose']) &&
                              !purchase_status.contains(languages.skeleton_language_objects[config.app_language]['choose']) &&
                              !payment_status.contains(languages.skeleton_language_objects[config.app_language]['choose'])) {

                            setState(() {
                              loaded = false;
                            });

                            make_purchase_request();
                          } else {
                            config.func_do_toast(languages.skeleton_language_objects[config.app_language]['enter_all_fields'], Colors.red);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: SpinKitChasingDots(color: Colors.deepPurple),
              ));
  }

  //create a post purchase request
  void make_purchase_request() async {
    final CollectionReference purchase_ref =
        Firestore.instance.collection('/purchases');
    var purchase_id = randomAlphaNumeric(20);

    //print(config.user_details[0]['id']);

    var values = {
      "createdAt": FieldValue.serverTimestamp(),
      "createdBy": "",
      "id": purchase_id,
      "importHash": null,
      "purchasesPaymentStatus": payment_status.toString().toLowerCase(),
      "purchasesProductId": param_id[0]['id'],
      "purchasesProductUnits": unitsController.text,
      "purchasesRefNo":
          int.parse("${refController.text.toString() + randomNumeric(7)}"),
      "purchasesStallId": config.store_details[0]['id'],
      "purchasesStatus": purchase_status.toString().toLowerCase(),
      "purchasesSupplierId":
          ids_list_document[supplier_list_document.indexOf(selected_supplier)],
      "purchasesTotal": totalController.text,
      "purchasesVisible": "visible",
      "updatedAt": FieldValue.serverTimestamp(),
      "updatedBy": ""
    };

    print(values);
    await purchase_ref.document(purchase_id).setData(values);
    make_product_debit();
  }

  //this function increases product stock
  void make_product_debit() async {
    final CollectionReference product_ref =
        Firestore.instance.collection('/products');
    var product_details = param_id[0];
    var attributes = product_details['productAttribute'];
    var new_attributes = [];

    if (attributes == "" || attributes == null) {
      var object = [
          {
            "\"store\"": "\"${config.store_details[0]['id']}\"",
            "\"current_units\"": unitsController.text,
            "\"units_sold\"": 0,
            "\"units_bought\"": unitsController.text,
            "\"unit_value\"": totalController.text,
            "\"units_udjusted\"": 0
          }
        ];
      await product_ref
          .document(product_details['id'])
          .updateData({'productAttribute': "${object.toString()}"});
    }
    if (attributes != "" || attributes != null) {
      attributes = json.decode(product_details['productAttribute']);
      print(attributes);
      for (int i = 0; i < attributes.length; i++) {

          if (attributes[i]['store'] == config.store_details[0]['id']) {
            var object = {
              "\"store\"": "\"${config.store_details[0]['id']}\"",
              "\"current_units\"": attributes[i]['current_units'] + int.parse(unitsController.text),
              "\"units_sold\"": attributes[i]['units_sold'],
              "\"units_bought\"": attributes[i]['units_bought'] + int.parse(unitsController.text),
              "\"unit_value\"": totalController.text,
              "\"units_udjusted\"": attributes[i]['units_udjusted']
            };
            new_attributes.add(object);
            print("@@@ 1" + new_attributes.toString());
          } else if( attributes[i]['store'] != config.store_details[0]['id'] && i == attributes.length - 1){
            var object = {
              "\"store\"": "\"${attributes[i]['store']}\"",
              "\"current_units\"": attributes[i]['current_units'],
              "\"units_sold\"": attributes[i]['units_sold'],
              "\"units_bought\"": attributes[i]['units_bought'],
              "\"unit_value\"": attributes[i]['unit_value'],
              "\"units_udjusted\"": attributes[i]['units_udjusted']
            };
            new_attributes.add(object);
            print("@@@ 2" + new_attributes.toString());
          }
          else{
            var object = {
              "\"store\"": "\"${attributes[i]['store']}\"",
              "\"current_units\"": attributes[i]['current_units'],
              "\"units_sold\"": attributes[i]['units_sold'],
              "\"units_bought\"": attributes[i]['units_bought'],
              "\"unit_value\"": attributes[i]['unit_value'],
              "\"units_udjusted\"": attributes[i]['units_udjusted']
            };
            new_attributes.add(object);
            print("@@@ 3" + new_attributes.toString());
          }
      }
      await product_ref.document(product_details['id']).updateData({"productAttribute": "${new_attributes.toString()}"});
    }

    config.func_do_toast(languages.skeleton_language_objects[config.app_language]['purchase_successful'], Colors.green);
    Navigator.of(context).pop();

  }
}

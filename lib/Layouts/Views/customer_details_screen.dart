import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:spree/Utils/languages.dart';
import 'package:spree/Utils/config.dart';

class customer_details_screen extends StatefulWidget {
  customer_details_screen(this.staff_id);

  final staff_id;

  @override
  _customer_details_screenState createState() =>
      _customer_details_screenState(staff_id);
}

class _customer_details_screenState extends State<customer_details_screen> {
  _customer_details_screenState(this.staff_id);

  TextEditingController amountController = new TextEditingController();
  final db = Firestore.instance;

  final staff_id;

  @override
  void initState() {
    super.initState();
    get_customer_details();
  }

  var customer_sales_documents;
  var customer_documents;
  bool loaded = false;

  //check if customer exist our db
  Future<bool> get_customer_details() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('customers')
        .where('id', isEqualTo: staff_id)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length == 1) {
      setState(() {
        customer_documents = documents;
        loaded = true;
        get_customer_sales_data();
      });
    }
    return documents.length == 1;
  }

  //this function fetches customer sales
  get_customer_sales_data() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('sales')
        .where('salesCustomerName', isEqualTo: customer_documents[0]['id'])
        .limit(10)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      customer_sales_documents = documents;
    });
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
            loaded == true
                ? customer_documents[0]['customerName']
                : "Loading Customer...",
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
//            IconButton(
//              onPressed: () {
//              },
//              icon: Icon(Icons.mode_edit, color: Colors.grey[800], size: 24),
//            )
          ],
        ),
        body: loaded == true
            ? Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: NetworkImage(
                                  customer_documents[0]['customerAvatar'][0]
                                      ['publicUrl'])),
                          SizedBox(
                            height: 20,
                          ),
                          Text(customer_documents[0]['customerName'],
                              maxLines: 2,
                              style: new TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 18,
                                  color: Colors.grey[800])),
                          SizedBox(
                            height: 10,
                          ),
                          Text(customer_documents[0]['customerEmail'],
                              maxLines: 2,
                              style: new TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: 12,
                                  color: Colors.grey[500])),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 0.7,
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 45,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.message,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.call,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.alternate_email,
                              color: Colors.grey[600],
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      languages.skeleton_language_objects[config.app_language]
                          ['customer_activity'],
                      maxLines: 2,
                      style: new TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    customer_sales_documents != null ?
                    Container(
                        height: 700.0,
                        child: ListView.builder(
                                itemCount: customer_sales_documents.length,
                                itemBuilder: (context, index) => _sales_tile(
                                    context,
                                    customer_sales_documents[index],
                                    index),
                              )) : Center(
                      child: SpinKitChasingDots(
                          color: Colors.deepPurple),
                    )
                  ],
                ),
              )
            : Center(
                child: SpinKitChasingDots(color: Colors.deepPurple),
              ));
  }

  //customer sales list
  Widget _sales_tile(context, document, index) {
    return ListTile(
      onTap: (){
        if(document['salesPaymentStatus'] != "paid"){
          func_pay_customer_credit(context, document);
        }
      },
      dense: true,
      enabled: true,
      leading: Icon(Icons.av_timer),
      title: Text(
        ' INV : ${document['salesInvoiceNo']}',
        style: TextStyle(fontFamily: "Roboto", fontSize: 14),
        maxLines: 2,
      ),
      subtitle: Text(languages.skeleton_language_objects[config.app_language]
      ['amount'] +
        ' : ${document['salesTotalAmount']}',
        style: TextStyle(fontFamily: "Roboto", fontSize: 12),
        maxLines: 3,
      ),
      trailing: document['salesPaymentStatus'] != "paid" ? Icon(
        Icons.arrow_forward,
        size: 24,
      ) : Icon(
        Icons.done,
        color: Colors.green,
        size: 16,
      )
    );
  }

  func_pay_customer_credit(context, document) {
    print("#### " + document['salePayload'].toString());
    var salePayload = json.decode(document['salePayload'].toString().replaceAll("\"tax\"", ",\"tax\"").replaceAll(",,", ","));
    showDialog(
      context: context,
      child: new AlertDialog(
        title: Text(languages.skeleton_language_objects[config.app_language]
        ['pay_customer_credit']),
        content: Container(
          height: 200,
          child: Column(
            children: <Widget>[
              Text(languages.skeleton_language_objects[config.app_language]
              ['pay_customer_credit_confirm'] + "${((salePayload['amount_expected'] - salePayload['amount_paid']) == 0 ? salePayload['amount_expected'] : (salePayload['amount_expected'] - salePayload['amount_paid'])).toString()}"),
              SizedBox(height: 10),
              TextField(
                maxLines: 1,
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText:
                    languages.skeleton_language_objects[config.app_language]
                    ['enter_amount_to_be_paid'],
                    hintStyle: TextStyle(fontSize: 14.0, fontFamily: "Roboto"),
                    labelText:
                    languages.skeleton_language_objects[config.app_language]
                    ['amount_to_be_paid'],
                    labelStyle:
                    TextStyle(fontSize: 12.0, fontFamily: "Roboto")),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
        actions: [
          new FlatButton(
            child: Text(languages.skeleton_language_objects[config.app_language]
            ['cancel']),
            onPressed: () => Navigator.pop(context),
          ),
          new FlatButton(
            child: Text(
              languages.skeleton_language_objects[config.app_language]
              ['complete'],
              style: TextStyle(color: Colors.teal),
            ),
            onPressed: () {
              if (amountController.text != null &&
                  int.parse(amountController.text) <= ((salePayload['amount_expected'] - salePayload['amount_paid']) == 0 ? salePayload['amount_expected'] : (salePayload['amount_expected'] - salePayload['amount_paid'])) &&
                  amountController.text != "") {
                func_pay_credit(salePayload, document, int.parse(amountController.text), salePayload['amount_paid']);
                Navigator.pop(context);
              } else if(int.parse(amountController.text) > ((salePayload['amount_expected'] - salePayload['amount_paid']) == 0 ? salePayload['amount_expected'] : (salePayload['amount_expected'] - salePayload['amount_paid']))) {
                config.func_do_toast(
                    languages.skeleton_language_objects[config.app_language]
                    ['credit_payment_can_not_exeed_balance'] + "${salePayload['amount_expected'] - salePayload['amount_paid']}",
                    Colors.red);
              } else{
                config.func_do_toast(
                    languages.skeleton_language_objects[config.app_language]
                    ['enter_amount_to_be_paid'],
                    Colors.red);
              }
            },
          ),
        ],
      ),
    );
  }

  func_pay_credit(payload, document, amount, amount_paid) async {

    var salePayload = payload;
    int current_value = amount + amount_paid;

    if(current_value == payload['amount_expected']){
      salePayload['amount_paid'] = current_value;
      salePayload['payments']['paid'] = true;
      func_update_status_on_db(salePayload, document);
    } else if(current_value < payload['amount_expected']){
      salePayload['amount_paid'] = current_value;
    } else{
      salePayload['amount_paid'] = payload['amount_expected'];
      salePayload['payments']['paid'] = true;
      func_update_status_on_db(salePayload, document);
    }
    func_update_payload_on_db(salePayload, document);
    func_update_sales();
  }

  func_update_payload_on_db(salePayload, document) async {
    await db
        .collection('sales')
        .document(document.documentID)
        .updateData({'salePayload': "${json.decode(salePayload)}"});
  }

  func_update_status_on_db(salePayload, document) async {
    await db
        .collection('sales')
        .document(document.documentID)
        .updateData({'salesPaymentStatus': "paid"});
  }

  func_update_sales(){
    config.func_do_toast("${languages.skeleton_language_objects[config.app_language]
    ['credit_paid']}", Colors.green);
    setState(() {
      customer_sales_documents = null;
      get_customer_sales_data();
    });
  }


}

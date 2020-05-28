import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spree/Layouts/Views/splash_screen.dart';
import 'package:spree/Utils/back_button_interceptor.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spree/Layouts/Views/home_screen.dart';
import 'package:spree/Layouts/Views/pos_screen.dart';
import 'package:spree/Layouts/Views/reports_screen.dart';
import 'package:spree/Layouts/Views/settings_screen.dart';
import 'package:spree/Utils/config.dart';
import 'package:spree/Utils/languages.dart';
import 'package:serial_number/serial_number.dart';

class dashboard_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _dashboard_screenState();
  }
}

class _dashboard_screenState extends State<dashboard_screen>
    with SingleTickerProviderStateMixin {
  //firestore db dump
  //user roles
  var user_roles;
  //get device store location
  var device_store;

  //page key tag
  final Key keyOne = PageStorageKey('pageOne');
  final Key keyTwo = PageStorageKey('pageTwo');
  final Key keyThree = PageStorageKey('pageThree');
  final Key keyFour = PageStorageKey('pageFour');

  int _index = 0;
  TabController _controller;

  //bottom navigation pages
  settings_screen four;
  reports_screen three;
  pos_screen two;
  home_screen one;

  List<Widget> pages;
  Widget currentPage;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    one = home_screen();
    two = pos_screen();
    three = reports_screen();
    four = settings_screen();

    get_device_location();
    get_store_brands();
    get_store_categories();
    get_store_inventory();
    get_store_units();
    get_user_role();
    get_store_tax();
    get_store_customers();
    get_store_stalls();

    pages = [one, two, three, four];

    currentPage = one;

    super.initState();
//    BackButtonInterceptor.add(myInterceptor);
    _controller = TabController(vsync: this, length: 4, initialIndex: _index);
  }

  //get device store details
  Future<bool> get_store_details() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('stalls')
        .where('id', isEqualTo: "${device_store[0]['deviceStallId']}")
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length == 1
        ? setState(() {
            config.store_details = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['msg_stall_does_not_exist'],
            Colors.red);

    return documents.length == 1;
  }

  //get device store location
  Future<bool> get_device_location() async {
    String sn = await SerialNumber.serialNumber;
    print("%%% ${sn}");

    final QuerySnapshot result = await Firestore.instance
        .collection('devices')
        .where("deviceSerial", isEqualTo: sn)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length == 1
        ? setState(() {
            device_store = documents;
            config.device_store = documents;
            get_store_purchases();
            get_store_sales();
            get_store_details();
            get_store_suppliers();
          })
        : documents.length > 1
            ? config.func_do_toast(
                languages.skeleton_language_objects[config.app_language]
                    ['device_exists_more_than_one_instance'],
                Colors.red)
            : do_logout_func();

    return documents.length == 1;
  }

  //logout user if device is not registered.
  do_logout_func() async {
    config.func_do_toast(
        languages.skeleton_language_objects[config.app_language]
            ['device_not_connected_to_any_stall'],
        Colors.red);

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

  //get product brands
  Future<bool> get_store_brands() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('brands').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_brands = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_brands_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product categories
  Future<bool> get_store_categories() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('categories').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_categories = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_categories_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product units
  Future<bool> get_store_units() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('units').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_units = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_units_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get store customers
  Future<bool> get_store_customers() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('customers').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_customers = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_customers_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get store supplier
  Future<bool> get_store_suppliers() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('suppliers').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_suppliers = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_suppliers_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product tax
  Future<bool> get_store_tax() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('taxClass').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_tax = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_tax_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get product inventory
  Future<bool> get_store_inventory() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('products').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_inventory = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_products_found'],
            Colors.red);

    return documents.length == 1;
  }

  //get user role
  Future<bool> get_user_role() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('user')
        .where("authenticationUid", isEqualTo: "cZNqFB4QO9N1Zbq7ILeMRln9hkz2")
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length == 1
        ? setState(() {
            config.user_details = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['user_not_created_on_db'],
            Colors.red);

    return documents.length == 1;
  }

  //get store purchase
  Future<bool> get_store_purchases() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('purchases')
        .where("purchasesStallId",
            isEqualTo: "${device_store[0]['deviceStallId']}")
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      config.store_purchases = documents;
    });

    return documents.length == 1;
  }

  //get store sales
  Future<bool> get_store_sales() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('sales')
        .where("salesStallId", isEqualTo: "${device_store[0]['deviceStallId']}")
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    setState(() {
      config.store_sales = documents;
    });

    return documents.length == 1;
  }

  //get store stalls
  Future<bool> get_store_stalls() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('stalls').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    documents.length > 0
        ? setState(() {
            config.store_stalls = documents;
          })
        : config.func_do_toast(
            languages.skeleton_language_objects[config.app_language]
                ['no_stalls_found'],
            Colors.red);

    return documents.length == 1;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  //Blocks user from closing app
  bool myInterceptor(bool stopDefaultButtonEvent) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) => setState(() {
          _index = index;
          _controller.animateTo(_index);
          currentPage = pages[_index];
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(
              Icons.dashboard,
              size: 22,
            ),
            title: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['dashboard'],
              style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
            ),
            activeColor: Colors.deepPurple,
          ),
          BottomNavyBarItem(
              icon: Icon(
                Icons.center_focus_weak,
                size: 22,
              ),
              title: Text(
                languages.skeleton_language_objects[config.app_language]['pos'],
                style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
              ),
              activeColor: Colors.deepPurple),
          BottomNavyBarItem(
            icon: Icon(
              Icons.insert_chart,
              size: 22,
            ),
            title: Text(
              languages.skeleton_language_objects[config.app_language]
                  ['reports'],
              style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
            ),
            activeColor: Colors.deepPurple,
          ),
          BottomNavyBarItem(
              icon: Icon(
                Icons.settings,
                size: 22,
              ),
              title: Text(
                languages.skeleton_language_objects[config.app_language]
                    ['settings'],
                style: new TextStyle(fontFamily: "Roboto", fontSize: 12),
              ),
              activeColor: Colors.deepPurple),
        ],
      ),
    );
  }
}

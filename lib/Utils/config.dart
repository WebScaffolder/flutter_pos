import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spree/Layouts/Views/device_screen.dart';
import 'package:spree/Utils/url_launcher.dart';

class config {
  //chenge to the app url
  static const String app_url = "https://mobipos-d474e.web.app";

  //change app name
  static const String app_name = "Orderista Pos";

  //change contacts
  static const String app_contacts = "+1 1234 567 890";

  static const String app_po_box = "P.O BOX 12345 - 00100, NAIROBI, KENYA";

  //this holds_the language chosen
  static const String app_language = "english";

  //change currency
  static const String app_currency = "Kes";

  static const String language = "en";

  //change to your site/ terms page
  static const String terms_url =
      'https://codecanyon.net/user/castle_tech_empire';

  //change to your app name
  static const String app_title_name = "Orderista Pos";

  static void func_do_toast(msg, color) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static var store_sales;
  static var store_purchases;
  static var user_details;
  static var device_store;
  static var store_details;
  static var store_categories;
  static var store_brands;
  static var store_units;
  static var store_inventory;
  static var store_tax;
  static var store_customers;
  static var store_suppliers;
  static var store_stalls;

  static String get_product_by_id(product_id) {
    for (var x in store_inventory) {
      if (x['id'] == product_id) {
        return x['productName'];
      }
    }
  }

  static int get_product_sku_by_id(product_id) {
    for (var x in store_inventory) {
      if (x['id'] == product_id) {
        return x['productSku'];
      }
    }
  }

  static int get_customer_order_limit(customer_id) {
    for (var x in store_customers) {
      if (x['id'] == customer_id) {
        return x['customerOderLimit'];
      }
    }
  }

  static String get_brand_by_id(brand_id) {
    for (var x in store_brands) {
      if (x['id'] == brand_id) {
        return x['brandName'];
      }
    }
  }

  static int get_tax_by_id(tax_id) {
    for (var x in store_tax) {
      if (x['id'] == tax_id) {
        return x['taxClassPercentage'];
      }
    }
  }

  static String get_unit_by_id(unit_id) {
    for (var x in store_units) {
      if (x['id'] == unit_id) {
        return x['unitsName'];
      }
    }
  }

  static String get_category_by_ids(category_id) {
    int cat_count = store_categories.length;
    int ids_count = 0;
    String categories = "";

    for (var x in store_categories) {
      if (x['id'].toString().contains(category_id)) {
        categories = categories + ",  " + x['categoryName'];
        ids_count = ids_count + 0;
      }
      if (cat_count == ids_count) {
        return categories;
      }
    }
  }

  static int get_product_units(product_id) {
    for (int i = 0; i < store_purchases; i++) {
      if ((i + 1) == store_purchases.length) {
        print("\n\n\n ${store_purchases[i]['purchasesProductUnits']} \n\n\n");
        return store_purchases[i]['purchasesProductUnits'];
      }
    }
  }

  static int get_product_price(product_id) {
    for (int i = 0; i < store_purchases; i++) {
      if ((i + 1) == store_purchases.length) {
        print("\n\n\n ${store_purchases[i]['purchasesProductUnits']} \n\n\n");
        return store_purchases[i]['purchasesProductUnits'];
      }
    }
  }

  static List get_pos_inventory() {
    List inventory = [];

    for (var x in store_inventory) {
      var product = {
        "id": x['id'],
        "productAlertQuantity": x['productAlertQuantity'],
        "productBrandId": x['productBrandId'],
        "productCategoryId": x['productCategoryId'],
        "productCodeType": x['productCodeType'],
        "productDesc": x['productDesc'],
        "productEnableStock": x['productEnableStock'],
        "productExpiry": x['productExpiry'],
        "productImage": x['productImage'],
        "productName": x['productName'],
        "productPublic": x['productPublic'],
        "productSku": x['productSku'],
        "productTax": x['productTax'],
        "productUnit": x['productUnit'],
        "productCost": get_product_price(x['id']),
        "productUnits": get_product_units(x['id'])
      };
      inventory.add(product);
    }

    return inventory;
  }

  func_inventory_credit() {}

  static void launcher(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

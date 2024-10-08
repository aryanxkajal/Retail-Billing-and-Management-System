import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:barcode1/account_customer/operation/operation_customer.dart';
import 'package:barcode1/account_inventory/model/inventory_model.dart';
import 'package:barcode1/account_inventory/operation/inventory_operation.dart';

import 'package:barcode1/account_sales/model/model_sales.dart';
import 'package:barcode1/account_sales/operation/operation_sales.dart';
import 'package:barcode1/account_supplies/UI/widget/global_supply.dart';
import 'package:barcode1/billing/quick_add/quick_add_model.dart';
import 'package:barcode1/billing/quick_add/quick_add_operation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vibration/vibration.dart';

//import 'package:share_plus/share_plus.dart';

import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ignore_for_file: prefer_final_fields

import '../account_customer/model/model_customer.dart';
import '../account_supplies/model/model_order.dart';
import '../account_supplies/operation/operation_orderId.dart';
import '../account_sales/model/model_sales_order.dart';
import '../account_sales/model/model_sales_transaction.dart';
import '../account_sales/operation/operation_sales_order.dart';
import '../account_sales/operation/operation_sales_transaction.dart';

import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

import '../../../global.dart' as globals;
import '../shop/operations/operation_store.dart';

//import 'package:pdf/pdf.dart';
//import 'package:pdf/widgets.dart' as pw;

class AccountSalesPage extends StatefulWidget {
  const AccountSalesPage({super.key});

  @override
  State<AccountSalesPage> createState() => _AccountSalesPageState();
}

class _AccountSalesPageState extends State<AccountSalesPage> {
/////////////////////
  ///
  ///
  int indexSelected = 0;

  int _selectedIndex = -1;

  bool showWidget = false;

  ///// Original
  ///
  String? _barcode;
  late bool visible;

  //// MAIN

  @override
  void initState() {
    super.initState();
    _refreshSalesList();

    _order();

    _refreshInventoryList();

    _refreshCustomerList1();
    //printer1();

    _ctrlQty.text = '0';

    _fetchStore();

    //WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  bool quickAdd = false;

  final _dbHelperQ = QuickAddOperation();

  QuickAdd _quickAdd = QuickAdd();

  List<QuickAdd> _quickAddList = [];

  List<Inventory> _inventoryListQuickAdd = [];

  _fetchQuickAdd() async {
    List<QuickAdd> x = await _dbHelperQ.fetchQuickAdd();
    _inventoryListQuickAdd = [];
    _quickAddList = x;
    if (x.isNotEmpty) {
      for (var i in x) {
        for (var j in _inventoryListAll) {
          if (i.barcode == j.barcode) {
            _inventoryListQuickAdd.add(j);
          }
        }
      }
    }
    print('sdss');
    setState(() {});
  }

  final _dbHelperS = StoreOperation();

  _fetchStore() async {
    var k = await _dbHelperS.fetchStore();

    if (k.isNotEmpty) {
      storeName = k[0].name!;
      storeAddress = k[0].address!;
      storePhone = k[0].phone!;
      storeUpi = k[0].website!;
    }
  }

  String storeName = '';
  String storeAddress = '';
  String storePhone = '';
  String storeUpi = '';

  SalesOrderId _orderId = SalesOrderId();

  final _dbHelperOrder1 = SalesOrderOperation();
  static List<SalesOrderId> _0000 = [];

  String _lastOrderId = '';

  _order() async {
    List<SalesOrderId> k = await _dbHelperOrder1.fetchO();
    //List<OrderId> k = await _dbHelperOrder1.id;
    if (k.isNotEmpty) {
      print(k.last.id);
      _lastOrderId = (k.last.id! + 1).toString();
      //return (k.last.id! + 1).toString();
    } else {
      _lastOrderId = '1';
      //return '1';
    }
  }

  //// BARCODE SCANNER

  // CustomerNumber Generator

  String lastCustomerNumber = '0';

  _generateCustomerNumber() async {
    List<Sales> x = await _dbHelperE.fetchSales();

    if (x.last.customerNumber == null) {
      print('object1');
      _sales.customerNumber = '1';
    } else {
      print('object2');
      _sales.customerNumber =
          (int.parse(x.last.customerNumber!) + 1).toString();
    }

    _lastBarcode();
  }

  _lastBarcode() async {
    List<Sales> x = await _dbHelperE.fetchSales();

    //lastCustomerNumber = x.last.customerNumber!;
    print(lastCustomerNumber);
  }

  // Purchase Entry

  static List<Inventory> _entry = [];
  final _dbHelperE1 = InventoryOperation();
  static List<Inventory> _inventorys = [];

  static List<Inventory> display_list12 = List.from(_inventorys);

  _purchaseEntryL(String b) async {
    print('hhhh');
    List<Inventory> k = await _dbHelperE1.fetchInventory();
    setState(() {
      if (k.isNotEmpty) {
        _inventorys = k;
        display_list12 = k;

        _setQtyL(b);

        //_findMap(b);
      } else {
        print('Product not in inventory');
      }
    });
  }

  _setQtyL(String b) async {
    print(productMap.entries.map((e) => e.value['productName']).toList());

    if (productMap.entries.map((e) => e.value['productName']).toList().contains(
        display_list12
            .where((element) => element.barcode!.toLowerCase().contains(b))
            .toList()[0]
            .productName!)) {
      already = productMap.entries
          .where((element) => element.toString().contains(display_list12
              .where((element) => element.barcode!.toLowerCase().contains(b))
              .toList()[0]
              .productName!))
          .toString();
    } else {
      listNumber += 1;
      productMap['$listNumber'] = {
        'productName': display_list12
            .where((element) => element.barcode!.toLowerCase().contains(b))
            .toList()[0]
            .productName!,
        'price': display_list12
            .where((element) => element.barcode!.toLowerCase().contains(b))
            .toList()[0]
            .sell!,
        'qty': weightText,
      };
    }
    setState(() {});
    _resetLoose();

    _totalPrice();
  }

  String weightText = '';
  String barcodeText = '';

  _totalPrice() {
    double x = 0;

    for (var i in productMap.entries) {
      print(
          '${double.parse(i.value['price']!) * double.parse(i.value['qty']!)}');

      x += double.parse(i.value['price']!) * double.parse(i.value['qty']!);
    }

    setState(() {
      totalPrice = x;
      //_sales.price = x.toString();
    });

    //print(x);
  }

  // UPDATE INVENTORY

  // List-Map of product name, qty, price

  Map<String, String> product = {'productName': '', 'price': '', 'qty': ''};
  Map<String, Map<String, String>> productMap = {};

  int listNumber = 0;

  String productName = 'a1';

  double price = 0;
  int qty = 01;

  final _dbHelperE = SalesOperation();
  Sales _sales = Sales();

  static List<Sales> _saless = [];

  static List<Sales> display_list1 = List.from(_saless);

  _refreshSalesList() async {
    List<Sales> k = await _dbHelperE.fetchSales();
    setState(() {
      _saless = k;
      display_list1 = k;
      // _Hm();
    });
  }

  _resetFormSales() {
    setState(() {
      _sales.id = null;

      _sales.customerName = null;
      _sales.customerNumber = null;

      _sales.date = null;
      _sales.paidStatus = null;
      _sales.productName = null;
    });
  }

  static List<Inventory> display_list3 = [];

  List split = [];
  List split1 = [];

  //List split2 = [];

  String xxx = '';

  static List<Inventory> split2 = List.from(display_list3);

  Map<String, Map<String, String>> productMap1 = {};

  String already = '';

  double totalPrice = 0;

  double x = 1;

  // inventory

  //static List<Inventory> _inventory = [];
  String Qty = '';

  static List<Inventory> update = [];

  Inventory _inventory = Inventory();

  _resetFormInventory() {
    setState(() {
      _inventory.id = null;

      _inventory.barcode = null;
      _inventory.productName = null;
      _inventory.qty = null;
      _inventory.buy = null;
      _inventory.sell = null;

      _inventory.weight = null;
      _inventory.DOE = null;
    });
  }

  _update() {
    print(update.map((e) => e.productName));
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController searchControllerC = TextEditingController();

  static List<String> _productsBarcode = [];

  static List<Inventory> _inventoryList = [];

  static List<Inventory> _inventoryList1 = [];

  _refreshInventoryList() async {
    List<Inventory> k = await _dbHelperE1.fetchInventory();

    List<Inventory> k1 = [];

    for (var i in k) {
      if (double.parse(i.qty!) <= 0) {
        //print(i.productName);
        k1.add(i);
        //k.remove(i);
      }
    }
    for (var i in k1) {
      k.remove(i);
    }

    _refreshInventoryList0(k);
  }

  List<Inventory> _inventoryListAll = [];

  _refreshInventoryList0(List<Inventory> k) async {
    setState(() {
      _inventoryListAll = k;
      _inventoryList = k;
      display_list12 = k;
    });
    _fetchQuickAdd();
  }

  // SEARCH BAR
  static List<Inventory> display_list = List.from(_inventoryList);

  void updateList(String value) {
    setState(() {
      _inventoryList1 = _inventoryList
          .where((element) =>
              element.productName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _resetLoose() {
    weightText = '';
    barcodeText = '';
    _ctrlSupplyWeight.text = '';
  }

  bool _showSearchResults = false;

  bool _showWeight = false;

  final _ctrlSupplyWeight = TextEditingController();

  void _appendNumber(String number) {
    // Appends the pressed number to the current value in the TextField

    _ctrlSupplyWeight.text = _ctrlSupplyWeight.text + number;
    partialPaymentAmount = partialPaymentAmount + number;
    ;
    setState(() {});
  }

  void _deleteLastCharacter() {
    // Delete the last character from the text in the TextField
    String currentText = _ctrlSupplyWeight.text;
    String currentText1 = partialPaymentAmount;
    if (currentText.isNotEmpty) {
      _ctrlSupplyWeight.text = currentText.substring(0, currentText.length - 1);
      partialPaymentAmount = currentText1.substring(0, currentText1.length - 1);
      setState(() {});
    }
  }

  Sales _supply = Sales();
  var oo;

  _submitSales() async {
    List<Sales> k = await _dbHelperE.fetchSales();

    _sales.productName = jsonEncode(cartList);

    if (_supply.id == null) {
      print('added');
      await _dbHelperE.insertSales(_sales);
    } else {
      //await _dbHelperE.updateSupply(_supply);
    }

    //_resetFormInventory();
    _updateInventory();

    /* if (_sales.deliveryMode == 'store') {
      _updateInventory();
    } else {
      _resetAll();
      cartList = {};
      _order();
      _resetFormInventory();
    }*/

    //_updateInventory();
  }

  _updateInventory() async {
    for (var i in cartList.entries) {
      List d = [];

      for (var c in display_list12) {
        //print('Hi - ${c.productName}');
        d.add(c.barcode);
        if (c.productName == i.value['productName']!) {
          if (c.packing == 'l') {
            print('yes yes');
            _inventory = c;

            _inventory.qty =
                '${-double.parse(i.value['qty']!) + double.parse(c.qty!)}';
            // _inventory.DOE = c.DOE;

            if (_inventory.id == null) {
              print('added');
              await _dbHelperE1.insertInventory(_inventory);
            } else {
              await _dbHelperE1.updateInventory(_inventory);
            }
            //_inventory.id == null;
            setState(() {
              _resetFormInventory();
            });
          } else {
            print('yes yes yes');

            _inventory = c;

            _inventory.qty =
                '${double.parse(c.qty!) - double.parse(i.value['qty']!)}';
            // _inventory.DOE = c.DOE;

            if (_inventory.id == null) {
              print('added');
              await _dbHelperE1.insertInventory(_inventory);
            } else {
              await _dbHelperE1.updateInventory(_inventory);
            }
            //_inventory.id == null;
            setState(() {
              _resetFormInventory();
            });
          }
        } else {
          print('no no');
        }
      }
    }
    _resetAll();
    cartList = {};

    //_inventoryList = [];

    _refreshSalesList();

    _order();

    _refreshInventoryList();

    _refreshCustomerList1();
    //printer1();

    _ctrlQty.text = '0';
  }

  ///// Customer

  bool customer = false;

  bool _showSearchResultsC = false;

  void updateListC(String value) {
    setState(() {
      _CustomerList1 = _CustomerList.where((element) =>
          element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    });
    _addcust(_CustomerList1);
  }

  _addcust(List<Customer> k) {
    k.add(Customer(name: 'Add Customer', phone: '', address: '', points: ''));
  }

  static List<Customer> _CustomerList = [];

  static List<Customer> _CustomerList1 = [];
  static List<Customer> _CustomerList2 = [];

  final _dbHelperC = CustomerOperation();
  Customer _customer = Customer();

  _refreshCustomerList(String value) async {
    List<Customer> k = await _dbHelperC.fetchCustomer();

    setState(() {
      _CustomerList = k;
    });

    updateListC(value);
  }

  String nameC = '-';
  String phoneC = '-';
  String addressC = '-';
  String pointsC = '-';

  //// PAYMENT MODE

  bool cash = true;
  bool cardd = false;
  bool wallet = false;
  bool upi = false;

  //// Delivery MODE

  bool store = true;
  bool home = false;

  //// Paid Amount

  bool fullPayment = true;
  bool partialPayment = false;

  String partialPaymentAmount = '';

  _updateSales(String date) async {
    List<Sales> k = await _dbHelperE.fetchSales1(date.toString());

    List<int> id = [];

    for (var i in k) {
      _sales = i;

      _sales.deliveryStatus = 'delivered';
      _sales.deliveryDate = DateTime.now().toString();

      await _dbHelperE.updateSales(_sales);

      //id.add(i.id!);
    }

    //print(id);

    setState(() {
      _refreshSalesList();

      //_salesList = k;
    });
  }

  _cancelSales(String date) async {
    List<Sales> k = await _dbHelperE.fetchSales1(date.toString());

    List<int> id = [];

    for (var i in k) {
      _sales = i;

      //_sales.deliveryStatus = 'delivered';
      //_sales.deliveryDate = DateTime.now().toString();

      await _dbHelperE.deleteSales(_sales.id!);

      //id.add(i.id!);
    }

    //print(id);

    setState(() {
      _refreshSalesList();

      //_salesList = k;
    });
  }

  ///// Home Delivery Card
  ///

  int revenue = 0;
  List<String> date = [];

  List totalCust = [];
  Map<String, List<Sales>> map = {};

  List<Customer> cust = [];

  _refreshCustomerList1() async {
    List<Customer> x = await _dbHelperC.fetchCustomer();

    if (x.isEmpty) {
      _customer.name = 'cashCustomer';
      _customer.phone = '1';
      _customer.address = 'x';
      _customer.points = 'x';
      await _dbHelperC.insertCustomer(_customer);
      cust.add(_customer);
    } else {
      setState(() {
        cust = x;

        //globals.x = x;
      });
    }
  }

  String _customerAddress(String name) {
    List<Customer> k = cust.where((element) => element.name == name).toList();

    return k[0].address.toString().toUpperCase();
    //return name;
  }

  String _customerphone(String name) {
    List<Customer> k = cust.where((element) => element.name == name).toList();

    return k[0].phone.toString().toUpperCase();
    //return name;
  }

  String _totalAmt(int index) {
    int total = 0;
    for (var i in map.entries) {
      if (i.value[0].date == date[index]) {
        for (var j in i.value) {
          // total = total + int.parse(j.price!) * int.parse(j.qty!);
        }
        //print(total.toString());
        //return total.toString();
      }
    }

    return total.toString();
  }

  String discUnit = 'rs';

  final _ctrlProductName = TextEditingController();
  final _ctrlMRP = TextEditingController();
  final _ctrlDisc = TextEditingController();
  final _ctrlQty = TextEditingController();
  final _ctrlsell = TextEditingController();
  final _ctrlsellDisc = TextEditingController();
  final _ctrlBarcode = TextEditingController();

  final _ctrlBuy = TextEditingController();

  final _ctrlpayment = TextEditingController();
  final _ctrlCustomerNumber = TextEditingController();

  final _ctrlCustomerName = TextEditingController();
  final _ctrlCustomerPhone = TextEditingController();
  final _ctrlCustomerAddress = TextEditingController();

  Map<String, Map<String, String>> cartList = {};
  int cartListNumber = 0;

  bool incQty = true;

  _resetProduct() {
    _ctrlProductName.clear();
    _ctrlMRP.clear();
    _ctrlDisc.clear();
    _ctrlQty.clear();
    _ctrlsell.clear();
    _ctrlsellDisc.clear();
    _ctrlBarcode.clear();
  }

  _afterSearchLoose(
      String productName, String mrp, String barcode, String mrp1, String buy) {
    searchController.clear();
    _ctrlProductName.text = productName;
    _ctrlMRP.text = mrp1;
    _ctrlDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
    _ctrlQty.text = '1';
    _ctrlsell.text = mrp;
    _ctrlsellDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
    _ctrlBarcode.text = barcode;
    _ctrlBuy.text = buy;
  }

  _afterSearch(String productName, String mrp, String barcode, String mrp1,
      String buy, bool inc) {
    bool already = false;
    for (var i in cartList.entries) {
      if (i.value['barcode'] == barcode) {
        _ctrlProductName.text = productName;
        _ctrlMRP.text = mrp1;
        _ctrlDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
        _ctrlBarcode.text.length != 4
            ? _ctrlQty.text = (inc == true)
                ? '${int.parse(i.value['qty']!) + 1}'
                : '${int.parse(i.value['qty']!) - 1}'
            : _ctrlQty.text = _ctrlQty.text;
        _ctrlsell.text = mrp;
        _ctrlsellDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
        _ctrlBarcode.text = barcode;
        _ctrlBuy.text = buy;

        already = true;

        cartList['${i.key}'] = {
          'productName': productName,
          'price': mrp,
          'mrp': mrp1,
          'buy': buy,
          'barcode': barcode,
          /*'qty': inc == true
              ? '${int.parse(i.value['qty']!) + 1}'
              : '${int.parse(i.value['qty']!) - 1}',*/
          'qty': _ctrlQty.text,
          'disc': '${-double.parse(mrp) + double.parse(mrp1)}',
        };
        _total();
      } else {
        //incQty = true;
      }
    }

    _addToCart(productName, mrp, barcode, already, mrp1, buy);
  }

  _addToCart(String productName, String mrp, String barcode, bool already,
      String mrp1, String buy) {
    if (already != true) {
      _ctrlProductName.text = productName;
      _ctrlMRP.text = mrp1;
      _ctrlDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
      _ctrlQty.text = _ctrlBarcode.text.length != 4 ? '1' : _ctrlQty.text;
      _ctrlsell.text = mrp;
      _ctrlsellDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
      _ctrlBarcode.text = barcode;
      _ctrlBuy.text = buy;

      cartListNumber += 1;
      cartList['$cartListNumber'] = {
        'productName': productName,
        'price': mrp,
        'mrp': mrp1,
        'buy': buy,
        'barcode': barcode,
        'qty': _ctrlBarcode.text.length != 4 ? '1' : _ctrlQty.text,
        'disc': '${-double.parse(mrp) + double.parse(mrp1)}',
      };
    }

    setState(() {});
    _total();
  }

  _addToCartLoose(String productName, String mrp, String barcode, bool already,
      String mrp1, String buy) {
    if (already != true) {
      _ctrlProductName.text = productName;
      _ctrlMRP.text = mrp1;
      _ctrlDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
      //_ctrlQty.text = _ctrlBarcode.text.length != 4 ? '1' : _ctrlQty.text;
      _ctrlsell.text = mrp;
      _ctrlsellDisc.text = '${-double.parse(mrp) + double.parse(mrp1)}';
      _ctrlBarcode.text = barcode;
      _ctrlBuy.text = buy;

      cartListNumber += 1;
      cartList['$cartListNumber'] = {
        'productName': productName,
        'price': mrp,
        'mrp': mrp1,
        'buy': buy,
        'barcode': barcode,
        'qty': '1',
        'disc': '${-double.parse(mrp) + double.parse(mrp1)}',
      };
    }

    setState(() {});
    _total();
  }

  double disc = 0;
  _total() {
    double t = 0;

    double d = 0;

    for (var i in cartList.entries) {
      t = t + double.parse(i.value['price']!) * double.parse(i.value['qty']!);
      d = d + double.parse(i.value['disc']!) * double.parse(i.value['qty']!);

      print(i.value['productName']!);

      print(double.parse(i.value['price']!) * double.parse(i.value['qty']!));
    }
    totalPrice = t;
    _ctrlpayment.text = totalPrice.toString();

    disc = d;

    setState(() {});
  }

  bool returnProduct = false;

  String deliveryMode = 'store';

  String paymentStatus = 'full';

  String paymentMode = 'cash';

  bool customerDetails = false;

  Customer _customer1 = Customer();

  _changeQty(String name) {
    for (var i in cartList.entries) {
      if (i.value['productName'] == name) {
        _ctrlQty.text = i.value['qty']!;
      }
    }
    setState(() {});
  }

  _removeFromCart() {
    int key1 = 0;
    for (var i in cartList.entries) {
      if (i.value['barcode'] == _ctrlBarcode.text) {
        key1 = int.parse(i.key);
      } else {}
    }
    _removeFromCart1(key1);
  }

  _removeFromCart1(int key) {
    print(key);
    cartList.remove('$key');
    setState(() {});
    _total();
    _resetProduct11();
  }

  _return() {
    for (var i in cartList.entries) {
      if (i.value['barcode'] == _ctrlBarcode.text && returnProduct == true) {
        cartList['${i.key}'] = {
          'productName': i.value['productName']!,
          'price': i.value['price']!,
          'mrp': i.value['mrp']!,
          'barcode': i.value['barcode']!,
          'qty': (int.parse(i.value['qty']!) * (-1)).toString(),
          'disc': i.value['disc']!,
        };
        // _total();
      }
      if (i.value['barcode'] == _ctrlBarcode.text && returnProduct == false) {
        cartList['${i.key}'] = {
          'productName': i.value['productName']!,
          'price': i.value['price']!,
          'mrp': i.value['mrp']!,
          'barcode': i.value['barcode']!,
          'qty': (int.parse(i.value['qty']!) * (-1)).toString(),
          'disc': i.value['disc']!,
        };
        // _total();
      }
    }
    _total();
    setState(() {});
  }

  String searchPacking = 'p';

  _addToCartL() {
    bool already = false;

    for (var i in cartList.entries) {
      if (i.value['barcode'] == _ctrlBarcode.text) {
        already = true;

        cartList['${i.key}'] = {
          'productName': i.value['productName']!,
          'price': i.value['price']!,
          'mrp': _ctrlMRP.text,
          'barcode': i.value['barcode']!,
          'qty': _ctrlQty.text,
          'disc': i.value['disc']!,
        };
        _total();
      }
    }
    _addToCartL1(already);
  }

  _addToCartL1(bool already) {
    if (already == false) {
      cartListNumber += 1;
      cartList['$cartListNumber'] = {
        'productName': _ctrlProductName.text,
        'price': _ctrlsell.text,
        'mrp': _ctrlMRP.text,
        'barcode': _ctrlBarcode.text,
        'qty': _ctrlQty.text,
        'disc': '${double.parse(_ctrlMRP.text) - double.parse(_ctrlsell.text)}',
      };
      _total();
    }
    _resetProduct11();
  }

  bool showC = false;

  _resetAll() {
    _ctrlProductName.clear();
    _ctrlMRP.clear();
    _ctrlDisc.clear();
    _ctrlQty.text = '0';
    _ctrlsell.clear();
    _ctrlsellDisc.clear();
    _ctrlBarcode.clear();
    _ctrlpayment.clear();
    _ctrlCustomerName.clear();
    _ctrlCustomerPhone.clear();
    _ctrlCustomerAddress.clear();
    _ctrlSupplyWeight.clear();
    _resetFormSales();
    _resetFormInventory();
    cartList = {};
    cartListNumber = 0;
    totalPrice = 0;
    _resetLoose();
    _resetProduct();
    _resetFormSales();

    _resetFormInventory();

    deliveryMode = 'store';
    paymentStatus = 'full';
    paymentMode = 'cash';
    customerDetails = false;

    _ctrlPaymentChange.clear();
    _ctrlPayment.clear();
    _ctrlCustomerId.clear();
    _ctrlCustomerNumber.clear();
    _ctrlCustomerName.clear();

    errorCustomerAddress = '';
    errorCustomerName = '';
    errorCustomerPhone = '';
    errorPartialPayment = '';
    errorPartialPayment1 = '';
    errorProductWeight = '';
    errorQty = '';
    errorDelivery = '';
    setState(() {});
  }

////////////////////// Keyboard /////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

  // Holds the text that user typed.

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  TextEditingController _ctrlCustomerId = TextEditingController();

  TextEditingController _ctrlPayment = TextEditingController();

  TextEditingController _ctrlPaymentChange = TextEditingController();

  FocusNode _productSearch = FocusNode();
  FocusNode _productDisc = FocusNode();
  FocusNode _customerSearch = FocusNode();
  FocusNode _partialPayment = FocusNode();
  FocusNode _productQty = FocusNode();
  FocusNode _productWeight = FocusNode();

  FocusNode _customername = FocusNode();
  FocusNode _customerPhone = FocusNode();
  FocusNode _customerAddress1 = FocusNode();

  FocusNode _payment = FocusNode();

  String text = '';
  String errorProductWeight = '';

  String errorPartialPayment = '';

  String errorCustomerName = '';
  String errorCustomerPhone = '';
  String errorCustomerAddress = '';

  String errorPartialPayment1 = '';

  String errorQty = '';

  _onKeyPress(VirtualKeyboardKey key, TextEditingController controller) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      controller.text =
          controller.text + (shiftEnabled ? key.capsText! : key.text!);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (controller.text.isEmpty) return;
          controller.text =
              controller.text.substring(0, controller.text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          controller.text = controller.text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          controller.text = controller.text + key.text!;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }

    //product search

    if (_productSearch.hasFocus) {
      _showSearchResults = true;
      _updateSearchResultsInventory(controller.text.toLowerCase());
    } else {}

    //payment change

    if (_payment.hasFocus) {
      if (paymentStatus == 'full' &&
          double.tryParse(controller.text) != null &&
          controller.text.length > 0) {
        _ctrlPaymentChange.text =
            (double.parse(_ctrlPayment.text) - totalPrice).toString();
      } else if (paymentStatus == 'partial' &&
          double.tryParse(controller.text) != null &&
          controller.text.length > 0) {
        _ctrlPaymentChange.text =
            (double.parse(_ctrlPayment.text) - double.parse(_ctrlpayment.text))
                .toString();
      } else {
        _ctrlPaymentChange.text = '0';
      }
    } else {}

    //weight

    if (_productQty.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorProductWeight = 'Invalid';
      } else {
        _changeQty(_ctrlProductName.text);
        errorProductWeight = '';
      }
    } else {
      errorProductWeight = '';
    }

//partial payment

    if (_partialPayment.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorPartialPayment = 'Invalid';
      } else if (double.tryParse(controller.text) != null &&
          controller.text.length > 0 &&
          _ctrlPayment.text.length > 0 &&
          double.parse(controller.text) <= double.parse(_ctrlPayment.text)) {
        _ctrlPaymentChange.text =
            (double.parse(_ctrlPayment.text) - double.parse(_ctrlpayment.text))
                .toString();
        errorPartialPayment = '';
      } else {
        errorPartialPayment = '';
        _ctrlPaymentChange.text = '0';
      }
    } else {
      errorPartialPayment = '';
    }
    //customer search list

    if (_customerSearch.hasFocus) {
      showC = true;
      setState(() {});

      _updateSearchResultsCustomer(controller.text.toLowerCase());
    } else {}

    if (_customerPhone.hasFocus) {
      if ((double.tryParse(controller.text) == null &&
              controller.text.length > 0) ||
          controller.text.length != 10) {
        errorCustomerPhone = 'Invalid';
      } else {
        errorCustomerPhone = '';
      }
    } else {
      errorCustomerPhone = '';
    }

    // Update the screen
    setState(() {});
  }

  Widget searchListCardProduct(int index) {
    return InkWell(
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black),
          ),
          // color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 20,
              alignment: Alignment.centerLeft,
              //color: const Color.fromRGBO(244, 244, 244, 1),

              child: Text(
                '${_inventoryList1[index].productName}',
                style: const TextStyle(
                    fontFamily: 'BanglaBold',
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  //height: 40,
                  // color: const Color.fromRGBO(
                  //  244, 244, 244, 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            '${_inventoryList1[index].sell} Rs',
                            style: const TextStyle(
                                fontFamily: 'Bangla',
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: Text(
                            '${_inventoryList1[index].barcode}',
                            style: const TextStyle(
                                fontFamily: 'Bangla',
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      onTap: () {
       
        _selectedIndex = -1;
        returnProduct = false;
       
        setState(() {
          if (lastCustomerNumber == null) {
            _generateCustomerNumber();
          } else {}
          _showSearchResults = false;

          if (_inventoryList1[index].packing == 'p') {
            searchPacking = 'p';

            _afterSearch(
                _inventoryList1[index].productName!,
                _inventoryList1[index].sell!,
                _inventoryList1[index].barcode!,
                _inventoryList1[index].mrp!,
                _inventoryList1[index].buy!,
                true);
            _selectedIndex = -1;

            searchController.text = '';
          } else {
            setState(() {
              searchPacking = 'l';
              _afterSearchLoose(
                _inventoryList1[index].productName!,
                _inventoryList1[index].sell!,
                _inventoryList1[index].barcode!,
                _inventoryList1[index].mrp!,
                _inventoryList1[index].buy!,
              );
            });
          }
        });
      },
    );
  }

  Widget searchListCardCustomer(int index) {
    return InkWell(
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black),
          ),
          // color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 20,
              alignment: Alignment.centerLeft,
              //color: const Color.fromRGBO(244, 244, 244, 1),

              child: Text(
                '${_CustomerList1[index].name}' == 'cashCustomer'
                    ? ''
                    : '${_CustomerList1[index].name}',
                style: const TextStyle(
                    fontFamily: 'BanglaBold',
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
            Expanded(
              child: Container(
                  width: double.infinity,
                  //height: 40,
                  // color: const Color.fromRGBO(
                  //  244, 244, 244, 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_CustomerList1[index].name}' == 'cashCustomer'
                                ? ''
                                : '${_CustomerList1[index].phone}',
                            style: const TextStyle(
                                fontFamily: 'Bangla',
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
      onTap: () {
        Vibration.vibrate(duration: 100);
        if ('${_CustomerList1[index].name}' != 'cashCustomer') {
          if (_CustomerList1[index].name == 'Add Customer') {
            showC = false;
            _addCustomer = true;
            searchControllerC.clear();
            setState(() {
              _ctrlCustomerName.text = '';
              _ctrlCustomerPhone.text = '';
              _ctrlCustomerAddress.text = '';
              _ctrlCustomerNumber.text = '';
            });
          } else {
            showC = false;
            searchControllerC.clear();

            setState(() {
              _ctrlCustomerId.text = '${_CustomerList1[index].id}';
              _ctrlCustomerName.text = '${_CustomerList1[index].name}';
              _ctrlCustomerPhone.text = '${_CustomerList1[index].phone}';
              _ctrlCustomerAddress.text = '${_CustomerList1[index].address}';
              _ctrlCustomerNumber.text = '${_CustomerList1[index].id}';
              print(_CustomerList1[index].id);
            });
          }
        } else {}
      },
    );
  }

  bool _addCustomer = false;

  _resetFormCustomer() {
    setState(() {
      _customer.id = null;
      _customer.name = null;
      _customer.phone = null;
      _customer.address = null;
      _customer.points = null;
    });
  }

  _scanner(String b) {
    for (var i in _inventoryList) {
      if (i.barcode == b) {
        setState(() {
          if (lastCustomerNumber == null) {
            _generateCustomerNumber();
          } else {}
          _showSearchResults = false;

          if (i.packing == 'p') {
            searchPacking = 'p';

            _afterSearch(
                i.productName!, i.sell!, i.barcode!, i.mrp!, i.buy!, true);
            _selectedIndex = -1;

            searchController.text = '';
          } else {
            setState(() {
              searchPacking = 'l';
              _afterSearchLoose(
                  i.productName!, i.sell!, i.barcode!, i.mrp!, i.buy!);
            });
          }
        });
      }
    }
  }

///////////filter
  ///
  List<Inventory> filterInventory(String searchText) {
    return _inventoryList.where((inventory) {
      final productNameMatches = inventory.productName!
          .toLowerCase()
          .contains(searchText.toLowerCase());

      final barcodeMatches = inventory.barcode!.contains(searchText);
      return productNameMatches || barcodeMatches;
    }).toList();
  }

  void _updateSearchResultsInventory(String searchText) {
    setState(() {
      _inventoryList1 = filterInventory(searchText);
      print(filteredContacts.length);
    });
  }

  /////customer search list
  ///
  List<Customer> filterCustomer(
      String searchText, List<Customer> _CustomerList0) {
    return _CustomerList0.where((inventory) {
      final productNameMatches =
          inventory.name!.toLowerCase().contains(searchText.toLowerCase());

      final barcodeMatches = inventory.phone!.contains(searchText);
      return productNameMatches || barcodeMatches;
    }).toList();
  }

  void _updateSearchResultsCustomer(String searchText) async {
    List<Customer> k = await _dbHelperC.fetchCustomer();
    setState(() {
      _CustomerList1 = filterCustomer(searchText, k);
      //print(filteredContacts.length);
      _addcust(_CustomerList1);
    });
  }

  _resetProduct11() {
    _ctrlProductName.clear();
    _ctrlMRP.clear();
    _ctrlDisc.clear();
    _ctrlQty.clear();
    _ctrlsell.clear();
    _ctrlsellDisc.clear();
    _ctrlBarcode.clear();
    _selectedIndex = -1;
    returnProduct = false;
    errorQty = '';
  }

  List<Inventory> filteredContacts = [];

  bool _productSearchColor = false;

  static List<SalesTransaction> _transactions1 = [];

  SalesTransaction _transaction1 = SalesTransaction();

  final _dbHelperTransaction1 = SalesTransactionOperation();

  _transaction() async {
    _transaction1.amount = _ctrlpayment.text.toString();

    _transaction1.description = '';
    _transaction1.orderCustom = 'order';
    _transaction1.paidReceived = 'paid';
    _transaction1.paymentMode = paymentMode.toString();

    _dbHelperTransaction1.insertSalesTransaction(_transaction1);
    _transaction1.orderId = _lastOrderId;

    int x = 0;
    //_transaction1.x = 'a';l
    x = await _dbHelperOrder1.insertSalesOrderId(_orderId);

    print(x);
  }

  bool _checkQty() {
    bool x = true;

    if (searchPacking == 'p') {
      for (var i in _inventoryList) {
        if (i.barcode == _ctrlBarcode.text) {
          if (double.parse(_ctrlQty.text) >= double.parse(i.qty!)) {
            errorQty = 'available ${i.qty} only';

            x = false;
          } else {
            errorQty = '';

            x = true;
          }
        }
      }
    }
    if (searchPacking == 'l') {
      for (var i in _inventoryList) {
        if (i.barcode == _ctrlBarcode.text) {
          if (double.parse(_ctrlQty.text) > double.parse(i.qty!)) {
            errorProductWeight = 'available ${i.qty} only';
            x = false;
          } else {
            errorProductWeight = '';
            x = true;
          }
        }
      }
    }
    setState(() {});

    return x;
  }

////////////////////// Printer /////////////////////////
////////////////////// Printer ////////////////////////
////////////////////// Printer ////////////////////////
////////////////////// Printer ////////////////////////
/*
  Future<Uint8List> generatePDF(double height, double width) async {
    final pdf = pw.Document();

    final listView = pw.ListView.builder(
      itemCount: cartList.length,
      itemBuilder: (context, index) {
        final item = cartList[index];
        return pw.Container(
          width: double.infinity,
          height: height * 0.045,
          padding: pw.EdgeInsets.only(right: 2),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
          ),
          child: pw.Container(
            child: pw.Container(
              width: double.infinity,
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 20,
                    height: double.infinity,
                    margin: const pw.EdgeInsets.only(right: 2),
                    child: pw.Center(
                      child: pw.Text(
                        cartList.keys.elementAt(index),
                        style:
                            pw.TextStyle(fontSize: 20, color: PdfColors.black),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Container(
                      height: double.infinity,
                      child: pw.Column(
                        children: [
                          pw.Container(
                            width: double.infinity,
                            height: 20,
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              cartList.values
                                  .elementAt(index)['productName']!
                                  .toUpperCase(),
                              style: pw.TextStyle(
                                  font: pw.Font.courierBold(),
                                  // fontFamily: 'BanglaBold',
                                  fontSize: 9,
                                  color: PdfColors.black),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Container(
                                width: double.infinity,
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Expanded(
                                      child: pw.Container(
                                        height: double.infinity,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                          cartList.values
                                              .elementAt(index)['mrp']!
                                              .toString(),
                                          style: pw.TextStyle(
                                              font: pw.Font.courier(),
                                              // fontFamily: 'Bangla',
                                              fontSize: 9,
                                              color: PdfColors.black),
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Container(
                                        alignment: pw.Alignment.center,
                                        height: double.infinity,
                                        child: pw.Text(
                                          cartList.values
                                              .elementAt(index)['disc']!
                                              .toString(),
                                          style: pw.TextStyle(
                                              font: pw.Font.courier(),
                                              fontSize: 9,
                                              color: PdfColors.black),
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Container(
                                        height: double.infinity,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                          cartList.values
                                              .elementAt(index)['qty']!
                                              .toString(),
                                          style: pw.TextStyle(
                                              font: pw.Font.courier(),
                                              fontSize: 9,
                                              color: PdfColors.black),
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Container(
                                        height: double.infinity,
                                        alignment: pw.Alignment.center,
                                        child: pw.Text(
                                          (double.parse(cartList.values
                                                      .elementAt(index)['qty']!
                                                      .toString()) *
                                                  double.parse(cartList.values
                                                      .elementAt(
                                                          index)['price']!
                                                      .toString()))
                                              .toString(),
                                          style: pw.TextStyle(
                                              font: pw.Font.courier(),
                                              fontSize: 9,
                                              color: PdfColors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(144, double.infinity),
        build: (context) {
          return pw.Container(
            color: PdfColors.white,
            //height: height * 0.8,
            width: double.infinity,
            margin:
                const pw.EdgeInsets.only(top: 5, right: 0, bottom: 5, left: 0),
            child: pw.Column(
              children: [
                //cart card
                pw.Container(
                  width: double.infinity,
                  height: height * 0.045,
                  padding: pw.EdgeInsets.only(right: 2),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.black,
                  ),
                  child: pw.Container(
                    child: pw.Container(
                      width: double.infinity,
                      child: pw.Row(
                        children: [
                          pw.Container(
                            width: 20,
                            height: double.infinity,
                            margin: const pw.EdgeInsets.only(right: 2),
                            child: pw.Center(
                              child: pw.Text(
                                '#',
                                style: pw.TextStyle(
                                    fontSize: 20, color: PdfColors.white),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Container(
                              height: double.infinity,
                              child: pw.Column(
                                children: [
                                  pw.Container(
                                    width: double.infinity,
                                    height: 20,
                                    alignment: pw.Alignment.centerLeft,
                                    child: pw.Text(
                                      'Product',
                                      style: pw.TextStyle(
                                          font: pw.Font.courierBold(),
                                          // fontFamily: 'BanglaBold',
                                          fontSize: 9,
                                          color: PdfColors.white),
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Container(
                                        width: double.infinity,
                                        child: pw.Row(
                                          crossAxisAlignment:
                                              pw.CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              pw.MainAxisAlignment.center,
                                          children: [
                                            pw.Expanded(
                                              child: pw.Container(
                                                height: double.infinity,
                                                alignment: pw.Alignment.center,
                                                child: pw.Text(
                                                  'MRP',
                                                  style: pw.TextStyle(
                                                      font: pw.Font.courier(),
                                                      // fontFamily: 'Bangla',
                                                      fontSize: 9,
                                                      color: PdfColors.white),
                                                ),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                alignment: pw.Alignment.center,
                                                height: double.infinity,
                                                child: pw.Text(
                                                  'Disc.',
                                                  style: pw.TextStyle(
                                                      font: pw.Font.courier(),
                                                      fontSize: 9,
                                                      color: PdfColors.white),
                                                ),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                height: double.infinity,
                                                alignment: pw.Alignment.center,
                                                child: pw.Text(
                                                  'QTY',
                                                  style: pw.TextStyle(
                                                      font: pw.Font.courier(),
                                                      fontSize: 9,
                                                      color: PdfColors.white),
                                                ),
                                              ),
                                            ),
                                            pw.Expanded(
                                              child: pw.Container(
                                                height: double.infinity,
                                                alignment: pw.Alignment.center,
                                                child: pw.Text(
                                                  'Total',
                                                  style: pw.TextStyle(
                                                      font: pw.Font.courier(),
                                                      fontSize: 9,
                                                      color: PdfColors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // cart card listview
                pw.Container(
                  height: cartList.length < 8 ? height * 0.8 : null,
                  // height: 300,
                  width: double.infinity,
                  margin: pw.EdgeInsets.only(
                    top: 5,
                  ),
                  child: pw.Container(child: listView),
                ),

                //disc
                pw.Container(
                  height: height * 0.012,
                  width: double.infinity,
                  padding: pw.EdgeInsets.only(top: 1, left: 2),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          top:
                              pw.BorderSide(width: 1, color: PdfColors.black))),
                  child: pw.Text(
                    'Discount: ${disc}',
                    style: pw.TextStyle(
                        //fontFamily: 'BanglaBold',
                        fontSize: 7,
                        color: PdfColors.black),
                  ),
                ),

                // total price
                pw.Container(
                  height: height * 0.03,
                  width: double.infinity,
                  margin: pw.EdgeInsets.only(right: 0),
                  padding: const pw.EdgeInsets.only(right: 0),
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(0),
                    color: PdfColors.black,
                  ),
                  child: pw.Column(
                    children: [
                      pw.Expanded(
                        child: pw.Container(
                          margin: pw.EdgeInsets.only(right: 10),
                          alignment: pw.Alignment.centerRight,
                          width: double.infinity,
                          child: pw.Text(
                            'Total: $totalPrice',
                            style: pw.TextStyle(
                              font: pw.Font.courierBold(),
                              fontSize: 15,
                              color: PdfColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );

    // Generate the PDF as bytes
    final pdfBytes = await pdf.save();

    return pdfBytes;
  }

  /*Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text('Hello, PDF!'),
          );
        },
      ),
    );

    // Generate the PDF as bytes
    final pdfBytes = await pdf.save();

    return pdfBytes;
  }*/

  Future<void> sharePDF(double height, double width) async {
    final pdfBytes = await generatePDF(height, width);

    // Save the PDF temporarily
    final directory = await getTemporaryDirectory();
    String name = _ctrlCustomerName.text;
    final filePath = '${directory.path}/${name}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Share the PDF via WhatsApp
    await Share.shareFiles([filePath], text: 'Check out this PDF:');

    // Delete the temporarily saved PDF
    await file.delete();
  }

  Future<void> viewPDF(double height, double width) async {
    final pdfBytes = await generatePDF(height, width);

    // Save the PDF temporarily
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/invoice.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    filePath1 = filePath;

    setState(() {});
  }
*/
  bool pdfView = false;
  bool pdfViewWhatsapp = false;
  String filePath1 = '';

  late Uint8List pdfData;

  Widget card(
      double height,
      double width,
      String no,
      String product,
      String qty,
      String mrp,
      String disc,
      String total,
      String barcode,
      int index,
      BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 0, right: 0),
          // height: height * 0.15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              //color: Colors.black,
              color: _selectedIndex == index ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey, // Color of the shadow
                  offset: Offset.zero, // Offset of the shadow
                  blurRadius: 6, // Spread or blur radius of the shadow
                  spreadRadius: 0, // How much the shadow should spread
                )
              ]),
          padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
          child: Column(
            children: [
              //product
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${cartList.values.elementAt(index)['productName']!}',
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontSize: 17,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //other
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                  height: 36,
                  margin: EdgeInsets.only(bottom: 4),
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //mrp
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'mrp  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 15.3,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${cartList.values.elementAt(index)['mrp']!}',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 19.8,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //disc
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: double.infinity,
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'disc  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 15.3,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${((double.parse(cartList.values.elementAt(index)['disc']!) / double.parse(cartList.values.elementAt(index)['mrp']!)) * 100).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: _selectedIndex == index
                                        ? Colors.white
                                        : Colors.black,

                                    fontSize: 19.8,
                                    fontFamily: 'Koulen',
                                    //fontWeight: FontWeight.w100
                                  ),
                                ),
                                TextSpan(
                                  text: ' %',
                                  style: TextStyle(
                                    color: _selectedIndex == index
                                        ? Colors.white
                                        : Colors.black,

                                    fontSize: 14,
                                    fontFamily: 'Koulen',
                                    //fontWeight: FontWeight.w100
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //qty
                      Expanded(
                        child: Container(
                          // width: width * 0.14,
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'qty  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 15.3,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${cartList.values.elementAt(index)['qty']!}',
                                  style: TextStyle(
                                    color: Color.fromRGBO(2, 120, 174, 1),
                                    fontSize: 19.8,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //total
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: double.infinity,
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: 'total  ',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15.3,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${(double.parse(cartList.values.elementAt(index)['price']!) * double.parse(cartList.values.elementAt(index)['qty']!)).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : Colors.black,

                                  fontSize: 19.8,
                                  fontFamily: 'Koulen',
                                  //fontWeight: FontWeight.w100
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),

              Container(
                height: 1,
                width: double.infinity,
                color: Colors.black,
                margin: const EdgeInsets.only(left: 0, right: 0),
              )
            ],
          ),
        ),
        onTap: () {
          Vibration.vibrate(duration: 100);
          if (_selectedIndex == index) {
            setState(() {
              _resetProduct();
              _selectedIndex = -1;
              returnProduct = false;
              errorQty = '';
            });
          } else {
            setState(() {
              _ctrlProductName.text = product;
              _ctrlMRP.text = mrp;
              _ctrlDisc.text = disc;
              _ctrlQty.text = qty;
              _ctrlsell.text =
                  (double.parse(mrp) - double.parse(disc)).toString();
              _ctrlsellDisc.text =
                  (double.parse(mrp) - double.parse(disc)).toString();

              _ctrlBarcode.text = barcode;

              errorQty = '';

              _selectedIndex = index;
              returnProduct = false;
              if (barcode.length < 13) {
                searchPacking = 'l';
              } else {
                searchPacking = 'p';
              }
            });
          }
        },
      ),
    );
  }

  Widget cardPrint(
      double height, double width, int index, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 0, right: 0),
      // height: height * 0.15,
      decoration: BoxDecoration(
        //color: Colors.black,
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
      child: Column(
        children: [
          //product
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text:
                        '${cartList.values.elementAt(index)['productName']!.toUpperCase()}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        //fontFamily: 'Koulen',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          //other
          Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
              height: 36,
              margin: EdgeInsets.only(bottom: 4),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //mrp
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${cartList.values.elementAt(index)['mrp']!}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.8,
                                  fontWeight: FontWeight.bold

                                  //fontFamily: 'Koulen',
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //disc
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${((double.parse(cartList.values.elementAt(index)['disc']!) / double.parse(cartList.values.elementAt(index)['mrp']!)) * 100).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,

                                fontSize: 19.8,
                                //fontFamily: 'Koulen',
                                //fontWeight: FontWeight.w100
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //qty
                  Expanded(
                    child: Container(
                      // width: width * 0.14,
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${cartList.values.elementAt(index)['qty']!}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.8,
                                  fontWeight: FontWeight.bold
                                  //fontFamily: 'Koulen',
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  //total
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${(double.parse(cartList.values.elementAt(index)['price']!) * double.parse(cartList.values.elementAt(index)['qty']!)).toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.8,
                                  fontWeight: FontWeight.bold
                                  //fontFamily: 'Koulen',
                                  //fontWeight: FontWeight.w100
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),

          Container(
            height: 1,
            width: double.infinity,
            color: Colors.black,
            margin: const EdgeInsets.only(left: 0, right: 0),
          )
        ],
      ),
    );
  }

  /////// bluetooth printer //////
  /////// bluetooth printer //////
  /////// bluetooth printer //////
  /////// bluetooth printer //////
  ///
  ///
  ScreenshotController screenshotController = ScreenshotController();

  void printer1() async {}

  Future<void> shareCapturedImage(Uint8List jpegBytes) async {
    try {
      // Uint8List jpegBytes = await captureWidgetAsImage(widgetKey);
      // Uint8List jpegBytes = await convertWidgetToImage(widgetKey, height, width);

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = await File('${tempDir.path}/captured_image.jpg')
          .writeAsBytes(jpegBytes);

      // Share the image
      /* await Share.shareFiles(
        [tempFile.path],
        text: "36: Today's Offers!",
      );*/

      List<LineText> list1 = [];
      List<LineText> list = [];
      List<LineText> list2 = [];
      Map<String, dynamic> config = Map();
      // 标签间隔，单位mm
      //ByteData data = await rootBundle.load("${tempDir.path}/captured_image.jpg");
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '**********************************************',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '36 STORES',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Ph No. 8168889152',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));

      list2.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '**********************************************',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list2.add(LineText(linefeed: 1));

      list2.add(LineText(linefeed: 1));

      List<int> imageBytes = jpegBytes.buffer
          .asUint8List(jpegBytes.offsetInBytes, jpegBytes.lengthInBytes);
      String base64Image = base64Encode(imageBytes);
      //list1.add(LineText(type: LineText.TYPE_IMAGE, x:10, y:10, content: base64Image,));

      list1.add(LineText(
          type: LineText.TYPE_IMAGE,
          x: 0,
          y: 0,
          content: base64Image,
          height: 800,
          width: 380,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));

      // await bluetoothPrint.printLabel(config, list);
      await bluetoothPrint.printLabel(config, list1);
      // await bluetoothPrint.printLabel(config, list2);
      //await bluetoothPrint.printReceipt(config, list);
    } catch (e) {
      print('Error sharing the image: $e');
    }
  }

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';
/*
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    // bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }
*/

  Widget xxxx(double height, double width) {
    return Container(
      width: width * 0.35,
      //height: 800,
      color: Colors.white,
      //height: double.infinity,
      padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            //height: 65,

            // color: Colors.black,
            //  margin: EdgeInsets.only(bottom: 2),
            child: Text(
              '${storeName}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 50, color: Colors.black, fontFamily: 'Koulen'),
            ),
          ),
          Container(
            width: double.infinity,
            // height: 40,

            // color: Colors.black,
            //  margin: EdgeInsets.only(bottom: 2),
            child: Text(
              '${storePhone}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          Container(
            width: double.infinity,
            //  height: 40,

            // color: Colors.black,
            //  margin: EdgeInsets.only(bottom: 2),
            child: Text(
              '${storeAddress.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          Container(
            // height: 20,
            //  color: Colors.black,
            width: double.infinity,
            margin: EdgeInsets.only(right: 10, bottom: 5, top: 10),
            // height: 150,
            // alignment: FractionalOffset.topRight,
            child: Row(
              children: [
                Expanded(child: Container()),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${DateFormat('dd-MM-yyyy').format(DateTime.now())}  ${DateTime.now().hour}:${DateTime.now().minute}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          //fontFamily: 'Koulen',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, left: 4, right: 4),

            child: Text(
              '*******************************************',
              textAlign: TextAlign.center,
              style: TextStyle(
                //color: Color.fromRGBO(92, 94, 98, 1),
                color: Colors.black,
                fontSize: 20,
                //fontFamily: 'Koulen',
              ),
            ),
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 0, right: 0),
            // height: height * 0.15,
            decoration: BoxDecoration(
              //color: Colors.black,
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
            child: Column(
              children: [
                //product
                Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PRODUCT',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          //fontFamily: 'Koulen',
                          fontWeight: FontWeight.bold),
                    )),
                //other
                Container(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                    height: 36,
                    margin: EdgeInsets.only(bottom: 4),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //mrp
                        Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: Text(
                                'MRP',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    //fontFamily: 'Koulen',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        //disc
                        Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: Text(
                                'DISC %',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    //fontFamily: 'Koulen',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        //qty
                        Expanded(
                          child: Container(
                              // width: width * 0.14,
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: Text(
                                'QTY',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    //fontFamily: 'Koulen',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),

                        //total
                        Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: Text(
                                'TOTAL',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    //fontFamily: 'Koulen',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    )),

                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.black,
                  margin: const EdgeInsets.only(left: 0, right: 0),
                )
              ],
            ),
          ),

          // cardCart(height, width, 1, context),
          Expanded(
            child: Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (cartList.isNotEmpty) {
                      return cardPrint(height, width, index, context);
                    } else {
                      return const Text('Select Supplier');
                    }
                  }),
            ),
          ),
          //disc
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, left: 4),
            margin: const EdgeInsets.only(top: 5, right: 0),

            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Disc.  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 16,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text:
                        '${((disc / (totalPrice + disc)) * 100).toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                  TextSpan(
                    text: ' %',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        //fontWeight: FontWeight.w100
                        ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, left: 4, right: 4),

            child: Text(
              '*******************************************',
              textAlign: TextAlign.center,
              style: TextStyle(
                //color: Color.fromRGBO(92, 94, 98, 1),
                color: Colors.black,
                fontSize: 20,
                //fontFamily: 'Koulen',
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 4),
            alignment: Alignment.centerLeft,
            //height: double.infinity,
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Total Prod.  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 27,
                      fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '${cartList.length}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 37,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 4),
            alignment: Alignment.centerLeft,
            //height: double.infinity,
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Total Amt  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 27,
                      fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '$totalPrice',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 37,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 5, left: 4, right: 4),

            child: Text(
              '*******************************************',
              textAlign: TextAlign.center,
              style: TextStyle(
                //color: Color.fromRGBO(92, 94, 98, 1),
                color: Colors.black,
                fontSize: 20,
                //fontFamily: 'Koulen',
              ),
            ),
          ),

          //delivery mode
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, left: 4),
            margin: const EdgeInsets.only(top: 5, right: 0),

            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Delivery Mode  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '${deliveryMode.toUpperCase()}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                ],
              ),
            ),
          ),

//payment status
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, left: 4),
            margin: const EdgeInsets.only(top: 5, right: 0),

            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Payment Status  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: paymentStatus == 'full'
                        ? 'COMPLETE'
                        : '${paymentStatus.toUpperCase()}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                ],
              ),
            ),
          ),
          //paid amt
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, left: 4),
            margin: const EdgeInsets.only(top: 5, right: 0),

            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Paid Amt.  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '${_ctrlpayment.text}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                ],
              ),
            ),
          ),

//payment mode
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, left: 4),
            margin: const EdgeInsets.only(top: 5, right: 0),

            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Payment Mode  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '${paymentMode.toUpperCase()}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                ],
              ),
            ),
          ),

//cash
          if (paymentMode == 'cash')
            Container(
              //height: height * 0.04,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, left: 4),
              margin: const EdgeInsets.only(top: 5, right: 0),

              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Cash   ',
                      style: TextStyle(
                        //color: Color.fromRGBO(92, 94, 98, 1),
                        color: Colors.black,
                        fontSize: 18,
                        //fontFamily: 'Koulen',
                      ),
                    ),
                    TextSpan(
                      text: '${_ctrlPayment.text}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold
                          //fontFamily: 'Koulen',
                          ),
                    ),
                  ],
                ),
              ),
            ),

          //change
          if (paymentMode == 'cash')
            Container(
              //height: height * 0.04,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, left: 4),
              margin: const EdgeInsets.only(top: 5, right: 0),

              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Change  ',
                      style: TextStyle(
                        //color: Color.fromRGBO(92, 94, 98, 1),
                        color: Colors.black,
                        fontSize: 18,
                        //fontFamily: 'Koulen',
                      ),
                    ),
                    TextSpan(
                      text: '${_ctrlPaymentChange.text}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold
                          //fontFamily: 'Koulen',
                          ),
                    ),
                  ],
                ),
              ),
            ),

          //customer details
          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, left: 4),
            margin: const EdgeInsets.only(top: 5, right: 0),

            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Customer Details  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Bangla',
                    ),
                  ),
                  TextSpan(
                    text:
                        '${_ctrlCustomerName.text.toUpperCase()} - ${_ctrlCustomerPhone.text}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold
                        //fontFamily: 'Koulen',
                        ),
                  ),
                ],
              ),
            ),
          ),
//customer details
          if (deliveryMode == 'home')
            Container(
              //height: height * 0.04,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, left: 4),
              margin: const EdgeInsets.only(top: 5, right: 0),

              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Customer Add.  ',
                      style: TextStyle(
                        //color: Color.fromRGBO(92, 94, 98, 1),
                        color: Colors.black,
                        fontSize: 18,
                        //fontFamily: 'Bangla',
                      ),
                    ),
                    TextSpan(
                      text: _ctrlCustomerAddress.text.toUpperCase(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold
                          //fontFamily: 'Koulen',
                          ),
                    ),
                  ],
                ),
              ),
            ),

          if (deliveryMode == 'home')
            Container(
              height: 400,
              width: double.infinity,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: QrImageView(
                data:
                    "upi://pay?pa=${storeUpi}&pn=${storeName}&am='${paymentStatus == 'full' ? totalPrice : _ctrlpayment.text}'&cu=INR&mode=01&purpose=10&orgid=-&sign=-",
                version: QrVersions.auto,
              ),
            ),

          //Thank you
          Container(
              //height: height * 0.04,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, left: 4, right: 5),
              margin: const EdgeInsets.only(top: 0, right: 0),
              child: Text(
                'Thank You For Shopping With Us!',
                style: TextStyle(
                  //color: Color.fromRGBO(92, 94, 98, 1),
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Koulen',
                ),
              )),

          Container(
            //height: 20,
            //  color: Colors.black,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, bottom: 30),
            // height: 150,
            // alignment: FractionalOffset.topRight,
          ),
        ],
      ),
    );
  }

  int z = 15;

  String errorDelivery = '';

  bool checkout = false;

  String orderId = '';

  Widget CardQuickAdd(
      double height, double width, int index, BuildContext context) {
    return Dismissible(
      key: Key(_inventoryListQuickAdd[index].id.toString()),
      confirmDismiss: (direction) async {
       for (var i in _quickAddList) {
          if (_inventoryListQuickAdd[index].barcode == i.barcode) {
            _quickAdd = i;
          }
        }
        

         if (_inventoryListQuickAdd[index].packing == 'p') {
            searchPacking = 'p';

            _afterSearch(
                _inventoryListQuickAdd[index].productName!,
                _inventoryListQuickAdd[index].sell!,
                _inventoryListQuickAdd[index].barcode!,
                _inventoryListQuickAdd[index].mrp!,
                _inventoryListQuickAdd[index].buy!,
                true);
            //_selectedIndex = -1;

            searchController.text = '';
          } else {
            setState(() {
              searchPacking = 'l';
              _afterSearchLoose(
                _inventoryListQuickAdd[index].productName!,
                _inventoryListQuickAdd[index].sell!,
                _inventoryListQuickAdd[index].barcode!,
                _inventoryListQuickAdd[index].mrp!,
                _inventoryListQuickAdd[index].buy!,
              );
            });
          }

        setState(() {});
        return await false;
      },
      direction: DismissDirection.endToStart,

      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          //items.removeAt(index);
        });

        // Then show a snackbar.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('dismissed')));
      },
      // Show a red background as the item is swiped away.

      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        margin: EdgeInsets.only(bottom: 0, top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 134, 193, 1),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          'Add to cart',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
        ),
      ),
      child: InkWell(
        child: Container(
          height: height * 0.07,
          width: double.infinity,

          margin: EdgeInsets.only(bottom: 0, top: 10, left: 0, right: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  // Color of the shadow
                  offset: Offset.zero, // Offset of the shadow
                  blurRadius: 6, // Spread or blur radius of the shadow
                  spreadRadius: 0, // How much the shadow should spread
                )
              ]),
          //padding: const EdgeInsets.only( top: 10),
          child: Row(
            children: [
              Container(
                //width: width * 0.08,
                height: double.infinity,
                //color: const Color.fromRGBO(244, 244, 244, 1),
                margin: const EdgeInsets.only(right: 20, left: 20),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'qty ',
                          style: TextStyle(
                            color: Color.fromRGBO(92, 94, 98, 1),
                            fontSize: 16,
                            fontFamily: 'Koulen',
                          ),
                        ),
                        TextSpan(
                          text: '${_inventoryListQuickAdd[index].qty}',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 134, 193, 1),
                            fontSize: 35,
                            fontFamily: 'Koulen',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  //height: 40,
                  //color: const Color.fromRGBO(
                  //  244, 244, 244, 1),

                  child: Container(
                    width: double.infinity,
                    //height: 40,
                    alignment: Alignment.centerLeft,
                    //color: const Color.fromRGBO(244, 244, 244, 1),
                    padding: const EdgeInsets.only(top: 5),

                    child: Text(
                      '${_inventoryListQuickAdd[index].productName}',
                      style: TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          /* if (indexSelected == index) {
                  indexSelected = -1;
                } else {
                  indexSelected = index;
                }
                setState(() {});*/
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 0, right: 0),
          width: double.infinity,
          height: height * 0.9,
          color: const Color.fromRGBO(244, 244, 244, 1),
          child: Row(
            children: [
              //row1
              Container(
                width: width * 0.33,
                height: double.infinity,
                padding: EdgeInsets.only(left: 5, right: 10, top: 5, bottom: 5),
                child: Column(
                  children: [
                    Container(
                      height: height * 0.02,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2)),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey, // Color of the shadow
                              offset: Offset.zero, // Offset of the shadow
                              blurRadius:
                                  6, // Spread or blur radius of the shadow
                              spreadRadius:
                                  0, // How much the shadow should spread
                            )
                          ]),
                    ),
                    // cardCart(height, width, 1, context),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        child: ListView.builder(
                            itemCount: cartList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (cartList.isNotEmpty) {
                                return card(
                                    height,
                                    width,
                                    cartList.keys.elementAt(index),
                                    cartList.values
                                        .elementAt(index)['productName']!
                                        .toUpperCase(),
                                    cartList.values
                                        .elementAt(index)['qty']!
                                        .toUpperCase(),
                                    cartList.values
                                        .elementAt(index)['mrp']!
                                        .toUpperCase(),
                                    cartList.values
                                        .elementAt(index)['disc']!
                                        .toUpperCase(),
                                    '${double.parse(cartList.values.elementAt(index)['price']!) * double.parse(cartList.values.elementAt(index)['qty']!)}',
                                    cartList.values
                                        .elementAt(index)['barcode']!
                                        .toUpperCase(),
                                    index,
                                    context);
                              } else {
                                return const Text('Select Supplier');
                              }
                            }),
                      ),
                    ),
                    //disc
                    Container(
                      //height: height * 0.04,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 0, left: 4),
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(width: 1, color: Colors.black))),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Disc.  ',
                              style: TextStyle(
                                color: Color.fromRGBO(92, 94, 98, 1),
                                fontSize: 16,
                                fontFamily: 'Koulen',
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${((disc / (totalPrice + disc)) * 100).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontFamily: 'Koulen',
                              ),
                            ),
                            TextSpan(
                              text: ' %',
                              style: TextStyle(
                                color: Colors.black,

                                fontSize: 14,
                                fontFamily: 'Koulen',
                                //fontWeight: FontWeight.w100
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      height: height * 0.06,
                      width: double.infinity,
                      margin: const EdgeInsets.only(right: 0),
                      padding: const EdgeInsets.only(right: 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey, // Color of the shadow
                              offset: Offset.zero, // Offset of the shadow
                              blurRadius:
                                  6, // Spread or blur radius of the shadow
                              spreadRadius:
                                  0, // How much the shadow should spread
                            )
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20),
                              alignment: Alignment.centerLeft,
                              height: double.infinity,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Total Prod.  ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 20,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${cartList.length}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 20),
                              alignment: Alignment.centerRight,
                              height: double.infinity,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Total Amt  ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 20,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text: '$totalPrice',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //row2 and row3

              if (true)
                Expanded(
                  child: Container(
                    height: double.infinity,
                    child: Column(
                      children: [
                        Expanded( 
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 0),
                            child: Row(
                              children: [
                                //product search

                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: width * 0.0001,
                                          height: height * 0.0001,
                                          //height: height * 0.001,
                                          child: VisibilityDetector(
                                            onVisibilityChanged:
                                                (VisibilityInfo info) {
                                              visible =
                                                  info.visibleFraction > 0;
                                            },
                                            key: const Key(
                                                'visible-detector-key'),
                                            child: BarcodeKeyboardListener(
                                              bufferDuration: const Duration(
                                                  milliseconds: 200),
                                              onBarcodeScanned: (barcode) {
                                                if (!visible) {
                                                  return;
                                                }
                                                _scanner(barcode);

                                                setState(() {
                                                  if (lastCustomerNumber ==
                                                      null) {
                                                    _generateCustomerNumber();
                                                  } else {}
                                                  _showSearchResults = false;

                                                  // _purchaseEntry(barcode);
                                                  searchController.text = '';
                                                });
                                              },
                                              child: Text(
                                                _barcode == null
                                                    ? 'SCAN BARCODE'
                                                    : 'BARCODE: $_barcode',
                                              ),
                                            ),
                                          ),
                                        ),

                                        //product search
                                        InkWell(
                                          child: Container(
                                            height: height * 0.05,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .grey, // Color of the shadow
                                                    offset: Offset
                                                        .zero, // Offset of the shadow
                                                    blurRadius:
                                                        6, // Spread or blur radius of the shadow
                                                    spreadRadius:
                                                        0, // How much the shadow should spread
                                                  )
                                                ],
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            margin: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Center(
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.bottom,
                                                readOnly:
                                                    true, // Prevent system keyboard
                                                showCursor: false,

                                                focusNode: _productSearch,
                                                controller: searchController,
                                                onChanged: (value) {
                                                  _showSearchResults = true;
                                                  updateList(
                                                      value.toLowerCase());
                                                },
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.bold,

                                                  //fontFamily: 'Bangla'
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.transparent,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          51,
                                                                          154,
                                                                          1),
                                                                  width: 2),
                                                        ),
                                                        hintText: '',
                                                        hintStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                        prefixIcon:
                                                            Icon(Icons.search),
                                                        prefixIconColor:
                                                            Colors.black),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Vibration.vibrate(duration: 100);
                                            // _textFieldFocusChange('productSearch');
                                            _productSearch.requestFocus();
                                            _productSearchColor = true;
                                            setState(() {});
                                          },
                                        ),

                                        //return
                                        if (_ctrlProductName.text != '')
                                          Row(
                                            children: [
                                              InkWell(
                                                  child: Container(
                                                    height: height * 0.07,
                                                    width: width * 0.022,
                                                    // height: height * 0.022,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 1),
                                                        shape: BoxShape.circle),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      width: width * 0.008,
                                                      // height: height * 0.022,
                                                      decoration: BoxDecoration(
                                                          color: ((returnProduct ==
                                                                      true) ||
                                                                  ((double.tryParse(_ctrlQty
                                                                              .text) ==
                                                                          null)
                                                                      ? false
                                                                      : (double.parse(_ctrlQty.text) <
                                                                              0)
                                                                          ? true
                                                                          : false))
                                                              ? Colors.black
                                                              : Colors
                                                                  .transparent,
                                                          shape:
                                                              BoxShape.circle),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Vibration.vibrate(
                                                        duration: 100);
                                                    setState(() {
                                                      _return();
                                                      returnProduct =
                                                          !returnProduct;
                                                    });
                                                  }),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                height: height * 0.07,
                                                width: width * 0.05,
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 5, top: 5),
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: const Text(
                                                  'Return',
                                                  style: TextStyle(
                                                    fontFamily: 'Bangla',
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container())
                                            ],
                                          ),

                                        //packed
                                        if (searchPacking == 'p' &&
                                            _showSearchResults == false &&
                                            _ctrlProductName.text != '')
                                          Expanded(
                                            child: Container(
                                              // height: double.infinity,
                                              width: double.infinity,
                                              child: Form(
                                                child: Column(
                                                  children: [
                                                    //productname
                                                    Container(
                                                      height: height * 0.09,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5,
                                                              top: 0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,

                                                            //color: Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            child: const Text(
                                                                'Product',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          238,
                                                                          72,
                                                                          72,
                                                                          73),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.w100
                                                                )),
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                height * 0.047,
                                                            //color: Colors.black,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    right: 5,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 2,
                                                                    bottom: 0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: _ctrlProductName.text !=
                                                                            ''
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .white, // Color of the shadow
                                                                    offset: Offset
                                                                        .zero, // Offset of the shadow
                                                                    blurRadius:
                                                                        6, // Spread or blur radius of the shadow
                                                                    spreadRadius:
                                                                        0, // How much the shadow should spread
                                                                  )
                                                                ]),
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              //focusNode: _focusNodeProduct,
                                                              controller:
                                                                  _ctrlProductName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  fontSize: 16),
                                                              cursorColor:
                                                                  Colors.black,

                                                              //enabled: !lock,

                                                              decoration:
                                                                  const InputDecoration(
                                                                //prefixIcon: Icon(Icons.person),
                                                                //prefixIconColor: Colors.black,
                                                                disabledBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none),

                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none),

                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none),

                                                                labelStyle:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  color: Colors
                                                                      .black,
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                                //counterStyle: TextStyle(color: Colors.white, ),
                                                                labelText: '',
                                                              ),

                                                              /* decoration: const InputDecoration(
                                                                    labelText: 'Product Name'),*/
                                                              validator:
                                                                  (val) =>

                                                                      // ignore: prefer_is_empty
                                                                      (val!.length ==
                                                                              0
                                                                          ? 'This field is mandatory'
                                                                          : null),
                                                              onSaved: (val) =>
                                                                  {
                                                                setState(() {
                                                                  //_inventory.productName = val;
                                                                  //_supply.productName = val;
                                                                }),
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    //qty and mrp
                                                    Container(
                                                      height: height * 0.11,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 10),
                                                      child: Row(
                                                        children: [
                                                          //qty
                                                          Expanded(
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom: 0,
                                                                      top: 0,
                                                                      left: 5),
                                                              child: Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: double
                                                                          .infinity,

                                                                      //color: Colors.white,
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                      child: const Text(
                                                                          'Qty',
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromARGB(
                                                                                238,
                                                                                72,
                                                                                72,
                                                                                73),
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                'koulen',
                                                                            //fontWeight: FontWeight.w100
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                      height: height *
                                                                          0.047,
                                                                      width: double
                                                                          .infinity,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                width * 0.02,
                                                                            height:
                                                                                double.infinity,
                                                                            margin:
                                                                                const EdgeInsets.only(right: 15),
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  Vibration.vibrate(duration: 100);
                                                                                  //returnProduct = false;
                                                                                  if (returnProduct == false) {
                                                                                    if (double.parse(_ctrlQty.text) > 1) {
                                                                                      _ctrlQty.text = '${int.parse(_ctrlQty.text) - 1}';

                                                                                      _afterSearch(_ctrlProductName.text, _ctrlsell.text, _ctrlBarcode.text, _ctrlMRP.text, _ctrlBuy.text, false);
                                                                                    }
                                                                                  } else {
                                                                                    if (double.parse(_ctrlQty.text) < 0) {
                                                                                      _ctrlQty.text = '${int.parse(_ctrlQty.text) + 1}';

                                                                                      _afterSearch(_ctrlProductName.text, _ctrlsell.text, _ctrlBarcode.text, _ctrlMRP.text, _ctrlBuy.text, false);
                                                                                    }
                                                                                  }
                                                                                  errorQty = '';
                                                                                  setState(() {});
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.remove,
                                                                                  color: Colors.black,
                                                                                )),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                double.infinity,
                                                                            width:
                                                                                width * 0.05,
                                                                            //color: Colors.black,
                                                                            padding: const EdgeInsets.only(
                                                                                left: 5,
                                                                                right: 5,
                                                                                top: 0,
                                                                                bottom: 0),
                                                                            margin: const EdgeInsets.only(
                                                                                left: 0,
                                                                                right: 0,
                                                                                top: 2,
                                                                                bottom: 0),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white, boxShadow: [
                                                                              BoxShadow(
                                                                                color: _ctrlQty.text != '' ? Colors.grey : Colors.white, // Color of the shadow
                                                                                offset: Offset.zero, // Offset of the shadow
                                                                                blurRadius: 6, // Spread or blur radius of the shadow
                                                                                spreadRadius: 0, // How much the shadow should spread
                                                                              )
                                                                            ]),

                                                                            child:
                                                                                TextFormField(
                                                                              onTap: () {
                                                                                Vibration.vibrate(duration: 100);
                                                                              },
                                                                              enabled: false,
                                                                              // textInputAction: TextInputAction.none,
                                                                              focusNode: _productQty,
                                                                              onChanged: (value) {
                                                                                _changeQty(_ctrlProductName.text);
                                                                              },
                                                                              textAlign: TextAlign.center,
                                                                              //focusNode: _focusNodeProduct,

                                                                              controller: _ctrlQty,
                                                                              style: const TextStyle(color: Colors.black, fontFamily: 'Koulen', fontSize: 18),
                                                                              cursorColor: Colors.black,

                                                                              //enabled: !lock,

                                                                              decoration: const InputDecoration(
                                                                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                                labelStyle: TextStyle(
                                                                                  fontFamily: 'Koulen',
                                                                                  color: Colors.black,
                                                                                  //fontWeight: FontWeight.bold
                                                                                ),
                                                                                //counterStyle: TextStyle(color: Colors.white, ),
                                                                                labelText: '',
                                                                              ),

                                                                              /* decoration: const InputDecoration(
                                                                    labelText: 'Product Name'),*/
                                                                              validator: (val) =>

                                                                                  // ignore: prefer_is_empty
                                                                                  (val!.length == 0 ? 'This field is mandatory' : null),
                                                                              onSaved: (val) => {
                                                                                setState(() {
                                                                                  //_inventory.productName = val;
                                                                                  //_supply.productName = val;
                                                                                }),
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                width * 0.02,
                                                                            height:
                                                                                double.infinity,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 0),
                                                                            child: IconButton(
                                                                                onPressed: () {
                                                                                  Vibration.vibrate(duration: 100);
                                                                                  //returnProduct = false;
                                                                                  if (returnProduct == false) {
                                                                                    if (_checkQty()) {
                                                                                      if (int.parse(_ctrlQty.text) >= 1) {
                                                                                        _ctrlQty.text = '${int.parse(_ctrlQty.text) + 1}';

                                                                                        _afterSearch(_ctrlProductName.text, _ctrlsell.text, _ctrlBarcode.text, _ctrlMRP.text, _ctrlBuy.text, true);
                                                                                      }
                                                                                    } else {}
                                                                                  } else {
                                                                                    if (_checkQty()) {
                                                                                      if (int.parse(_ctrlQty.text) < 1) {
                                                                                        _ctrlQty.text = '${int.parse(_ctrlQty.text) - 1}';

                                                                                        _afterSearch(_ctrlProductName.text, _ctrlsell.text, _ctrlBarcode.text, _ctrlMRP.text, _ctrlBuy.text, true);
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                  setState(() {});
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.add,
                                                                                  color: Colors.black,
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              0,
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                      width: double
                                                                          .infinity,
                                                                      height: height *
                                                                          0.022,
                                                                      //color: Colors.black,
                                                                      child:
                                                                          Text(
                                                                        errorQty,
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                'Koulen',
                                                                            fontSize:
                                                                                14,
                                                                            color: Color.fromRGBO(
                                                                                139,
                                                                                0,
                                                                                0,
                                                                                1),
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //mrp
                                                          Container(
                                                            height:
                                                                double.infinity,
                                                            width: width * 0.12,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,

                                                                  //color: Colors.white,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  child: const Text(
                                                                      'MRP',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromARGB(
                                                                            238,
                                                                            72,
                                                                            72,
                                                                            73),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        //fontWeight: FontWeight.w100
                                                                      )),
                                                                ),
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.047,
                                                                  width: double
                                                                      .infinity,
                                                                  //height: height * 0.04,
                                                                  //color: Colors.black,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 2,
                                                                      bottom:
                                                                          0),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              3),
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: _ctrlMRP.text != ''
                                                                              ? Colors.grey
                                                                              : Colors.white, // Color of the shadow
                                                                          offset:
                                                                              Offset.zero, // Offset of the shadow
                                                                          blurRadius:
                                                                              6, // Spread or blur radius of the shadow
                                                                          spreadRadius:
                                                                              0, // How much the shadow should spread
                                                                        )
                                                                      ]),
                                                                  child:
                                                                      TextFormField(
                                                                    //focusNode: _focusNodeProduct,
                                                                    enabled:
                                                                        false,
                                                                    controller:
                                                                        _ctrlMRP,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        fontSize:
                                                                            16),
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,

                                                                    //enabled: !lock,

                                                                    decoration:
                                                                        const InputDecoration(
                                                                      disabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),
                                                                      //prefixIcon: Icon(Icons.person),
                                                                      //prefixIconColor: Colors.black,
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      focusedBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        //fontWeight: FontWeight.bold
                                                                      ),
                                                                      //counterStyle: TextStyle(color: Colors.white, ),
                                                                      labelText:
                                                                          '',
                                                                    ),

                                                                    /* decoration: const InputDecoration(
                                                                        labelText: 'Product Name'),*/
                                                                    validator:
                                                                        (val) =>

                                                                            // ignore: prefer_is_empty
                                                                            (val!.length == 0
                                                                                ? 'This field is mandatory'
                                                                                : null),
                                                                    onSaved:
                                                                        (val) =>
                                                                            {
                                                                      setState(
                                                                          () {
                                                                        //_inventory.productName = val;
                                                                        //_supply.productName = val;
                                                                      }),
                                                                    },
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.022,
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 0,
                                                                      left: 0,
                                                                      right: 0,
                                                                      bottom:
                                                                          0),
                                                                  width: double
                                                                      .infinity,
                                                                  //height: height * 0.05,
                                                                  //color: Colors.black,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    //disc and price
                                                    Container(
                                                      height: height * 0.09,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 0),
                                                      child: Row(
                                                        children: [
                                                          //disc
                                                          Expanded(
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              // width: width*0.08
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 8,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),

                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: double
                                                                        .infinity,
                                                                    width:
                                                                        width *
                                                                            0.05,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,

                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          child: const Text(
                                                                              'Discount',
                                                                              style: TextStyle(
                                                                                color: Color.fromARGB(238, 72, 72, 73),
                                                                                fontSize: 14,
                                                                                fontFamily: 'Koulen',
                                                                                //fontWeight: FontWeight.w100
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              height * 0.047,
                                                                          //height: height * 0.04,
                                                                          //color: Colors.black,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 5,
                                                                              right: 5,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          margin: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 2,
                                                                              bottom: 0),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              color: Colors.white,
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: _ctrlDisc.text != '' ? Colors.grey : Colors.white, // Color of the shadow
                                                                                  offset: Offset.zero, // Offset of the shadow
                                                                                  blurRadius: 6, // Spread or blur radius of the shadow
                                                                                  spreadRadius: 0, // How much the shadow should spread
                                                                                )
                                                                              ]),
                                                                          child:
                                                                              TextFormField(
                                                                            textInputAction:
                                                                                TextInputAction.none,
                                                                            focusNode:
                                                                                _productDisc,
                                                                            //focusNode: _focusNodeProduct,
                                                                            controller:
                                                                                _ctrlDisc,
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontFamily: 'Koulen',
                                                                                fontSize: 16),
                                                                            cursorColor:
                                                                                Colors.black,

                                                                            enabled:
                                                                                false,

                                                                            decoration:
                                                                                const InputDecoration(
                                                                              //prefixIcon: Icon(Icons.person),
                                                                              //prefixIconColor: Colors.black,
                                                                              disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                              labelStyle: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 16
                                                                                  //fontWeight: FontWeight.bold
                                                                                  ),
                                                                              //counterStyle: TextStyle(color: Colors.white, ),
                                                                              labelText: '',
                                                                            ),

                                                                            /* decoration: const InputDecoration(
                                                                        labelText: 'Product Name'),*/
                                                                            validator: (val) =>

                                                                                // ignore: prefer_is_empty
                                                                                (val!.length == 0 ? 'This field is mandatory' : null),
                                                                            onSaved: (val) =>
                                                                                {
                                                                              setState(() {
                                                                                //_inventory.productName = val;
                                                                                //_supply.productName = val;
                                                                              }),
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: double
                                                                        .infinity,
                                                                    width:
                                                                        width *
                                                                            0.04,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            0,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,

                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          child: const Text(
                                                                              '',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontFamily: 'Koulen',
                                                                                //fontWeight: FontWeight.w100
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                            height: height *
                                                                                0.047,
                                                                            width: double
                                                                                .infinity,
                                                                            padding: const EdgeInsets.only(
                                                                                left: 5,
                                                                                right: 5,
                                                                                top: 0,
                                                                                bottom: 0),
                                                                            margin: const EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 0),
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Container(
                                                                                      height: double.infinity,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(3),
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                      alignment: Alignment.center,
                                                                                      margin: const EdgeInsets.only(left: 2, right: 0),
                                                                                      padding: const EdgeInsets.only(bottom: 0),
                                                                                      child: TextButton(
                                                                                        onPressed: () {},
                                                                                        child: const Text(
                                                                                          'Rs',
                                                                                          style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'BanglaBold'),
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          //price
                                                          Container(
                                                            height:
                                                                double.infinity,
                                                            width: width * 0.12,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,

                                                                  //color: Colors.white,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  child: const Text(
                                                                      'Price',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromARGB(
                                                                            238,
                                                                            72,
                                                                            72,
                                                                            73),
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        //fontWeight: FontWeight.w100
                                                                      )),
                                                                ),
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height:
                                                                      height *
                                                                          0.047,
                                                                  //height: height * 0.04,
                                                                  //color: Colors.black,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 2,
                                                                      bottom:
                                                                          0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: _ctrlsell.text !=
                                                                                ''
                                                                            ? Colors.grey
                                                                            : Colors.white, // Color of the shadow
                                                                        offset:
                                                                            Offset.zero, // Offset of the shadow
                                                                        blurRadius:
                                                                            6, // Spread or blur radius of the shadow
                                                                        spreadRadius:
                                                                            0, // How much the shadow should spread
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(3),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child:
                                                                      TextFormField(
                                                                    enabled:
                                                                        false,
                                                                    //focusNode: _focusNodeProduct,
                                                                    controller:
                                                                        _ctrlsell,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        fontSize:
                                                                            16),
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,

                                                                    //enabled: !lock,

                                                                    decoration:
                                                                        const InputDecoration(
                                                                      //prefixIcon: Icon(Icons.person),
                                                                      //prefixIconColor: Colors.black,
                                                                      disabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      focusedBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        //fontWeight: FontWeight.bold
                                                                      ),
                                                                      //counterStyle: TextStyle(color: Colors.white, ),
                                                                      labelText:
                                                                          '',
                                                                    ),

                                                                    /* decoration: const InputDecoration(
                                                                        labelText: 'Product Name'),*/
                                                                    validator:
                                                                        (val) =>

                                                                            // ignore: prefer_is_empty
                                                                            (val!.length == 0
                                                                                ? 'This field is mandatory'
                                                                                : null),
                                                                    onSaved:
                                                                        (val) =>
                                                                            {
                                                                      setState(
                                                                          () {
                                                                        //_inventory.productName = val;
                                                                        //_supply.productName = val;
                                                                      }),
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    //button
                                                    Container(
                                                      width: double.infinity,

                                                      height: height * 0.05,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 10,
                                                              left: 5,
                                                              right: 0),
                                                      //padding: EdgeInsets.only(bottom: 5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(),
                                                          ),
                                                          Container(
                                                              width:
                                                                  width * 0.13,
                                                              margin: const EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  top: 5,
                                                                  bottom: 0),
                                                              height: double
                                                                  .infinity,
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors
                                                                              .black),
                                                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  5)))),
                                                                      onPressed:
                                                                          () {
                                                                        Vibration.vibrate(
                                                                            duration:
                                                                                100);
                                                                        _removeFromCart();
                                                                      },
                                                                      child: const Text(
                                                                          'Remove from Cart',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Koulen',
                                                                              fontSize: 15,
                                                                              color: Colors.white)))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                        //loose
                                        if (searchPacking == 'l' &&
                                            _showSearchResults == false &&
                                            _ctrlProductName.text != '')
                                          Expanded(
                                            child: Container(
                                              //height: height * 0.7,
                                              width: double.infinity,
                                              child: Form(
                                                child: Column(
                                                  children: [
                                                    //productname
                                                    Container(
                                                      height: height * 0.09,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5,
                                                              top: 0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,

                                                            //color: Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            child: const Text(
                                                                'Product',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          238,
                                                                          72,
                                                                          72,
                                                                          73),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.w100
                                                                )),
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                height * 0.047,
                                                            //color: Colors.black,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5,
                                                                    right: 5,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 2,
                                                                    bottom: 0),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: _ctrlProductName.text !=
                                                                            ''
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .white, // Color of the shadow
                                                                    offset: Offset
                                                                        .zero, // Offset of the shadow
                                                                    blurRadius:
                                                                        6, // Spread or blur radius of the shadow
                                                                    spreadRadius:
                                                                        0, // How much the shadow should spread
                                                                  )
                                                                ]),
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              //focusNode: _focusNodeProduct,
                                                              controller:
                                                                  _ctrlProductName,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  fontSize: 16),
                                                              cursorColor:
                                                                  Colors.black,

                                                              //enabled: !lock,

                                                              decoration:
                                                                  const InputDecoration(
                                                                //prefixIcon: Icon(Icons.person),
                                                                //prefixIconColor: Colors.black,
                                                                disabledBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none),

                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none),

                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none),

                                                                labelStyle:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  color: Colors
                                                                      .black,
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                                //counterStyle: TextStyle(color: Colors.white, ),
                                                                labelText: '',
                                                              ),

                                                              /* decoration: const InputDecoration(
                                                                    labelText: 'Product Name'),*/
                                                              validator:
                                                                  (val) =>

                                                                      // ignore: prefer_is_empty
                                                                      (val!.length ==
                                                                              0
                                                                          ? 'This field is mandatory'
                                                                          : null),
                                                              onSaved: (val) =>
                                                                  {
                                                                setState(() {
                                                                  //_inventory.productName = val;
                                                                  //_supply.productName = val;
                                                                }),
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //weight and mrp
                                                    Container(
                                                      height: height * 0.11,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 10),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom: 0,
                                                                      top: 0,
                                                                      left: 0),
                                                              child: Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: double
                                                                          .infinity,

                                                                      //color: Colors.white,
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          top:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                      child: const Text(
                                                                          'Weight (Kg)',
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromARGB(
                                                                                238,
                                                                                72,
                                                                                72,
                                                                                73),
                                                                            fontSize:
                                                                                14,
                                                                            fontFamily:
                                                                                'Koulen',
                                                                            //fontWeight: FontWeight.w100
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                      height: height *
                                                                          0.048,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                double.infinity,
                                                                            width:
                                                                                width * 0.08,
                                                                            //color: Colors.black,
                                                                            padding: const EdgeInsets.only(
                                                                                left: 5,
                                                                                right: 5,
                                                                                top: 0,
                                                                                bottom: 0),
                                                                            margin: const EdgeInsets.only(
                                                                                left: 0,
                                                                                right: 0,
                                                                                top: 2,
                                                                                bottom: 0),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.white, boxShadow: [
                                                                              BoxShadow(
                                                                                color: _ctrlQty.text != '' ? Colors.grey : Colors.white, // Color of the shadow
                                                                                offset: Offset.zero, // Offset of the shadow
                                                                                blurRadius: 6, // Spread or blur radius of the shadow
                                                                                spreadRadius: 0, // How much the shadow should spread
                                                                              )
                                                                            ]),

                                                                            child:
                                                                                TextFormField(
                                                                              onTap: () {
                                                                                Vibration.vibrate(duration: 100);
                                                                              },
                                                                              focusNode: _productQty,
                                                                              onChanged: (value) {
                                                                                _changeQty(_ctrlProductName.text);
                                                                              },
                                                                              textAlign: TextAlign.left,
                                                                              readOnly: true, // Prevent system keyboard
                                                                              showCursor: false,

                                                                              controller: _ctrlQty,
                                                                              style: const TextStyle(color: Colors.black, fontFamily: 'Koulen', fontSize: 18),
                                                                              cursorColor: Colors.black,

                                                                              //enabled: !lock,

                                                                              decoration: const InputDecoration(
                                                                                enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                                focusedBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Color.fromRGBO(0, 51, 154, 1), width: 2),
                                                                                ),

                                                                                labelStyle: TextStyle(
                                                                                  fontFamily: 'Koulen',
                                                                                  color: Colors.black,
                                                                                  //fontWeight: FontWeight.bold
                                                                                ),
                                                                                //counterStyle: TextStyle(color: Colors.white, ),
                                                                                labelText: '',
                                                                              ),

                                                                              /* decoration: const InputDecoration(
                                                                            labelText: 'Product Name'),*/
                                                                              validator: (val) =>

                                                                                  // ignore: prefer_is_empty
                                                                                  (val!.length == 0 ? 'This field is mandatory' : null),
                                                                              onSaved: (val) => {
                                                                                setState(() {
                                                                                  //_inventory.productName = val;
                                                                                  //_supply.productName = val;
                                                                                }),
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                              child: Container())
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height: height *
                                                                          0.022,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              0,
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                      width: double
                                                                          .infinity,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //mrp
                                                          Container(
                                                            height:
                                                                double.infinity,
                                                            width: width * 0.12,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,

                                                                  //color: Colors.white,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  child: const Text(
                                                                      'MRP',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromARGB(
                                                                            238,
                                                                            72,
                                                                            72,
                                                                            73),
                                                                        fontSize:
                                                                            14,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        //fontWeight: FontWeight.w100
                                                                      )),
                                                                ),
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.047,
                                                                  width: double
                                                                      .infinity,
                                                                  //height: height * 0.04,
                                                                  //color: Colors.black,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 2,
                                                                      bottom:
                                                                          0),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              3),
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: _ctrlMRP.text != ''
                                                                              ? Colors.grey
                                                                              : Colors.white, // Color of the shadow
                                                                          offset:
                                                                              Offset.zero, // Offset of the shadow
                                                                          blurRadius:
                                                                              6, // Spread or blur radius of the shadow
                                                                          spreadRadius:
                                                                              0, // How much the shadow should spread
                                                                        )
                                                                      ]),
                                                                  child:
                                                                      TextFormField(
                                                                    //focusNode: _focusNodeProduct,
                                                                    enabled:
                                                                        false,
                                                                    controller:
                                                                        _ctrlMRP,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        fontSize:
                                                                            16),
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,

                                                                    //enabled: !lock,

                                                                    decoration:
                                                                        const InputDecoration(
                                                                      disabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),
                                                                      //prefixIcon: Icon(Icons.person),
                                                                      //prefixIconColor: Colors.black,
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      focusedBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        //fontWeight: FontWeight.bold
                                                                      ),
                                                                      //counterStyle: TextStyle(color: Colors.white, ),
                                                                      labelText:
                                                                          '',
                                                                    ),

                                                                    /* decoration: const InputDecoration(
                                                                        labelText: 'Product Name'),*/
                                                                    validator:
                                                                        (val) =>

                                                                            // ignore: prefer_is_empty
                                                                            (val!.length == 0
                                                                                ? 'This field is mandatory'
                                                                                : null),
                                                                    onSaved:
                                                                        (val) =>
                                                                            {
                                                                      setState(
                                                                          () {
                                                                        //_inventory.productName = val;
                                                                        //_supply.productName = val;
                                                                      }),
                                                                    },
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.022,
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 0,
                                                                      left: 0,
                                                                      right: 0,
                                                                      bottom:
                                                                          0),
                                                                  width: double
                                                                      .infinity,
                                                                  //height: height * 0.05,
                                                                  //color: Colors.black,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    //disc and price
                                                    Container(
                                                      height: height * 0.09,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 0),
                                                      child: Row(
                                                        children: [
                                                          //disc
                                                          Expanded(
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              // width: width*0.08
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 8,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),

                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: double
                                                                        .infinity,
                                                                    width:
                                                                        width *
                                                                            0.05,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,

                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          child: const Text(
                                                                              'Discount',
                                                                              style: TextStyle(
                                                                                color: Color.fromARGB(238, 72, 72, 73),
                                                                                fontSize: 14,
                                                                                fontFamily: 'Koulen',
                                                                                //fontWeight: FontWeight.w100
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              height * 0.047,
                                                                          //height: height * 0.04,
                                                                          //color: Colors.black,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 5,
                                                                              right: 5,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          margin: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 2,
                                                                              bottom: 0),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              color: Colors.white,
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: _ctrlDisc.text != '' ? Colors.grey : Colors.white, // Color of the shadow
                                                                                  offset: Offset.zero, // Offset of the shadow
                                                                                  blurRadius: 6, // Spread or blur radius of the shadow
                                                                                  spreadRadius: 0, // How much the shadow should spread
                                                                                )
                                                                              ]),
                                                                          child:
                                                                              TextFormField(
                                                                            textInputAction:
                                                                                TextInputAction.none,
                                                                            focusNode:
                                                                                _productDisc,
                                                                            //focusNode: _focusNodeProduct,
                                                                            controller:
                                                                                _ctrlDisc,
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontFamily: 'Koulen',
                                                                                fontSize: 16),
                                                                            cursorColor:
                                                                                Colors.black,

                                                                            enabled:
                                                                                false,

                                                                            decoration:
                                                                                const InputDecoration(
                                                                              //prefixIcon: Icon(Icons.person),
                                                                              //prefixIconColor: Colors.black,
                                                                              disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                                                              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),

                                                                              labelStyle: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 16
                                                                                  //fontWeight: FontWeight.bold
                                                                                  ),
                                                                              //counterStyle: TextStyle(color: Colors.white, ),
                                                                              labelText: '',
                                                                            ),

                                                                            /* decoration: const InputDecoration(
                                                                        labelText: 'Product Name'),*/
                                                                            validator: (val) =>

                                                                                // ignore: prefer_is_empty
                                                                                (val!.length == 0 ? 'This field is mandatory' : null),
                                                                            onSaved: (val) =>
                                                                                {
                                                                              setState(() {
                                                                                //_inventory.productName = val;
                                                                                //_supply.productName = val;
                                                                              }),
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: double
                                                                        .infinity,
                                                                    width:
                                                                        width *
                                                                            0.04,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            0,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,

                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          child: const Text(
                                                                              '',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontFamily: 'Koulen',
                                                                                //fontWeight: FontWeight.w100
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                            height: height *
                                                                                0.047,
                                                                            width: double
                                                                                .infinity,
                                                                            padding: const EdgeInsets.only(
                                                                                left: 5,
                                                                                right: 5,
                                                                                top: 0,
                                                                                bottom: 0),
                                                                            margin: const EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 0),
                                                                            child: Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Container(
                                                                                      height: double.infinity,
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(3),
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                      alignment: Alignment.center,
                                                                                      margin: const EdgeInsets.only(left: 2, right: 0),
                                                                                      padding: const EdgeInsets.only(bottom: 0),
                                                                                      child: TextButton(
                                                                                        onPressed: () {},
                                                                                        child: const Text(
                                                                                          'Rs',
                                                                                          style: TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'BanglaBold'),
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          //price
                                                          Container(
                                                            height:
                                                                double.infinity,
                                                            width: width * 0.12,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,

                                                                  //color: Colors.white,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  child: const Text(
                                                                      'Price',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color.fromARGB(
                                                                            238,
                                                                            72,
                                                                            72,
                                                                            73),
                                                                        fontSize:
                                                                            13,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        //fontWeight: FontWeight.w100
                                                                      )),
                                                                ),
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height:
                                                                      height *
                                                                          0.047,
                                                                  //height: height * 0.04,
                                                                  //color: Colors.black,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      right: 5,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 2,
                                                                      bottom:
                                                                          0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: _ctrlsell.text !=
                                                                                ''
                                                                            ? Colors.grey
                                                                            : Colors.white, // Color of the shadow
                                                                        offset:
                                                                            Offset.zero, // Offset of the shadow
                                                                        blurRadius:
                                                                            6, // Spread or blur radius of the shadow
                                                                        spreadRadius:
                                                                            0, // How much the shadow should spread
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(3),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child:
                                                                      TextFormField(
                                                                    enabled:
                                                                        false,
                                                                    //focusNode: _focusNodeProduct,
                                                                    controller:
                                                                        _ctrlsell,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        fontSize:
                                                                            16),
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,

                                                                    //enabled: !lock,

                                                                    decoration:
                                                                        const InputDecoration(
                                                                      //prefixIcon: Icon(Icons.person),
                                                                      //prefixIconColor: Colors.black,
                                                                      disabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      focusedBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        //fontWeight: FontWeight.bold
                                                                      ),
                                                                      //counterStyle: TextStyle(color: Colors.white, ),
                                                                      labelText:
                                                                          '',
                                                                    ),

                                                                    /* decoration: const InputDecoration(
                                                                        labelText: 'Product Name'),*/
                                                                    validator:
                                                                        (val) =>

                                                                            // ignore: prefer_is_empty
                                                                            (val!.length == 0
                                                                                ? 'This field is mandatory'
                                                                                : null),
                                                                    onSaved:
                                                                        (val) =>
                                                                            {
                                                                      setState(
                                                                          () {
                                                                        //_inventory.productName = val;
                                                                        //_supply.productName = val;
                                                                      }),
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    //button
                                                    Container(
                                                      width: double.infinity,

                                                      height: height * 0.05,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 0,
                                                              top: 10,
                                                              left: 5,
                                                              right: 0),
                                                      //padding: EdgeInsets.only(bottom: 5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(),
                                                          ),
                                                          Container(
                                                              width:
                                                                  width * 0.13,
                                                              margin: const EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  top: 5,
                                                                  bottom: 0),
                                                              height: double
                                                                  .infinity,
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors
                                                                              .black),
                                                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  5)))),
                                                                      onPressed:
                                                                          () {
                                                                        Vibration.vibrate(
                                                                            duration:
                                                                                100);
                                                                        _removeFromCart();
                                                                      },
                                                                      child: const Text(
                                                                          'Remove from Cart',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Koulen',
                                                                              fontSize: 15,
                                                                              color: Colors.white)))),
                                                          Container(
                                                              width:
                                                                  width * 0.1,
                                                              margin: const EdgeInsets.only(
                                                                  left: 5,
                                                                  right: 5,
                                                                  top: 5,
                                                                  bottom: 0),
                                                              height: double
                                                                  .infinity,
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors
                                                                              .black),
                                                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  5)))),
                                                                      onPressed:
                                                                          () {
                                                                        Vibration.vibrate(
                                                                            duration:
                                                                                100);
                                                                        if (_ctrlQty ==
                                                                                '' ||
                                                                            !_checkQty()) {
                                                                          if (_ctrlQty ==
                                                                              '') {
                                                                            errorProductWeight =
                                                                                'Invalid';
                                                                          }
                                                                        } else {
                                                                          //_addToCart();
                                                                          _afterSearch(
                                                                              _ctrlProductName.text,
                                                                              _ctrlsell.text,
                                                                              _ctrlBarcode.text,
                                                                              _ctrlMRP.text,
                                                                              _ctrlBuy.text,
                                                                              false);
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                          'Add to Cart',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Koulen',
                                                                              fontSize: 15,
                                                                              color: Colors.white)))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                        //inventory search result
                                        if (_showSearchResults)
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  bottom: 15),

                                              //color: Colors.white,
                                              child: ListView.builder(
                                                itemCount:
                                                    _inventoryList1.length,
                                                itemBuilder: (context, index) {
                                                  return searchListCardProduct(
                                                      index);
                                                },
                                              ),
                                            ),
                                          ),

                                        if (_ctrlProductName.text == '' &&
                                            !_showSearchResults)
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                                left: 15, top: 10),
                                            child: Text(
                                              'Quick Add',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ),

                                        if (_ctrlProductName.text == '' &&
                                            !_showSearchResults)
                                          Expanded(
                                            child: Container(
                                                width: double.infinity,
                                                //height: height * 0.8,

                                                margin: const EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 10,
                                                    left: 0,
                                                    right: 0),
                                                child: ListView.builder(
                                                  itemCount:
                                                      _inventoryListQuickAdd
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return CardQuickAdd(height,
                                                        width, index, context);
                                                  },
                                                )),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                // final checkout
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 5, left: 20, right: 10),
                                  width: width * 0.32,
                                  height: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Container(
                                              height: (customerDetails == false)
                                                  ? height * 0.03
                                                  : height * 0.05,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Vibration.vibrate(
                                                        duration: 100);
                                                    setState(() {
                                                      customerDetails =
                                                          !customerDetails;
                                                      _customerSearch
                                                          .requestFocus();
                                                    });
                                                  },
                                                  icon: customerDetails == false
                                                      ? const Icon(
                                                          Icons.arrow_back_ios,
                                                          size: 11,
                                                          color: Colors.black)
                                                      : const Icon(Icons.close,
                                                          color:
                                                              Colors.black))),
                                          if (customerDetails == false)
                                            InkWell(
                                              child: Container(
                                                height: height * 0.03,
                                                width: width * 0.118,

                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey,

                                                        // Color of the shadow
                                                        offset: Offset
                                                            .zero, // Offset of the shadow
                                                        blurRadius:
                                                            6, // Spread or blur radius of the shadow
                                                        spreadRadius:
                                                            0, // How much the shadow should spread
                                                      )
                                                    ],
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                margin: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                //padding: EdgeInsets.only(top: 10),
                                                child: Center(
                                                  child: Text(
                                                    _ctrlCustomerPhone
                                                            .text.isEmpty
                                                        ? 'CUSTOMER DETAILS'
                                                        : '+91 ${_ctrlCustomerPhone.text}',
                                                    style: TextStyle(
                                                      fontFamily: 'Koulen',
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Vibration.vibrate(
                                                    duration: 100);
                                                setState(() {
                                                  customerDetails =
                                                      !customerDetails;
                                                  _customerSearch
                                                      .requestFocus();
                                                });
                                              },
                                            ),

                                          /// customer search bar
                                          if (customerDetails == true)
                                            Container(
                                              height: height * 0.05,
                                              width: width * 0.241,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: _customerSearch
                                                              .hasFocus
                                                          ? Colors.grey
                                                          : Colors
                                                              .white, // Color of the shadow
                                                      offset: Offset
                                                          .zero, // Offset of the shadow
                                                      blurRadius:
                                                          6, // Spread or blur radius of the shadow
                                                      spreadRadius:
                                                          0, // How much the shadow should spread
                                                    )
                                                  ],
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                              margin: const EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                  top: 0,
                                                  bottom: 2),
                                              //padding: EdgeInsets.only(top: 10),
                                              child: Center(
                                                child: TextField(
                                                  textAlignVertical:
                                                      TextAlignVertical.bottom,
                                                  readOnly:
                                                      true, // Prevent system keyboard
                                                  showCursor: false,

                                                  focusNode: _customerSearch,
                                                  controller: searchControllerC,
                                                  onTap: () {
                                                    Vibration.vibrate(
                                                        duration: 100);
                                                  },
                                                  onChanged: (value) {
                                                    // customerDetails = false;
                                                    showC = true;
                                                    setState(() {});

                                                    _refreshCustomerList(
                                                        value.toLowerCase());
                                                  },
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 19,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            51,
                                                                            154,
                                                                            1),
                                                                    width: 2),
                                                          ),
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          border:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          hintText: '',
                                                          hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                          ),
                                                          prefixIcon: Icon(
                                                              Icons.search),
                                                          prefixIconColor:
                                                              Colors.black),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),

                                      //delivery mode
                                      if (customerDetails == false)
                                        Container(
                                          // height: height * 0.1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 0, top: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,

                                                //color: Colors.white,
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child:
                                                    const Text('Delivery Mode',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              238, 72, 72, 73),
                                                          fontSize: 14,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.w100
                                                        )),
                                              ),
                                              Container(
                                                height: height * 0.07,
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                        child: Container(
                                                          width: width * 0.022,
                                                          // height: height * 0.022,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              shape: BoxShape
                                                                  .circle),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width:
                                                                width * 0.008,
                                                            // height: height * 0.022,
                                                            decoration: BoxDecoration(
                                                                color: deliveryMode ==
                                                                        'store'
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .transparent,
                                                                shape: BoxShape
                                                                    .circle),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Vibration.vibrate(
                                                              duration: 100);
                                                          setState(() {
                                                            deliveryMode =
                                                                'store';
                                                            errorDelivery = '';
                                                          });
                                                        }),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: double.infinity,
                                                      width: width * 0.05,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5),
                                                      child: const Text(
                                                        'In Store',
                                                        style: TextStyle(
                                                          fontFamily: 'Koulen',
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        width: width * 0.022,
                                                        // height: height * 0.022,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1),
                                                            shape: BoxShape
                                                                .circle),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          width: width * 0.008,
                                                          // height: height * 0.022,
                                                          decoration: BoxDecoration(
                                                              color: deliveryMode ==
                                                                      'home'
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .transparent,
                                                              shape: BoxShape
                                                                  .circle),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Vibration.vibrate(
                                                            duration: 100);
                                                        if (_ctrlCustomerName
                                                                .text ==
                                                            '') {
                                                          setState(() {
                                                            errorDelivery =
                                                                'Customer not selected';
                                                          });
                                                        } else {
                                                          setState(() {
                                                            deliveryMode =
                                                                'home';
                                                            errorDelivery = '';
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: double.infinity,
                                                      width: width * 0.06,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5),
                                                      child: const Text(
                                                        'Home',
                                                        style: TextStyle(
                                                          fontFamily: 'Koulen',
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: height * 0.022,
                                                margin: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                width: double.infinity,
                                                //height: height * 0.05,
                                                //color: Colors.black,
                                                child: Text(
                                                  errorDelivery,
                                                  style: const TextStyle(
                                                    fontFamily: 'Koulen',
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        139, 0, 0, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      //payment status
                                      if (customerDetails == false)
                                        Container(
                                          height: height * 0.11,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 0, top: 0),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 5, top: 0),
                                                width: double.infinity,

                                                //color: Colors.white,
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child:
                                                    const Text('Payment Status',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              238, 72, 72, 73),
                                                          fontSize: 14,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.w100
                                                        )),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height:
                                                              double.infinity,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                height: height *
                                                                    0.048,
                                                                child: Row(
                                                                  children: [
                                                                    InkWell(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              width * 0.022,
                                                                          // height: height * 0.022,
                                                                          decoration: BoxDecoration(
                                                                              border: Border.all(color: Colors.black, width: 1),
                                                                              shape: BoxShape.circle),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                width * 0.008,
                                                                            // height: height * 0.022,
                                                                            decoration:
                                                                                BoxDecoration(color: paymentStatus == 'full' ? Colors.black : Colors.transparent, shape: BoxShape.circle),
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          Vibration.vibrate(
                                                                              duration: 100);
                                                                          setState(
                                                                              () {
                                                                            errorPartialPayment1 =
                                                                                '';
                                                                            paymentStatus =
                                                                                'full';
                                                                            _ctrlpayment.text =
                                                                                totalPrice.toString();
                                                                            if (paymentMode ==
                                                                                'cash') {
                                                                              _ctrlPaymentChange.text = (double.parse(_ctrlPayment.text) - totalPrice).toString();
                                                                            }
                                                                          });
                                                                        }),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      height: double
                                                                          .infinity,
                                                                      width: width *
                                                                          0.05,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          const Text(
                                                                        'Full',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Koulen',
                                                                          fontSize:
                                                                              17,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      child:
                                                                          Container(
                                                                        width: width *
                                                                            0.022,
                                                                        // height: height * 0.022,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Colors.black, width: 1),
                                                                            shape: BoxShape.circle),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              width * 0.008,
                                                                          // height: height * 0.022,
                                                                          decoration: BoxDecoration(
                                                                              color: paymentStatus == 'partial' ? Colors.black : Colors.transparent,
                                                                              shape: BoxShape.circle),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Vibration.vibrate(
                                                                            duration:
                                                                                100);
                                                                        setState(
                                                                            () {
                                                                          if (_ctrlCustomerName.text ==
                                                                              '') {
                                                                            errorPartialPayment1 =
                                                                                'Customer not selected';
                                                                          } else {
                                                                            errorPartialPayment1 =
                                                                                '';
                                                                            paymentStatus =
                                                                                'partial';
                                                                            _ctrlpayment.clear();
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      height: double
                                                                          .infinity,
                                                                      width: width *
                                                                          0.06,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          const Text(
                                                                        'Partial',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Koulen',
                                                                          fontSize:
                                                                              17,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: height *
                                                                    0.022,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0),
                                                                width: double
                                                                    .infinity,
                                                                child: Text(
                                                                  errorPartialPayment1,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'Koulen',
                                                                    fontSize:
                                                                        14,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            139,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                  ),
                                                                ),
                                                                //height: height * 0.05,
                                                                //color: Colors.black,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: width * 0.1,
                                                        height: double.infinity,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              height: height *
                                                                  0.047,
                                                              //color: Colors.black,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 2,
                                                                      bottom:
                                                                          0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: (paymentStatus ==
                                                                            'partial')
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .white, // Color of the shadow
                                                                    offset: Offset
                                                                        .zero, // Offset of the shadow
                                                                    blurRadius:
                                                                        6, // Spread or blur radius of the shadow
                                                                    spreadRadius:
                                                                        0, // How much the shadow should spread
                                                                  )
                                                                ],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            3),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                onTap: () {
                                                                  Vibration.vibrate(
                                                                      duration:
                                                                          100);
                                                                },
                                                                readOnly:
                                                                    true, // Prevent system keyboard
                                                                showCursor:
                                                                    false,
                                                                focusNode:
                                                                    _partialPayment,
                                                                //focusNode: _focusNodeProduct,
                                                                enabled:
                                                                    paymentStatus !=
                                                                            'full'
                                                                        ? true
                                                                        : false,
                                                                controller:
                                                                    _ctrlpayment,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Koulen',
                                                                    fontSize:
                                                                        24),
                                                                cursorColor:
                                                                    Colors
                                                                        .black,

                                                                //enabled: !lock,

                                                                decoration:
                                                                    const InputDecoration(
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Color.fromRGBO(
                                                                            0,
                                                                            51,
                                                                            154,
                                                                            1),
                                                                        width:
                                                                            2),
                                                                  ),
                                                                  disabledBorder:
                                                                      UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                  //prefixIcon: Icon(Icons.person),
                                                                  //prefixIconColor: Colors.black,
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide.none),

                                                                  labelStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Koulen',
                                                                    color: Colors
                                                                        .black,
                                                                    //fontWeight: FontWeight.bold
                                                                  ),
                                                                  //counterStyle: TextStyle(color: Colors.white, ),
                                                                  labelText: '',
                                                                ),

                                                                /* decoration: const InputDecoration(
                                                                                               labelText: 'Product Name'),*/
                                                                validator:
                                                                    (val) =>

                                                                        // ignore: prefer_is_empty
                                                                        (val!.length ==
                                                                                0
                                                                            ? 'This field is mandatory'
                                                                            : null),
                                                                onSaved:
                                                                    (val) => {
                                                                  setState(() {
                                                                    //_inventory.productName = val;
                                                                    //_supply.productName = val;
                                                                  }),
                                                                },
                                                              ),
                                                            ),
                                                            Container(
                                                              height: height *
                                                                  0.022,
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0,
                                                                      left: 0,
                                                                      right: 0,
                                                                      bottom:
                                                                          0),
                                                              width: double
                                                                  .infinity,
                                                              //height: height * 0.05,
                                                              //color: Colors.black,
                                                              child: Text(
                                                                errorPartialPayment,
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  fontSize: 14,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          139,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      //payment mode
                                      if (customerDetails == false)
                                        Container(
                                          // height: height * 0.1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 0, top: 0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,

                                                //color: Colors.white,
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child:
                                                    const Text('Payment Mode',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              238, 72, 72, 73),
                                                          fontSize: 14,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.w100
                                                        )),
                                              ),
                                              Container(
                                                height: height * 0.1,
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                        child: Container(
                                                          width: width * 0.022,
                                                          // height: height * 0.022,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              shape: BoxShape
                                                                  .circle),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width:
                                                                width * 0.008,
                                                            // height: height * 0.022,
                                                            decoration: BoxDecoration(
                                                                color: paymentMode ==
                                                                        'cash'
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .transparent,
                                                                shape: BoxShape
                                                                    .circle),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Vibration.vibrate(
                                                              duration: 100);
                                                          setState(() {
                                                            paymentMode =
                                                                'cash';
                                                          });
                                                        }),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: double.infinity,
                                                      width: width * 0.04,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 0),
                                                      child: const Text(
                                                        'Cash',
                                                        style: TextStyle(
                                                          fontFamily: 'Koulen',
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        width: width * 0.022,
                                                        // height: height * 0.022,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width: 1),
                                                            shape: BoxShape
                                                                .circle),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          width: width * 0.008,
                                                          // height: height * 0.022,
                                                          decoration: BoxDecoration(
                                                              color: paymentMode ==
                                                                      'card'
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .transparent,
                                                              shape: BoxShape
                                                                  .circle),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Vibration.vibrate(
                                                            duration: 100);
                                                        setState(() {
                                                          paymentMode = 'card';
                                                        });
                                                      },
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: double.infinity,
                                                      width: width * 0.04,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 0),
                                                      child: const Text(
                                                        'Card',
                                                        style: TextStyle(
                                                          fontFamily: 'Koulen',
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                        child: Container(
                                                          width: width * 0.022,
                                                          // height: height * 0.022,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 1),
                                                              shape: BoxShape
                                                                  .circle),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width:
                                                                width * 0.008,
                                                            // height: height * 0.022,
                                                            decoration: BoxDecoration(
                                                                color: paymentMode ==
                                                                        'upi'
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .transparent,
                                                                shape: BoxShape
                                                                    .circle),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          Vibration.vibrate(
                                                              duration: 100);
                                                          setState(() {
                                                            _ctrlPayment.text =
                                                                '';
                                                            _ctrlPaymentChange
                                                                .text = '';
                                                            paymentMode = 'upi';
                                                          });
                                                        }),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: double.infinity,
                                                      width: width * 0.025,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 0),
                                                      child: const Text(
                                                        'UPI',
                                                        style: TextStyle(
                                                          fontFamily: 'Koulen',
                                                          fontSize: 17,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    if (paymentMode == 'upi')
                                                      Expanded(
                                                        child: Container(
                                                            // width: width*0.05,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8,
                                                                    right: 0,
                                                                    top: 5,
                                                                    bottom: 0),
                                                            height:
                                                                double.infinity,
                                                            child:
                                                                ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .black),
                                                                  shape: MaterialStatePropertyAll(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)))),
                                                              onPressed:
                                                                  () async {
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        100);
                                                                /*if (amount == null) {
                                                         return "upi://pay?pa=$upiID&pn=$payeeName&tr=$transactionID&am=0&cu=$currencyCode&mode=01&purpose=10&orgid=-&sign=-&tn=$transactionNote";
                                                       }
                                                       return "upi://pay?pa=$upiID&pn=$payeeName&tr=$transactionID&am=$amount&cu=$currencyCode&mode=01&purpose=10&orgid=-&sign=-&tn=$transactionNote";
                                                     }*/
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          Container(
                                                                        height:
                                                                            400,
                                                                        width:
                                                                            100,
                                                                        child:
                                                                            QrImageView(
                                                                          data:
                                                                              "upi://pay?pa=${storeUpi}&pn=${storeName}&am='${paymentStatus == 'full' ? totalPrice : _ctrlpayment.text}'&cu=INR&mode=01&purpose=10&orgid=-&sign=-",
                                                                          version:
                                                                              QrVersions.auto,
                                                                        ),
                                                                      ),
                                                                    ); // Display the custom dialog
                                                                  },
                                                                );
                                                              },
                                                              child: const Text(
                                                                'Generate QR',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Koulen',
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            )),
                                                      ),
                                                    if (paymentMode == 'cash')
                                                      Expanded(
                                                        child: Container(
                                                          // width: width * 0.1,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 8),

                                                          height:
                                                              double.infinity,
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width: width *
                                                                          0.04,
                                                                      child: Text(
                                                                          'Amt.',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Koulen',
                                                                            fontSize:
                                                                                16,
                                                                            color: Color.fromARGB(
                                                                                238,
                                                                                72,
                                                                                72,
                                                                                73),
                                                                          )),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        //color: Colors.black,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5,
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                0,
                                                                            right:
                                                                                0,
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                3),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: (paymentMode == 'cash') ? Colors.grey : Colors.white, // Color of the shadow
                                                                              offset: Offset.zero, // Offset of the shadow
                                                                              blurRadius: 6, // Spread or blur radius of the shadow
                                                                              spreadRadius: 0, // How much the shadow should spread
                                                                            )
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(3),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          onTap:
                                                                              () {
                                                                            Vibration.vibrate(duration: 100);
                                                                          },
                                                                          readOnly:
                                                                              true, // Prevent system keyboard
                                                                          showCursor:
                                                                              false,
                                                                          focusNode:
                                                                              _payment,
                                                                          //focusNode: _focusNodeProduct,
                                                                          enabled: paymentMode == 'cash'
                                                                              ? true
                                                                              : false,
                                                                          controller:
                                                                              _ctrlPayment,
                                                                          style: const TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: 'Koulen',
                                                                              fontSize: 26),
                                                                          cursorColor:
                                                                              Colors.black,

                                                                          //enabled: !lock,

                                                                          decoration:
                                                                              const InputDecoration(
                                                                            focusedBorder:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Color.fromRGBO(0, 51, 154, 1), width: 2),
                                                                            ),
                                                                            disabledBorder:
                                                                                UnderlineInputBorder(borderSide: BorderSide.none),
                                                                            //prefixIcon: Icon(Icons.person),
                                                                            //prefixIconColor: Colors.black,
                                                                            enabledBorder:
                                                                                UnderlineInputBorder(borderSide: BorderSide.none),

                                                                            labelStyle:
                                                                                TextStyle(
                                                                              fontFamily: 'Koulen',
                                                                              color: Colors.black,
                                                                              //fontWeight: FontWeight.bold
                                                                            ),
                                                                            //counterStyle: TextStyle(color: Colors.white, ),
                                                                            labelText:
                                                                                '',
                                                                          ),

                                                                          /* decoration: const InputDecoration(
                                                                                                         labelText: 'Product Name'),*/
                                                                          validator: (val) =>

                                                                              // ignore: prefer_is_empty
                                                                              (val!.length == 0 ? 'This field is mandatory' : null),
                                                                          onSaved:
                                                                              (val) => {
                                                                            setState(() {
                                                                              //_inventory.productName = val;
                                                                              //_supply.productName = val;
                                                                            }),
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      width: width *
                                                                          0.04,
                                                                      child: Text(
                                                                          'Change',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Koulen',
                                                                            fontSize:
                                                                                16,
                                                                            color: Color.fromARGB(
                                                                                238,
                                                                                72,
                                                                                72,
                                                                                73),
                                                                          )),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        //color: Colors.black,
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5,
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        margin: const EdgeInsets.only(
                                                                            left:
                                                                                0,
                                                                            right:
                                                                                0,
                                                                            top:
                                                                                3,
                                                                            bottom:
                                                                                0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: (paymentMode == 'cash') ? Colors.grey : Colors.white, // Color of the shadow
                                                                              offset: Offset.zero, // Offset of the shadow
                                                                              blurRadius: 6, // Spread or blur radius of the shadow
                                                                              spreadRadius: 0, // How much the shadow should spread
                                                                            )
                                                                          ],
                                                                          borderRadius:
                                                                              BorderRadius.circular(3),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          onTap:
                                                                              () {
                                                                            Vibration.vibrate(duration: 100);
                                                                          },
                                                                          readOnly:
                                                                              true, // Prevent system keyboard
                                                                          showCursor:
                                                                              false,

                                                                          //focusNode: _focusNodeProduct,
                                                                          enabled:
                                                                              false,
                                                                          controller:
                                                                              _ctrlPaymentChange,
                                                                          style: const TextStyle(
                                                                              color: Colors.black,
                                                                              fontFamily: 'Koulen',
                                                                              fontSize: 26),
                                                                          cursorColor:
                                                                              Colors.black,

                                                                          decoration:
                                                                              const InputDecoration(
                                                                            focusedBorder:
                                                                                UnderlineInputBorder(borderSide: BorderSide.none),
                                                                            disabledBorder:
                                                                                UnderlineInputBorder(borderSide: BorderSide.none),
                                                                            //prefixIcon: Icon(Icons.person),
                                                                            //prefixIconColor: Colors.black,
                                                                            enabledBorder:
                                                                                UnderlineInputBorder(borderSide: BorderSide.none),

                                                                            labelStyle:
                                                                                TextStyle(
                                                                              fontFamily: 'Koulen',
                                                                              color: Colors.black,
                                                                              //fontWeight: FontWeight.bold
                                                                            ),
                                                                            //counterStyle: TextStyle(color: Colors.white, ),
                                                                            labelText:
                                                                                '',
                                                                          ),

                                                                          /* decoration: const InputDecoration(
                                                                                                         labelText: 'Product Name'),*/
                                                                          validator: (val) =>

                                                                              // ignore: prefer_is_empty
                                                                              (val!.length == 0 ? 'This field is mandatory' : null),
                                                                          onSaved:
                                                                              (val) => {
                                                                            setState(() {
                                                                              //_inventory.productName = val;
                                                                              //_supply.productName = val;
                                                                            }),
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      //final button
                                      if (customerDetails == false)
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,

                                            height: height * 0.05,
                                            margin: const EdgeInsets.only(
                                                bottom: 8,
                                                top: 5,
                                                left: 0,
                                                right: 0),
                                            //padding: EdgeInsets.only(bottom: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 5,
                                                              top: 5,
                                                              bottom: 0),
                                                      height: double.infinity,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all<Color>(
                                                                  Colors.black),
                                                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5)))),
                                                          onPressed: () async {
                                                            Vibration.vibrate(
                                                                duration: 100);
                                                            _resetAll();
                                                          },
                                                          child: const Text(
                                                              'Dismiss',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white)))),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 0,
                                                              top: 5,
                                                              bottom: 0),
                                                      height: double.infinity,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor: MaterialStateProperty.all<Color>(
                                                                  Colors.black),
                                                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5)))),
                                                          onPressed: () async {
                                                            Vibration.vibrate(
                                                                duration: 150);
                                                            if (_ctrlpayment
                                                                    .text ==
                                                                '') {
                                                              errorPartialPayment =
                                                                  'Invalid';
                                                              setState(() {});
                                                            } else {
                                                              _order();
                                                              if (globals
                                                                  .printerConnected) {
                                                                screenshotController
                                                                    .captureFromWidget(
                                                                        xxxx(
                                                                            height,
                                                                            width),
                                                                        //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

                                                                        delay: Duration(
                                                                            seconds:
                                                                                1),
                                                                        targetSize: deliveryMode ==
                                                                                'home'
                                                                            ? Size(
                                                                                380,
                                                                                //fixed= 390, card =
                                                                                (1300 + 30 + (50 * (cartList.length * 1.4)).toDouble()))
                                                                            : Size(
                                                                                380,
                                                                                //fixed= 390, card =
                                                                                (850 + 30 + (50 * (cartList.length * 1.4)).toDouble())))
                                                                    .then((capturedImage) {
                                                                  shareCapturedImage(
                                                                      capturedImage);
                                                                  // Handle captured image
                                                                });
                                                              }
                                                              _submitSales();

                                                              _transaction();

                                                              _sales.orderId =
                                                                  _lastOrderId;

                                                              _sales.customerNumber =
                                                                  (_ctrlCustomerNumber
                                                                              .text) ==
                                                                          ''
                                                                      ? '1'
                                                                      : _ctrlCustomerNumber
                                                                          .text;

                                                              _transaction1
                                                                      .supplierId =
                                                                  (_ctrlCustomerNumber
                                                                              .text) ==
                                                                          ''
                                                                      ? '1'
                                                                      : _ctrlCustomerNumber
                                                                          .text;

                                                              _sales.customerName =
                                                                  (_ctrlCustomerName
                                                                              .text ==
                                                                          '')
                                                                      ? 'cashCustomer'
                                                                      : _ctrlCustomerName
                                                                          .text;

                                                              _sales.customerName =
                                                                  (_ctrlCustomerAddress
                                                                              .text ==
                                                                          '')
                                                                      ? 'x'
                                                                      : _ctrlCustomerAddress
                                                                          .text;

                                                              _sales.date =
                                                                  DateTime.now()
                                                                      .toString();
                                                              _transaction1
                                                                      .date =
                                                                  DateTime.now()
                                                                      .toString();
                                                              _sales.deliveryMode =
                                                                  deliveryMode;
                                                              _sales.paymentMode =
                                                                  paymentMode;

                                                              _sales.deliveryStatus =
                                                                  deliveryMode ==
                                                                          'store'
                                                                      ? 'delivered'
                                                                      : 'pending';
                                                              _sales.deliveryDate =
                                                                  DateTime.now()
                                                                      .toString();
                                                              _sales.paidStatus =
                                                                  paymentStatus;
                                                              _sales.paidAmount =
                                                                  _ctrlpayment.text ==
                                                                          ''
                                                                      ? '0'
                                                                      : _ctrlpayment
                                                                          .text;
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Generate Bill',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white)))),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      //customer name
                                      if (customerDetails == true &&
                                          showC == false)
                                        Container(
                                          height: height * 0.12,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 0, top: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                //height: height * 0.022,
                                                //color: Colors.white,
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child:
                                                    const Text('Customer Name',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              238, 72, 72, 73),
                                                          fontSize: 14,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.w100
                                                        )),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: height * 0.048,
                                                //color: Colors.black,
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 0,
                                                    bottom: 0),
                                                margin: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 2,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (_customername
                                                                  .hasFocus ||
                                                              _ctrlCustomerName
                                                                      .text !=
                                                                  '')
                                                          ? Colors.grey
                                                          : Colors
                                                              .white, // Color of the shadow
                                                      offset: Offset
                                                          .zero, // Offset of the shadow
                                                      blurRadius:
                                                          6, // Spread or blur radius of the shadow
                                                      spreadRadius:
                                                          0, // How much the shadow should spread
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.white,
                                                ),
                                                child: TextFormField(
                                                  onTap: () {
                                                    Vibration.vibrate(
                                                        duration: 100);
                                                  },
                                                  readOnly:
                                                      true, // Prevent system keyboard
                                                  showCursor: false,
                                                  focusNode: _customername,
                                                  enabled: _addCustomer,
                                                  //focusNode: _focusNodeProduct,
                                                  controller: _ctrlCustomerName,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Koulen',
                                                      fontSize: 16),
                                                  cursorColor: Colors.black,

                                                  //enabled: !lock,

                                                  decoration:
                                                      const InputDecoration(
                                                    //prefixIcon: Icon(Icons.person),
                                                    //prefixIconColor: Colors.black,
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),

                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),

                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              0, 51, 154, 1),
                                                          width: 2),
                                                    ),

                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Koulen',
                                                      color: Colors.black,
                                                      //fontWeight: FontWeight.bold
                                                    ),
                                                    //counterStyle: TextStyle(color: Colors.white, ),
                                                    labelText: '',
                                                  ),

                                                  /* decoration: const InputDecoration(
                                      labelText: 'Product Name'),*/
                                                  validator: (val) =>

                                                      // ignore: prefer_is_empty
                                                      (val!.length == 0
                                                          ? 'This field is mandatory'
                                                          : null),
                                                  onSaved: (val) => {
                                                    setState(() {
                                                      //_inventory.productName = val;
                                                      //_supply.productName = val;
                                                    }),
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                width: double.infinity,
                                                //height: height * 0.05,
                                                //color: Colors.black,
                                                child: Text(
                                                  errorCustomerName,
                                                  style: TextStyle(
                                                    fontFamily: 'Koulen',
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        139, 0, 0, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      //customer name
                                      if (customerDetails == true &&
                                          showC == false)
                                        Container(
                                          height: height * 0.12,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 0, top: 0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,

                                                //color: Colors.white,
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child:
                                                    const Text('Phone Number',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              238, 72, 72, 73),
                                                          fontSize: 14,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.w100
                                                        )),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: height * 0.048,
                                                //color: Colors.black,
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 0,
                                                    bottom: 0),
                                                margin: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 2,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (_customerPhone
                                                                  .hasFocus ||
                                                              _ctrlCustomerPhone
                                                                      .text !=
                                                                  '')
                                                          ? Colors.grey
                                                          : Colors
                                                              .white, // Color of the shadow
                                                      offset: Offset
                                                          .zero, // Offset of the shadow
                                                      blurRadius:
                                                          6, // Spread or blur radius of the shadow
                                                      spreadRadius:
                                                          0, // How much the shadow should spread
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.white,
                                                ),
                                                child: TextFormField(
                                                  onTap: () {
                                                    Vibration.vibrate(
                                                        duration: 100);
                                                  },
                                                  readOnly:
                                                      true, // Prevent system keyboard
                                                  showCursor: false,
                                                  focusNode: _customerPhone,
                                                  //focusNode: _focusNodeProduct,
                                                  enabled: _addCustomer,
                                                  controller:
                                                      _ctrlCustomerPhone,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Koulen',
                                                      fontSize: 16),
                                                  cursorColor: Colors.black,

                                                  //enabled: !lock,

                                                  decoration:
                                                      const InputDecoration(
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                    //prefixIcon: Icon(Icons.person),
                                                    //prefixIconColor: Colors.black,
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),

                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              0, 51, 154, 1),
                                                          width: 2),
                                                    ),

                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Koulen',
                                                      color: Colors.black,
                                                      //fontWeight: FontWeight.bold
                                                    ),
                                                    //counterStyle: TextStyle(color: Colors.white, ),
                                                    labelText: '',
                                                  ),

                                                  /* decoration: const InputDecoration(
                                      labelText: 'Product Name'),*/
                                                  validator: (val) =>

                                                      // ignore: prefer_is_empty
                                                      (val!.length == 0
                                                          ? 'This field is mandatory'
                                                          : null),
                                                  onSaved: (val) => {
                                                    setState(() {
                                                      //_inventory.productName = val;
                                                      //_supply.productName = val;
                                                    }),
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                width: double.infinity,
                                                //height: height * 0.05,
                                                //color: Colors.black,
                                                child: Text(
                                                  errorCustomerPhone,
                                                  style: TextStyle(
                                                    fontFamily: 'Koulen',
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        139, 0, 0, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      //address
                                      if (customerDetails == true &&
                                          showC == false)
                                        Container(
                                          height: height * 0.12,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 0, top: 0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,

                                                //color: Colors.white,
                                                padding: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child: const Text('Address',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          238, 72, 72, 73),
                                                      fontSize: 14,
                                                      fontFamily: 'Koulen',
                                                      //fontWeight: FontWeight.w100
                                                    )),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: height * 0.048,
                                                //color: Colors.black,
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 0,
                                                    bottom: 0),
                                                margin: const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 2,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: (_customerAddress1
                                                                  .hasFocus ||
                                                              _ctrlCustomerAddress
                                                                      .text !=
                                                                  '')
                                                          ? Colors.grey
                                                          : Colors
                                                              .white, // Color of the shadow
                                                      offset: Offset
                                                          .zero, // Offset of the shadow
                                                      blurRadius:
                                                          6, // Spread or blur radius of the shadow
                                                      spreadRadius:
                                                          0, // How much the shadow should spread
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  color: Colors.white,
                                                ),
                                                child: TextFormField(
                                                  onTap: () {
                                                    Vibration.vibrate(
                                                        duration: 100);
                                                  },
                                                  readOnly:
                                                      true, // Prevent system keyboard
                                                  showCursor: false,
                                                  focusNode: _customerAddress1,
                                                  enabled: _addCustomer,
                                                  //focusNode: _focusNodeProduct,
                                                  controller:
                                                      _ctrlCustomerAddress,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Koulen',
                                                      fontSize: 16),
                                                  cursorColor: Colors.black,

                                                  //enabled: !lock,

                                                  decoration:
                                                      const InputDecoration(
                                                    //prefixIcon: Icon(Icons.person),
                                                    //prefixIconColor: Colors.black,
                                                    disabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),

                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),

                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              0, 51, 154, 1),
                                                          width: 2),
                                                    ),

                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Koulen',
                                                      color: Colors.black,
                                                      //fontWeight: FontWeight.bold
                                                    ),
                                                    //counterStyle: TextStyle(color: Colors.white, ),
                                                    labelText: '',
                                                  ),

                                                  /* decoration: const InputDecoration(
                                      labelText: 'Product Name'),*/
                                                  validator: (val) =>

                                                      // ignore: prefer_is_empty
                                                      (val!.length == 0
                                                          ? 'This field is mandatory'
                                                          : null),
                                                  onSaved: (val) => {
                                                    setState(() {
                                                      //_inventory.productName = val;
                                                      //_supply.productName = val;
                                                    }),
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    bottom: 0),
                                                width: double.infinity,
                                                //height: height * 0.05,
                                                //color: Colors.black,
                                                child: Text(
                                                  errorCustomerAddress,
                                                  style: TextStyle(
                                                    fontFamily: 'Koulen',
                                                    fontSize: 14,
                                                    color: Color.fromRGBO(
                                                        139, 0, 0, 1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      //search list
                                      if (showC == true &&
                                          customerDetails == true)
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,

                                            margin: const EdgeInsets.only(
                                                bottom: 10, top: 10),

                                            //color: Colors.white,
                                            child: ListView.builder(
                                              itemCount: _CustomerList1.length,
                                              itemBuilder: (context, index) {
                                                return searchListCardCustomer(
                                                    index);
                                              },
                                            ),
                                          ),
                                        ),

                                      //button
                                      if (customerDetails == true &&
                                          showC == false)
                                        Container(
                                          width: double.infinity,

                                          height: height * 0.05,
                                          margin: const EdgeInsets.only(
                                              bottom: 0,
                                              top: 5,
                                              left: 5,
                                              right: 0),
                                          //padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Container(
                                                  width: width * 0.08,
                                                  margin: const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                      top: 5,
                                                      bottom: 0),
                                                  height: double.infinity,
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty.all<Color>(
                                                                  Colors.black),
                                                          shape: MaterialStatePropertyAll(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          5)))),
                                                      onPressed: () {
                                                        Vibration.vibrate(
                                                            duration: 100);
                                                        _ctrlCustomerName
                                                            .clear();
                                                        _addCustomer = false;
                                                        _ctrlCustomerPhone
                                                            .clear();
                                                        _ctrlCustomerAddress
                                                            .clear();
                                                        customerDetails = false;
                                                        setState(() {});
                                                      },
                                                      child: const Text('Cancel',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Koulen',
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white)))),
                                              if (_addCustomer == true)
                                                Container(
                                                    width: width * 0.1,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            top: 5,
                                                            bottom: 0),
                                                    height: double.infinity,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                                Colors.black),
                                                            shape: MaterialStatePropertyAll(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)))),
                                                        onPressed: () async {
                                                          Vibration.vibrate(
                                                              duration: 100);
                                                          if (_ctrlCustomerName
                                                                      .text ==
                                                                  '' ||
                                                              _ctrlCustomerPhone
                                                                      .text ==
                                                                  '' ||
                                                              errorCustomerName !=
                                                                  '' ||
                                                              errorCustomerPhone !=
                                                                  '') {
                                                            if (_ctrlCustomerName
                                                                    .text ==
                                                                '') {
                                                              errorCustomerName =
                                                                  'Invalid';
                                                            }
                                                            if (_ctrlCustomerPhone
                                                                    .text ==
                                                                '') {
                                                              errorCustomerPhone =
                                                                  'Invalid';
                                                            }

                                                            setState(() {});
                                                          } else {
                                                            errorCustomerName =
                                                                '';
                                                            errorCustomerPhone =
                                                                '';
                                                            errorCustomerAddress =
                                                                '';

                                                            _customer.name =
                                                                _ctrlCustomerName
                                                                    .text;
                                                            _customer.phone =
                                                                _ctrlCustomerPhone
                                                                    .text;
                                                            _customer.address =
                                                                _ctrlCustomerAddress
                                                                    .text;
                                                            _customer.points =
                                                                '0';
                                                            if (_customer.id ==
                                                                null) {
                                                              _ctrlCustomerNumber
                                                                  .text = (await _dbHelperC
                                                                      .insertCustomer(
                                                                          _customer))
                                                                  .toString();

                                                              await _refreshCustomerList1();
                                                              _resetFormCustomer();
                                                            }
                                                            _addCustomer =
                                                                false;

                                                            setState(() {});
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Add Customer',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Koulen',
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white)))),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        /// keyboard
                        Container(
                          width: double.infinity,
                          height: height * 0.375,
                          // margin: const EdgeInsets.only(bottom: 5, right: 5),
                          decoration:
                              BoxDecoration(color: Colors.black, boxShadow: [
                            BoxShadow(
                              color: Colors.grey, // Color of the shadow
                              offset: Offset.zero, // Offset of the shadow
                              blurRadius:
                                  6, // Spread or blur radius of the shadow
                              spreadRadius:
                                  0, // How much the shadow should spread
                            )
                          ]),
                          child: VirtualKeyboard(
                              textColor: Colors.white,
                              textController: _controllerText,
                              defaultLayouts: [
                                VirtualKeyboardDefaultLayouts.English
                              ],
                              type: false
                                  ? VirtualKeyboardType.Numeric
                                  : VirtualKeyboardType.Alphanumeric,
                              onKeyPress: (key) {
                                Vibration.vibrate(duration: 100);
                                _onKeyPress(
                                    key,
                                    _productSearch.hasFocus
                                        ? searchController
                                        : _productDisc.hasFocus
                                            ? _ctrlDisc
                                            : _payment.hasFocus
                                                ? _ctrlPayment
                                                : _customerSearch.hasFocus
                                                    ? searchControllerC
                                                    : _partialPayment.hasFocus
                                                        ? _ctrlpayment
                                                        : _productQty.hasFocus
                                                            ? _ctrlQty
                                                            : _customername
                                                                    .hasFocus
                                                                ? _ctrlCustomerName
                                                                : _customerPhone
                                                                        .hasFocus
                                                                    ? _ctrlCustomerPhone
                                                                    : _customerAddress1
                                                                            .hasFocus
                                                                        ? _ctrlCustomerAddress
                                                                        : _none);
                              }),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

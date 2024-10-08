import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:barcode1/account_inventory/model/inventory_model.dart';
import 'package:barcode1/account_inventory/operation/inventory_operation.dart';
import 'package:barcode1/account_supplies/UI/widget/add_product.dart';

import 'package:barcode1/account_supplies/UI/widget/add_product_loose.dart';
import 'package:barcode1/account_supplies/UI/widget/add_product_packed.dart';
import 'package:barcode1/account_supplies/UI/widget/supplies_page1.dart';
import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/account_supplies/model/model_test.dart';
import 'package:barcode1/account_supplies/operation/operation_supplier.dart';
import 'package:barcode1/account_supplies/operation/operation_orderId.dart';
import 'package:barcode1/account_supplies/operation/operation_supply.dart';
import 'package:barcode1/database_helper/database_helper.dart';
import 'package:barcode1/product_database/model/product_database_model.dart';
import 'package:barcode1/product_database/operation/operation_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../../database_helper/loose_database/loose_model.dart';
import '../../../database_helper/loose_database/loose_operation.dart';
import '../../../home_page/widget/substring_highlighted.dart';
import '../../../main.dart';

import '../../../utils.dart';
import '../../model/model_order.dart';
import '../../model/model_transaction.dart';
import '../../operation/operation_test.dart';
import '../../operation/operation_transaction.dart';
import 'global_supply.dart' as globals;

//import 'lib/account_supplies/UI/widget/global_supply.dart' as globals;

class ChooseSupplier extends StatefulWidget {
  const ChooseSupplier({super.key});

  @override
  State<ChooseSupplier> createState() => _ChooseSupplierState();
}

class _ChooseSupplierState extends State<ChooseSupplier> {
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();

    globals.productMap = {};

    _refreshSupplierList();

    _order();
    if (globals.AddPayment == true) {
      _supplierVisible = false;
      _looseVisible = false;
      _checkout = true;
    }
    //createProduct();
  }

  
  OrderId _orderId = OrderId();

  final _dbHelperOrder1 = OrderOperation();
  static List<OrderId> _0000 = [];

  String _lastOrderId = '';

  _order() async {
    List<OrderId> k = await _dbHelperOrder1.fetchO();
    //List<OrderId> k = await _dbHelperOrder1.id;
    if (k.isNotEmpty) {
      print(k.last.id);
      _lastOrderId = ((k.last.id!) + 1).toString();
    } else {
      _lastOrderId = '1';
    }
  }

  final ValueNotifier<int> _counter1 = ValueNotifier(0);

  bool _supplierVisible = true;
  bool _looseVisible = false;
  bool _checkout = false;

  bool _chooseType = false;

  bool _chooseDate = false;
  bool _summary = false;
  bool _summaryL = false;

  bool _end = false;

  static Color one = Colors.redAccent;
  static Color two = Colors.white;
  static const Color three = Colors.white;

  bool _packagingColor = false;

  //////////////////// DATETIME PICKER
  ///
  ///
  ///
  ///
  ///

  String _selectedDate = '${DateTime.now().toString()}';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        _selectedDate = '${d}';

        print(d);

        //globals.chooseDate = ;
        //_selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
    }
  }

  /////////////// SUPPLIER LIST
  ///
  ///
  ///
  ///
  ///
  static List<Supplier> _suppliers = [];

  final _dbHelperSupplier = SupplierOperation();

  static List<Supplier> display_list_supplier = List.from(_suppliers);

  // List View
  int index1 = 0;
  //bool _selected = false;

  _refreshSupplierList() async {
    List<Supplier> x = await _dbHelperSupplier.fetchSupplier();
    setState(() {
      if (x.isNotEmpty) {
        //_suppliers = x;
        display_list_supplier = x;
        // _generateList();

        print(x[0].name);
      } else {
        //display_list = [];
        print('eeee');
      }

      //globals.x = x;
    });
  }

  void updateList(String value) {
    setState(() {
      _searchResultSupplier = display_list_supplier
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();

      _searchResultSupplier.add(Supplier(name: 'Add new supplier', phone: ' '));
    });
  }

  TextEditingController searchController = TextEditingController();
  String supplierName = '';
  String packing = 'packed';

  int totalAmount = 0;

  Supply _supply = Supply();

  static List<Supply> _supplys = [];

  Inventory _inventory = Inventory();

  static List<Supplier> _searchResultSupplier = [];
  final _dbHelperE3 = SupplyOperation();
  final _dbHelperE4 = InventoryOperation();
  var oo;
  int id = 0;
// inventory
  _submitInventory() async {
    List<Inventory> k = await _dbHelperE4.fetchInventory();

    //print(productMap);
    for (var i in globals.productMap.entries) {
      List d = [];
      setState(() {
        oo = i;
      });

      for (var x in k) {
        d.add(x.barcode);
      }
      if (d.contains(i.value['barcode']!)) {
        id = k
            .where((element) => element.barcode!
                .toLowerCase()
                .contains('${i.value['barcode']!}'))
            .toList()[0]
            .id!;

        //_already();
        print('already in there');

        double buy = double.parse(i.value['buy']!);
        double qty = double.parse(i.value['qty']!);

        double buy1 = double.parse(k
            .where((element) => element.barcode!
                .toLowerCase()
                .contains('${i.value['barcode']!}'))
            .toList()[0]
            .buy!);

        double qty1 = double.parse(k
            .where((element) => element.barcode!
                .toLowerCase()
                .contains('${i.value['barcode']!}'))
            .toList()[0]
            .qty!);

        _inventory.id = k
            .where((element) => element.barcode!
                .toLowerCase()
                .contains('${i.value['barcode']!}'))
            .toList()[0]
            .id!;

        _inventory.packing = '${i.value['packing']}' == 'l' ? 'l' : 'p';

        _inventory.productName = '${i.value['productName']}';

        _inventory.barcode = '${i.value['barcode']}';

        _inventory.qty =
            '${double.parse(i.value['qty']!) + double.parse(k.where((element) => element.barcode!.toLowerCase().contains('${i.value['barcode']!}')).toList()[0].qty!)}';

        _inventory.buy = '${((buy * qty + buy1 * qty1) / (qty + qty1))}';

        _inventory.sell = '${i.value['sell']}';

        _inventory.weight = '${i.value['weight']}';

        _inventory.DOE = '${i.value['doe']}';

        _inventory.mrp = '${i.value['mrp']}';

        if (_inventory.id == null) {
          print('added');
          await _dbHelperE4.insertInventory(_inventory);
        } else {
          await _dbHelperE4.updateInventory(_inventory);
        }
        //_inventory.id == null;
        setState(() {
          //_resetFormInventory();
        });
      } else {
        //_new();
        print('new product');

        //_inventory.id = int.parse(id);
        _inventory.packing = '${i.value['packing']}' == 'l' ? 'l' : 'p';

        _inventory.productName = '${i.value['productName']}';
        _inventory.barcode = '${i.value['barcode']}';
        _inventory.qty = '${i.value['qty']}';
        _inventory.buy = '${i.value['buy']}';
        _inventory.sell = '${i.value['sell']}';
        _inventory.weight = '${i.value['weight']}';
        _inventory.DOE = '${i.value['doe']}';

        _inventory.mrp = '${i.value['mrp']}';

        if (_inventory.id == null) {
          print('added');
          await _dbHelperE4.insertInventory(_inventory);
        } else {
          await _dbHelperE4.updateInventory(_inventory);
        }
        setState(() {
          //_resetFormInventory();
        });
      }
    }

    //_resetFormInventory();
    _resetGlobal();
  }

  _submitInventoryL() async {
    List<Inventory> k = await _dbHelperE4.fetchInventory();

    //print(productMap);
    for (var i in globals.productMapL.entries) {
      print('zzz');
      List d = [];
      setState(() {
        oo = i;
      });

      for (var x in k) {
        d.add(x.barcode);
      }
      if (d.contains(i.value['barcode']!)) {
        print('xxx');
        id = k
            .where((element) => element.barcode!
                .toLowerCase()
                .contains('${i.value['barcode']!}'))
            .toList()[0]
            .id!;

        //_already();
        print('already in there');

        _inventory.id = k
            .where((element) => element.barcode!
                .toLowerCase()
                .contains('${i.value['barcode']!}'))
            .toList()[0]
            .id!;

        _inventory.productName = '${i.value['productName']}';
        _inventory.barcode = '${i.value['barcode']}';
        /* _inventory.qty =
            '${int.parse(i.value['qty']!) + int.parse(k.where((element) => element.barcode!.toLowerCase().contains('${i.value['barcode']!}')).toList()[0].qty!)}';
       */
        _inventory.buy = '${i.value['buy']}';
        _inventory.sell = '${i.value['sell']}';
        //_inventory.weight = '${i.value['weight']}';
        _inventory.weight =
            '${double.parse(i.value['weight']!) + int.parse(k.where((element) => element.barcode!.toLowerCase().contains('${i.value['barcode']!}')).toList()[0].weight!)}';
        //_inventory.DOE = '${i.value['doe']}';

        if (_inventory.id == null) {
          print('added');
          await _dbHelperE4.insertInventory(_inventory);
        } else {
          await _dbHelperE4.updateInventory(_inventory);
        }
        //_inventory.id == null;
        setState(() {
          //_resetFormInventory();
        });
      } else {
        print('yyy');
        //_new();
        print('new product');

        //_inventory.id = int.parse(id);

        _inventory.productName = '${i.value['productName']}';
        _inventory.barcode = '${i.value['barcode']}';
        //_inventory.qty = '${i.value['qty']}';
        _inventory.buy = '${i.value['buy']}';
        _inventory.sell = '${i.value['sell']}';
        _inventory.weight = '${i.value['weight']}';
        //_inventory.DOE = '${i.value['doe']}';

        if (_inventory.id == null) {
          print('added');
          await _dbHelperE4.insertInventory(_inventory);
        } else {
          await _dbHelperE4.updateInventory(_inventory);
        }
        setState(() {
          //_resetFormInventory();
        });
      }
    }
    _resetGlobal();

    //_resetFormInventory();
  }

  _resetGlobal() {
    globals.productMap = {};
    globals.totalAmount = 0;
  }

  _updateDeliveryInventory() async {
    List<Inventory> k = await _dbHelperE4.fetchInventory();

    Map<String, Map<String, String>> produc = globals.productMap;

    Map<String, Map<String, String>> create = {};

    // Map<String, Map<String, String>> create = {};

    for (var i in produc.entries) {
      bool found = false;

      for (var j in k) {
        if (j.barcode == i.value['barcode']) {
          double buy = double.parse(i.value['buy']!);
          double qty = double.parse(i.value['qty']!);

          double buy1 = double.parse(j.buy!);

          double qty1 = double.parse(j.qty!);

          found = true;
          //print('found');
          print(
              '(${j.productName}, ${j.qty}, ${j.buy} )( ${i.value['productName']}, ${i.value['qty']}, ${i.value['buy']})');

          print(double.parse(i.value['buy']!));
          print(double.parse(i.value['qty']!));
          print(j.buy);
          print(j.qty);
          _inventory = j;

          _inventory.qty =
              (double.parse(j.qty!) + double.parse(i.value['qty']!)).toString();

          _inventory.buy = '${((buy * qty + buy1 * qty1) / (qty + qty1))}';

          await _dbHelperE4.updateInventory(_inventory);

          print(_inventory.buy);
          print(_inventory.qty);

          _inventory = Inventory();
        } else {
          //print('not found');
          //create = {i.key: i.value};
        }
      }

      if (found == false) {
        print('(${i.value['productName']}, ${i.value['qty']})');
        //create = {i.key: i.value};

        _inventory.packing = '${i.value['packing']}' == 'l' ? 'l' : 'p';

        _inventory.productName = '${i.value['productName']}';
        _inventory.barcode = '${i.value['barcode']}';
        _inventory.qty = '${i.value['qty']}';
        _inventory.buy = '${i.value['buy']}';
        _inventory.sell = '${i.value['sell']}';
        _inventory.weight = '0';
        _inventory.DOE = i.value['doe'] != '' ? '${i.value['doe']}' : '0';
        _inventory.mrp = '${i.value['mrp']}';

        _inventory.supplierId = '0';
        _inventory.date = DateTime.now().toString();
        _inventory.weightLoose = '0';

        await _dbHelperE4.insertInventory(_inventory);
        _inventory = Inventory();
      }
    }
  }

  //// k bar
  ///
  String text = 'Speak....';
  bool isListening = false;

  bool _vendor = false;

  bool _showSearchResults = false;

  //packed

  bool _searchP = false;
  Widget card(int index, BuildContext context) {
    //int totalAmount = 0;

    return Card(
        color: Color.fromRGBO(244, 244, 244, 1),
        // color: Colors.white,
        elevation: 0,
        // margin: EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: Container(
          // height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
          ),

          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          //width: 10,
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          const Text('Total amount',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 72, 72, 73),
                                  fontSize: 13,
                                  fontFamily: 'Bangla',
                                  fontWeight: FontWeight.bold)),
                          Text(
                            '${globals.totalAmount}',
                            style: const TextStyle(
                              fontFamily: 'Koulen',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      color: Colors.white,
                      width: 1,
                      height: double.infinity,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          const Text('Total products',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 72, 72, 73),
                                  fontSize: 13,
                                  fontFamily: 'Bangla',
                                  fontWeight: FontWeight.bold)),
                          Text(
                            '${globals.productMap.length}',
                            style: const TextStyle(
                              fontFamily: 'Koulen',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /*  Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      'ORDER PLACED - ${reversed[index]}',
                      style: const TextStyle(
                        fontFamily: 'Koulen',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 200),
                      child: Text(
                        'TOTAL - ${totalAmount}',
                        style: const TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             */
              Expanded(
                child: Container(
                  width: double.infinity,
                  //height: 40,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Center(child: Text('QTY'))),
                          DataColumn(
                              label: Center(
                                  child: Text(
                            'Product Name',
                          ))),
                          DataColumn(label: Center(child: Text('MRP'))),
                          DataColumn(
                              label: Center(child: Text('Buying Price'))),
                          DataColumn(
                              label: Center(child: Text('Selling Price'))),
                          DataColumn(label: Center(child: Text('Weight'))),
                          DataColumn(label: Center(child: Text('DOE'))),
                        ],
                        rows: globals.productMap
                            .entries // Loops through dataColumnText, each iteration assigning the value to element
                            .map(
                              ((element) => DataRow(
                                    /* display_list1 // Loops through dataColumnText, each iteration assigning the value to element
                                              .map(
                                                ((element) => DataRow(*/
                                    cells: <DataCell>[
                                      DataCell(Center(
                                          child:
                                              Text('${element.value['qty']}'))),
                                      DataCell(Text(
                                          '${element.value['productName']}')),
                                      DataCell(Center(
                                          child:
                                              Text('${element.value['mrp']}'))),
                                      DataCell(Center(
                                          child:
                                              Text('${element.value['buy']}'))),
                                      DataCell(Center(
                                          child: Text(
                                              '${element.value['sell']}'))),
                                      DataCell(Center(
                                        child:
                                            Text('${element.value['weight']}'),
                                      )),
                                      DataCell(Center(
                                          child:
                                              Text('${element.value['doe']}'))),
                                    ],
                                  )),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget cardL(int index, BuildContext context) {
    //int totalAmount = 0;

    return Card(
        color: Color.fromRGBO(244, 244, 244, 1),
        // color: Colors.white,
        elevation: 0,
        // margin: EdgeInsets.all(4.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        child: Container(
          // height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
          ),

          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 0),
                      child: Column(
                        children: [
                          const Text('Total amount',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 72, 72, 73),
                                  fontSize: 13,
                                  fontFamily: 'Bangla',
                                  fontWeight: FontWeight.bold)),
                          Text(
                            '${globals.totalAmountL}',
                            style: const TextStyle(
                              fontFamily: 'Koulen',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                      color: Colors.white,
                      width: 1,
                      height: double.infinity,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          const Text('Total products',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 72, 72, 73),
                                  fontSize: 13,
                                  fontFamily: 'Bangla',
                                  fontWeight: FontWeight.bold)),
                          Text(
                            '${globals.productMapL.length}',
                            style: const TextStyle(
                              fontFamily: 'Koulen',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          //width: 10,
                          ),
                    ),
                  ],
                ),
              ),

              /*  Container(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      'ORDER PLACED - ${reversed[index]}',
                      style: const TextStyle(
                        fontFamily: 'Koulen',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 200),
                      child: Text(
                        'TOTAL - ${totalAmount}',
                        style: const TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
             */
              Expanded(
                child: Container(
                  width: double.infinity,
                  //height: 40,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Center(child: Text('Total'))),
                          DataColumn(
                              label: Center(child: Text('Weight\n(Kg)'))),
                          DataColumn(
                              label: Center(
                                  child: Text(
                            'Product Name',
                          ))),
                          DataColumn(
                              label: Center(
                                  child: Text(
                            'Barcode',
                          ))),
                          DataColumn(
                              label: Center(child: Text('Buy\nPrice\n(Kg)'))),
                          DataColumn(
                              label: Center(child: Text('Sell\nPrice\n(Kg)'))),
                          DataColumn(label: Center(child: Text('DOE'))),
                        ],
                        rows: globals.productMapL
                            .entries // Loops through dataColumnText, each iteration assigning the value to element
                            .map(
                              ((element) => DataRow(
                                    /* display_list1 // Loops through dataColumnText, each iteration assigning the value to element
                                              .map(
                                                ((element) => DataRow(*/
                                    cells: <DataCell>[
                                      DataCell(Center(
                                          child: Text(
                                              '${double.parse(element.value['buy']!) * double.parse(element.value['weight']!)}'))),
                                      DataCell(Center(
                                          child: Text(
                                              '${element.value['weight']}'))),
                                      DataCell(Center(
                                        child: Text(
                                            '${element.value['productName']}'),
                                      )),
                                      DataCell(Center(
                                        child:
                                            Text('${element.value['barcode']}'),
                                      )),
                                      DataCell(Center(
                                          child:
                                              Text('${element.value['buy']}'))),
                                      DataCell(Center(
                                          child: Text(
                                              '${element.value['sell']}'))),
                                      DataCell(Center(
                                          child:
                                              Text('${element.value['doe']}'))),
                                    ],
                                  )),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String paidStatus = 'full';

  static List<Transaction1> _transactions1 = [];

  Transaction1 _transaction1 = Transaction1();

  final _dbHelperTransaction1 = TransactionOperation();

  _transaction() async {
    _transaction1.supplierId = globals.SupplierId.toString();
    _transaction1.amount = _ctrlSupplyPaidAmt.text.toString();
    _transaction1.date = _supply.date.toString();
    _transaction1.description = '';
    _transaction1.orderCustom = 'order';
    _transaction1.paidReceived = 'paid';
    _transaction1.paymentMode = _ctrlSupplyPaymentMode.text.toString();

    _dbHelperTransaction1.insertTransaction(_transaction1);
    _transaction1.orderId = _lastOrderId;

    int x = 0;
    //_transaction1.x = 'a';
    x = await _dbHelperOrder1.insertOrderId(_orderId);

    print(x);
  }

  Widget card1L(
      double height,
      double width,
      String no,
      String product,
      String barcode,
      String weight,
      String buy,
      String sell,
      int index,
      BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        child: Column(
          children: [
            Container(
              height: height * 0.15,
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: double.infinity,
                    //color: const Color.fromRGBO(244, 244, 244, 1),
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        //fontFamily: 'Koulen',
                        fontSize: 63,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      //height: 40,
                      //color: const Color.fromRGBO(
                      //  244, 244, 244, 1),

                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            //color: const Color.fromRGBO(244, 244, 244, 1),

                            child: Text(
                              '$product',
                              style: TextStyle(
                                fontFamily: 'BanglaBold',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$barcode',
                              style: TextStyle(
                                fontFamily: 'Bangla',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${weight}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                          ),
                                        ),

                                        /*  alignment: Alignment.center,
                                        
                                        child: Text(
                                          
                                          '$qty',
                                          style: const TextStyle(
                                              fontFamily: 'Bangla',
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),*/
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$buy',
                                          style: TextStyle(
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$sell',
                                          style: TextStyle(
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
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
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.black,
              margin: const EdgeInsets.only(left: 5, right: 5),
            )
          ],
        ),
        onTap: () {
          ///
          ///
        },
      ),
    );
  }

  ///////////////////KEYBOARD//////////////////////
  ///
  ///
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  final _ctrlSupplyDeliveryStatus = TextEditingController();
  final _ctrlSupplyRemarks = TextEditingController();
  final _ctrlSupplyPaidStatus = TextEditingController();
  final _ctrlSupplyPaymentMode = TextEditingController();
  final _ctrlSupplyPaidAmt = TextEditingController();

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  FocusNode _partialPayment = FocusNode();
  FocusNode _description = FocusNode();

  String errorpartialPayment = '';

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

    //partial paymnet

    if (_partialPayment.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorpartialPayment = 'Invalid';
      } else {
        errorpartialPayment = '';
      }
    } else {
      errorpartialPayment = '';
    }

    // Update the screen
    setState(() {});
  }

  Widget card1(
      double height,
      double width,
      String no,
      String product,
      String barcode,
      String mrp,
      String qty,
      String buy,
      String sell,
      int index,
      BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        child: Column(
          children: [
            Container(
              height: height * 0.15,
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: double.infinity,
                    //color: const Color.fromRGBO(244, 244, 244, 1),
                    margin: const EdgeInsets.only(right: 20),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        //fontFamily: 'Koulen',
                        fontSize: 63,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      //height: 40,
                      //color: const Color.fromRGBO(
                      //  244, 244, 244, 1),

                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.centerLeft,
                            //color: const Color.fromRGBO(244, 244, 244, 1),

                            child: Text(
                              '$product',
                              style: TextStyle(
                                fontFamily: 'BanglaBold',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '$barcode',
                              style: TextStyle(
                                fontFamily: 'Bangla',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '$mrp',
                                          style: TextStyle(
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${qty}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                          ),
                                        ),

                                        /*  alignment: Alignment.center,
                                        
                                        child: Text(
                                          
                                          '$qty',
                                          style: const TextStyle(
                                              fontFamily: 'Bangla',
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),*/
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$buy',
                                          style: TextStyle(
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$sell',
                                          style: TextStyle(
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                            color: Colors.black,
                                          ),
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
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.black,
              margin: const EdgeInsets.only(left: 5, right: 5),
            )
          ],
        ),
        onTap: () {},
      ),
    );
  }

///////////////////////////////
  ///

  Supply1 _supplyn = Supply1();
  final _dbHelperT = SupplyOperationT();

  _testMap() async {
    _supply.productList = jsonEncode(globals.productMap);

    print(globals.productMap);

    if (_supply.id == null) {
      print('added');
      await _dbHelperE3.insertSupply(_supply);
    } else {
      await _dbHelperE3.updateSupply(_supply);
    }
    setState(() {
      //_resetFormInventory();
    });

    // print(productList[1]);
  }

  Widget cardCart(double height, double width, int index, String product,
      BuildContext context) {
    return Dismissible(
      key: Key(''),
      //Key(_inventoryListAllFilter[index].id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      confirmDismiss: (direction) async {},
      direction: DismissDirection.none,

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
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Text(
          'Add',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontFamily: 'BanglaBold'),
        ),
      ),

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
                            '${globals.productMap.values.elementAt(index)['productName']!}',
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
              //barcode
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                // height: 20.7,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 0, bottom: 0),

                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '${globals.productMap.values.elementAt(index)['barcode']!}',
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
                                      '${globals.productMap.values.elementAt(index)['qty']!}',
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
                                      '${globals.productMap.values.elementAt(index)['mrp']!}',
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
                      //cost
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: double.infinity,
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'cost  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 15.3,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${globals.productMap.values.elementAt(index)['buy']!}',
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
                      ),
                      //price
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height: double.infinity,
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'price  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 15.3,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${globals.productMap.values.elementAt(index)['sell']!}',
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
        onTap: () {},
      ),
    );
  }

  int _selectedIndex = -1;

  bool supplies = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        
       
        child: Stack(
          children: [
            if (_supplierVisible)
              Container(
                margin: const EdgeInsets.only(left: 0, right: 5, top: 0, bottom: 10),
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
                 
                //width: width*0.8,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.05,
                      margin: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        children: [
                          Container(
                            height: double.infinity,
                            width: width * 0.15,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
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
                            padding: EdgeInsets.only(top: 0),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${globals.SupplierName}  ',
                                    style: TextStyle(
                                      color: Color.fromRGBO(92, 94, 98, 1),
                                      fontSize: 20,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              height: double.infinity,
                              width: width * 0.15,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey, // Color of the shadow
                                      offset: Offset.zero,
                                      //Offset.zero,
                                      blurRadius:
                                          6, // Spread or blur radius of the shadow
                                      spreadRadius:
                                          0, // How much the shadow should spread
                                    )
                                  ]),
                              alignment: FractionalOffset.center,
                              padding:
                                  EdgeInsets.only(top: 0, left: 10, right: 10),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          '${_selectedDate.substring(0, 10)}  ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 20,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text: '^',
                                      style: TextStyle(
                                        color: Color.fromRGBO(2, 120, 174, 1),
                                        fontSize: 25,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /*Text(_selectedDate,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontFamily: 'Koulen',
                                      fontWeight: FontWeight.w500)),*/
                            ),
                            onTap: () {
                              _selectDate(context);
                            },
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                            ),
                          ),
                          Container(
                            width: width * 0.215,
                            height: double.infinity,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // Color of the shadow
                                offset: Offset.zero, // Offset of the shadow
                                blurRadius:
                                    6, // Spread or blur radius of the shadow
                                spreadRadius:
                                    0, // How much the shadow should spread
                              )
                            ]),
                            child: ElevatedButton(
                              onPressed: () {
                                if (globals.productMap.isNotEmpty) {
                                  setState(() {
                                    _chooseDate = false;
                                    _supplierVisible = false;
                                    _looseVisible = false;
                                    _summary = false;
                                    _summaryL = false;
                                    _checkout = true;
                                    _ctrlSupplyPaidAmt.text =
                                        '${globals.totalAmount}';
                                    _ctrlSupplyPaymentMode.text = 'cash';
                                    _ctrlSupplyPaidStatus.text = 'full';
                                    _ctrlSupplyDeliveryStatus.text =
                                        'delivered';
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll(
                                    Colors.black),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3))),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'CHECKOUT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: width * 0.04,
                            margin: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
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
                            child: IconButton(
                                onPressed: () {
                                  globals.productMap = {};
                                  globals.totalAmount = 0;
                                 // createProduct();

                                 _checkout = false;
                                 _supplierVisible = false;
                                 supplies = true;
                                 setState(() {
                                   
                                 });
                                 
                            /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SuppliesPage1()));*/
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 27,
                                )),
                          ),
                        ],
                      ),
                    ),

                    Container(child: AddProduct()),
                    //Container(child: AddProductPacked()),
                  ],
                ),
              ),
            if (_checkout)
              Container(
                margin: const EdgeInsets.only(left: 0, right: 5, top: 0, bottom: 10),
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
                
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.05,
                      child: Row(
                        children: [
                          Container(
                            height: double.infinity,
                            width: width * 0.04,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
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
                            child: IconButton(
                                onPressed: () {
                                  _chooseDate = true;
                                  _checkout = false;
                                  _supplierVisible = true;
              
                                  print(globals.productMap);
              
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                  size: 27,
                                )),
                          ),
                          Container(
                            height: double.infinity,
                            width: width * 0.15,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
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
                            padding: EdgeInsets.only(top: 0),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${globals.SupplierName}  ',
                                    style: TextStyle(
                                      color: Color.fromRGBO(92, 94, 98, 1),
                                      fontSize: 20,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              height: double.infinity,
                              width: width * 0.15,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey, // Color of the shadow
                                      offset: Offset.zero,
                                      //Offset.zero,
                                      blurRadius:
                                          6, // Spread or blur radius of the shadow
                                      spreadRadius:
                                          0, // How much the shadow should spread
                                    )
                                  ]),
                              alignment: FractionalOffset.center,
                              padding:
                                  EdgeInsets.only(top: 0, left: 10, right: 10),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${_selectedDate.substring(0, 10)}  ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 20,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text: '^',
                                      style: TextStyle(
                                        color: Color.fromRGBO(2, 120, 174, 1),
                                        fontSize: 25,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
              
                              /*Text(_selectedDate,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontFamily: 'Koulen',
                                        fontWeight: FontWeight.w500)),*/
                            ),
                            onTap: () {},
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            width: width * 0.16,
                            height: double.infinity,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey, // Color of the shadow
                                offset: Offset.zero, // Offset of the shadow
                                blurRadius:
                                    6, // Spread or blur radius of the shadow
                                spreadRadius:
                                    0, // How much the shadow should spread
                              )
                            ]),
                            //alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                               // createProduct();
                                if (_ctrlSupplyPaidAmt.text == '' ||
                                    errorpartialPayment != '') {
                                  errorpartialPayment = 'Invalid';
                                  setState(() {});
                                } else {
                                  _testMap();
              
                                  if (_ctrlSupplyDeliveryStatus.text ==
                                      'delivered') {
                                    //_submitInventory();
                                    _updateDeliveryInventory();
                                  }
              
                                  _chooseDate = false;
                                  _supplierVisible = false;
                                  _looseVisible = false;
                                  _summary = false;
                                  _summaryL = false;
              
                                  _checkout = false;
                                  _end = false;
              
                                  _supply.supplierId =
                                      globals.SupplierId.toString();
                                  _inventory.supplierId =
                                      globals.SupplierId.toString();
              
                                  if (_selectedDate == '') {
                                    _supply.date = DateTime.now().toString();
              
                                    _inventory.date = DateTime.now().toString();
                                  } else {
                                    _supply.date = _selectedDate;
              
                                    _inventory.date = _selectedDate;
                                  }
              
                                  _supply.packing = packing[0];
              
                                  _supply.deliveryStatus =
                                      _ctrlSupplyDeliveryStatus.text;
                                  _supply.paymentMode =
                                      _ctrlSupplyPaymentMode.text;
                                  _supply.paidStatus = _ctrlSupplyPaidStatus.text;
                                  _supply.paidAmt = _ctrlSupplyPaidAmt.text;
                                  _supply.remarks = _ctrlSupplyRemarks.text;
              
                                  _supply.orderId = _lastOrderId;
                                  _supply.deliveryDate = _selectedDate;
              
                                  _transaction();
                                  _checkout = false;
                                 _supplierVisible = false;
                                 supplies = true;
                                 setState(() {
                                   
                                 });
              
                                /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SuppliesPage1()));*/
              
                                  print('Billed');
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll(Colors.black),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3))),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Add Order',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: width * 0.04,
                            margin: const EdgeInsets.only(right: 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.white,
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
                            child: IconButton(
                                onPressed: () {
                                  globals.productMap = {};
                                  globals.totalAmount = 0;
                                  globals.totalAmountL = 0;

                                  _checkout = false;
                                 _supplierVisible = false;
                                 supplies = true;
                                 setState(() {
                                   
                                 });
                                 
                               
                              
              
                                 /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SuppliesPage1()));*/
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 27,
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
                        width: double.infinity,
                        child: Row(
                          // ROW 1/2
              
                          children: [
                            Container(
                              width: width * 0.33,
                              height: double.infinity,
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
                                            color: Colors
                                                .grey, // Color of the shadow
                                            offset: Offset(
                                                0, 2), // Offset of the shadow
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
                                          itemCount: globals.productMap.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            if (globals.productMap.isNotEmpty) {
                                              return cardCart(
                                                  height,
                                                  width,
                                                  index,
                                                  globals.productMap.values
                                                      .elementAt(
                                                          index)['productName']!,
                                                  context);
                                              /* cardSupplyCart(
                                      height,
                                      width,
                                      globals.productMap.keys.elementAt(index),
                                      globals.productMap.values
                                          .elementAt(index)['productName']!
                                          .toUpperCase(),
                                      globals.productMap.values
                                          .elementAt(index)['barcode']!
                                          .toUpperCase(),
                                      globals.productMap.values
                                          .elementAt(index)['mrp']!
                                          .toUpperCase(),
                                      globals.productMap.values
                                          .elementAt(index)['qty']!
                                          .toUpperCase(),
                                      globals.productMap.values
                                          .elementAt(index)['buy']!
                                          .toUpperCase(),
                                      globals.productMap.values
                                          .elementAt(index)['sell']!
                                          .toUpperCase(),
                                      index,
                                      context);
                               */
                                            } else {
                                              return const Text(
                                                  'Select Supplier');
                                            }
                                          }),
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
                                            color: Colors
                                                .grey, // Color of the shadow
                                            offset: Offset(
                                                0, 2), // Offset of the shadow
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
                                            margin:
                                                const EdgeInsets.only(left: 20),
                                            alignment: Alignment.centerLeft,
                                            height: double.infinity,
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Total Prod.  ',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 20,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${globals.productMap.length}',
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
                                            margin:
                                                const EdgeInsets.only(right: 20),
                                            alignment: Alignment.centerRight,
                                            height: double.infinity,
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Total Amt  ',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 20,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${globals.totalAmount}',
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
              
                            // ROW 2/2
              
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 0,
                                          bottom: 10),
                                      // FORM TO ENTER ADDITIONAL DETAILS ABOUT A PARTICULAR PRODUCT
              
                                      child: Form(
                                        // key: _formKeySupply,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                height: double.infinity,
                                                child: Column(
                                                  children: [
                                                    // total amount
              
                                                    /*    Container(
                                                      height: height * 0.07,
                                                      width: double.infinity,
                                                      margin:
                                                          const EdgeInsets.only(
                                                        bottom: 30,
                                                        top: 0,
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                height * 0.022,
                                                            //color: Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            child: const Text(
                                                                'Amount to be paid',
                                                                style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          238,
                                                                          72,
                                                                          72,
                                                                          73),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      'BanglaBold',
                                                                  //fontWeight: FontWeight.w100
                                                                )),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                                width: double
                                                                    .infinity,
                                                                //height: height * 0.04,
                                                                //color: Colors.black,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right: 5,
                                                                        top: 4,
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
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child: Text(
                                                                  'Rs ${globals.totalAmount}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'BanglaBold',
                                                                      fontSize:
                                                                          18),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
              */
                                                    //paymnet mode
                                                    Container(
                                                      width: double.infinity,
              
                                                      // height: height * 0.16,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5,
                                                              top: 0,
                                                              left: 5,
                                                              right: 5),
                                                      padding:
                                                          EdgeInsets.only(top: 5),
                                                      //color: Colors.white,
                                                      //height: height*0.3,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height:
                                                                height * 0.085,
                                                            width:
                                                                double.infinity,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,
              
                                                                  //color: Colors.white,
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          left: 0,
                                                                          right:
                                                                              0,
                                                                          top: 0,
                                                                          bottom:
                                                                              0),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              3),
                                                                  child: RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      style: DefaultTextStyle.of(
                                                                              context)
                                                                          .style,
                                                                      children: <
                                                                          TextSpan>[
                                                                        TextSpan(
                                                                          text:
                                                                              'Payment Mode',
                                                                          style:
                                                                              TextStyle(
                                                                            color: Color.fromRGBO(
                                                                                92,
                                                                                94,
                                                                                98,
                                                                                1),
                                                                            fontSize:
                                                                                15,
                                                                            fontFamily:
                                                                                'Koulen',
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    //height: height * 0.04,
                                                                    ///color: Colors.black,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left: 0,
                                                                        right: 0,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
              
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child: Container(
                                                                              height: double.infinity,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(4),
                                                                                color: _ctrlSupplyPaymentMode.text == 'cash' ? Colors.black : Colors.grey[300],
                                                                              ),
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 5, right: 5),
                                                                              padding: const EdgeInsets.only(bottom: 0),
                                                                              child: TextButton(
                                                                                onPressed: () {
                                                                                  _ctrlSupplyPaymentMode.text = 'cash';
                                                                                  setState(() {});
                                                                                },
                                                                                child: Text(
                                                                                  'Cash',
                                                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        Expanded(
                                                                          child: Container(
                                                                              height: double.infinity,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(4),
                                                                                color: _ctrlSupplyPaymentMode.text == 'card' ? Colors.black : Colors.grey[300],
                                                                              ),
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 5, right: 5),
                                                                              padding: const EdgeInsets.only(bottom: 0),
                                                                              child: TextButton(
                                                                                onPressed: () {
                                                                                  _ctrlSupplyPaymentMode.text = 'card';
                                                                                  setState(() {});
                                                                                },
                                                                                child: Text(
                                                                                  'Card',
                                                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
                                                                                ),
                                                                              )),
                                                                        ),
              
                                                                        /* Expanded(
                                                                          child: Container(
                                                                              height: double.infinity,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                color: _ctrlSupplyPaymentMode.text == 'cash' ? Colors.black : Colors.grey[300],
                                                                              ),
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 0, right: 5),
                                                                              padding: const EdgeInsets.only(bottom: 0),
                                                                              child: IconButton(
                                                                                onPressed: () {
                                                                                  _ctrlSupplyPaymentMode.text = 'cash';
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  Icons.attach_money,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              )),
                                                                        ),
                                                                        Expanded(
                                                                          child: Container(
                                                                              height: double.infinity,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                color: _ctrlSupplyPaymentMode.text == 'card' ? Colors.black : Colors.grey[300],
                                                                              ),
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 0, right: 5),
                                                                              padding: const EdgeInsets.only(bottom: 0),
                                                                              child: IconButton(
                                                                                onPressed: () {
                                                                                  _ctrlSupplyPaymentMode.text = 'card';
                                                                                  setState(() {});
                                                                                },
                                                                                icon: Icon(
                                                                                  Icons.credit_card,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              )),
                                                                        ),
                                                                      */
                                                                        Expanded(
                                                                          child: Container(
                                                                              height: double.infinity,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(4),
                                                                                color: _ctrlSupplyPaymentMode.text == 'upi' ? Colors.black : Colors.grey[300],
                                                                              ),
                                                                              alignment: Alignment.center,
                                                                              margin: const EdgeInsets.only(left: 5, right: 5),
                                                                              padding: const EdgeInsets.only(bottom: 0),
                                                                              child: TextButton(
                                                                                onPressed: () {
                                                                                  _ctrlSupplyPaymentMode.text = 'upi';
                                                                                  setState(() {});
                                                                                },
                                                                                child: Text(
                                                                                  'UPI',
                                                                                  style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: height * 0.11,
                                                            width:
                                                                double.infinity,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 0,
                                                                    top: 15),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height: double
                                                                        .infinity,
                                                                    // width: width*0.08
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            right:
                                                                                5),
              
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          width: double
                                                                              .infinity,
              
                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left:
                                                                                  0,
                                                                              right:
                                                                                  0,
                                                                              top:
                                                                                  0,
                                                                              bottom:
                                                                                  0),
                                                                          margin: EdgeInsets.only(
                                                                              bottom:
                                                                                  3),
                                                                          child:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              style:
                                                                                  DefaultTextStyle.of(context).style,
                                                                              children: <TextSpan>[
                                                                                TextSpan(
                                                                                  text: 'Payment Status',
                                                                                  style: TextStyle(
                                                                                    color: Color.fromRGBO(92, 94, 98, 1),
                                                                                    fontSize: 15,
                                                                                    fontFamily: 'Koulen',
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            height: height *
                                                                                0.048,
                                                                            width: double
                                                                                .infinity,
                                                                            //height: height * 0.04,
                                                                            //color: Colors.black,
                                                                            padding: const EdgeInsets.only(
                                                                                left:
                                                                                    0,
                                                                                right:
                                                                                    0,
                                                                                top:
                                                                                    0,
                                                                                bottom:
                                                                                    0),
                                                                            margin: const EdgeInsets.only(
                                                                                left:
                                                                                    5,
                                                                                right:
                                                                                    5),
                                                                            child:
                                                                                Row(children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                    height: double.infinity,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      color: _ctrlSupplyPaidStatus.text == 'full' ? Colors.black : Colors.grey[300],
                                                                                    ),
                                                                                    alignment: Alignment.center,
                                                                                    margin: const EdgeInsets.only(left: 0, right: 5),
                                                                                    padding: const EdgeInsets.only(bottom: 0),
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        _ctrlSupplyPaidStatus.text = 'full';
                                                                                        setState(() {
                                                                                          _ctrlSupplyPaidStatus.text = 'full';
                                                                                          _ctrlSupplyPaidAmt.text = globals.totalAmount.toString();
                                                                                        });
                                                                                      },
                                                                                      child: Text(
                                                                                        'Full',
                                                                                        style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                    height: double.infinity,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      color: _ctrlSupplyPaidStatus.text == 'partial' ? Colors.black : Colors.grey[300],
                                                                                    ),
                                                                                    alignment: Alignment.center,
                                                                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                    padding: const EdgeInsets.only(bottom: 0),
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        _ctrlSupplyPaidStatus.text = 'partial';
                                                                                        setState(() {
                                                                                          _ctrlSupplyPaidStatus.text = 'partial';
              
                                                                                          _ctrlSupplyPaidAmt.text = '';
                                                                                        });
                                                                                      },
                                                                                      child: Text(
                                                                                        'Partial',
                                                                                        style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
                                                                                      ),
                                                                                    )),
                                                                              ),
                                                                            ])),
                                                                        Container(
                                                                          height: height *
                                                                              0.022,
                                                                          margin: const EdgeInsets.only(
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
                                                                          //height: height * 0.05,
                                                                          //color: Colors.black,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    height: double
                                                                        .infinity,
                                                                    //width: width * 0.08,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    child: Column(
                                                                      children: [
                                                                        Container(
                                                                          width: double
                                                                              .infinity,
              
                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left:
                                                                                  0,
                                                                              right:
                                                                                  0,
                                                                              top:
                                                                                  0,
                                                                              bottom:
                                                                                  0),
                                                                          margin: EdgeInsets.only(
                                                                              bottom:
                                                                                  3),
                                                                          child:
                                                                              RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              style:
                                                                                  DefaultTextStyle.of(context).style,
                                                                              children: <TextSpan>[
                                                                                TextSpan(
                                                                                  text: 'Payment Amount',
                                                                                  style: TextStyle(
                                                                                    color: Color.fromRGBO(92, 94, 98, 1),
                                                                                    fontSize: 15,
                                                                                    fontFamily: 'Koulen',
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height: height *
                                                                              0.048,
                                                                          width: double
                                                                              .infinity,
                                                                          //height: height * 0.04,
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
                                                                                  5,
                                                                              top:
                                                                                  2,
                                                                              bottom:
                                                                                  0),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(3),
                                                                              color: Colors.white,
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: _ctrlSupplyPaidStatus.text != 'full' ? Colors.grey : Colors.white, // Color of the shadow
                                                                                  offset: Offset.zero, // Offset of the shadow
                                                                                  blurRadius: 6, // Spread or blur radius of the shadow
                                                                                  spreadRadius: 0, // How much the shadow should spread
                                                                                )
                                                                              ]),
                                                                          child:
                                                                              TextFormField(
                                                                            //focusNode: _focusNodeProduct,
                                                                            readOnly:
                                                                                true, // Prevent system keyboard
                                                                            showCursor:
                                                                                false,
                                                                            focusNode:
                                                                                _partialPayment,
              
                                                                            enabled: _ctrlSupplyPaidStatus.text == 'full'
                                                                                ? false
                                                                                : true,
                                                                            //focusNode: _focusNodeBarcode,
                                                                            controller:
                                                                                _ctrlSupplyPaidAmt,
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontFamily: 'Koulen',
                                                                                fontSize: 17),
                                                                            cursorColor:
                                                                                Colors.black,
              
                                                                            //enabled: !lock,
              
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              disabledBorder:
                                                                                  UnderlineInputBorder(borderSide: BorderSide.none),
                                                                              //prefixIcon: Icon(Icons.person),
                                                                              //prefixIconColor: Colors.black,
                                                                              enabledBorder:
                                                                                  UnderlineInputBorder(borderSide: BorderSide.none),
              
                                                                              focusedBorder:
                                                                                  UnderlineInputBorder(
                                                                                borderSide: BorderSide(color: Color.fromRGBO(0, 51, 154, 1), width: 2),
                                                                              ),
              
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
                                                                        Container(
                                                                          height: height *
                                                                              0.022,
                                                                          margin: const EdgeInsets.only(
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
                                                                          //height: height * 0.05,
                                                                          //color: Colors.black,
                                                                          child:
                                                                              Text(
                                                                            errorpartialPayment,
                                                                            style: TextStyle(
                                                                                fontFamily: 'Bangla',
                                                                                fontSize: 13,
                                                                                color: Color.fromRGBO(139, 0, 0, 1),
                                                                                fontWeight: FontWeight.bold),
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
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.27,
              
                                              // height: height * 0.18,
                                              margin: const EdgeInsets.only(
                                                  bottom: 5,
                                                  top: 15,
                                                  left: 5,
                                                  right: 5),
                                              padding: EdgeInsets.only(top: 5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: height * 0.085,
                                                    width: double.infinity,
                                                    margin: const EdgeInsets.only(
                                                      bottom: 5,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: double.infinity,
              
                                                          //color: Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  bottom: 0),
                                                          margin: EdgeInsets.only(
                                                              bottom: 3),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      'Delivery Status',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            92,
                                                                            94,
                                                                            98,
                                                                            1),
                                                                    fontSize: 15,
                                                                    fontFamily:
                                                                        'Koulen',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                              width:
                                                                  double.infinity,
                                                              //height: height * 0.04,
                                                              //color: Colors.black,
              
                                                              child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Container(
                                                                          height: double.infinity,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            color: _ctrlSupplyDeliveryStatus.text == 'delivered'
                                                                                ? Colors.black
                                                                                : Colors.grey[300],
                                                                          ),
                                                                          alignment: Alignment.center,
                                                                          margin: const EdgeInsets.only(left: 5, right: 5),
                                                                          padding: const EdgeInsets.only(bottom: 0),
                                                                          child: TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                _ctrlSupplyDeliveryStatus.text = 'delivered';
              
                                                                                //_ctrlSupplyPaidAmt.text = globals.totalAmount.toString();
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Delivered',
                                                                              style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 15,
                                                                                  fontFamily: 'Koulen'),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                    Expanded(
                                                                      child: Container(
                                                                          height: double.infinity,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            color: _ctrlSupplyDeliveryStatus.text == 'pending'
                                                                                ? Colors.black
                                                                                : Colors.grey[300],
                                                                          ),
                                                                          alignment: Alignment.center,
                                                                          margin: const EdgeInsets.only(left: 5, right: 5),
                                                                          padding: const EdgeInsets.only(bottom: 0),
                                                                          child: TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                _ctrlSupplyDeliveryStatus.text = 'pending';
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              'Pending',
                                                                              style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 15,
                                                                                  fontFamily: 'Koulen'),
                                                                            ),
                                                                          )),
                                                                    ),
                                                                  ])),
                                                        ),
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
                                  ),
                                  //keyboard
                                  Container(
                                    width: double.infinity,
                                    height: height * 0.375,
                                    margin: const EdgeInsets.only(
                                        bottom: 0, right: 0, left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
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
                                        ]),
                                    child: VirtualKeyboard(
              
                                        // height: 300,
                                        //width: 500,
                                        textColor: Colors.white,
                                        textController: _controllerText,
                                        //customLayoutKeys: _customLayoutKeys,
                                        defaultLayouts: [
                                          VirtualKeyboardDefaultLayouts.English
                                        ],
                                        //reverseLayout :true,
                                        type: isNumericMode
                                            ? VirtualKeyboardType.Numeric
                                            : VirtualKeyboardType.Alphanumeric,
                                        onKeyPress: (key) {
                                          _onKeyPress(
                                              key,
                                              _partialPayment.hasFocus
                                                  ? _ctrlSupplyPaidAmt
                                                  : _description.hasFocus
                                                      ? _ctrlSupplyRemarks
                                                      : _none);
                                        }),
                                  )
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
          
         if(supplies)
         SuppliesPage1()
          ],
        ),
      ),
    );
  }
}

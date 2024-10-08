// ignore_for_file: prefer_final_fields
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:barcode1/billing/quick_add/quick_add_model.dart';
import 'package:barcode1/billing/quick_add/quick_add_operation.dart';

import 'package:barcode1/utils.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vibration/vibration.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../../../database_helper/database_helper.dart';

import '../../../account_sales/model/model_sales.dart';
import '../../../account_sales/operation/operation_sales.dart';
import '../../../database_helper/loose_database/loose_model.dart';
import '../../../database_helper/loose_database/loose_operation.dart';
import '../../model/inventory_model.dart';
import '../../operation/inventory_operation.dart';
import 'global_inventory.dart' as globals;

import '../../../global.dart' as globalsPrinter;

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  String text = 'Speak....';
  bool isListening = false;

/////////////////////
  ///
  ///

  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;

    _refreshInventoryList0();
    _fetchSales();
    display_list_l = [];
    display_list_p = [];
    _fetchQuickAdd();
  }

  final _formKeySupply = GlobalKey<FormState>();

  final _ctrlP1W = TextEditingController();
  final _ctrlP1Q = TextEditingController();

  final _ctrlP2W = TextEditingController();
  final _ctrlP2Q = TextEditingController();

  final _ctrlP3W = TextEditingController();
  final _ctrlP3Q = TextEditingController();

  // Inventory
  Inventory _inventory = Inventory();

  static List<Inventory> _inventorys = [];

  static List<Inventory> display_list1 = List.from(_inventorys);

  final _dbHelperE3 = InventoryOperation();

  bool loading = false;

  _refreshInventoryList0() async {
    loading = true;
    List<Inventory> k = await _dbHelperE3.fetchInventory();
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

    _refreshInventoryList(k);
  }

  List<Inventory> _inventoryListAll = [];

  List<Inventory> _inventoryListAllFilter0 = [];

  List<Inventory> _inventoryListAllFilter = [];

  _refreshInventoryList(List<Inventory> k) async {
    // List<Inventory> k = await _dbHelperE3.fetchInventory();
//display_list_p = k;
    setState(() {
      _inventoryListAll = k;
      loading = false;
      _lowInventoryList = k;

      //_nameMap();
    });

    //_sortListAlphabetically(_inventoryListAll);
    _filter(packingF);
    _totalInventoryValue();
    _sortListQty(_lowInventoryList, 'l-h');
  }

  List<Inventory> _lowInventoryList = [];

  double totalInventoryValue = 0;

  _totalInventoryValue() {
    double total = 0;
    for (var i in _inventoryListAll) {
      total += double.parse(i.sell!) * double.parse(i.qty!);
    }
    totalInventoryValue = total;
  }

  _sortListAlphabetically(List<Inventory> list) {
    list.sort((a, b) => a.productName!.compareTo(b.productName!));
  }

  _sortListQty(List<Inventory> list, String value) {
    if (value == 'l-h') {
      list.sort((a, b) => double.parse(a.qty!).compareTo(double.parse(b.qty!)));
    } else {
      list.sort((a, b) => double.parse(b.qty!).compareTo(double.parse(a.qty!)));
    }
  }

  static List<Inventory> display_list_p = [];

  static List<Inventory> display_list_l = [];

  // SEARCH BAR
  static List<Inventory> display_list = List.from(_inventorys);

  void updateList(String value) {
    setState(() {
      display_list1 = _inventorys
          .where((element) =>
              element.productName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _nameMap() {
    int xxx = 0;
    for (var i in display_list) {
      if (i.packing == 'p') {
        // print(xxx);

        String x = i.productName!;
        //print(x);
        //String y1 = x.substring(1, 2);

        String y = x.substring(0, x.length - 2);

        List z = y.split('}, ');
        List<String> ww = [];

        int listNumber1 = 0;

        for (var i in z) {
          //print('i');
          String zzz = i.substring(5, i.length);
          //print(zzz);
          //String zz = i.split(': ')[1];
          ww.add(zzz);
          listNumber1 += 1;
        }
        int p = 0;

        for (var i in ww) {
          List x = i.split(',');
          xxx += 1;

          List y = [];

          for (var c in x) {
            List s = c.split(': ');

            y.add(s[1]);

            // print(y);
          }
          productMap['$xxx'] = {
            'barcode': '${y[0]}',
            'productName': '${y[1]}',
            'qty': '${y[2]}',
            'buy': '${y[3]}',
            'sell': '${y[4]}',
            'weight': '${y[5]}',
            'doe': '${y[6]}',
          };
          //print(y);

          //print(x);
        }
        print(productMap);

        //print(ww);
      } else {
        //print('loose');

        String x = i.productName!;

        //String y1 = x.substring(1, 2);

        String y = x.substring(0, x.length - 2);

        List z = y.split('}, ');
        List<String> ww = [];

        int listNumber1 = 0;

        for (var i in z) {
          //print('i');
          String zzz = i.substring(5, i.length);
          //print(zzz);
          //String zz = i.split(': ')[1];
          ww.add(zzz);
          listNumber1 += 1;
        }
        int p = 0;

        for (var i in ww) {
          List x = i.split(',');
          xxx += 1;

          List y = [];

          for (var c in x) {
            List s = c.split(': ');

            y.add(s[1]);

            // print(y);
          }
          productMap['$xxx'] = {
            'barcode': '${y[0]}',
            'productName': '${y[1]}',
            'buy': '${y[2]}',
            'sell': '${y[3]}',
            'weight': '${y[4]}',
            'weightLoose': '${y[5]}',
            'p1W': '${y[6]}',
            'p1Q': '${y[7]}',
            'p1B': '${y[8]}',
            'p2W': '${y[9]}',
            'p2Q': '${y[10]}',
            'p2B': '${y[11]}',
            'p3W': '${y[12]}',
            'p3Q': '${y[13]}',
            'p3B': '${y[14]}',
          };
          //print(y);

          //print(x);
        }
      }
    }
    //print(display_list1.);
    globals.productMap = productMap;
  }

  bool showWidget = false;

  bool createPacket = false;

  Map<String, Map<String, String>> productMap = {};

  // create packet

  String lastBarcodeP1 = '';
  final _dbSupplierLoose = LooseOperation();
  Loose _loose = Loose();
  static List<Loose> _looses = [];

  _generateBarcodeP1() async {
    List<Loose> x = await _dbSupplierLoose.fetchLoose();
    lastBarcodeP1 = x.last.barcode!;

    print(x.last.barcode);

    if (createPacket) {
      _loose.name = '${display_list1[0].productName} - P1';
      _loose.barcode = (int.parse(lastBarcodeP1) + 1).toString();
      await _dbSupplierLoose.insertLoose(_loose);

      //print(lastBarcodeP1);
    } else {
      null;
    }
    _lastBarcodeP1();
  }

  _lastBarcodeP1() async {
    List<Loose> x = await _dbSupplierLoose.fetchLoose();

    //print('${x.last.name}, ${x.last.barcode}');
    if (createPacket) {
      P1B = int.parse(x.last.barcode!);
    } else {
      //_inventory.p1B = null;
    }
    print(P1B);
  }

  _showForEditInventory() {
    setState(() {
      _inventory = _inventoryss[0];
    });
  }

  static List<Inventory> _inventoryss = [];

  int P1W = 0;
  int P1Q = 0;
  int P1B = 0;

  _updateMap() {
    _inventory.weight =
        '${double.parse(display_list_l[indexSelected].weight!) - P1W * P1Q}';

    _submitl();
  }

  _submitl() async {
    await _dbHelperE3.updateInventory(_inventory);

    _submit11();
  }

  _submit11() {
    _submit();
  }

  _submit() {
    print('${display_list_l[indexSelected].productName} ${P1W} kg');
    _inventory.productName =
        '${display_list_l[indexSelected].productName} ${P1W} kg';
    _inventory.id = null;
    _inventory.barcode = '${P1B}';
    _inventory.weight = '${P1W}';
    _inventory.qty = '${P1Q}';

    _inventory.packing = 'p';

    _submit1();
  }

  _submit1() {
    //print(_inventory.productName);

    //print(_inventory.id);

    _dbHelperE3.insertInventory(_inventory);
    setState(() {});
    //_refreshInventoryList();
    display_list_l = [];
    display_list_p = [];

    _dddd();
  }

  _dddd() {
    _refreshInventoryList0();
    _ctrlP1Q.text = '';
    _ctrlP1W.text = '';

    P1B = 0;
    P1Q = 0;
    P1W = 0;
  }

  _showForEdit(index) {
    setState(() {
      _inventory = display_list_l[index];
    });
    print(display_list_l[index].productName);
    indexSelected = index;
  }

  int indexSelected = -1;
  int indexSelectedL = -1;

  bool _updateSellPrice = false;
  bool _updateSellPriceL = false;

  TextEditingController _ctrlPackedSell = TextEditingController();
  TextEditingController _ctrlPackedMrp = TextEditingController();
  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  TextEditingController _ctrlPackedSell1 = TextEditingController();
  TextEditingController _ctrlPackedMrp1 = TextEditingController();

  TextEditingController _ctrlSearch = TextEditingController();

  FocusNode _packedSell = FocusNode();
  FocusNode _packedMrp = FocusNode();

  FocusNode _search = FocusNode();

  String errorPackedSell = '';
  String errorPackedMrp = '';

  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  _resetUpdatePacked() {
    _updateSellPrice = false;
    _updateSellPriceL = false;

    _ctrlPackedSell.text = '';
    _ctrlPackedMrp.text = '';
    _ctrlPackedSell1.text = '';
    _ctrlPackedMrp1.text = '';
    setState(() {});
  }

  Widget Card(double height, double width, int index, BuildContext context) {
    return (indexSelected != index)
        ? Dismissible(
            key: Key(_inventoryListAllFilter[index].id.toString()),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                print('yes');

                if (indexSelected == index) {
                  indexSelected = -1;
                } else {
                  indexSelected = index;
                }

                _ctrlPackedSell1.text = _inventoryListAllFilter[index].sell!;
                _updateSellPrice = true;
              } else {
                bool yes = false;
                for (var i in _inventoryListQuickAdd) {
                  if (i.barcode == _inventoryListAllFilter[index].barcode) {
                    yes = true;
                  }
                }
                if (yes == false) {
                  _quickAdd.barcode = _inventoryListAllFilter[index].barcode!;
                  _quickAdd.productName =
                      _inventoryListAllFilter[index].productName!;
                  _dbHelperQ.insertQuickAdd(_quickAdd);

                  _quickAdd = QuickAdd();

                  _fetchQuickAdd();
                }
              }

              setState(() {});
              return await false;
            },
            // direction: DismissDirection.,

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
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20, left: 20),
              margin: EdgeInsets.only(bottom: 0, top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Update Selling Price',
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
              ),
            ),
            background: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 20, left: 20),
              margin: EdgeInsets.only(bottom: 0, top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Add to Quick Add',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
              ),
            ),
            child: InkWell(
              child: Container(
                height: height * 0.115,
                width: double.infinity,

                margin:
                    EdgeInsets.only(bottom: 0, top: 10, left: 10, right: 10),
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
                                text: '${_inventoryListAllFilter[index].qty}',
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

                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              //height: 40,
                              alignment: Alignment.centerLeft,
                              //color: const Color.fromRGBO(244, 244, 244, 1),
                              padding: const EdgeInsets.only(top: 5),

                              child: Text(
                                '${_inventoryListAllFilter[index].productName}',
                                style: TextStyle(
                                    fontFamily: 'Koulen',
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  width: double.infinity,
                                  //height: 40,
                                  // color: const Color.fromRGBO(
                                  //  244, 244, 244, 1),
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //barcode
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        height: double.infinity,
                                        margin: EdgeInsets.only(right: 10),
                                        child: RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'barcode ',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      92, 94, 98, 1),
                                                  fontSize: 14,
                                                  fontFamily: 'Koulen',
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${_inventoryListAllFilter[index].barcode}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontFamily: 'Koulen',
                                                ),
                                              ),
                                              TextSpan(
                                                text: ' ',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontFamily: 'Koulen',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //cost
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: double.infinity,
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'avg. cost  ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        92, 94, 98, 1),
                                                    fontSize: 14,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${double.parse(_inventoryListAllFilter[index].buy!).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
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
                                          alignment: Alignment.centerLeft,
                                          height: double.infinity,
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'mrp  ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        92, 94, 98, 1),
                                                    fontSize: 14,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${double.parse(_inventoryListAllFilter[index].mrp!).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      //sell
                                      Expanded(
                                        child: Container(
                                          height: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'price  ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        92, 94, 98, 1),
                                                    fontSize: 14,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${double.parse(_inventoryListAllFilter[index].sell!).toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        0, 134, 193, 1),
                                                    fontSize: 30,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      //discount
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: double.infinity,
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'discount  ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        92, 94, 98, 1),
                                                    fontSize: 12,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${((1 - (double.parse(_inventoryListAllFilter[index].sell!) / double.parse(_inventoryListAllFilter[index].mrp!))) * 100).toStringAsFixed(2)} %',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      //margin
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: double.infinity,
                                          child: RichText(
                                            text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'margin  ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        92, 94, 98, 1),
                                                    fontSize: 12,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${((1 - (double.parse(_inventoryListAllFilter[index].buy!) / double.parse(_inventoryListAllFilter[index].sell!))) * 100).toStringAsFixed(2)} %',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 30,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                              ],
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
              onTap: () {
                /* if (indexSelected == index) {
                  indexSelected = -1;
                } else {
                  indexSelected = index;
                }
                setState(() {});*/
              },
            ),
          )
        : (false)
            ? InkWell(
                child: Container(
                  // height: height * 0.14,
                  width: double.infinity,

                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  //padding: const EdgeInsets.only( top: 10),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.1,
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.08,
                              height: double.infinity,
                              //color: const Color.fromRGBO(244, 244, 244, 1),
                              margin: const EdgeInsets.only(right: 20),
                              child: Center(
                                child: Text(
                                  '${_inventoryListAllFilter[index].qty}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      //fontFamily: 'Koulen',
                                      fontSize: 40,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      //color: const Color.fromRGBO(244, 244, 244, 1),

                                      child: Text(
                                        '${_inventoryListAllFilter[index].productName}',
                                        style: TextStyle(
                                            fontFamily: 'BanglaBold',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: double.infinity,
                                                  child: Text(
                                                    '${_inventoryListAllFilter[index].barcode}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'BanglaBold',
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: double.infinity,
                                                  child: Text(
                                                    '${_inventoryListAllFilter[index].mrp}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'BanglaBold',
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${_inventoryListAllFilter[index].sell}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'BanglaBold',
                                                        fontSize: 18,
                                                        color: Colors.black),
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
                        width: double.infinity,
                        height: height * 0.04,
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 20, bottom: 5),
                        child: TextButton(
                          child: Text('Update Selling Price',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 72, 72, 73),
                                  fontSize: 13,
                                  fontFamily: 'Bangla',
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            setState(() {
                              // _ctrlPackedMrp1.text = _inventoryListAllFilter[index].buy!;
                              _ctrlPackedSell1.text =
                                  _inventoryListAllFilter[index].sell!;
                              _updateSellPrice = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (indexSelected == index) {
                    indexSelected = -1;
                  } else {
                    indexSelected = index;
                  }
                  setState(() {});
                },
              )
            : InkWell(
                child: Container(
                  // height: height * 0.14,
                  width: double.infinity,

                  margin:
                      EdgeInsets.only(bottom: 0, top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        // Color of the shadow
                        offset: Offset.zero, // Offset of the shadow
                        blurRadius: 6, // Spread or blur radius of the shadow
                        spreadRadius: 0, // How much the shadow should spread
                      )
                    ],
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  //padding: const EdgeInsets.only( top: 10),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.141,
                        child: Row(
                          children: [
                            Container(
                              //width: width * 0.08,
                              height: double.infinity,
                              //color: const Color.fromRGBO(244, 244, 244, 1),
                              margin:
                                  const EdgeInsets.only(right: 20, left: 20),
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
                                        text:
                                            '${_inventoryListAllFilter[index].qty}',
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
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      //height: 40,
                                      alignment: Alignment.centerLeft,
                                      //color: const Color.fromRGBO(244, 244, 244, 1),
                                      padding: const EdgeInsets.only(top: 5),

                                      child: Text(
                                        '${_inventoryListAllFilter[index].productName}',
                                        style: TextStyle(
                                            fontFamily: 'Koulen',
                                            fontSize: 20,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //barcode
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: double.infinity,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text: 'barcode ',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        92,
                                                                        94,
                                                                        98,
                                                                        1),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '${_inventoryListAllFilter[index].barcode}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' ',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 30,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: height * 0.022,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 0),
                                                      width: double.infinity,
                                                      //height: height * 0.05,
                                                      //color: Colors.black,
                                                      child: Text(
                                                        '',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Bangla',
                                                            fontSize: 13,
                                                            color:
                                                                Color.fromRGBO(
                                                                    139,
                                                                    0,
                                                                    0,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //cost
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: double.infinity,
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  'avg. cost  ',
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        92,
                                                                        94,
                                                                        98,
                                                                        1),
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '${double.parse(_inventoryListAllFilter[index].buy!).toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 24,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text: ' ',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 30,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: height * 0.022,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 0),
                                                      width: double.infinity,
                                                      //height: height * 0.05,
                                                      //color: Colors.black,
                                                      child: Text(
                                                        '',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Bangla',
                                                            fontSize: 13,
                                                            color:
                                                                Color.fromRGBO(
                                                                    139,
                                                                    0,
                                                                    0,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //mrp
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        width: double.infinity,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            style: DefaultTextStyle
                                                                    .of(context)
                                                                .style,
                                                            children: <
                                                                TextSpan>[
                                                              TextSpan(
                                                                text: 'mrp  ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          92,
                                                                          94,
                                                                          98,
                                                                          1),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    '${double.parse(_inventoryListAllFilter[index].mrp!).toStringAsFixed(2)}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 24,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: ' ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 30,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: height * 0.022,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0),
                                                        width: double.infinity,
                                                        //height: height * 0.05,
                                                        //color: Colors.black,
                                                        child: Text(
                                                          '',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bangla',
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromRGBO(139,
                                                                      0, 0, 1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              //sell

                                              Expanded(
                                                child: Container(
                                                  //alignment: Alignment.centerLeft,
                                                  //   height: height * 0.1,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: double
                                                                    .infinity,
                                                                width: 45,
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
                                                                            ' ',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              30,
                                                                          fontFamily:
                                                                              'Koulen',
                                                                        ),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            'price  ',
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              92,
                                                                              94,
                                                                              98,
                                                                              1),
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'Koulen',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: double
                                                                    .infinity,
                                                                //height: height * 0.048,
                                                                //width: 50,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                  width: width *
                                                                      0.08,
                                                                  height:
                                                                      height *
                                                                          0.048,
                                                                  //color: Colors.black,
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
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
                                                                        color: Colors
                                                                            .grey,
                                                                        // Color of the shadow
                                                                        offset:
                                                                            Offset.zero, // Offset of the shadow
                                                                        blurRadius:
                                                                            4, // Spread or blur radius of the shadow
                                                                        spreadRadius:
                                                                            0, // How much the shadow should spread
                                                                      )
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(3),
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            244,
                                                                            244,
                                                                            244,
                                                                            1),
                                                                  ),
                                                                  child:
                                                                      TextFormField(
                                                                    textAlignVertical:
                                                                        TextAlignVertical
                                                                            .bottom,
                                                                    readOnly:
                                                                        true, // Prevent system keyboard
                                                                    showCursor:
                                                                        false,
                                                                    focusNode:
                                                                        _packedSell,

                                                                    controller: _ctrlPackedSell.text.length ==
                                                                            0
                                                                        ? _ctrlPackedSell1
                                                                        : _ctrlPackedSell,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              134,
                                                                              193,
                                                                              1),
                                                                      fontSize:
                                                                          30,
                                                                      fontFamily:
                                                                          'Koulen',
                                                                    ),
                                                                    cursorColor:
                                                                        Colors
                                                                            .black,

                                                                    //enabled: !lock,

                                                                    decoration:
                                                                        const InputDecoration(
                                                                      //prefixIcon: Icon(Icons.person),
                                                                      //prefixIconColor: Colors.black,
                                                                      enabledBorder:
                                                                          UnderlineInputBorder(
                                                                              borderSide: BorderSide.none),

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
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: height * 0.022,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0),
                                                        width: double.infinity,
                                                        //height: height * 0.05,
                                                        //color: Colors.black,
                                                        child: Text(
                                                          errorPackedSell,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bangla',
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromRGBO(139,
                                                                      0, 0, 1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              /*   Expanded(
                                                child: Container(
                                                  //alignment: Alignment.centerLeft,
                                                  //   height: height * 0.1,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        //height: height * 0.048,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          width: width * 0.06,
                                                          height:
                                                              height * 0.048,
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
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            color:
                                                                Color.fromRGBO(
                                                                    244,
                                                                    244,
                                                                    244,
                                                                    1),
                                                          ),
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _packedSell,

                                                            controller: _ctrlPackedSell
                                                                        .text
                                                                        .length ==
                                                                    0
                                                                ? _ctrlPackedSell1
                                                                : _ctrlPackedSell,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'BanglaBold',
                                                                fontSize: 16),
                                                            cursorColor:
                                                                Colors.black,

                                                            //enabled: !lock,

                                                            decoration:
                                                                const InputDecoration(
                                                              //prefixIcon: Icon(Icons.person),
                                                              //prefixIconColor: Colors.black,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),

                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),

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
                                                            validator: (val) =>

                                                                // ignore: prefer_is_empty
                                                                (val!.length ==
                                                                        0
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
                                                      ),
                                                      Container(
                                                        height: height * 0.022,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0),
                                                        width: double.infinity,
                                                        //height: height * 0.05,
                                                        //color: Colors.black,
                                                        child: Text(
                                                          errorPackedSell,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bangla',
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromRGBO(139,
                                                                      0, 0, 1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
*/
                                              //weight
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
                          width: double.infinity,
                          height: height * 0.04,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 20, bottom: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)))),
                              onPressed: () async {
                                if (_ctrlPackedSell.text == '') {
                                  if (_ctrlPackedSell.text == '') {
                                    errorPackedSell = 'Invalid';
                                  }
                                  setState(() {});
                                } else {
                                  _inventory = _inventoryListAllFilter[index];

                                  _inventory.sell = _ctrlPackedSell.text;
                                  await _dbHelperE3.updateInventory(_inventory);
                                  _refreshInventoryList0();
                                  _updateSellPrice = false;
                                  _inventoryListAllFilter = [];

                                  indexSelected = -1;

                                  _resetUpdatePacked();
                                }
                              },
                              child: Text('Update',
                                  style: TextStyle(
                                      fontFamily: 'BanglaBold',
                                      fontSize: 14,
                                      color: Colors.white))))
                    ],
                  ),
                ),
                onTap: () {
                  if (indexSelected == index) {
                    indexSelected = -1;

                    _resetUpdatePacked();
                  } else {
                    indexSelected = index;
                  }
                  setState(() {});
                },
              );
  }

  String packedMrp = '';
  String packedSell = '';

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

    // mrp

    if (_packedMrp.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorPackedMrp = 'Invalid';
      } else {
        errorPackedMrp = '';
      }
    } else {
      errorPackedMrp = '';
    }

    // sell

    if (_packedSell.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorPackedSell = 'Invalid';
      } else {
        errorPackedSell = '';
      }
    } else {
      errorPackedSell = '';
    }

    if (_search.hasFocus) {
      _updateSearchResults(controller.text.toLowerCase());

      //updateList(_ctrlSearch.text);
    }

    // Update the screen
    setState(() {});
  }

  List<Inventory> filterProduct(String searchText) {
    return _inventoryListAllFilter0.where((x) {
      final productNameMatches =
          x.productName!.toLowerCase().contains(searchText.toLowerCase());

      final barcodeMatches = x.barcode!.contains(searchText);
      return productNameMatches || barcodeMatches;
    }).toList();
  }

  void _updateSearchResults(String searchText) {
    setState(() {
      _inventoryListAllFilter = filterProduct(searchText);
    });
  }

  Widget CardL(double height, double width, int index, BuildContext context) {
    return (indexSelectedL != index)
        ? InkWell(
            child: Container(
              height: height * 0.1,
              width: double.infinity,

              margin: EdgeInsets.only(bottom: 10, top: 0, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
              ),
              //padding: const EdgeInsets.only( top: 10),
              child: Row(
                children: [
                  Container(
                    width: width * 0.08,
                    height: double.infinity,
                    //color: const Color.fromRGBO(244, 244, 244, 1),
                    margin: const EdgeInsets.only(right: 30, left: 15),
                    child: Center(
                      child: Text(
                        '${display_list_l[index].qty}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'BanglaBold',
                            fontSize: 30,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            //color: const Color.fromRGBO(244, 244, 244, 1),

                            child: Text(
                              '${display_list_l[index].productName}',
                              style: TextStyle(
                                  fontFamily: 'BanglaBold',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                                        alignment: Alignment.centerLeft,
                                        height: double.infinity,
                                        child: Text(
                                          '${display_list_l[index].barcode}',
                                          style: TextStyle(
                                              fontFamily: 'Bangla',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        height: double.infinity,
                                        child: Text(
                                          '${display_list_l[index].buy}',
                                          style: TextStyle(
                                              fontFamily: 'Bangla',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${display_list_l[index].sell}',
                                          style: TextStyle(
                                              fontFamily: 'Bangla',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black),
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
            onTap: () {
              if (indexSelectedL == index) {
                indexSelectedL = -1;
              } else {
                indexSelectedL = index;
              }
              setState(() {});
            },
          )
        : (_updateSellPriceL == false)
            ? InkWell(
                child: Container(
                  // height: height * 0.14,
                  width: double.infinity,

                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  //padding: const EdgeInsets.only( top: 10),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.1,
                        width: double.infinity,

                        margin: EdgeInsets.only(
                            bottom: 10, top: 0, left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                        ),
                        //padding: const EdgeInsets.only( top: 10),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.08,
                              height: double.infinity,
                              //color: const Color.fromRGBO(244, 244, 244, 1),
                              margin:
                                  const EdgeInsets.only(right: 30, left: 15),
                              child: Center(
                                child: Text(
                                  '${display_list_l[index].weight}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'BanglaBold',
                                      fontSize: 30,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      //color: const Color.fromRGBO(244, 244, 244, 1),

                                      child: Text(
                                        '${display_list_l[index].productName}',
                                        style: TextStyle(
                                            fontFamily: 'BanglaBold',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: double.infinity,
                                                  child: Text(
                                                    '${display_list_l[index].barcode}',
                                                    style: TextStyle(
                                                        fontFamily: 'Bangla',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: double.infinity,
                                                  child: Text(
                                                    '${display_list_l[index].buy}',
                                                    style: TextStyle(
                                                        fontFamily: 'Bangla',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${display_list_l[index].sell}',
                                                    style: TextStyle(
                                                        fontFamily: 'Bangla',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.black),
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
                        width: double.infinity,
                        height: height * 0.04,
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 20, bottom: 5),
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Container(
                              width: width * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black),
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.center,
                              child: TextButton(
                                child: Text('Update Price',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontFamily: 'BanglaBold',
                                      // fontWeight: FontWeight.bold
                                    )),
                                onPressed: () {
                                  setState(() {
                                    _ctrlPackedMrp1.text =
                                        display_list_l[index].buy!;
                                    _ctrlPackedSell1.text =
                                        display_list_l[index].sell!;
                                    _updateSellPriceL = true;
                                  });
                                },
                              ),
                            ),
                            /*  Container(
                              width: width * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black
                              ),
                              margin: EdgeInsets.only(right: 10),
                              alignment: Alignment.center,
                              child: TextButton(
                                
                                child: Text('Create Packet',
                                textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'BanglaBold',
                                       // fontWeight: FontWeight.bold
                                        )),
                                onPressed: () {
                                  setState(() {
                                    _ctrlPackedMrp1.text = display_list_p[index].buy!;
                                    _ctrlPackedSell1.text =
                                        display_list_p[index].sell!;
                                    _updateSellPrice = true;
                                  });
                                },
                              ),
                            ),*/
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (indexSelectedL == index) {
                    indexSelectedL = -1;
                  } else {
                    indexSelectedL = index;
                  }
                  setState(() {});
                },
              )
            : InkWell(
                child: Container(
                  // height: height * 0.14,
                  width: double.infinity,

                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  //padding: const EdgeInsets.only( top: 10),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.14,
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.08,
                              height: double.infinity,
                              //color: const Color.fromRGBO(244, 244, 244, 1),
                              margin:
                                  const EdgeInsets.only(right: 30, left: 15),
                              child: Center(
                                child: Text(
                                  '${display_list_l[index].weight}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'BanglaBold',
                                      fontSize: 30,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      //color: const Color.fromRGBO(244, 244, 244, 1),

                                      child: Text(
                                        '${display_list_l[index].productName}',
                                        style: TextStyle(
                                            fontFamily: 'BanglaBold',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //barcode
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: height * 0.048,
                                                      width: double.infinity,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '${display_list_l[index].barcode}',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Bangla',
                                                            fontSize: 18,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: height * 0.022,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 0,
                                                              left: 0,
                                                              right: 0,
                                                              bottom: 0),
                                                      width: double.infinity,
                                                      //height: height * 0.05,
                                                      //color: Colors.black,
                                                      child: Text(
                                                        '',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Bangla',
                                                            fontSize: 13,
                                                            color:
                                                                Color.fromRGBO(
                                                                    139,
                                                                    0,
                                                                    0,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              //mrp
                                              Expanded(
                                                child: Container(
                                                  //alignment: Alignment.centerLeft,
                                                  //   height: height * 0.1,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        //height: height * 0.048,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          width: width * 0.06,
                                                          height:
                                                              height * 0.048,
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
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            color:
                                                                Color.fromRGBO(
                                                                    244,
                                                                    244,
                                                                    244,
                                                                    1),
                                                          ),
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _packedMrp,

                                                            controller: (_ctrlPackedMrp
                                                                        .text
                                                                        .length ==
                                                                    0)
                                                                ? _ctrlPackedMrp1
                                                                : _ctrlPackedMrp,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'BanglaBold',
                                                                fontSize: 16),
                                                            cursorColor:
                                                                Colors.black,

                                                            //enabled: !lock,

                                                            decoration:
                                                                const InputDecoration(
                                                              //prefixIcon: Icon(Icons.person),
                                                              //prefixIconColor: Colors.black,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),

                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),

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
                                                            validator: (val) =>

                                                                // ignore: prefer_is_empty
                                                                (val!.length ==
                                                                        0
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
                                                      ),
                                                      Container(
                                                        height: height * 0.022,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0),
                                                        width: double.infinity,
                                                        child: Text(
                                                          errorPackedMrp,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bangla',
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromRGBO(139,
                                                                      0, 0, 1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              //sell
                                              Expanded(
                                                child: Container(
                                                  //alignment: Alignment.centerLeft,
                                                  //   height: height * 0.1,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        //height: height * 0.048,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Container(
                                                          width: width * 0.06,
                                                          height:
                                                              height * 0.048,
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
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            color:
                                                                Color.fromRGBO(
                                                                    244,
                                                                    244,
                                                                    244,
                                                                    1),
                                                          ),
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _packedSell,

                                                            controller: _ctrlPackedSell
                                                                        .text
                                                                        .length ==
                                                                    0
                                                                ? _ctrlPackedSell1
                                                                : _ctrlPackedSell,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'BanglaBold',
                                                                fontSize: 16),
                                                            cursorColor:
                                                                Colors.black,

                                                            //enabled: !lock,

                                                            decoration:
                                                                const InputDecoration(
                                                              //prefixIcon: Icon(Icons.person),
                                                              //prefixIconColor: Colors.black,
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),

                                                              focusedBorder:
                                                                  UnderlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide
                                                                              .none),

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
                                                            validator: (val) =>

                                                                // ignore: prefer_is_empty
                                                                (val!.length ==
                                                                        0
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
                                                      ),
                                                      Container(
                                                        height: height * 0.022,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0),
                                                        width: double.infinity,
                                                        //height: height * 0.05,
                                                        //color: Colors.black,
                                                        child: Text(
                                                          errorPackedSell,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Bangla',
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromRGBO(139,
                                                                      0, 0, 1),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
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
                          width: double.infinity,
                          height: height * 0.04,
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(right: 20, bottom: 5),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)))),
                              onPressed: () async {
                                if (_ctrlPackedMrp.text == '' ||
                                    _ctrlPackedSell.text == '') {
                                  if (_ctrlPackedMrp.text == '') {
                                    errorPackedMrp = 'Invalid';
                                  }
                                  if (_ctrlPackedSell.text == '') {
                                    errorPackedSell = 'Invalid';
                                  }
                                  setState(() {});
                                } else {
                                  _inventory = display_list_l[index];
                                  _inventory.buy = _ctrlPackedMrp.text;
                                  _inventory.sell = _ctrlPackedSell.text;
                                  await _dbHelperE3.updateInventory(_inventory);
                                  _refreshInventoryList0();
                                  _updateSellPriceL = false;
                                  display_list_l = [];

                                  _resetUpdatePacked();
                                }
                              },
                              child: Text('Update',
                                  style: TextStyle(
                                      fontFamily: 'BanglaBold',
                                      fontSize: 14,
                                      color: Colors.white))))
                    ],
                  ),
                ),
                onTap: () {
                  if (indexSelectedL == index) {
                    indexSelectedL = -1;

                    _resetUpdatePacked();
                  } else {
                    indexSelectedL = index;
                  }
                  setState(() {});
                },
              );
  }

  String packingF = 'p';
  String qtyF = 'l-h';

  _filter(
    String packing1,
  ) {
    packingF = packing1;

    List<Inventory> x = [];

    for (var i in _inventoryListAll) {
      if ((packing1 != ''
          ? i.packing!.toLowerCase() == packing1.toLowerCase()
          : true)) {
        x.add(i);
      }
    }

    // _date(x);

    _inventoryListAllFilter0 = x;

    _inventoryListAllFilter = x;

    _sortListQty(_inventoryListAllFilter, qtyF);

    // print(x);

    setState(() {});
  }

  bool filter = false;

  //// inventory report print

  _printOrder(double height, double width, bool print) async {
    // Map<String, Map<String, String>> produc = await _returnMap(index);

    //producX = produc;

    //orderXXXX(height, width, index);

    screenshotController
        .captureFromWidget(orderXXXX(height, width),
            //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

            delay: Duration(seconds: 1),
            targetSize: Size(
                380,
                //fixed= 390, card =
                (580 +
                    30 +
                    (50 * (_inventoryListAllFilter.length * 1.4)).toDouble())))
        .then((capturedImage) {
      printCapturedImage(capturedImage);
      // Handle captured image
    });
  }

  Widget orderXXXX(double height, double width) {
    double totalPrice = 0;

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
              '${globalsPrinter.storeName}',
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
              '${globalsPrinter.storePhone}',
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
              '${globalsPrinter.storeAddress.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),

          Container(
            width: double.infinity,
            //height: 65,

            // color: Colors.black,
            margin: EdgeInsets.only(bottom: 0, top: 10),
            child: Text(
              'Inventory Report',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, color: Colors.black, fontFamily: 'Koulen'),
            ),
          ),

          Container(
            width: double.infinity,
            //height: 65,

            // color: Colors.black,
            margin: EdgeInsets.only(bottom: 10, top: 0),
            child: Text(
              packingF == 'p' ? '(Packaged)' : '(Loose)',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25, color: Colors.black, fontFamily: 'Koulen'),
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
                              alignment: Alignment.centerLeft,
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
                        //disc
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: double.infinity,
                              child: Text(
                                'COST',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    //fontFamily: 'Koulen',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
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
                        Expanded(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              height: double.infinity,
                              child: Text(
                                'PRICE',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    //fontFamily: 'Koulen',
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    )),
              ],
            ),
          ),

          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0, left: 4, right: 4),

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

          // cardCart(height, width, 1, context),
          Expanded(
            child: Container(
              width: double.infinity,
              margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: ListView.builder(
                  itemCount: _inventoryListAllFilter.length,
                  //cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_inventoryListAllFilter.isNotEmpty) {
                      return cardPrintOrder(height, width, index, context);
                    } else {
                      return const Text('Select Supplier');
                    }
                  }),
            ),
          ),

          Container(
            //height: height * 0.04,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, left: 4, right: 4),

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

          //Thank you
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 0, left: 4, right: 5),
              margin: const EdgeInsets.only(top: 10, right: 0),
              child: Text(
                'Total Products: ${_inventoryListAllFilter.length}',
                style: TextStyle(
                  //color: Color.fromRGBO(92, 94, 98, 1),
                  color: Colors.black,
                  fontSize: 25,
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

  ScreenshotController screenshotController = ScreenshotController();

  Future<void> printCapturedImage(Uint8List jpegBytes) async {
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

  Widget cardPrintOrder(
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
                        '${_inventoryListAllFilter[index].productName!.toUpperCase()}',
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
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${double.parse(_inventoryListAllFilter[index].qty!).toStringAsFixed(2)}',
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

                  //offer price
                  Expanded(
                    child: Container(
                      // width: width * 0.14,
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${double.parse(_inventoryListAllFilter[index].buy!).toStringAsFixed(2)}',
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

                  //mrp
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${double.parse(_inventoryListAllFilter[index].mrp!).toStringAsFixed(2)}',
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

                  //offer price
                  Expanded(
                    child: Container(
                      // width: width * 0.14,
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  '${double.parse(_inventoryListAllFilter[index].sell!).toStringAsFixed(2)}',
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

  bool dashboard = true;

  Widget CardInventory(
      double height, double width, int index, BuildContext context) {
    return InkWell(
      child: Container(
        //height: height * 0.05,
        width: double.infinity,

        margin: const EdgeInsets.only(top: 10, bottom: 0, left: 5, right: 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Color of the shadow
                offset: Offset.zero, // Offset of the shadow
                blurRadius: 6, // Spread or blur radius of the shadow
                spreadRadius: 0, // How much the shadow should spread
              )
            ]),
        padding: const EdgeInsets.only(top: 0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                //height: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '${_lowInventoryList[index].productName}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 120, 174, 1),
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
              //width: width * 0.08,
              // height: double.infinity,

              //color: const Color.fromRGBO(244, 244, 244, 1),
              margin: const EdgeInsets.only(
                right: 20,
              ),

              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'QTY  ',
                        style: TextStyle(
                          color: Color.fromRGBO(92, 94, 98, 1),
                          fontSize: 12,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text:
                            '${double.parse(_lowInventoryList[index].qty!).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
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
      ),
      onTap: () {},
    );
  }

  String packaging = '';

  String supplierF = '';
  String packingFx = '';
  String dateF = 'week';
  String statusF = '';

  String customOrderF = '';

  List<Sales> _salesAll0 = [];
  final _dbHelperSales = SalesOperation();

  List<Sales> _salesAll = [];

  _fetchSales() async {
    loading = true;
    List<Sales> x = await _dbHelperSales.fetchSales();
    loading = false;
    setState(() {});
    //List<SalesTransaction> t = await _dbHelperT.fetchSalesTransaction();
    if (!mounted) return;
    setState(() {
      _salesAll0 = x;
    });
    // await _dbHelperT.deleteSalesTransaction(t.last.id!);

    _filterx(supplierF, packingF, dateF, statusF, customOrderF);
  }

  _filterx(String supplier1, String packing1, String date1, String status1,
      String customOrder1) {
    supplierF = supplier1;
    packingFx = packing1;
    dateF = date1;
    statusF = status1;
    customOrderF = customOrder1;

    List<Sales> x = [];

    productMa1 = {};

    _salesAll = [];

    for (var i in _salesAll0) {
      print(i.date);
      if ((date1 != ''
          ? (date1 == 'today'
              ? (_today(i.date!))
              : date1 == 'yesterday'
                  ? (_yesterday(i.date!))
                  : date1 == 'week'
                      ? (_week(i.date!))
                      : date1 == '1month'
                          ? (_month(i.date!))
                          : date1 == '6month'
                              ? (_6month(i.date!))
                              : date1 == '1year'
                                  ? (_year(i.date!))
                                  : true)
          : true)) {
        x.add(i);
      }
    }

    _salesAll = x;
    //_mapToListSales();

    _grid();
    setState(() {});
    //  _totalSales();
  }

  Map<String, Map<String, String>> productMa1 = {};

  String formatDate(String inputDate) {
    final dateParts = inputDate.split('/');

    if (dateParts.length != 3) {
      return inputDate; // Return original input if not in expected format
    }

    final day = dateParts[0];
    final month = dateParts[1];
    final year = dateParts[2];

    final dateTime =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    final formattedDate = DateFormat('dd MMMM yyyy', 'en_US').format(dateTime);

    return formattedDate;
  }

  _today(String date) {
    //return true;

    return _parseDateTime(
        '${DateFormat('yyyy-MM-dd').format(DateTime.parse(date.trim())).toString()} 00:00:00.000000',
        1);
  }

  _yesterday(String date) {
    return _parseDateTimeYesterday(
        '${DateFormat('yyyy-MM-dd').format(DateTime.parse(date.trim())).toString()} 00:00:00.000000',
        2);
  }

  _week(String date) {
    return _parseDateTime(
        '${DateFormat('yyyy-MM-dd').format(DateTime.parse(date.trim())).toString()} 00:00:00.000000',
        7);
  }

  _month(String date) {
    return _parseDateTime(
        '${DateFormat('yyyy-MM-dd').format(DateTime.parse(date.trim())).toString()} 00:00:00.000000',
        30);
  }

  _6month(String date) {
    return _parseDateTime(
        '${DateFormat('yyyy-MM-dd').format(DateTime.parse(date.trim())).toString()} 00:00:00.000000',
        30 * 6);
  }

  _year(String date) {
    return _parseDateTime(
        '${DateFormat('yyyy-MM-dd').format(DateTime.parse(date.trim())).toString()} 00:00:00.000000',
        30 * 12);
  }

  bool _parseDateTime(String date, int duration) {
    DateTime x = DateTime.parse(date);
    if (x.isAfter(DateTime.parse(
        '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: duration)))} 00:00:00.000000'))) {
      return true;
    } else {
      return false;
    }
  }

  bool _parseDateTimeYesterday(String date, int duration) {
    DateTime x = DateTime.parse(date);
    if (x.isAfter(DateTime.parse(
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: duration)))} 00:00:00.000000')) &&
        x.isBefore(DateTime.parse(
            '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'))) {
      return true;
    } else {
      return false;
    }
  }

  Widget Cardx(double height, double width, int index, BuildContext context) {
    return InkWell(
      child: Container(
        //height: height * 0.05,
        width: double.infinity,

        margin: EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Color of the shadow
                offset: Offset.zero, // Offset of the shadow
                blurRadius: 6, // Spread or blur radius of the shadow
                spreadRadius: 0, // How much the shadow should spread
              )
            ]),
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Expanded(
              child: Container(
                //height: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '${profitProduct[index].key}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 120, 174, 1),
                          fontSize: 28,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              //width: width * 0.08,
              // height: double.infinity,

              //color: const Color.fromRGBO(244, 244, 244, 1),
              margin: const EdgeInsets.only(
                right: 20,
              ),

              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'QTY  ',
                        style: TextStyle(
                          color: Color.fromRGBO(92, 94, 98, 1),
                          fontSize: 14,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: '${profitProduct[index].value['qtySold']}',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 120, 174, 1),
                          fontSize: 28,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              //width: width * 0.08,
              // height: double.infinity,

              //color: const Color.fromRGBO(244, 244, 244, 1),
              margin: const EdgeInsets.only(
                right: 20,
              ),

              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Profit  ',
                        style: TextStyle(
                          color: Color.fromRGBO(92, 94, 98, 1),
                          fontSize: 14,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: profitProduct[index]
                                .value['totalProfit']
                                .toString()
                                .split('.')
                                .toList()[0] +
                            ' \u{20B9}',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 120, 174, 1),
                          fontSize: 28,
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
      ),
      onTap: () {},
    );
  }

  ///////dashboard

  List<Inventory> productsSold = [];

  List<MapEntry<String, Map<String, dynamic>>> profitProduct = [];

  double totalRevenue = 0;
  double totalProfit = 0;
  double receievedPayments = 0;
  double pendingPayments = 0;
  double totalOrders = 0;
  double orderSize = 0;
  double totalPrductSold = 0;
  double homeDelivery = 0;
  int totalCustomers = 0;
  int regularCustomers = 0;

  _grid() {
    double totalRevenue1 = 0;
    double totalProfit1 = 0;
    double receievedPayments1 = 0;
    double pendingPayments1 = 0;
    double totalOrders1 = 0;
    double orderSize1 = 0;
    double totalPrductSold1 = 0;
    double homeDelivery1 = 0;
    List<String> totalCustomers1 = [];
    List<String> regularCustomers1 = [];
    Map<int, Map<String, dynamic>> productMapAll = {};

    int count = 0;

    for (var i in _salesAll) {
      receievedPayments1 = receievedPayments1 + double.parse(i.paidAmount!);

      String? jsonString = i.productName;

      Map<String, dynamic>? stringMap;

      if (jsonString != null) {
        stringMap = json.decode(jsonString);
      } else {
        // Handle the case when jsonString is null, e.g., provide a default value or show an error message.
      }

      Map<String, Map<String, String>> productMa = {};
      if (stringMap != null) {
        stringMap.forEach((key, value) {
          productMa[key] = Map<String, String>.from(value);
        });
      }

      productMa1 = productMa;

      double totalMrp = 0;
      double totalAmount = 0;
      double totalBuy = 0;

      Map<int, Map<String, String>> productMapInt = {};

      for (var i in productMa1.entries) {
        totalAmount = totalAmount +
            double.parse(i.value['price']!) * double.parse(i.value['qty']!);

        totalMrp = totalMrp +
            double.parse(i.value['mrp']!) * double.parse(i.value['qty']!);

        totalBuy = totalBuy +
            double.parse(i.value['buy']!) * double.parse(i.value['qty']!);

        totalPrductSold1 = totalPrductSold1 + double.parse(i.value['qty']!);

        count = count + 1;

        productMapInt[count] = i.value;

        // print(count);
        // print(i.value);
      }
      //print(productMapInt);
      productMapAll.addEntries(productMapInt.entries);

      totalRevenue1 = totalRevenue1 + totalAmount;

      totalProfit1 = totalProfit1 + (totalAmount - totalBuy);

      totalOrders1 = totalOrders1 + 1;

      if (i.deliveryMode == 'home') {
        homeDelivery1 = homeDelivery1 + 1;
      }

      totalCustomers1.add(i.customerNumber!);

      if (i.customerNumber != '1') {
        regularCustomers1.add(i.customerNumber!);
      }
    }

    Map<String, Map<String, dynamic>> productInfo = {};

    productMapAll.forEach((key, product) {
      String productName = product["productName"];
      double price = double.tryParse(product["price"]) ?? 0.0;
      double buy = double.tryParse(product["buy"]) ?? 0.0;
      int qty = int.tryParse(product["qty"]) ?? 0;

      double profit = (price - buy) * qty;

      if (!productInfo.containsKey(productName)) {
        productInfo[productName] = {
          "qtySold": qty,
          "totalProfit": profit,
        };
      } else {
        productInfo[productName]!["qtySold"] += qty;
        productInfo[productName]!["totalProfit"] += profit;
      }
    });

    // Convert the map to a list for sorting
    List<MapEntry<String, Map<String, dynamic>>> productList =
        productInfo.entries.toList();

    // Sort the list by profitability in descending order
    productList.sort(
        (a, b) => b.value["totalProfit"].compareTo(a.value["totalProfit"]));

    // Print the sorted list of products with quantity sold and total profit
    productList.forEach((entry) {
      print(
          "${entry.key}: Quantity Sold = ${entry.value["qtySold"]}, Total Profit = ${entry.value["totalProfit"]}");
    });

    profitProduct = productList;

    ///

    List<String> resultList = [];
    Set<String> seen = Set();

    for (String item in totalCustomers1) {
      if (item == "1" || !seen.contains(item)) {
        resultList.add(item);
        seen.add(item);
      }
    }

    List<String> resultListRegistered = regularCustomers1.toSet().toList();

    //print(receievedPayments1);
    totalRevenue = totalRevenue1;
    totalProfit = totalProfit1;
    receievedPayments = receievedPayments1;
    pendingPayments = totalRevenue - receievedPayments;
    totalOrders = totalOrders1;
    orderSize = totalRevenue / totalOrders;
    totalPrductSold = totalPrductSold1;
    homeDelivery = homeDelivery1;
    totalCustomers = resultList.length;
    regularCustomers = resultListRegistered.length;
    print(resultList);
    //print(filteredList);
    setState(() {});
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
    setState(() {});
  }

  Widget CardQuickAdd(
      double height, double width, int index, BuildContext context) {
    return Dismissible(
      key: Key(_inventoryListQuickAdd[index].id.toString()),
      confirmDismiss: (direction) async {
        //_quickAdd = _inventoryListAllFilter[index];
        for (var i in _quickAddList) {
          if (_inventoryListQuickAdd[index].barcode == i.barcode) {
            _quickAdd = i;
          }
        }
        // _quickAdd = _inventoryListQuickAdd[index];
        _dbHelperQ.deleteQuickAdd(_quickAdd.id!);

        _inventoryListQuickAdd.removeAt(index);

        _fetchQuickAdd();

        _quickAdd = QuickAdd();

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
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 0, top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(5)),
        child: Text(
          'Remove',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontFamily: 'Koulen'),
        ),
      ),
      child: InkWell(
        child: Container(
          height: height * 0.115,
          width: double.infinity,

          margin: EdgeInsets.only(bottom: 0, top: 10, left: 10, right: 10),
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

                  child: Column(
                    children: [
                      Container(
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
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            //height: 40,
                            // color: const Color.fromRGBO(
                            //  244, 244, 244, 1),
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //barcode
                                Container(
                                  alignment: Alignment.centerLeft,
                                  height: double.infinity,
                                  margin: EdgeInsets.only(right: 10),
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'barcode ',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(92, 94, 98, 1),
                                            fontSize: 14,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${_inventoryListQuickAdd[index].barcode}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontFamily: 'Koulen',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //cost
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: double.infinity,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'avg. cost  ',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(92, 94, 98, 1),
                                              fontSize: 14,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${double.parse(_inventoryListQuickAdd[index].buy!).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
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
                                    alignment: Alignment.centerLeft,
                                    height: double.infinity,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'mrp  ',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(92, 94, 98, 1),
                                              fontSize: 14,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${double.parse(_inventoryListQuickAdd[index].mrp!).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //sell
                                Expanded(
                                  child: Container(
                                    height: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'price  ',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(92, 94, 98, 1),
                                              fontSize: 14,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${double.parse(_inventoryListQuickAdd[index].sell!).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  0, 134, 193, 1),
                                              fontSize: 30,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                //discount
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: double.infinity,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'discount  ',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(92, 94, 98, 1),
                                              fontSize: 12,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${((1 - (double.parse(_inventoryListQuickAdd[index].sell!) / double.parse(_inventoryListQuickAdd[index].mrp!))) * 100).toStringAsFixed(2)} %',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                //margin
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: double.infinity,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'margin  ',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(92, 94, 98, 1),
                                              fontSize: 12,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '${((1 - (double.parse(_inventoryListQuickAdd[index].buy!) / double.parse(_inventoryListQuickAdd[index].sell!))) * 100).toStringAsFixed(2)} %',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                        ],
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
          color: Color.fromRGBO(244, 244, 244, 1),
          child: Row(
            children: [
              Container(
                width: width * 0.22,
                height: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey, // Color of the shadow
                        offset: Offset(0, 2), // Offset of the shadow
                        blurRadius: 6, // Spread or blur radius of the shadow
                        spreadRadius: 0, // How much the shadow should spread
                      ),
                    ],
                    //  color: _selectedIndex != index ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      //bottomRight: Radius.circular(4),
                    ),
                    //BorderRadius.circular(4),
                    color: Colors.black),
                margin: EdgeInsets.only(bottom: 0, right: 0, left: 0, top: 5),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.transparent),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Text(
                        'Total Products Available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 0),
                      child: Text(
                        _inventoryListAll.length.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.transparent),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: Text(
                        'Total Inventory Value',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: height * 0.05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 0),
                      child: Text(
                        totalInventoryValue.toStringAsFixed(2) + ' \u{20B9}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 64, 177, 68),
                          fontSize: 23,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.black,
                      margin: EdgeInsets.only(left: 5, right: 5, top: 60),
                    ),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: dashboard
                                ? Color.fromRGBO(38, 40, 40, 1)
                                : Colors.transparent),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: Text(
                          'Dashboard',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Koulen',
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          dashboard = true;
                          quickAdd = false;
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: !showWidget && !dashboard && !quickAdd
                                ? Color.fromRGBO(38, 40, 40, 1)
                                : Colors.transparent),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                        child: Text(
                          'Packaged',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Koulen',
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          dashboard = false;
                          showWidget = false;
                          quickAdd = false;

                          _filter('p');
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: showWidget && !dashboard && !quickAdd
                                ? Color.fromRGBO(38, 40, 40, 1)
                                : Colors.transparent),
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                        alignment: Alignment.center,
                        child: Text(
                          'Loose',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Koulen',
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          dashboard = false;
                          showWidget = true;
                          quickAdd = false;

                          _filter('l');
                        });
                      },
                    ),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: quickAdd
                                ? Color.fromRGBO(38, 40, 40, 1)
                                : Colors.transparent),
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                        alignment: Alignment.center,
                        child: Text(
                          '***Quick Add***',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Koulen',
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          dashboard = false;
                          // showWidget = false;
                          quickAdd = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      if (!dashboard && !quickAdd)
                        Container(
                          width: double.infinity,
                          height: height * 0.075,
                          //color: Colors.black,
                          margin: EdgeInsets.only(
                            bottom: 5,
                          ),

                          child: Row(
                            children: [
                              //packaging
                              /*    Container(
                              height: double.infinity,
                              width: width * 0.2,
                              margin: EdgeInsets.only(left: 10, right: 0),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    // height: height * 0.03,
                                    alignment: Alignment.centerLeft,
                                    //margin: EdgeInsets.only(bottom: 5),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Packaging',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(92, 94, 98, 1),
                                              fontSize: 12,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      //height: height * 0.06,
                                      decoration: BoxDecoration(),
                                      child: Row(
                                        children: [
                                          InkWell(
                                              child: Container(
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
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: showWidget ==
                                                                  false
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
                                                      color: showWidget == false
                                                          ? Colors.black
                                                          : Colors.transparent,
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  showWidget = false;

                                                  _filter('p');
                                                });
                                              }),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: double.infinity,
                                            width: width * 0.05,
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text(
                                              'Packed',
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
                                                      color: Colors.black,
                                                      width: 1),
                                                  shape: BoxShape.circle),
                                              alignment: Alignment.center,
                                              child: Container(
                                                width: width * 0.008,
                                                // height: height * 0.022,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: showWidget
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
                                                    color: showWidget == true
                                                        ? Colors.black
                                                        : Colors.transparent,
                                                    shape: BoxShape.circle),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                showWidget = true;
                                                _filter('l');
                                              });
                                            },
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            height: double.infinity,
                                            width: width * 0.06,
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Text(
                                              'Loose',
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
                                  ),
                                ],
                              ),
                            ),

                            //divider
                            Container(
                              height: double.infinity,
                              width: 1,
                              color: Color.fromARGB(255, 72, 72, 73),
                              margin: EdgeInsets.only(left: 10, right: 10),
                            ),
*/
                              //filters
                              Container(
                                height: double.infinity,
                                width: width * 0.26,
                                margin: EdgeInsets.only(left: 10),
                                //color: Colors.black,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Filter - Qty',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 12,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        // height: height * 0.06,
                                        width: double.infinity,
                                        // height: double.infinity,
                                        //color: Colors.black,

                                        child: Row(
                                          children: [
                                            // date filter
                                            Container(
                                              height: double.infinity,
                                              width: width * 0.11,
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: filter
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
                                                  color: Colors.white),
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    qtyF == 'l-h'
                                                        ? 'Low to High'
                                                        : 'High to Low',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                  Expanded(child: Container()),
                                                  PopupMenuButton(
                                                    color: Colors.white,
                                                    offset: Offset(-84, 48),

                                                    // Color of the shadow

                                                    //offset: const Offset(-120, 45),
                                                    shape:
                                                        BeveledRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2)),

                                                    icon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        color: Colors.black,
                                                        size: 20),
                                                    //initialValue: 2,
                                                    onOpened: () {
                                                      filter = true;
                                                      setState(() {});
                                                    },

                                                    initialValue: 0,
                                                    onCanceled: () {
                                                      filter = false;
                                                      setState(() {});
                                                      print(
                                                          "You have canceled the menu selection.");
                                                    },
                                                    shadowColor: Colors.grey,
                                                    onSelected: (value) {
                                                      filter = false;
                                                      setState(() {});
                                                      switch (value) {
                                                        case 0:
                                                          //do something
                                                          setState(() {
                                                            //packaging = '';

                                                            _sortListAlphabetically(
                                                                _inventoryListAllFilter);
                                                          });
                                                          break;
                                                        case 1:
                                                          //do something
                                                          setState(() {
                                                            //packaging = 'Packed';
                                                            _sortListQty(
                                                                _inventoryListAllFilter,
                                                                'l-h');
                                                            qtyF = 'l-h';
                                                          });
                                                          break;
                                                        case 2:
                                                          //do something
                                                          setState(() {
                                                            //packaging = 'Loose';
                                                            _sortListQty(
                                                                _inventoryListAllFilter,
                                                                'h-l');
                                                            qtyF = 'h-l';
                                                          });
                                                          break;
                                                        default:
                                                          {
                                                            print(
                                                                "Invalid choice");
                                                          }
                                                          break;
                                                      }
                                                    },

                                                    itemBuilder: (context) {
                                                      return [
                                                        const PopupMenuItem(
                                                            value: 1,
                                                            child: Center(
                                                              child: Text(
                                                                'Low to High',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                ),
                                                              ),
                                                            )),
                                                        const PopupMenuItem(
                                                            value: 2,
                                                            child: Center(
                                                              child: Text(
                                                                'High to Low',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                ),
                                                              ),
                                                            )),
                                                      ];
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Expanded(
                                              child: Container(
                                                //   width: width * 0.05,
                                                height: double.infinity,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //if(loading)
                              Container(
                                height: double.infinity,
                                width: width * 0.05,
                                margin: EdgeInsets.only(
                                  left: 0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 12,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          width: double.infinity,
                                          child: (loading)
                                              ? CircularProgressIndicator()
                                              : Container()),
                                    ),
                                  ],
                                ),
                              ),

                              //divider
                              Container(
                                height: double.infinity,
                                width: 1,
                                color: Color.fromARGB(255, 72, 72, 73),
                                margin: EdgeInsets.only(left: 10, right: 10),
                              ),

                              //search inventory
                              Expanded(
                                child: Container(
                                  height: double.infinity,
                                  width: width * 0.1,
                                  margin: EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Search Inventory',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      92, 94, 98, 1),
                                                  fontSize: 12,
                                                  fontFamily: 'Koulen',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          child: Container(
                                            // height: height * 0.05,
                                            // width: width * 0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _updateSellPrice
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
                                            ),
                                            margin: EdgeInsets.only(
                                                bottom: 0, top: 0, left: 0),
                                            child: Container(
                                              //width: width * 0.789,
                                              // height: height * 0.1,
                                              child: TextField(
                                                onTap: () {
                                                  setState(() {
                                                    _updateSellPrice =
                                                        !_updateSellPrice;
                                                    if (_updateSellPrice ==
                                                        true) {
                                                    } else {
                                                      _search.unfocus();
                                                    }
                                                  });
                                                },
                                                focusNode: _search,
                                                readOnly:
                                                    true, // Prevent system keyboard
                                                showCursor: false,

                                                controller: _ctrlSearch,
                                                // controller: searchController,
                                                onChanged: (value) {},
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 19),
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              0, 51, 154, 1),
                                                          width: 2),
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        Colors.transparent,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    hintText: '',
                                                    hintStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                    prefixIcon: const Icon(
                                                        Icons.search),
                                                    prefixIconColor:
                                                        Colors.black),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _updateSellPrice =
                                                  !_updateSellPrice;
                                              _search.unfocus();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              //search inventory
                              Container(
                                height: double.infinity,
                                width: width * 0.1,
                                margin: EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Print Inventory Report',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 12,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: width * 0.12,
                                        height: double.infinity,
                                        margin: EdgeInsets.only(
                                          right: 0,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.black,
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
                                            ]),
                                        child: TextButton(
                                          child: Text(
                                            'Print',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (globalsPrinter
                                                        .printerConnected ==
                                                    true &&
                                                _inventoryListAllFilter
                                                    .isNotEmpty)
                                              _printOrder(height, width, true);
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
                      if (!dashboard && !quickAdd)
                        Expanded(
                          child: Container(
                              width: double.infinity,
                              //height: height * 0.8,

                              margin: const EdgeInsets.only(
                                  top: 0, bottom: 10, left: 0, right: 0),
                              child: ListView.builder(
                                itemCount: _inventoryListAllFilter.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(height, width, index, context);
                                },
                              )),
                        ),
                      if (!dashboard && quickAdd)
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            '***These products will appear on "quick add" section of "billing page" for faster billing***',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Koulen',
                                fontSize: 15,
                                color: Colors.black),
                          ),
                        ),
                      if (!dashboard && quickAdd)
                        Expanded(
                          child: Container(
                              width: double.infinity,
                              //height: height * 0.8,

                              margin: const EdgeInsets.only(
                                  top: 0, bottom: 10, left: 0, right: 0),
                              child: ListView.builder(
                                itemCount: _inventoryListQuickAdd.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CardQuickAdd(
                                      height, width, index, context);
                                },
                              )),
                        ),
                      if (dashboard && !quickAdd)
                        Expanded(
                            child: Container(
                          color: const Color.fromRGBO(244, 244, 244, 1),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.22,
                                height: double.infinity,
                                margin: const EdgeInsets.only(
                                    right: 0, left: 0, bottom: 10, top: 0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: height * 0.045,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)),
                                        // color: Colors
                                        //   .black,
                                      ),
                                      margin: EdgeInsets.only(
                                          bottom: 0,
                                          left: 5,
                                          right: 2,
                                          top: 10),
                                      padding:
                                          EdgeInsets.only(left: 5, right: 10),
                                      child: Container(
                                        height: double.infinity,
                                        width: width * 0.15,
                                        margin:
                                            EdgeInsets.only(left: 0, bottom: 0),
                                        child: InkWell(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            width: double.infinity,
                                            padding: EdgeInsets.only(left: 12),
                                            child: Text(
                                              'Low Stock Alert!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  color: Color.fromARGB(
                                                      255, 230, 43, 30),
                                                  //  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          //height: height * 0.8,

                                          margin: const EdgeInsets.only(
                                              top: 0,
                                              bottom: 10,
                                              left: 5,
                                              right: 5),
                                          child: ListView.builder(
                                            itemCount: _lowInventoryList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return CardInventory(height,
                                                  width, index, context);
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              /* Expanded(
                                child: Container(
                                  height: double.infinity,
                                  margin: const EdgeInsets.only(
                                      right: 0, left: 0, bottom: 10, top: 0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: height * 0.045,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              bottomRight: Radius.circular(4)),
                                          color: Colors.black,
                                        ),
                                        margin: EdgeInsets.only(
                                            bottom: 10, left: 2, right: 5),
                                        padding:
                                            EdgeInsets.only(left: 5, right: 10),
                                        child: Container(
                                          height: double.infinity,
                                          width: width * 0.15,
                                          margin: EdgeInsets.only(
                                              left: 0, bottom: 0),
                                          child: InkWell(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              width: double.infinity,
                                              padding:
                                                  EdgeInsets.only(left: 12),
                                              child: Text(
                                                'Pending Payments!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Koulen',
                                                    color: Colors.white,
                                                    //  fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            width: double.infinity,
                                            //height: height * 0.8,

                                            margin: const EdgeInsets.only(
                                                top: 0,
                                                bottom: 10,
                                                left: 8,
                                                right: 5),
                                            child: ListView.builder(
                                              itemCount:
                                                  _paymentSupplyAll.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return InkWell(
                                                  child: CardPayments(
                                                      height,
                                                      width,
                                                      (_paymentSupplyAll
                                                                  .length -
                                                              index) -
                                                          1,
                                                      context),
                                                  /* onLongPress:
                                                                                () {
                                                                              setState(() {
                                                                                order = true;
                                                                                transaction = false;
                                                                                dashboard = false;
                                                                                _filter(supplierF, packingF, dateF, statusF, customOrderF);
                                                                              });
                                                                              int index = 0;
                                                                              for (var i in _supplyAllFilter) {
                                                                                if (i.id == _paymentSupplyAll[index].orderId) {
                                                                                  index = _supplyAllFilter.indexOf(i);
                                                                                }
                                                                              }
                                                                              Future.delayed(Duration(seconds: 1), () {
                                                                                _scrollToElement(_supplyAllFilter.length - index - 1, height);
                                                                              });

                                                                            //  _scrollToElement(_supplyAllFilter.length - index - 1, height);
                                                                            },*/
                                                );
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                             */
                              Expanded(
                                child: Container(
                                  width: width * 0.228,
                                  height: double.infinity,
                                  margin: const EdgeInsets.only(
                                      right: 5, left: 0, bottom: 0, top: 5),
                                  child: Column(
                                    children: [
                                      // Today bar
                                      Container(
                                        width: double.infinity,
                                        height: height * 0.045,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.black,
                                        ),
                                        margin: EdgeInsets.only(
                                            bottom: 5, left: 5, right: 0),
                                        padding:
                                            EdgeInsets.only(left: 5, right: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: double.infinity,
                                              width: width * 0.15,
                                              margin: EdgeInsets.only(
                                                  left: 0, bottom: 0),
                                              child: InkWell(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  width: double.infinity,
                                                  padding:
                                                      EdgeInsets.only(left: 12),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        dateF == 'today'
                                                            ? 'Today'
                                                            : dateF ==
                                                                    'yesterday'
                                                                ? 'Yesterday'
                                                                : dateF ==
                                                                        'week'
                                                                    ? 'Last Week'
                                                                    : dateF ==
                                                                            '1month'
                                                                        ? 'Last Month'
                                                                        : dateF ==
                                                                                '6month'
                                                                            ? 'Last 6 Months'
                                                                            : dateF == '1year'
                                                                                ? 'Last Year'
                                                                                : 'All',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Koulen',
                                                            color: Colors.white,
                                                            //  fontWeight: FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                      PopupMenuButton(
                                                        offset: const Offset(
                                                            -120, 65),
                                                        shape:
                                                            BeveledRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            2)),

                                                        icon: Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            color: Colors.white,
                                                            size: 20),
                                                        //initialValue: 2,

                                                        initialValue: 0,
                                                        onCanceled: () {
                                                          print(
                                                              "You have canceled the menu selection.");
                                                        },
                                                        onOpened: () {
                                                          Vibration.vibrate(
                                                              duration: 100);
                                                        },
                                                        onSelected: (value) {
                                                          switch (value) {
                                                            case 0:
                                                              //do something
                                                              setState(() {
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        100);
                                                                //packaging = '';
                                                                _filterx(
                                                                    supplierF,
                                                                    packingFx,
                                                                    'today',
                                                                    statusF,
                                                                    customOrderF);
                                                              });
                                                              break;
                                                            case 1:
                                                              //do something
                                                              setState(() {
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        100);
                                                                //packaging = 'Packed';
                                                                _filterx(
                                                                    supplierF,
                                                                    packingFx,
                                                                    'yesterday',
                                                                    statusF,
                                                                    customOrderF);
                                                              });
                                                              break;
                                                            case 2:
                                                              //do something
                                                              setState(() {
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        100);
                                                                //packaging = 'Loose';
                                                                _filterx(
                                                                    supplierF,
                                                                    packingFx,
                                                                    'week',
                                                                    statusF,
                                                                    customOrderF);
                                                              });
                                                              break;
                                                            case 3:
                                                              //do something
                                                              setState(() {
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        100);
                                                                //packaging = 'Loose';
                                                                _filterx(
                                                                    supplierF,
                                                                    packingFx,
                                                                    '1month',
                                                                    statusF,
                                                                    customOrderF);
                                                              });
                                                              break;
                                                            case 4:
                                                              //do something
                                                              setState(() {
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        100);
                                                                //packaging = 'Loose';
                                                                _filterx(
                                                                    supplierF,
                                                                    packingFx,
                                                                    '6month',
                                                                    statusF,
                                                                    customOrderF);
                                                              });
                                                              break;
                                                            case 5:
                                                              //do something
                                                              setState(() {
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        100);
                                                                //packaging = 'Loose';
                                                                _filterx(
                                                                    supplierF,
                                                                    packingFx,
                                                                    '1year',
                                                                    statusF,
                                                                    customOrderF);
                                                              });
                                                              break;
                                                            default:
                                                              {
                                                                print(
                                                                    "Invalid choice");
                                                              }
                                                              break;
                                                          }
                                                        },

                                                        itemBuilder: (context) {
                                                          return [
                                                            const PopupMenuItem(
                                                                value: 0,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Today',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                )),
                                                            const PopupMenuItem(
                                                                value: 1,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Yesterday',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                )),
                                                            const PopupMenuItem(
                                                                value: 2,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Last Week',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                )),
                                                            const PopupMenuItem(
                                                                value: 3,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Last Month',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                )),
                                                            const PopupMenuItem(
                                                                value: 4,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Last 6 Months',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                )),
                                                            const PopupMenuItem(
                                                                value: 5,
                                                                child: Center(
                                                                  child: Text(
                                                                    'Last Year',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Koulen',
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                )),
                                                          ];
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            Container(
                                              height: double.infinity,
                                              width: width * 0.05,
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 0,
                                                  right: 0),
                                              margin: EdgeInsets.only(
                                                left: 0,
                                              ),
                                              alignment: Alignment.center,
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: double.infinity,
                                                  child: (loading)
                                                      ? CircularProgressIndicator(
                                                          color: Colors.white,
                                                        )
                                                      : Container()),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: width * 0.22,
                                                  height: double.infinity,
                                                  margin: const EdgeInsets.only(
                                                      right: 0,
                                                      left: 0,
                                                      bottom: 10,
                                                      top: 0),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: height * 0.045,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          4),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          4)),
                                                          color: Colors.black,
                                                        ),
                                                        margin: EdgeInsets.only(
                                                            bottom: 0,
                                                            left: 5,
                                                            right: 2),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                right: 10),
                                                        child: Container(
                                                          height:
                                                              double.infinity,
                                                          width: width * 0.15,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0,
                                                                  bottom: 0),
                                                          child: InkWell(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: double
                                                                  .infinity,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 12),
                                                              child: Text(
                                                                'Top Performing Products',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily: 'Koulen',
                                                                    color: Colors.white,
                                                                    //  fontWeight: FontWeight.bold,
                                                                    fontSize: 18),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            //height: height * 0.8,

                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    bottom: 10,
                                                                    left: 5,
                                                                    right: 6),
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  profitProduct
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return Cardx(
                                                                    height,
                                                                    width,
                                                                    (index),
                                                                    context);
                                                              },
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  margin: const EdgeInsets.only(
                                                      right: 0,
                                                      left: 0,
                                                      bottom: 10,
                                                      top: 0),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: height * 0.045,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          4),
                                                                  bottomRight:
                                                                      Radius.circular(
                                                                          4)),
                                                          color: Colors.black,
                                                        ),
                                                        margin: EdgeInsets.only(
                                                            bottom: 0,
                                                            left: 2,
                                                            right: 0),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                right: 10),
                                                        child: Container(
                                                          height:
                                                              double.infinity,
                                                          width: width * 0.15,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0,
                                                                  bottom: 0),
                                                          child: InkWell(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              width: double
                                                                  .infinity,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 12),
                                                              child: Text(
                                                                'Least Performing Products / Dead Stock!',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily: 'Koulen',
                                                                    color: Colors.white,
                                                                    //  fontWeight: FontWeight.bold,
                                                                    fontSize: 18),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                            width: double
                                                                .infinity,
                                                            //height: height * 0.8,

                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    bottom: 10,
                                                                    left: 6,
                                                                    right: 0),
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  profitProduct
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return InkWell(
                                                                  child: Cardx(
                                                                      height,
                                                                      width,
                                                                      (profitProduct.length -
                                                                              index) -
                                                                          1,
                                                                      context),
                                                                  /* onLongPress:
                                                                                () {
                                                                              setState(() {
                                                                                order = true;
                                                                                transaction = false;
                                                                                dashboard = false;
                                                                                _filter(supplierF, packingF, dateF, statusF, customOrderF);
                                                                              });
                                                                              int index = 0;
                                                                              for (var i in _supplyAllFilter) {
                                                                                if (i.id == _paymentSupplyAll[index].orderId) {
                                                                                  index = _supplyAllFilter.indexOf(i);
                                                                                }
                                                                              }
                                                                              Future.delayed(Duration(seconds: 1), () {
                                                                                _scrollToElement(_supplyAllFilter.length - index - 1, height);
                                                                              });

                                                                            //  _scrollToElement(_supplyAllFilter.length - index - 1, height);
                                                                            },*/
                                                                );
                                                              },
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      if (_updateSellPrice ||
                          _updateSellPriceL && !dashboard && !quickAdd)
                        Container(
                          width: double.infinity,
                          height: height * 0.375,
                          margin: const EdgeInsets.only(
                              bottom: 0, right: 0, left: 0),
                          decoration:
                              BoxDecoration(color: Colors.black, boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              // Color of the shadow
                              offset: Offset.zero, // Offset of the shadow
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
                                    _packedMrp.hasFocus
                                        ? _ctrlPackedMrp
                                        : _packedSell.hasFocus
                                            ? _ctrlPackedSell
                                            : _search.hasFocus
                                                ? _ctrlSearch
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




































/*
import 'package:barcode/account_inventory/model/inventory_model.dart';
import 'package:barcode/account_inventory/operation/inventory_operation.dart';
import 'package:barcode/database_helper/database_helper.dart';



























import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import 'global_inventory.dart' as globals;

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;

    _refreshInventoryList();
  }

  final _formKeySupply = GlobalKey<FormState>();

  final _ctrlP1W = TextEditingController();
  final _ctrlP1Q = TextEditingController();

  final _ctrlP2W = TextEditingController();
  final _ctrlP2Q = TextEditingController();

  final _ctrlP3W = TextEditingController();
  final _ctrlP3Q = TextEditingController();

  // Inventory
  Inventory _inventory = Inventory();

  static List<Inventory> _inventorys = [];

  static List<Inventory> display_list1 = List.from(_inventorys);

  final _dbHelperE3 = InventoryOperation();
  _refreshInventoryList() async {
    List<Inventory> k = await _dbHelperE3.fetchInventory();

    setState(() {
      for (var i in k) {
        if ((i.packing) == 'p') {
          if (display_list_p.contains(i)) {
            print('already');
          } else {
            //display_list_l
            display_list_p.add(i);
          }
        } else {
          if (display_list_l.contains(i)) {
            print('already');
          } else {
            display_list_l.add(i);
          }
        }
      }

      _inventorys = k;

      display_list1 = k;

      //_nameMap();
    });
  }

  static List<Inventory> display_list_p = [];

  static List<Inventory> display_list_l = [];

  // SEARCH BAR
  static List<Inventory> display_list = List.from(_inventorys);

  void updateList(String value) {
    setState(() {
      display_list1 = _inventorys
          .where((element) =>
              element.productName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _nameMap() {
    int xxx = 0;
    for (var i in display_list) {
      if (i.packing == 'p') {
        // print(xxx);

        String x = i.productName!;
        //print(x);
        //String y1 = x.substring(1, 2);

        String y = x.substring(0, x.length - 2);

        List z = y.split('}, ');
        List<String> ww = [];

        int listNumber1 = 0;

        for (var i in z) {
          //print('i');
          String zzz = i.substring(5, i.length);
          //print(zzz);
          //String zz = i.split(': ')[1];
          ww.add(zzz);
          listNumber1 += 1;
        }
        int p = 0;

        for (var i in ww) {
          List x = i.split(',');
          xxx += 1;

          List y = [];

          for (var c in x) {
            List s = c.split(': ');

            y.add(s[1]);

            // print(y);
          }
          productMap['$xxx'] = {
            'barcode': '${y[0]}',
            'productName': '${y[1]}',
            'qty': '${y[2]}',
            'buy': '${y[3]}',
            'sell': '${y[4]}',
            'weight': '${y[5]}',
            'doe': '${y[6]}',
          };
          //print(y);

          //print(x);
        }
        print(productMap);

        //print(ww);
      } else {
        //print('loose');

        String x = i.productName!;

        //String y1 = x.substring(1, 2);

        String y = x.substring(0, x.length - 2);

        List z = y.split('}, ');
        List<String> ww = [];

        int listNumber1 = 0;

        for (var i in z) {
          //print('i');
          String zzz = i.substring(5, i.length);
          //print(zzz);
          //String zz = i.split(': ')[1];
          ww.add(zzz);
          listNumber1 += 1;
        }
        int p = 0;

        for (var i in ww) {
          List x = i.split(',');
          xxx += 1;

          List y = [];

          for (var c in x) {
            List s = c.split(': ');

            y.add(s[1]);

            // print(y);
          }
          productMap['$xxx'] = {
            'barcode': '${y[0]}',
            'productName': '${y[1]}',
            'buy': '${y[2]}',
            'sell': '${y[3]}',
            'weight': '${y[4]}',
            'weightLoose': '${y[5]}',
            'p1W': '${y[6]}',
            'p1Q': '${y[7]}',
            'p1B': '${y[8]}',
            'p2W': '${y[9]}',
            'p2Q': '${y[10]}',
            'p2B': '${y[11]}',
            'p3W': '${y[12]}',
            'p3Q': '${y[13]}',
            'p3B': '${y[14]}',
          };
          //print(y);

          //print(x);
        }
      }
    }
    //print(display_list1.);
    globals.productMap = productMap;
  }

  bool showWidget = false;

  Map<String, Map<String, String>> productMap = {};

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height * 0.92,
      decoration: BoxDecoration(
        color: const Color.fromARGB(41, 0, 0, 0),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.only(left: 0, right: 5, top: 5, bottom: 5),
      child: Container(
        height: double.infinity,
        width: width * 0.65,
        child: Column(
          children: [
            //COLUMN 1

            Container(
              width: double.infinity,
              height: height * 0.05,
              decoration: BoxDecoration(
                color: const Color.fromARGB(44, 255, 255, 255),
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.only(
                  left: 8, right: 8, top: 20, bottom: 8),
              child: TextField(
                onChanged: (value) {
                  updateList(value);
                },
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.white, fontSize: 19),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search Products',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(33, 255, 255, 255),
                      fontSize: 18,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor:
                        const Color.fromARGB(33, 255, 255, 255)),
              ),
            ),

            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Switch(
                  value: showWidget,
                  onChanged: (v) {
                    setState(() {
                      showWidget = v;
                    });
                  }),
            ),

            //COLUMN 2

            Visibility(
              visible: !showWidget,
              child: Expanded(
                child: Container(
                  width: double.infinity,
                  //height: height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 5, bottom: 10),
                  child: // LIST VIEW FOR ADDED PRODUCTS

                      Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          //horizontalMargin: width*0.2,
                          columnSpacing: width * 0.017,
                          columns: const [
                            DataColumn(label: Text('Qty')),
                            DataColumn(label: Text('Product Name')),
                            DataColumn(label: Text('delete')),
                            DataColumn(label: Text('Barcode')),
                            DataColumn(label: Text('Weight')),
                            // DataColumn(label: Text('Loose Weight')),
                            DataColumn(label: Text('Buying Price')),
                            DataColumn(label: Text('Selling Price')),
                            /*  DataColumn(label: Text('Packet 1')),
                            DataColumn(label: Text('Packet 2')),
                            DataColumn(label: Text('Packet 3')),
                            DataColumn(label: Text('Manage Product')),*/
                          ],
                          rows:
                              display_list_p // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            //Extracting from Map element the value
                                            DataCell(
                                                Text('${element.qty}')),

                                            DataCell(Text(
                                                '${element.productName}')),
                                            //  DataCell(Text(
                                            //     '${element.value['productName']}')),

                                            DataCell(IconButton(
                                                onPressed: () async {
                                                  await _dbHelperE3
                                                      .deleteInventory(
                                                          element.id!);

                                                  _refreshInventoryList();
                                                },
                                                icon: Icon(Icons.delete))),

                                            DataCell(
                                                Text('${element.barcode}')),

                                            DataCell(
                                                Text('${element.weight}')),

                                            /*  DataCell(Text(
                                                '${element.weightLoose}')),*/

                                            DataCell(
                                                Text('${element.buy}')),
                                            DataCell(
                                                Text('${element.sell}')),

                                            /*  DataCell(Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                      'Qty - ${element.p1Q}'),
                                                ),
                                                Container(
                                                  child: Text(
                                                      'Weight - ${element.p1W}'),
                                                )
                                              ],
                                            )),
            
                                            DataCell(Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                      'Qty - ${element.p2Q}'),
                                                ),
                                                Container(
                                                  child: Text(
                                                      'Weight - ${element.p2W}'),
                                                )
                                              ],
                                            )),
            
                                            DataCell(Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                      'Qty - ${element.p3Q}'),
                                                ),
                                                Container(
                                                  child: Text(
                                                      'Weight - ${element.p3W}'),
                                                )
                                              ],
                                            )),
            
                                            DataCell(IconButton(
                                                onPressed: () {
                                                  /* globals.inventory = globals
                                                              .display_list1 =
                                                          display_list1[
                                                              productMap.indexOf(
                                                                  element.key)];
                                                      globals.inventoryId =
                                                          element.id!;
                                                      globals.index = display_list1
                                                          .indexOf(element);*/
            
                                                  //globals.index = element.key;
            
                                                  globals.productMap4 =
                                                      productMap;
            
                                                  print(globals.inventoryId);
                                                  Navigator.pushNamed(
                                                      context, '/Manage',
                                                      arguments: null);
                                                },
                                                icon: Icon(Icons.settings))),*/
                                          ],
                                        )),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: showWidget,
              child: Expanded(
                child: Container(
                  width: double.infinity,
                  //height: height * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, top: 5, bottom: 10),
                  child: // LIST VIEW FOR ADDED PRODUCTS

                      Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          //horizontalMargin: width*0.2,
                          columnSpacing: width * 0.017,
                          columns: const [
                            DataColumn(label: Text('Qty')),
                            DataColumn(label: Text('Product Name')),
                            DataColumn(label: Text('delete')),
                            DataColumn(label: Text('Barcode')),
                            DataColumn(label: Text('Weight')),
                            DataColumn(label: Text('Buying Price')),
                            DataColumn(label: Text('Selling Price')),
                            DataColumn(label: Text('Packet 1')),
                            DataColumn(label: Text('Packet 2')),
                            DataColumn(label: Text('Packet 3')),
                            DataColumn(label: Text('Manage Product')),
                          ],
                          rows:
                              display_list_l // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            //Extracting from Map element the value
                                            DataCell(Text('1')),

                                            DataCell(Text(
                                                '${element.productName}')),
                                            //  DataCell(Text(
                                            //     '${element.value['productName']}')),

                                            DataCell(IconButton(
                                                onPressed: () async {
                                                  await _dbHelperE3
                                                      .deleteInventory(
                                                          element.id!);

                                                  // display_list_l.remove(display_list_l.indexOf(element));

                                                  _refreshInventoryList();
                                                },
                                                icon: Icon(Icons.delete))),

                                            DataCell(
                                                Text('${element.barcode}')),

                                            DataCell(
                                                Text('${element.weight}')),

                                            DataCell(
                                                Text('${element.buy}')),
                                            DataCell(
                                                Text('${element.sell}')),

                                            DataCell(Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                      'Qty - ${element.p1Q}'),
                                                ),
                                                Container(
                                                  child: Text(
                                                      'Weight - ${element.p1W}'),
                                                )
                                              ],
                                            )),

                                            DataCell(Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                      'Qty - ${element.p2Q}'),
                                                ),
                                                Container(
                                                  child: Text(
                                                      'Weight - ${element.p2W}'),
                                                )
                                              ],
                                            )),

                                            DataCell(Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                      'Qty - ${element.p3Q}'),
                                                ),
                                                Container(
                                                  child: Text(
                                                      'Weight - ${element.p3W}'),
                                                )
                                              ],
                                            )),

                                            DataCell(IconButton(
                                                onPressed: () {
                                                  /* globals.inventory = globals
                                                              .display_list1 =
                                                          display_list1[
                                                              productMap.indexOf(
                                                                  element.key)];
                                                      globals.inventoryId =
                                                          element.id!;
                                                      globals.index = display_list1
                                                          .indexOf(element);*/

                                                  //globals.index = element.key;

                                                  globals.inventoryId =
                                                      element.id!;

                                                  print(
                                                      globals.inventoryId);
                                                  Navigator.pushNamed(
                                                      context, '/Manage',
                                                      arguments: null);
                                                },
                                                icon:
                                                    Icon(Icons.settings))),
                                          ],
                                        )),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
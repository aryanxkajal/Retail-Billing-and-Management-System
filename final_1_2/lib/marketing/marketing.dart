import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode1/account_sales/model/model_sales.dart';
import 'package:barcode1/account_sales/operation/operation_sales.dart';

import 'package:barcode1/home_page/model/home_sales_model.dart';

import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:share_plus/share_plus.dart';

import 'package:widgets_to_image/widgets_to_image.dart';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../account_inventory/model/inventory_model.dart';
import '../account_inventory/operation/inventory_operation.dart';
import '../database_helper/database_helper.dart';
import '../database_helper/loose_database/loose_model.dart';
import '../database_helper/loose_database/loose_operation.dart';
import '../shop/operations/operation_store.dart';
import 'inventory/marketing_operation.dart';
import 'model/marketing_model.dart';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import '../../../global.dart' as globals;

class Marketing extends StatefulWidget {
  const Marketing({super.key});

  @override
  State<Marketing> createState() => _MarketingState();
}

class _MarketingState extends State<Marketing> {
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;

    _refreshInventoryList();
    display_list_l = [];
    display_list_p = [];

    _marketingList = [];
    _marketingListLoose = [];
    _fetchMarketing();

    // _fetchSales();

    show == false;
    _fetchStore();
    //WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  final _dbHelperS = StoreOperation();

  _fetchStore() async {
    var k = await _dbHelperS.fetchStore();

    storeName = k[0].name!;
    storeAddress = k[0].address!;
    storePhone = k[0].phone!;
    storeUpi = k[0].website!;
  }

  String storeName = '';
  String storeAddress = '';
  String storePhone = '';
  String storeUpi = '';

  _fetchMarketing() async {
    List<MarketingModel> k = await _dbHelperM.fetchMarketing();

    _marketingList = [];
    _marketingListLoose = [];
    _marketingAllDate = [];

    setState(() {
      // _marketingList = k;
    });
    _marketingAll = k;

    for (var i in k) {
      // print(i.date);

      if (i.date ==
          DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()) {
        _marketingAllDate.add(i);
        _marketingList.add(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 1)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 2)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 3)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 4)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 5)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 6)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 7)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 8)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 9)))
              .toString()) {
        _resetInventory(i);
      } else if (i.date ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 10)))
              .toString()) {
        _resetInventory(i);
      }
    }

    _refreshInventoryList();
    _fetchSales();
  }

  _resetInventory(MarketingModel x) async {
    if (_marketingAllDate.isEmpty) {
      List<Inventory> k = await _dbHelperE3.fetchInventory();

      for (var i in k) {
        if (i.barcode == x.barcode) {
          _inventory11 = i;

          _inventory11.sell = '${double.parse(x.sell!)}';

          _updateInventory('update', _inventory11);
        }
      }

      _refreshInventoryList();
    }
  }

  _refreshInventoryList() async {
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

    _refreshInventoryList0(k);
  }

  _refreshInventoryList0(List<Inventory> k) async {
    setState(() {
      _inventoryListAll = k;
    });

    for (var i in _marketingAllDate) {
      for (var j in k) {
        if ((i.barcode == j.barcode)) {
          if ((double.parse(i.sellAfter!) != double.parse(j.sell!))) {
            _inventory11 = j;

            _inventory11.sell = '${double.parse(i.sellAfter!)}';

            _updateInventory('update', _inventory11);
          }
        }
      }
    }

    _sortListAlphabetically(_inventoryListAll);
    _filter(packingF);
  }

  Inventory _inventory11 = Inventory();

  _updateInventory(String operation, Inventory x) async {
    await _dbHelperE3.updateInventory(x);

    _inventory11 = Inventory();
    //_refreshInventoryList();
  }

  _returnMap(Sales x) {
    String jsonString = x.productName!;

    Map<String, dynamic> stringMap = json.decode(jsonString);

    Map<String, Map<String, String>> productMa = {};

    stringMap.forEach((key, value) {
      productMa[key] = Map<String, String>.from(value);
    });

    return productMa;
  }

  List<MarketingModel> _marketingAllDate = [];

  List<MarketingModel> _marketingAll = [];

  double revenue = 0;
  double profit = 0;
  double orderSize = 0;
  int customers = 0;

  _fetchSales() async {
    double revenue1 = 0;
    double profit1 = 0;
    double orderSize1 = 0;
    double customers1 = 0;

    List<String> customerId = [];

    List<String> orderValue = [];

    List<Sales> k = await _dbHelperSales.fetchSales();

    List<Inventory> In = await _dbHelperE3.fetchInventory();

    List<Sales> salesOrder = [];

    setState(() {});

    for (var i in k) {
      if (i.date!.split(' ')[0] ==
          DateFormat('yyyy-MM-dd')
              .format(DateTime.now().subtract(Duration(days: 1)))
              .toString()) {
        //customers1 = customers1 + 1;

        Map<String, Map<String, String>> produc = _returnMap(i);
        for (var c in _marketingAll) {
          if (c.date ==
              DateFormat('yyyy-MM-dd')
                  .format(DateTime.now().subtract(Duration(days: 1)))
                  .toString()) {
            if (i.productName!.contains(c.productName!)) {
              if (i.customerNumber != '1') {
                customerId.add(i.customerNumber!);
                orderValue.add(i.paidAmount!);

                salesOrder.add(i);
              }
            }
            for (var z in produc.entries) {
              if (c.barcode == z.value['barcode']) {
                /*revenue1 = revenue1 +
                    (double.parse(z.value['price']!) *
                        double.parse(z.value['qty']!));*/

                //  profit1 = profit1 +
                //    (double.parse(z.value['price']!) - double.parse(c.buy!)) *
                //      double.parse(z.value['qty']!);
              }
            }
          }
        }
      } else {}
    }

    List<double> p = [];
    List<double> r = [];

    for (var i in salesOrder.toSet().toList()) {
      // print(i.productName);
      Map<String, Map<String, String>> produc = _returnMap(i);

      print(i.paidAmount);

      for (var d in produc.entries) {
        for (var j in In) {
          if (d.value['barcode'] == j.barcode) {
            profit1 = profit1 +
                ((double.parse(d.value['price']!) - double.parse(j.buy!))) *
                    double.parse(d.value['qty']!);

            revenue1 = revenue1 +
                (double.parse(d.value['price']!) *
                    double.parse(d.value['qty']!));
          }
        }
      }
    }

    //print(salesOrder.toSet().toList());

    revenue = revenue1;
    profit = profit1;

    for (var f in orderValue.toSet().toList()) {
      orderSize1 = orderSize1 + double.parse(f);
      // revenue = revenue + double.parse(f);
    }

    orderSize = orderSize1 / orderValue.toSet().toList().length;
    customers = customerId.toSet().toList().length;

    setState(() {});
  }

  // Inventory
  Inventory _inventory = Inventory();

  static List<Inventory> _inventorys = [];

  static List<Inventory> display_list1 = List.from(_inventorys);

  final _dbHelperE3 = InventoryOperation();

  final _dbHelperSales = SalesOperation();

  List<Inventory> _inventoryListAll = [];

  List<Inventory> _inventoryListAllFilter0 = [];

  List<Inventory> _inventoryListAllFilter = [];

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

  Map<String, Map<String, String>> productMap = {};

  // create packet

  String lastBarcodeP1 = '';
  final _dbSupplierLoose = LooseOperation();
  Loose _loose = Loose();
  static List<Loose> _looses = [];

  static List<Inventory> _inventoryss = [];

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  TextEditingController _ctrlSearch = TextEditingController();

  FocusNode _search = FocusNode();

  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  int indexSelected = -1;

  _mCI(List<MarketingModel> m, Inventory I) {
    if (m.isNotEmpty) {
      bool r = true;

      for (var i in m) {
        if (i.barcode == I.barcode) {
          r = false;
        } else {
          //r =  true;
        }
      }

      return r;
    } else {
      return true;
    }
  }

  Widget Card(double height, double width, int index, BuildContext context) {
    return Dismissible(
      key: Key(_inventoryListAll[index].id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      confirmDismiss: (direction) async {
        if (_mCI(_marketingList, _inventoryListAllFilter[index]) == true) {
          _updateMarketingDatabase(
              'add',
              MarketingModel(
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                barcode: _inventoryListAllFilter[index].barcode,
                productName: _inventoryListAllFilter[index].productName,
                buy: _inventoryListAllFilter[index].buy,
                sell: _inventoryListAllFilter[index].sell,
                mrp: _inventoryListAllFilter[index].mrp,
                packing: _inventoryListAllFilter[index].packing,
                sellAfter: _inventoryListAllFilter[index].sell,
              ));

          _marketingList.add(
            MarketingModel(
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              barcode: _inventoryListAllFilter[index].barcode,
              productName: _inventoryListAllFilter[index].productName,
              buy: _inventoryListAllFilter[index].buy,
              sell: _inventoryListAllFilter[index].sell,
              mrp: _inventoryListAllFilter[index].mrp,
              packing: _inventoryListAllFilter[index].packing,
              sellAfter: _inventoryListAllFilter[index].sell,
            ),
          );
        } else if (_mCI(_marketingList, _inventoryListAllFilter[index]) ==
            false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Already Exists!'),
          ));
        }

/*
        print('yes');
        if (_marketingList.length <= (int.parse(layout.split(':')[0]) - 1) &&
            _mCI(_marketingList, _inventoryListAllFilter[index]) &&
            _inventoryListAllFilter[index].packing == 'p') {
         
        } else if (_marketingListLoose.length <=
                (int.parse(layout.split(':')[1]) - 1) &&
            _mCI(_marketingListLoose, _inventoryListAllFilter[index]) &&
            _inventoryListAllFilter[index].packing == 'l') {
          _updateMarketingDatabase(
              'add',
              MarketingModel(
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                barcode: _inventoryListAllFilter[index].barcode,
                productName: _inventoryListAllFilter[index].productName,
                buy: _inventoryListAllFilter[index].buy,
                sell: _inventoryListAllFilter[index].sell,
                mrp: _inventoryListAllFilter[index].mrp,
                packing: _inventoryListAllFilter[index].packing,
                sellAfter: _inventoryListAllFilter[index].sell,
              ));

          _marketingListLoose.add(
            MarketingModel(
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              barcode: _inventoryListAllFilter[index].barcode,
              productName: _inventoryListAllFilter[index].productName,
              buy: _inventoryListAllFilter[index].buy,
              sell: _inventoryListAllFilter[index].sell,
              mrp: _inventoryListAllFilter[index].mrp,
              packing: _inventoryListAllFilter[index].packing,
              sellAfter: _inventoryListAllFilter[index].sell,
            ),
          );
        } else if (_marketingList.length == (int.parse(layout.split(':')[0]))) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'max ${(int.parse(layout.split(':')[0]))} items allowed in "Daily Care"')));
        } else if (_marketingListLoose.length ==
            (int.parse(layout.split(':')[1]))) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'max ${(int.parse(layout.split(':')[1]))} items allowed in "Fruits and Vegetables"')));
        } else if (_mCI(_marketingList, _inventoryListAllFilter[index]) ==
            false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('already exists in "Daily Care"'),
          ));
        } else if (_mCI(_marketingListLoose, _inventoryListAllFilter[index]) ==
            false) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('already exists in "Fruits and Vegetables"'),
          ));
        }*/
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

      child: Container(
        // height: height * 0.09,
        width: double.infinity,
        margin: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Color of the shadow
                offset: Offset.zero, // Offset of the shadow
                blurRadius: 6, // Spread or blur radius of the shadow
                spreadRadius: 0, // How much the shadow should spread
              )
            ]),

        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),

        child: Column(
          children: [
            Container(
              width: double.infinity,
              // height: 20.7,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 0, bottom: 0),
              color: Colors.white,
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '${_inventoryListAllFilter[index].productName}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Koulen',
                      ),
                    ),
                    TextSpan(
                      text: ' (${_inventoryListAllFilter[index].qty})',
                      style: TextStyle(
                        color: Color.fromRGBO(92, 94, 98, 1),
                        fontSize: 16,
                        //fontFamily: '',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                height: 36,
                margin: EdgeInsets.only(bottom: 4),
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: '*cost  ',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15.3,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${double.parse(_inventoryListAllFilter[index].buy!).toStringAsFixed(2)}',
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
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
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
                                    '${double.parse(_inventoryListAllFilter[index].mrp!).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.black,

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
                                text: 'price  ',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15.3,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${double.parse(_inventoryListAllFilter[index].sell!).toStringAsFixed(2)}',
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
                  ],
                )),
          ],
        ),
      ),
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

    // sell

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

  String packingF = 'p';
  String qtyF = 'l-h';

  _filter(
    String packing1,
  ) {
    _inventoryListAllFilter = [];
    _inventoryListAllFilter0 = [];

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

    // print(x);

    setState(() {});
  }

////////////////////// Keyboard /////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////

  // Holds the text that user typed.

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.

  TextEditingController searchController = TextEditingController();

  TextEditingController _ctrlOfferSell = TextEditingController();

  FocusNode _productSearch = FocusNode();

  FocusNode _offerSell = FocusNode();

  String errorOfferSell = '';

  bool keyboard = false;

  bool showWidget = false;

  List<Inventory> _inventoryListOffer = [];

  int selectedOfferIndex = -1;

  final _dbHelperM = MarketingOperation();

  MarketingModel _marketingModel = MarketingModel();

  _updateMarketingDatabase(String operation, MarketingModel x) async {
    if (operation == 'add') {
      await _dbHelperM.insertMarketing(x);
    } else if (operation == 'update') {
      await _dbHelperM.updateMarketing(x);
    } else if (operation == 'delete') {
      await _dbHelperM.deleteMarketing(x.id!);
      //print(x.id);
    }

    _marketingModel = MarketingModel();
    _fetchMarketing();
  }

  Widget offer(double height, double width, int index, BuildContext context) {
    return Dismissible(
      key: Key(_marketingList[index].id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          print('edit');

          if (selectedOfferIndex != index) {
            selectedOfferIndex = index;
            errorOfferSell = '';
            _ctrlOfferSell.clear();
            setState(() {
              keyboard = true;
              showDailyCare = true;
              showFruitsAndVegetables = false;
            });
          } else {
            selectedOfferIndex = -1;
            errorOfferSell = '';
            _ctrlOfferSell.clear();
            setState(() {
              keyboard = showInventory == true ? true : false;
              showDailyCare = true;
              showFruitsAndVegetables =
                  (showInventory == true && keyboard == true) ? false : true;
            });
          }

          return await false;
        } else {
          // keyboard = false;
          setState(() {});
          print('delete');

          return await true;
        }
      },
      direction: DismissDirection.horizontal,

      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          _updateMarketingDatabase('delete', _marketingList[index]);
          _marketingList.removeAt(index);

          errorOfferSell = '';
          _ctrlOfferSell.clear();

          //items.removeAt(index);
        });

        // Then show a snackbar.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('dismissed')));
      },
      // Show a red background as the item is swiped away.
      background: Container(
        margin: EdgeInsets.only(bottom: 8, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.red,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'Remove',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'Koulen'),
        ),
      ),

      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 8, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.green,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Text(
          'Edit',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'Koulen'),
        ),
      ),
      child: selectedOfferIndex != index
          ? Container(
              // height: height * 0.09,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8, right: 5),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, // Color of the shadow
                      offset: Offset.zero, // Offset of the shadow
                      blurRadius: 6, // Spread or blur radius of the shadow
                      spreadRadius: 0, // How much the shadow should spread
                    )
                  ]),
             
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 20.7,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    color: Colors.white,
                    child: Text(
                      '${_marketingList[index].productName}',
                      style: TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 16.2,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                      height: 36,
                      margin: EdgeInsets.only(bottom: 4),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*cost  ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 15.3,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${double.parse(_marketingList[index].buy!).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 19.8,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text: '1',
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
                              alignment: Alignment.bottomCenter,
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
                                          '${double.parse(_marketingList[index].mrp!).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 1.14,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor: Colors.black,
                                        fontSize: 19.8,
                                        fontFamily: 'Koulen',
                                        //fontWeight: FontWeight.w100
                                      ),
                                    ),
                                    TextSpan(
                                      text: '1',
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
                          Container(
                            width: width * 0.14,
                            alignment: Alignment.center,
                            height: double.infinity,
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'offer price !  ',
                                    style: TextStyle(
                                      color: Color.fromRGBO(92, 94, 98, 1),
                                      fontSize: 15.3,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${double.parse(_marketingList[index].sellAfter!).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(2, 120, 174, 1),
                                      fontSize: 27,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
          : Container(
              height: height * 0.12,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8, right: 5),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5),
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
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 20.7,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    color: Colors.white,
                    child: Text(
                      '${_marketingList[index].productName}',
                      style: TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 16.2,
                          color: Colors.black),
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
                                //alignment: Alignment.centerLeft,
                                //   height: height * 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      // height: double.infinity,
                                      width: double.infinity,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '*cost  ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 15.3,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${double.parse(_marketingList[index].buy!).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 19.8,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '1',
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
                                    Container(
                                      height: height * 0.022,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0, bottom: 0),
                                      width: double.infinity,
                                      //height: height * 0.05,
                                      //color: Colors.black,
                                      child: Text(
                                        '',
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
                            Expanded(
                              child: Container(
                                //alignment: Alignment.centerLeft,
                                //   height: height * 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      // height: double.infinity,
                                      width: double.infinity,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'mrp  ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 15.3,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${double.parse(_marketingList[index].mrp!).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 19.8,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '1',
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
                                    Container(
                                      height: height * 0.022,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0, bottom: 0),
                                      width: double.infinity,
                                      //height: height * 0.05,
                                      //color: Colors.black,
                                      child: Text(
                                        '',
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
                            Expanded(
                              child: Container(
                                //alignment: Alignment.centerLeft,
                                //   height: height * 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      //height: height * 0.048,
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: width * 0.06,
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
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1),
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
                                        child: TextFormField(
                                          readOnly:
                                              true, // Prevent system keyboard
                                          showCursor: false,
                                          focusNode: _offerSell,

                                          controller: _ctrlOfferSell,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'BanglaBold',
                                              fontSize: 14),
                                          cursorColor: Colors.black,

                                          //enabled: !lock,

                                          decoration: const InputDecoration(
                                            //prefixIcon: Icon(Icons.person),
                                            //prefixIconColor: Colors.black,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide.none),

                                            focusedBorder: UnderlineInputBorder(
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
                                    ),
                                    Container(
                                      height: height * 0.022,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0, bottom: 0),
                                      width: double.infinity,
                                      //height: height * 0.05,
                                      //color: Colors.black,
                                      child: Text(
                                        errorOfferSell,
                                        textAlign: TextAlign.center,
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
                            Container(
                              width: width * 0.06,
                              margin: EdgeInsets.only(right: 5),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    //height: height * 0.048,
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: width * 0.06,
                                      height: height * 0.048,
                                      //color: Colors.black,
                                      padding: EdgeInsets.all(5),

                                      child: Container(
                                        // alignment: Alignment.bottomCenter,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Colors.black,
                                        ),

                                        child: TextButton(
                                            onPressed: () {
                                              if (_ctrlOfferSell
                                                      .text.isNotEmpty &&
                                                  double.parse(
                                                          _ctrlOfferSell.text) >
                                                      0) {
                                                _marketingList[index]
                                                        .sellAfter =
                                                    _ctrlOfferSell.text;

                                                _updateMarketingDatabase(
                                                    'update',
                                                    _marketingList[index]);

                                                _marketingModel =
                                                    _marketingList[index];
                                                setState(() {
                                                  selectedOfferIndex = -1;
                                                  keyboard = false;
                                                  showDailyCare = true;
                                                  showFruitsAndVegetables =
                                                      true;
                                                  _ctrlOfferSell.clear();
                                                });
                                              } else {
                                                setState(() {
                                                  errorOfferSell = 'Invalid!';
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Done',
                                              style: TextStyle(
                                                  fontFamily: 'BanglaBold',
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.022,
                                    margin: const EdgeInsets.only(
                                        top: 0, left: 0, right: 0, bottom: 0),
                                    width: double.infinity,
                                    //height: height * 0.05,
                                    //color: Colors.black,
                                    child: Text(
                                      '',
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
                          ],
                        )),
                  ),
                ],
              ),
            ),
    );
  }

  Widget offerShare(
      double height, double width, int index, BuildContext context) {
    return Container(
      // height: height * 0.09,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8, right: 10, top: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // Color of the shadow
              offset: Offset.zero, // Offset of the shadow
              blurRadius: 6, // Spread or blur radius of the shadow
              spreadRadius: 0, // How much the shadow should spread
            )
          ]),
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 20.7,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 0, bottom: 0),
            color: Colors.white,
            child: Text(
              '${_marketingList[index].productName}',
              style: TextStyle(
                  fontFamily: 'Koulen', fontSize: 16.2, color: Colors.black),
            ),
          ),
          Container(
              height: 36,
              margin: EdgeInsets.only(bottom: 4),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: double.infinity,
                    width: 150,
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
                                '${double.parse(_marketingList[index].mrp!).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1.14,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.black,
                              fontSize: 19.8,
                              fontFamily: 'Koulen',
                              //fontWeight: FontWeight.w100
                            ),
                          ),
                          TextSpan(
                            text: '1',
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
                              text: 'offer price !  ',
                              style: TextStyle(
                                color: Color.fromRGBO(92, 94, 98, 1),
                                fontSize: 15.3,
                                fontFamily: 'Koulen',
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${double.parse(_marketingList[index].sellAfter!).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Color.fromRGBO(2, 120, 174, 1),
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
              )),
        ],
      ),
    );
  }

  Widget offerFruits(
      double height, double width, int index, BuildContext context) {
    return Dismissible(
      key: Key(_marketingListLoose[index].id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          print('edit');

          if (selectedOfferIndex != index) {
            selectedOfferIndex = index;
            errorOfferSell = '';
            _ctrlOfferSell.clear();
            setState(() {
              keyboard = true;
              showDailyCare = false;
              showFruitsAndVegetables = true;
            });
          } else {
            selectedOfferIndex = -1;
            errorOfferSell = '';
            _ctrlOfferSell.clear();

            setState(() {
              keyboard = showInventory == true ? true : false;
              showDailyCare =
                  (showInventory == true && keyboard == true) ? false : true;
              showFruitsAndVegetables = true;
            });
          }

          return await false;
        } else {
          // keyboard = false;
          setState(() {});
          print('delete');

          return await true;
        }
      },
      direction: DismissDirection.horizontal,

      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          _updateMarketingDatabase('delete', _marketingListLoose[index]);
          _marketingListLoose.removeAt(index);

          errorOfferSell = '';
          _ctrlOfferSell.clear();

          //items.removeAt(index);
        });

        // Then show a snackbar.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('dismissed')));
      },
      // Show a red background as the item is swiped away.
      background: Container(
        margin: EdgeInsets.only(bottom: 8, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.red,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Text(
          'Remove',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'Koulen'),
        ),
      ),

      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 8, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.green,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Text(
          'Edit',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'Koulen'),
        ),
      ),
      child: selectedOfferIndex != index
          ? Container(
              // height: height * 0.09,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, // Color of the shadow
                      offset: Offset.zero, // Offset of the shadow
                      blurRadius: 6, // Spread or blur radius of the shadow
                      spreadRadius: 0, // How much the shadow should spread
                    )
                  ]),
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 20.7,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    color: Colors.white,
                    child: Text(
                      '${_marketingListLoose[index].productName}',
                      style: TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 16.2,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                      height: 36,
                      margin: EdgeInsets.only(bottom: 4),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              child: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '*cost  ',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 15.3,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${double.parse(_marketingListLoose[index].buy!).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 19.8,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                    TextSpan(
                                      text: '1',
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
                              alignment: Alignment.bottomCenter,
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
                                          '${double.parse(_marketingListLoose[index].mrp!).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 1.14,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        decorationColor: Colors.black,
                                        fontSize: 19.8,
                                        fontFamily: 'Koulen',
                                        //fontWeight: FontWeight.w100
                                      ),
                                    ),
                                    TextSpan(
                                      text: '1',
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
                          Container(
                            width: width * 0.14,
                            alignment: Alignment.center,
                            height: double.infinity,
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'offer price !  ',
                                    style: TextStyle(
                                      color: Color.fromRGBO(92, 94, 98, 1),
                                      fontSize: 15.3,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${double.parse(_marketingListLoose[index].sellAfter!).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(2, 120, 174, 1),
                                      fontSize: 27,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )
          : Container(
              height: height * 0.12,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8, right: 5),
              padding: EdgeInsets.only(left: 10, right: 10, top: 5),
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
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 20.7,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(top: 0, bottom: 0),
                    color: Colors.white,
                    child: Text(
                      '${_marketingListLoose[index].productName}',
                      style: TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 16.2,
                          color: Colors.black),
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
                                //alignment: Alignment.centerLeft,
                                //   height: height * 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      // height: double.infinity,
                                      width: double.infinity,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '*cost  ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 15.3,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${double.parse(_marketingListLoose[index].buy!).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 19.8,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '1',
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
                                    Container(
                                      height: height * 0.022,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0, bottom: 0),
                                      width: double.infinity,
                                      //height: height * 0.05,
                                      //color: Colors.black,
                                      child: Text(
                                        '',
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
                            Expanded(
                              child: Container(
                                //alignment: Alignment.centerLeft,
                                //   height: height * 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      // height: double.infinity,
                                      width: double.infinity,
                                      child: RichText(
                                        text: TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'mrp  ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 15.3,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${double.parse(_marketingList[index].mrp!).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    92, 94, 98, 1),
                                                fontSize: 19.8,
                                                fontFamily: 'Koulen',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '1',
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
                                    Container(
                                      height: height * 0.022,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0, bottom: 0),
                                      width: double.infinity,
                                      //height: height * 0.05,
                                      //color: Colors.black,
                                      child: Text(
                                        '',
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
                            Expanded(
                              child: Container(
                                //alignment: Alignment.centerLeft,
                                //   height: height * 0.1,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      //height: height * 0.048,
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: width * 0.06,
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
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1),
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
                                        child: TextFormField(
                                          readOnly:
                                              true, // Prevent system keyboard
                                          showCursor: false,
                                          focusNode: _offerSell,

                                          controller: _ctrlOfferSell,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'BanglaBold',
                                              fontSize: 14),
                                          cursorColor: Colors.black,

                                          //enabled: !lock,

                                          decoration: const InputDecoration(
                                            //prefixIcon: Icon(Icons.person),
                                            //prefixIconColor: Colors.black,
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide.none),

                                            focusedBorder: UnderlineInputBorder(
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
                                    ),
                                    Container(
                                      height: height * 0.022,
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0, bottom: 0),
                                      width: double.infinity,
                                      //height: height * 0.05,
                                      //color: Colors.black,
                                      child: Text(
                                        errorOfferSell,
                                        textAlign: TextAlign.center,
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
                            Container(
                              width: width * 0.06,
                              margin: EdgeInsets.only(right: 5),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    //height: height * 0.048,
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: width * 0.06,
                                      height: height * 0.048,
                                      //color: Colors.black,
                                      padding: EdgeInsets.all(5),

                                      child: Container(
                                        // alignment: Alignment.bottomCenter,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Colors.black,
                                        ),

                                        child: TextButton(
                                            onPressed: () {
                                              if (_ctrlOfferSell
                                                      .text.isNotEmpty &&
                                                  double.parse(
                                                          _ctrlOfferSell.text) >
                                                      0) {
                                                _marketingListLoose[index]
                                                        .sellAfter =
                                                    _ctrlOfferSell.text;

                                                _updateMarketingDatabase(
                                                    'update',
                                                    _marketingListLoose[index]);

                                                _marketingModel =
                                                    _marketingListLoose[index];
                                                setState(() {
                                                  selectedOfferIndex = -1;
                                                  keyboard = false;
                                                  showDailyCare = true;
                                                  showFruitsAndVegetables =
                                                      true;
                                                  _ctrlOfferSell.clear();
                                                });
                                              } else {
                                                setState(() {
                                                  errorOfferSell = 'Invalid!';
                                                });
                                              }
                                            },
                                            child: Text(
                                              'Done',
                                              style: TextStyle(
                                                  fontFamily: 'BanglaBold',
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.022,
                                    margin: const EdgeInsets.only(
                                        top: 0, left: 0, right: 0, bottom: 0),
                                    width: double.infinity,
                                    //height: height * 0.05,
                                    //color: Colors.black,
                                    child: Text(
                                      '',
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
                          ],
                        )),
                  ),
                ],
              ),
            ),
    );
  }

  Widget offer1(List<MarketingModel> x, double height, double width, int index,
      BuildContext context) {
    return Container(
      // height: height * 0.09,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 13.5,

            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 0, bottom: 0),
            //color: Colors.black,
            child: Text(
              '${x[index].productName}',
              style: TextStyle(
                  fontFamily: 'Koulen', fontSize: 11, color: Colors.black),
            ),
          ),
          //16.2
          Container(
              height: 24,
              margin: EdgeInsets.only(bottom: 4),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: double.infinity,
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'mrp  ',
                            style: TextStyle(
                              color: Color.fromRGBO(92, 94, 98, 1),
                              fontSize: 10,
                              fontFamily: 'Koulen',
                            ),
                          ),
                          TextSpan(
                            text:
                                '${double.parse(x[index].mrp!).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1.14,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationColor: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Koulen',
                              //fontWeight: FontWeight.w100
                            ),
                          ),
                          TextSpan(
                            text: '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontFamily: 'Koulen',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    //width: width * 0.093,
                    // color: Colors.black,
                    alignment: Alignment.center,
                    height: double.infinity,
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'offer price !  ',
                            style: TextStyle(
                              color: Color.fromRGBO(92, 94, 98, 1),
                              fontSize: 10,
                              fontFamily: 'Koulen',
                            ),
                          ),
                          TextSpan(
                            text:
                                '${double.parse(x[index].sellAfter!).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Color.fromRGBO(2, 120, 174, 1),
                              fontSize: 19,
                              fontFamily: 'Koulen',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  List<MarketingModel> _marketingList = [];
  List<MarketingModel> _marketingListLoose = [];

  ////////////////////// Printer /////////////////////////
////////////////////// Printer ////////////////////////
////////////////////// Printer ////////////////////////
////////////////////// Printer ////////////////////////

  ///////////image
  ///
  Future<Uint8List> captureWidgetAsImage(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Capture the widget as an image
    ui.Image rawImage =
        await boundary.toImage(pixelRatio: 3.0); // Adjust pixelRatio as needed
    ByteData? byteData =
        await rawImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    return pngBytes;
  }

  final GlobalKey widgetKey = GlobalKey();
  Uint8List? imageBytes;

  Future<void> captureAndConvertWidget() async {
    try {
      Uint8List jpegBytes = await captureWidgetAsImage(widgetKey);

      setState(() {
        imageBytes = jpegBytes;
      });
    } catch (e) {
      print('Error capturing the widget: $e');
    }
  }

  Future<void> shareCapturedImage(Uint8List jpegBytes) async {
    try {
      // Uint8List jpegBytes = await captureWidgetAsImage(widgetKey);
      // Uint8List jpegBytes = await convertWidgetToImage(widgetKey, height, width);

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = await File('${tempDir.path}/captured_image.jpg')
          .writeAsBytes(jpegBytes);

      // Share the image
      await Share.shareFiles(
        [tempFile.path],
        text:
            "${storeName.toUpperCase()}: Today's Offers! (${DateFormat('dd-MM-yyyy').format(DateTime.now())})",
      );
    } catch (e) {
      print('Error sharing the image: $e');
    }
  }

  Future<Uint8List> convertWidgetToImage(
      GlobalKey key, double height, double width) async {
    try {
      // Create a RepaintBoundary around the widget you want to capture
      final repaintBoundary = RepaintBoundary(
        key: key,
        child: xxxx(height, width), // Replace with your widget
      );

      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Capture the widget as an image
      ui.Image rawImage = await boundary.toImage(
          pixelRatio: 3.0); // Adjust pixelRatio as needed
      ByteData? byteData =
          await rawImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      print('Error converting the widget to an image: $e');
      return Uint8List(0);
    }
  }

  bool pdfView = false;
  bool pdfViewWhatsapp = false;
  String filePath1 = '';

  late Uint8List pdfData;

  /////////////////

  Widget xxxx(double height, double width) {
    return Container(
      //width: 400,
      //height: 700,
      padding: const EdgeInsets.only(right: 0, left: 10, bottom: 10, top: 0),
      color: const Color.fromRGBO(244, 244, 244, 1),
      child: Column(
        children: [
          Container(
            height: 22,
            //  color: Colors.black,
            width: double.infinity,
            //   margin: EdgeInsets.only(bottom: 2),
            // height: 150,
            // alignment: FractionalOffset.topRight,
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'contact ',
                        style: TextStyle(
                          color: Color.fromRGBO(92, 94, 98, 1),
                          fontSize: 14,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: '$storePhone',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 65,

            // color: Colors.black,
            //  margin: EdgeInsets.only(bottom: 2),
            child: Text(
              '$storeName',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Koulen', fontSize: 50, color: Colors.black),
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,

            // color: Colors.black,
            //  margin: EdgeInsets.only(bottom: 2),
            child: Text(
              '$storeAddress',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Koulen', fontSize: 15, color: Colors.black),
            ),
          ),
          Container(
            height: 32,
            //  color: Colors.black,
            width: double.infinity,
            //  margin: EdgeInsets.only(bottom: 2),
            // height: 150,
            child: Text(
              "today's offers!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Koulen', fontSize: 22, color: Colors.black),
            ),
          ),
          Container(
            height: 20,
            //  color: Colors.black,
            width: double.infinity,
            margin: EdgeInsets.only(right: 10, bottom: 10),
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
                        text: 'date ',
                        style: TextStyle(
                          color: Color.fromRGBO(92, 94, 98, 1),
                          fontSize: 12,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                //color: Colors.black,
                //height: 275,

                width: double.infinity,
                child: ListView.builder(
                  itemCount: _marketingList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return offerShare(height, width, index, context);
                  },
                )),
          ),
          //Expanded(child: Container()),
          Container(
            height: 22,
            //  color: Colors.black,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10, top: 20),
            // height: 150,
            // alignment: FractionalOffset.topRight,
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '',
                        style: TextStyle(
                          color: Color.fromRGBO(92, 94, 98, 1),
                          fontSize: 14,
                          fontFamily: 'Koulen',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: '*offer valid for today only',
                          style: TextStyle(
                            color: Color.fromRGBO(92, 94, 98, 1),
                            fontSize: 14,
                            fontFamily: 'Koulen',
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

      /* child: Column(
      children: [
        // top product Text
        Container(
            width: double.infinity,
            //height: height * 0.06,
        
            margin: EdgeInsets.only(bottom: 0),
            padding: EdgeInsets.only(left: 0, right: 10),
            child: Text(
              'Inventory',
              style: TextStyle(
                  fontFamily: 'Koulen',
                  color: Colors.black,
                  fontSize: 20),
            )),
        Container(
            width: double.infinity,
            //height: height * 0.06,
        
            margin: EdgeInsets.only(bottom: 0),
            padding: EdgeInsets.only(left: 0, right: 10),
            child: Text(
              '<-- swipe left to add product to discounted product list',
              style: TextStyle(
                  fontFamily: 'Koulen',
                  color: Colors.black,
                  fontSize: 12),
            )),
        
        InkWell(
          child: Container(
            height: height * 0.05,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(bottom: 6.5, left: 0),
            child: Container(
              //width: width * 0.789,
              height: height * 0.1,
              child: TextField(
                onTap: () {
                  setState(() {
                    keyboard = !keyboard;
                    // _updateSellPrice = !_updateSellPrice;
                  });
                },
                focusNode: _search,
                readOnly: true, // Prevent system keyboard
                showCursor: false,
        
                controller: _ctrlSearch,
                // controller: searchController,
                onChanged: (value) {},
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.black, fontSize: 19),
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(0, 51, 154, 1),
                          width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '',
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.black),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              //_updateSellPrice = !_updateSellPrice;
            });
          },
        ),
        
        Container(
          height: height * 0.07,
          width: double.infinity,
        
          margin: EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.black,
          ),
          //padding: const EdgeInsets.only( top: 10),
          child: Row(
            children: [
              Container(
                //width: width * 0.05,
                height: double.infinity,
                //color: const Color.fromRGBO(244, 244, 244, 1),
                margin: const EdgeInsets.only(right: 15, left: 10),
                child: Center(
                  child: Text(
                    'Qty',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        //fontFamily: 'Koulen',
                        fontSize: 20,
                        color: Colors.white),
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
                        // height: 40,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 5),
        
                        child: Text(
                          'Product',
                          style: TextStyle(
                              fontFamily: 'BanglaBold',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: double.infinity,
                                    child: Text(
                                      'Avg Price(buy)',
                                      style: TextStyle(
                                          fontFamily: 'BanglaBold',
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: double.infinity,
                                    child: Text(
                                      'MRP',
                                      style: TextStyle(
                                          fontFamily: 'BanglaBold',
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: double.infinity,
                                    child: Text(
                                      'Price(Sell)',
                                      style: TextStyle(
                                          fontFamily: 'BanglaBold',
                                          fontSize: 12,
                                          color: Colors.white),
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
          //height: double.infinity,
          width: double.infinity,
          height: height * 0.03,
        
          margin: const EdgeInsets.only(bottom: 0, top: 5),
          child: Container(
            alignment: Alignment.centerLeft,
            // height: height * 0.07,
            // width: double.infinity,
            child: Row(
              children: [
                InkWell(
                    child: Container(
                      width: width * 0.022,
                      // height: height * 0.022,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black, width: 1),
                          shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Container(
                        width: width * 0.008,
                        // height: height * 0.022,
                        decoration: BoxDecoration(
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
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    'Packed',
                    style: TextStyle(
                      fontFamily: 'Bangla',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: width * 0.022,
                    // height: height * 0.022,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.black, width: 1),
                        shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Container(
                      width: width * 0.008,
                      // height: height * 0.022,
                      decoration: BoxDecoration(
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
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    'Loose',
                    style: TextStyle(
                      fontFamily: 'Bangla',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        
        Expanded(
          child: Container(
              width: double.infinity,
              //height: height * 0.8,
        
              margin: const EdgeInsets.only(
                  top: 5, bottom: 10, left: 0, right: 0),
              child: ListView.builder(
                itemCount: _inventoryListAllFilter.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(height, width, index, context);
                },
              )),
        ),
      ],
    ),
         */
    );
  }

  // WidgetsToImageController to access widget
  WidgetsToImageController controller = WidgetsToImageController();
// to save image bytes of widget
  Uint8List? bytes;
  bool show = false;

//////////

  int _counter = 0;
  // Uint8List _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  bool showDailyCare = true;
  bool showFruitsAndVegetables = true;

  bool showInventory = false;

  String layout = '8:8';

  bool autopilot = false;

/////////////Printer//////////////////////
/////////////Printer//////////////////////
/////////////Printer//////////////////////
/*
  bool pdfView = false;
  bool pdfViewWhatsapp = false;
  String filePath1 = '';

  late Uint8List pdfData;*/
/*
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
                    text: '${_marketingList[index].date}',
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
                              text: '${_searchResultT[index].orderCustom}',
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
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: '${_searchResultT[index].paidReceived}',
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
                              text: '${_searchResultT[index].paymentMode}',
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
                              text: '${_searchResultT[index].amount}',
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
*/
  //ScreenshotController screenshotController = ScreenshotController();

  void printer1() async {}

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

/*
  Future<void> shareCapturedImage(Uint8List jpegBytes) async {
    try {
      // Uint8List jpegBytes = await captureWidgetAsImage(widgetKey);
      // Uint8List jpegBytes = await convertWidgetToImage(widgetKey, height, width);

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = await File('${tempDir.path}/captured_image.jpg')
          .writeAsBytes(jpegBytes);

      // Share the image
      await Share.shareFiles(
        [tempFile.path],
        text: "36: Today's Offers!",
      );

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
      // await bluetoothPrint.printLabel(config, list1);
      // await bluetoothPrint.printLabel(config, list2);
      //await bluetoothPrint.printReceipt(config, list);
    } catch (e) {
      print('Error sharing the image: $e');
    }
  }
*/
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';

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
/*
  Widget xxxxPrint(double height, double width) {
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
              '36 STORES',
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
              '8168889152',
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
              'M-Block, 36, Janakpuri',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          Container(
            // height: 20,
            //  color: Colors.black,
            width: double.infinity,
            margin: EdgeInsets.only(right: 10, bottom: 5),
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
                        text: 'Date - ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          //fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
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
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
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
                      'DATE',
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
                                'ORDER/CUSTOM',
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
                                'PAID/RECEIVED',
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
                                'PAYMENT MODE',
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
                                'AMOUNT',
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
                  itemCount: _marketingList.length,
                  //cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_marketingList.isNotEmpty) {
                      return cardPrint(height, width, index, context);
                    } else {
                      return const Text('Select Supplier');
                    }
                  }),
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
                    text: 'Balance',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 27,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '',
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
                    text: '',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 27,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '',
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
            //height: 20,
            //  color: Colors.black,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10, bottom: 30),
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
                        text: '36STORES.COM',
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
        ],
      ),
    );
  }
*/
//////////order print/share//////////////////////
//////////order print/share//////////////////////
//////////order print/share//////////////////////
//////////order print/share//////////////////////

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
                    text: '${_marketingList[index].productName!.toUpperCase()}',
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
                              text: '${_marketingList[index].mrp!}',
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
                      alignment: Alignment.center,
                      height: double.infinity,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: _marketingList[index].sellAfter!,
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
            width: double.infinity,
            //height: 65,

            // color: Colors.black,
              margin: EdgeInsets.only(bottom: 10, top: 10),
            child: Text(
              'Today\'s Offers!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, color: Colors.black, fontFamily: 'Koulen'),
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
                                'Offer Price!',
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
                  itemCount: _marketingList.length,
                  //cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_marketingList.isNotEmpty) {
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

  Map<String, Map<String, String>> producX = {};

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
                (500 + 30 + (50 * (_marketingList.length * 1.4)).toDouble())))
        .then((capturedImage) {
      printCapturedImage(capturedImage);
      // Handle captured image
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color.fromRGBO(244, 244, 244, 1),
      child: Row(
        children: [
          Container(
            width: width * 0.6,
            height: double.infinity,
            margin:
                const EdgeInsets.only(right: 0, left: 0, bottom: 0, top: 10),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: height * 0.044,
                  margin: EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black,
                  ),
                  child: TextButton(
                    child: Text(
                      'Offers List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Koulen',
                      ),
                    ),
                    onPressed: () async {},
                  ),
                ),

                // Top Bar

                Container(
                  width: double.infinity,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: EdgeInsets.only(bottom: 6.5, left: 0, top: 10),
                  padding: EdgeInsets.only(left: 10, right: 0),
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.085,
                        height: double.infinity,
                        margin: EdgeInsets.only(
                          right: 10,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
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
                        child: TextButton(
                          child: Text(
                            'Share Offers!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Koulen',
                            ),
                          ),
                          onPressed: () async {
                            if (_marketingList.isNotEmpty) {
                              screenshotController
                                  .captureFromWidget(xxxx(height, width),
                                      //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

                                      delay: Duration(seconds: 1),
                                      targetSize: Size(
                                          380,
                                          //fixed= 390, card =
                                          (450 +
                                              30 +
                                              (50 *
                                                      (_marketingList.length *
                                                          1.4))
                                                  .toDouble())))
                                  .then((capturedImage) {
                                shareCapturedImage(capturedImage);
                                // Handle captured image
                              });
                            }

                            /*  screenshotController
                                .captureFromWidget(
                              xxxx(height, width),
                              pixelRatio: 9.16,
                              delay: Duration(seconds: 1),
                            )
                                .then((capturedImage) {
                              shareCapturedImage(capturedImage);
                              // Handle captured image
                            });*/
                          },
                        ),
                      ),

                      Container(
                        width: width * 0.08,
                        height: double.infinity,
                        margin: EdgeInsets.only(
                          right: 0,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
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
                        child: TextButton(
                          child: Text(
                            'Print Offers!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Koulen',
                            ),
                          ),
                          onPressed: () async {
                            if(globals.printerConnected==true && _marketingList.isNotEmpty)
                            _printOrder(height, width, true);
                          },
                        ),
                      ),

                      Expanded(child: Container()),
                      // configuration - 8:8 - 4:8 - 8:4
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 0),
                    padding:
                        EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: Column(
                      children: [
                        //date

                        //if (showDailyCare)
                        Container(
                            height: 25,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.only(left: 0, right: 0),
                            child: Text(
                              'Offers Valid for Today Only!',
                              style: TextStyle(
                                  fontFamily: 'Koulen',
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 20),
                            )),
//daily care grid

                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: _marketingList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return offer(height, width, index, context);
                                },
                              )),
                        ),

                        // fruits and vegetables

                        /* if (showFruitsAndVegetables)
                          Container(
                              height: 25,
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 15, top: 5),
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: Text(
                                'fruits and vegetables',
                                style: TextStyle(
                                    fontFamily: 'Koulen',
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 20),
                              )),
//fruits and vegetables grid
                        if (showFruitsAndVegetables)
                          Container(
                            //height: 275,
                            height: layout.split(':')[1] == '4'
                                ? 137.5
                                : layout.split(':')[1] == '8'
                                    ? 275
                                    : ((layout.split(':')[1] == '12') &&
                                            keyboard == false &&
                                            showFruitsAndVegetables == true)
                                        ? 412.5
                                        : ((layout.split(':')[1] == '12') &&
                                                keyboard == true &&
                                                showFruitsAndVegetables ==
                                                    false)
                                            ? 412.5
                                            : ((layout.split(':')[1] == '12') &&
                                                    keyboard == true &&
                                                    showFruitsAndVegetables ==
                                                        true)
                                                ? 275
                                                : 275,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,

                              itemCount: (_marketingListLoose.length /
                                      (int.parse(layout.split(':')[1]) ~/ 2))
                                  .ceil(), // Calculate the number of horizontal rows
                              itemBuilder: (context, rowIndex) {
                                return Container(
                                  width: width * 0.35, // Width of each row

                                  child: ListView.builder(
                                    itemCount: int.parse(layout.split(':')[1]),
                                    itemBuilder: (context, index) {
                                      final itemNumber = rowIndex *
                                              (int.parse(
                                                  layout.split(':')[1])) +
                                          index;
                                      if (itemNumber >=
                                              _marketingListLoose.length &&
                                          _marketingListLoose.length != 0) {
                                        return SizedBox
                                            .shrink(); // Hide excess items
                                      } else {
                                        return offerFruits(
                                            height, width, itemNumber, context);
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                     */
                      ],
                    ),
                  ),
                ),

                if (keyboard == true)
                  Container(
                    width: double.infinity,
                    height: height * 0.375,
                    color: Colors.black,
                    child: VirtualKeyboard(
                        textColor: Colors.white,
                        textController: _controllerText,
                        defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                        type: VirtualKeyboardType.Alphanumeric,
                        onKeyPress: (key) {
                          _onKeyPress(
                              key,
                              _search.hasFocus
                                  ? _ctrlSearch
                                  : _offerSell.hasFocus
                                      ? _ctrlOfferSell
                                      : _none);
                        }),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              // width: 378,
              height: double.infinity,
              padding: const EdgeInsets.only(
                  right: 10, left: 10, bottom: 0, top: 10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.044,
                    margin: EdgeInsets.only(right: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black,
                    ),
                    child: TextButton(
                      child: Text(
                        'Inventory',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      onPressed: () async {
                        /*  print('gg');
                          keyboard = !keyboard;
                          if (showDailyCare && showFruitsAndVegetables) {
                            showDailyCare = true;
                            showFruitsAndVegetables = false;
                          } else if (showDailyCare || showFruitsAndVegetables) {
                            showDailyCare = true;
                            showFruitsAndVegetables = true;
                          }

                          showInventory = !showInventory;
                          setState(() {});*/
                      },
                    ),
                  ),

                  // Inventory search bar

                  InkWell(
                    child: Container(
                      height: height * 0.05,
                      width: double.infinity,
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
                      margin: EdgeInsets.only(bottom: 6.5, left: 0, top: 10),
                      child: Container(
                        //width: width * 0.789,
                        height: height * 0.1,
                        child: TextField(
                          onTap: () {
                            keyboard = !keyboard;
                            setState(() {});
                          },
                          focusNode: _search,
                          readOnly: true, // Prevent system keyboard
                          showCursor: false,

                          controller: _ctrlSearch,
                          // controller: searchController,
                          onChanged: (value) {},
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 19),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 51, 154, 1),
                                    width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: '',
                              hintStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300),
                              prefixIcon: const Icon(Icons.search),
                              prefixIconColor: Colors.black),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        //_updateSellPrice = !_updateSellPrice;
                      });
                    },
                  ),

                  Container(
                    //height: double.infinity,
                    width: double.infinity,
                    height: height * 0.03,

                    margin: const EdgeInsets.only(bottom: 0, top: 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      // height: height * 0.07,
                      // width: double.infinity,
                      child: Row(
                        children: [
                          InkWell(
                              child: Container(
                                width: width * 0.022,
                                // height: height * 0.022,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Container(
                                  width: width * 0.008,
                                  // height: height * 0.022,
                                  decoration: BoxDecoration(
                                      color: showWidget == false
                                          ? Colors.black
                                          : Colors.transparent,
                                      shape: BoxShape.circle),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  showWidget = false;

                                  //showDailyCare = true;
                                  //  showFruitsAndVegetables = false;

                                  _filter('p');
                                });
                              }),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: double.infinity,
                            width: width * 0.05,
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              'Packed',
                              style: TextStyle(
                                fontFamily: 'Bangla',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              width: width * 0.022,
                              // height: height * 0.022,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  shape: BoxShape.circle),
                              alignment: Alignment.center,
                              child: Container(
                                width: width * 0.008,
                                // height: height * 0.022,
                                decoration: BoxDecoration(
                                    color: showWidget == true
                                        ? Colors.black
                                        : Colors.transparent,
                                    shape: BoxShape.circle),
                              ),
                            ),
                            onTap: () {
                              showWidget = true;

                              _filter('l');
                            },
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: double.infinity,
                            width: width * 0.06,
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              'Loose',
                              style: TextStyle(
                                fontFamily: 'Bangla',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                        width: double.infinity,
                        //height: height * 0.8,

                        margin: const EdgeInsets.only(
                            top: 5, bottom: 10, left: 0, right: 0),
                        child: ListView.builder(
                          itemCount: _inventoryListAllFilter.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(height, width, index, context);
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

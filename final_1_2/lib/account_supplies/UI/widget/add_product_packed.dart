// ignore_for_file: prefer_final_fields

import 'dart:ui';

import 'package:barcode1/account_inventory/model/inventory_model.dart';
import 'package:barcode1/account_inventory/operation/inventory_operation.dart';
import 'package:barcode1/account_supplies/model/model_supplier.dart';

import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/account_supplies/operation/operation_supplier.dart';

import 'package:barcode1/account_supplies/operation/operation_supply.dart';

import 'package:barcode1/product_database/UI/widget/widget_product1.dart';
import 'package:barcode1/product_database/model/product_database_model.dart';
import 'package:barcode1/product_database/operation/operation_product.dart';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../model/model_test.dart';
import 'global_supply.dart' as globals;

import 'package:provider/provider.dart';

import 'package:barcode1/product_database/model/provider_model.dart';

class AddProductPacked extends StatefulWidget {
  const AddProductPacked({super.key});

  @override
  State<AddProductPacked> createState() => _AddProductPackedState();
}

class _AddProductPackedState extends State<AddProductPacked> {
  //////// BARCODE SCANNER

  String? _barcode;
  late bool visible;

  //// MAIN

  @override
  void initState() {
    super.initState();
    //_refreshSupplyList(globals.addPurchaseDate, globals.SupplierId);
    _refreshProductList1();
    

    productMap = globals.productMap;

    _ctrlSupplyQty.text = '0';

    if (productMap.isEmpty) {
      listNumber = 0;
    } else {
      listNumber = int.parse(globals.productMap.entries.last.key);
    }
  }









  //// List in

  Map<String, String> product = {
    'barcode': '',
    'productName': '',
    'qty': '',
    'buy': '',
    'sell': '',
    'weight': '',
    'doe': '',
  };
  Map<String, Map<String, String>> productMap = {};

  Map<String, Map<String, String>> productMap1 = {};

  int listNumber = 0;

  String productName = 'a1';

  int price = 0;
  int qty = 0;

  

  static List<Product> _entry = [];

  

  Supply1 _supplyn = Supply1();

  _onSubmit1() async {
    int same = 0;
    if (productMap.isEmpty) {
      listNumber += 1;
      productMap["${listNumber}"] = {
        "barcode": "${_ctrlSupplyBarcode.text}",
        "productName": "${_ctrlSupplyProductName.text}",
        "qty": "${_ctrlSupplyQty.text}",
        'buy': '${_ctrlSupplyBuy.text}',
        'sell': '${_ctrlSupplySell.text}',
        'weight': '${_ctrlSupplyWeight.text}',
        'doe': '${_selectedDateE}',
        'packing': 'p',
        'mrp': '${_ctrlSupplyMRP.text}',
      };
      _globalMap();
    } else {
      for (var i in productMap.entries) {
        if (i.value["barcode"] == _ctrlSupplyBarcode.text) {
          same = 1;
          print('same');
        } else {
          //x = true;
          print('different');
        }
      }
      _next(same);
    }

    // _globalMap();

    setState(() {});
    //print(productMap);
  }

  _next(int x) {
    if (x == 1) {
      if (_selectedRowB == true) {
        productMap["${editKey}"] = {
          'barcode': '${_ctrlSupplyBarcode.text}',
          'productName': '${_ctrlSupplyProductName.text}',
          'qty': '${_ctrlSupplyQty.text}',
          'buy': '${_ctrlSupplyBuy.text}',
          'sell': '${_ctrlSupplySell.text}',
          'weight': '${_ctrlSupplyWeight.text}',
          'doe': '${_selectedDateE}',
          'packing': 'p',
          'mrp': '${_ctrlSupplyMRP.text}',
        };
      } else {}
    } else {
      listNumber += 1;
      productMap["${listNumber}"] = {
        'barcode': '${_ctrlSupplyBarcode.text}',
        'productName': '${_ctrlSupplyProductName.text}',
        'qty': '${_ctrlSupplyQty.text}',
        'buy': '${_ctrlSupplyBuy.text}',
        'sell': '${_ctrlSupplySell.text}',
        'weight': '${_ctrlSupplyWeight.text}',
        'doe': '${_selectedDateE}',
        'packing': 'p',
        'mrp': '${_ctrlSupplyMRP.text}',
      };
    }
    _globalMap();
  }

  String editKey = '';

  double totalAmount = 0;
  int totalProducts = 0;
  _globalMap() {
    print(productMap);
    globals.productMap = productMap;
    globals.totalAmount +=
        double.parse(_ctrlSupplyBuy.text) * double.parse(_ctrlSupplyQty.text);

    totalAmount +=
        double.parse(_ctrlSupplyBuy.text) * double.parse(_ctrlSupplyQty.text);

    totalProducts = productMap.length;

    //globals.totalProducts = productMap.length;
    setState(() {
      productMap1 = productMap;
    });
    _resetFormSupply();
  }

  bool _showSearchResults = false;

  // SEARCH BAR
  static List<Product> display_list_product1 = List.from(_productsBarcode);
  static List<Product> display_list_product2 = List.from(_productsName);
  static List<Product> _productsBarcode = [];
  static List<Product> _productsName = [];

  TextEditingController searchController = TextEditingController();

  void updateList(String value) {
    setState(() {
      display_list_product1 = _productsBarcode
          .where((item) => item.Barcode!.contains(value))
          .toList();

      display_list_product2 = _productsName
          .where((item) => item.Name!.toLowerCase().contains(value))
          .toList();
    });
    _updateList1();
  }

  _updateList1() {
    setState(() {
      display_list_product2.add(Product(
        Barcode: '',
        Name: 'Add product',
        Price: 0,
        MeasurementUnit: 'add',
      ));
    });
  }

  _refreshProductList1() async {
    List<Product> k = await _dbHelperE2.fetchProduct();
    setState(() {
      for (var i = 0; i < k.length; i++) {
        _productsBarcode.add(k[i]);
        _productsName.add(k[i]);
      }
    });
  }

  // togglle button
  // one must always be true, means selected.
  List<bool> isSelected = [true, false];

  /// Fired when the virtual keyboard key is pressed.

  //// SUPPLY
  ///

  Supply _supply = Supply();

  static List<Supply> _supplys = [];

  Inventory _inventory = Inventory();

  static List<Inventory> _inventorys = [];

  static List<Supply> display_list1 = List.from(_supplys);

  final _dbHelperE3 = SupplyOperation();
  final _dbHelperE4 = InventoryOperation();



  final _formKeySupply = GlobalKey<FormState>();

  //final _ctrlSupplySupplierId = TextEditingController();
  // final _ctrlSupplyDate = TextEditingController();
  //final _ctrlSupplyPacking = TextEditingController();

  final _ctrlSupplyBarcode = TextEditingController();
  var _ctrlSupplyProductName = TextEditingController();
  final _ctrlSupplyQty = TextEditingController();
  final _ctrlSupplyBuy = TextEditingController();
  final _ctrlSupplySell = TextEditingController();
  final _ctrlSupplyDOE = TextEditingController();
  final _ctrlSupplyWeight = TextEditingController();

  final _ctrlSupplyMRP = TextEditingController();
  final _ctrlSupplyUnit = TextEditingController();

  _resetFormSupply() {
    setState(() {
      _formKeySupply.currentState!.reset();
      _supply.id = null;

      _supply.productList = null;

      _selectedDateE = '';

      _ctrlSupplyBarcode.clear();
      _ctrlSupplyProductName.clear();
      _ctrlSupplyQty.text = '0';
      _ctrlSupplyBuy.clear();
      _ctrlSupplySell.clear();
      _ctrlSupplyWeight.clear();
      _ctrlSupplyDOE.clear();
      _ctrlSupplyMRP.clear();
      _ctrlSupplyUnit.clear();
    });
  }

  _resetFormInventory() {
    setState(() {
      _formKeySupply.currentState!.reset();
      _inventory.id = null;

      _inventory.productName = null;
    });
  }

  int index1 = 0;

  

  _showForEditInventory(index) {
    setState(() {
      _inventory = _inventorys[index];
    });
  }

  // PRODUCT DATABASE

  static List<Product> _products = [];
  var z1;
  final _dbHelperE2 = ProductOperation();

  var e;

  //final dataProvider = ChangeNotifierProvider((_) => DataModel());

  bool _productNotRegistered = false;
  bool _productRegistered = false;

  _refreshProductList(String x) async {
    //int x1 = int.parse(x);
    try {
      List<Product> z = await _dbHelperE2.fetchProduct1(x);
      z1 = z[0].Name;
      setState(() {
        _entry = z;
        // _inventory.productName = z1;
        // _supply.productName = z1;
        _ctrlSupplyProductName.text = z1;

        _ctrlSupplyMRP.text = z[0].Price.toString();

        _ctrlSupplySell.text = z[0].Price.toString();

        _ctrlSupplyUnit.text = z[0].MeasurementUnit.toString();

        _productRegistered = true;
      });
    } on RangeError {
      setState(() {
        _productNotRegistered = true;
        lock = false;
      });

      globals.b = x;

      print('object1');
    }

    setState(() {
      _ctrlSupplyBarcode.text = x;

      //  _supply.barcode = x;

      //_inventory.barcode = x;

      searchController.text = '';

      //
    });
  }

  int id = 0;
  var oo;

  final ScrollController controller = ScrollController();

  //////////////////// DATETIME PICKER
  ///
  ///
  ///
  ///
  ///

  String _selectedDate =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

  String _selectedDateE = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() {
        _selectedDate = '${d.day}/${d.month}/${d.year}';

        print(d);

        //globals.chooseDate = ;
        //_selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
    }
  }

  Future<void> _selectDateE(BuildContext context) async {
    final DateTime? d = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030));
    if (d != null) {
      setState(() {
        _selectedDateE = '${d.day}/${d.month}/${d.year}';
        _ctrlSupplyDOE.text = _selectedDateE;

        print(d);

        //globals.chooseDate = ;
        //_selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
    } else {
      _selectedDateE = '';
    }
  }

  static List<Supplier> display_list_supplier = List.from(_suppliers);
  final _dbHelperSupplier = SupplierOperation();
  static List<Supplier> _suppliers = [];

  // List View
  //int index1 = 0;
  //bool _selected = false;

  String supplierName = '';

  String packing = 'packed';
  bool _packagingColor = false;

  _refreshSupplierList(int id) async {
    List<Supplier> x = await _dbHelperSupplier.fetchSupplierId(id);
    setState(() {
      if (x.isNotEmpty) {
        //_suppliers = x;
        supplierName = x[0].name!;
        //display_list_supplier = x;
        // _generateList();

        print(x[0].name);
      } else {
        //display_list = [];
        print('eeee');
      }

      //globals.x = x;
    });
  }

  String _selectedRow = '';
  bool _selectedRowB = false;

  _editMap(String x) {
    //print('${x}');

    _ctrlSupplyProductName.text = productMap[x]!['productName']!;
    _ctrlSupplyBarcode.text = productMap[x]!['barcode']!;
    _ctrlSupplyQty.text = productMap[x]!['qty']!;
    _ctrlSupplyBuy.text = productMap[x]!['buy']!;
    _ctrlSupplySell.text = productMap[x]!['sell']!;
    _ctrlSupplyWeight.text = productMap[x]!['weight']!;
    _ctrlSupplyDOE.text = productMap[x]!['doe']!;
    _ctrlSupplyMRP.text = productMap[x]!['mrp']!;

    editKey = x;
  }

  Product _product = Product();
  _registerProduct() async {
    await _dbHelperE2.insertProduct(_product);

    _resetFormSupply();
  }

  bool lock = true;
  int _selectedIndex = -1;

  Widget searchListCardProduct(
      List<Product> x, List<Product> y, int index, int z) {
    return InkWell(
      child: Container(
        height: 50,
        margin: EdgeInsets.only(bottom: 0),
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
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
                '${x[index - z].Name}',
                style: TextStyle(
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
                            '${x[index - z].Barcode}',
                            style: TextStyle(
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
                            '${x[index - z].Price} Rs',
                            style: TextStyle(
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
        if (z == 0) {
          _showSearchResults = false;
          _refreshProductList(x[index].Barcode!);

          setState(() {});
        } else {
          _showSearchResults = false;
          print('${display_list_product2[index].Name}');

          _refreshProductList(y[index].Barcode!);

          setState(() {});
        }
      },
    );
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
              color:
                  _selectedIndex == index ? Colors.black : Colors.transparent,
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
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.black,
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
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
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
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
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
                                            color: _selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,
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
                                            color: _selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,
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
                                            color: _selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,
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
                                            color: _selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,
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
          if (_selectedIndex == index) {
            setState(() {
              _selectedRowB = false;
              _selectedRow = '';
              _resetFormSupply();
              print('p');
              _selectedIndex = -1;
              selectedCardKey = '';
            });
          } else {
            setState(() {
              _selectedIndex = index;
              selectedCardKey = no;

              _selectedRowB = true;
              _selectedRow = barcode;
              _editMap(no);
              print('y');
            });

            /*  setState(() {
                                        if (_selectedRow ==
                                            element.value['barcode']!) {
                                          _selectedRowB = false;
                                          _selectedRow = '';
                                          _resetFormSupply();
                                          print('p');
                                        } else {
                                          _selectedRowB = true;
                                          _selectedRow =
                                              element.value['barcode']!;
                                          _editMap(element.key);
                                          print('y');
                                        }
                                      });*/
          }
        },
      ),
    );
  }

  String selectedCardKey = '';

  ///////////////////KEYBOARD//////////////////////
  ///
  ///
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  FocusNode _productSearch = FocusNode();
  FocusNode _productName = FocusNode();
  FocusNode _productBarcode = FocusNode();

  FocusNode _productMRP = FocusNode();
  FocusNode _productWeight = FocusNode();
  FocusNode _productUnit = FocusNode();

  FocusNode _productQty = FocusNode();
  FocusNode _productBuy = FocusNode();
  FocusNode _productSell = FocusNode();

  String errorProductSearch = '';
  String errorProductName = '';
  String errorProductBarcode = '';
  String errorProductMRP = '';
  String errorProductWeight = '';
  String errorProductUnit = '';

  String errorProductQty = '';
  String errorProductBuy = '';
  String errorProductSell = '';

  String text = '';

  bool productSearchA = false;
  bool productNameA = false;
  bool productBarcodeA = false;
  bool productMrpA = false;
  bool productWeightA = false;
  bool productUnitA = false;

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
// product search
    if (_productSearch.hasFocus) {
      _showSearchResults = true;
      updateList(controller.text.toLowerCase());
    }

    // product barcode
    if (_productBarcode.hasFocus) {
      if (controller.text == '0') {
        controller.text = '';
      }
      if (int.tryParse(controller.text) == null && controller.text.length > 0) {
        errorProductBarcode = 'Please enter a valid number';
      } else {
        errorProductBarcode = '';
        if (controller.text.length == 13) {
          //errorProductBarcode = 'Please enter a valid number';
        }
      }
    } else {
      errorProductBarcode = '';
    }

    //mrp

    if (_productMRP.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorProductMRP = 'Invalid';
      } else {
        errorProductMRP = '';
      }
    } else {
      errorProductMRP = '';
    }

    //weight

    if (_productWeight.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorProductWeight = 'Invalid';
      } else {
        errorProductWeight = '';
      }
    } else {
      errorProductWeight = '';
    }

    //qty

    if (_productQty.hasFocus) {
      if (int.tryParse(controller.text) == null && controller.text.length > 0) {
        errorProductQty = 'Invalid';
      } else {
        errorProductQty = '';
      }
    } else {
      errorProductQty = '';
    }

    //buy

    if (_productBuy.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorProductBuy = 'Invalid';
      } else {
        errorProductBuy = '';
      }
    } else {
      errorProductBuy = '';
    }

    //sell

    if (_productSell.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorProductSell = 'Invalid';
      } else {
        errorProductSell = '';
      }
    } else {
      errorProductSell = '';
    }

    // Update the screen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final myDataProvider = Provider.of<MyDataProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 0, right: 0, top: 10),
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Row(
          // ROW 1/2

          children: [
            Container(
              width: width * 0.33,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.15,
                    decoration: const BoxDecoration(
                      //borderRadius: BorderRadius.circular(20),

                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      color: Colors.black,
                    ),
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,

                      // margin: EdgeInsets.all(4.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        //height: 100,
                        width: double.infinity,
                        //padding: const EdgeInsets.only( top: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: double.infinity,
                              //color: const Color.fromRGBO(244, 244, 244, 1),
                              margin: const EdgeInsets.only(right: 20),
                              child: const Center(
                                child: Text(
                                  '#',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      //fontFamily: 'Koulen',
                                      fontSize: 40,
                                      color: Colors.white),
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
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      //color: const Color.fromRGBO(244, 244, 244, 1),

                                      child: const Text(
                                        'Product',
                                        style: TextStyle(
                                            fontFamily: 'BanglaBold',
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 40,
                                      alignment: Alignment.centerLeft,
                                      //color: const Color.fromRGBO(244, 244, 244, 1),

                                      child: const Text(
                                        'Barcode',
                                        style: TextStyle(
                                            fontFamily: 'Bangla',
                                            fontSize: 18,
                                            color: Colors.white),
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
                                                  child: const Text(
                                                    'MRP',
                                                    style: TextStyle(
                                                        fontFamily: 'Bangla',
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: const Text(
                                                    'QTY',
                                                    style: TextStyle(
                                                        fontFamily: 'Bangla',
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: const Text(
                                                    'Price(Buy)',
                                                    style: TextStyle(
                                                        fontFamily: 'Bangla',
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'Price(Sell)',
                                                    style: TextStyle(
                                                        fontFamily: 'Bangla',
                                                        fontSize: 18,
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
                    ),
                  ),
                  Expanded(
                    child: Stack(children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, top: 5, bottom: 0),
                        child: ListView.builder(
                            itemCount: globals.productMap.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (globals.productMap.isNotEmpty) {
                                return card1(
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
                              } else {
                                return const Text('Select Supplier');
                              }
                            }),
                      ),
                    ]),
                  ),
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
                          left: 10, right: 10, top: 0, bottom: 10),
                      // FORM TO ENTER ADDITIONAL DETAILS ABOUT A PARTICULAR PRODUCT

                      child: Form(
                        key: _formKeySupply,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    //search
                                    Container(
                                      width: double.infinity,
                                      height: height * 0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: Colors.white,
                                      ),
                                      child: InkWell(
                                        child: Container(
                                          //width: width * 0.789,
                                          height: height * 0.1,
                                          child: TextField(
                                            focusNode: _productSearch,
                                            readOnly:
                                                true, // Prevent system keyboard
                                            showCursor: false,

                                            controller: searchController,
                                            // controller: searchController,
                                            onChanged: (value) {
                                              _showSearchResults = true;
                                              updateList(value.toLowerCase());
                                              //_showDataTable = false;
                                            },
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 19),
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  borderSide: BorderSide.none,
                                                ),
                                                hintText: '',
                                                hintStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w300),
                                                prefixIcon:
                                                    const Icon(Icons.search),
                                                prefixIconColor: Colors.black),
                                          ),
                                        ),
                                        onTap: () {
                                          _productSearch.requestFocus();
                                          setState(() {});
                                          //_selectDate(context);
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: _productSearch.hasFocus
                                          ? Color.fromRGBO(139, 0, 0, 1)
                                          : Colors.transparent,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 0, right: 0, bottom: 0),
                                      width: double.infinity,
                                      //height: height * 0.05,
                                      //color: Colors.black,
                                      child: Text(
                                        errorProductSearch,
                                        style: TextStyle(
                                            fontFamily: 'Bangla',
                                            fontSize: 13,
                                            color: Color.fromRGBO(139, 0, 0, 1),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    //

                                    if (!_showSearchResults)
                                      Container(
                                        width: double.infinity,

                                        //height: height * 0.4,
                                        margin: const EdgeInsets.only(
                                            bottom: 0,
                                            top: 0,
                                            left: 0,
                                            right: 0),
                                        padding: EdgeInsets.only(bottom: 0),
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
                                                  bufferDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  onBarcodeScanned: (barcode) {
                                                    if (!visible) {
                                                      return;
                                                    }

                                                    myDataProvider
                                                        .updateCount(barcode);

                                                    setState(() {
                                                      myDataProvider
                                                          .updateCount(barcode);

                                                      _refreshProductList(
                                                          barcode);

                                                      //_refreshProductList(p0.item?.ProductId);

                                                      //print(p0.item?.ProductId.toString());
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

                                            // product name

                                            Container(
                                              height: height * 0.1,
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  bottom: 0, top: 0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: height * 0.022,
                                                    //color: Colors.white,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0),
                                                    child: const Text(
                                                        'Product Name',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              238, 72, 72, 73),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'BanglaBold',
                                                          //fontWeight: FontWeight.w100
                                                        )),
                                                  ),
                                                  Container(
                                                    height: height * 0.048,
                                                    width: double.infinity,
                                                    //height: height * 0.04,
                                                    //color: Colors.black,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 5,
                                                            top: 0,
                                                            bottom: 0),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 2,
                                                            bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      color: Colors.white,
                                                    ),
                                                    child: TextFormField(
                                                      readOnly:
                                                          true, // Prevent system keyboard
                                                      showCursor: false,
                                                      focusNode: _productName,

                                                      controller:
                                                          _ctrlSupplyProductName,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'BanglaBold',
                                                          fontSize: 16),
                                                      cursorColor: Colors.black,

                                                      enabled: !lock,

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
                                                      errorProductName,
                                                      style: TextStyle(
                                                          fontFamily: 'Bangla',
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              139, 0, 0, 1),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // barcode and mrp

                                            Container(
                                              height: height * 0.1,
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  bottom: 0, top: 0),
                                              child: Row(
                                                children: [
                                                  //barcode
                                                  Expanded(
                                                    child: Container(
                                                      height: double.infinity,
                                                      // width: width*0.08
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 8,
                                                              top: 0,
                                                              bottom: 0),

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
                                                                'Barcode',
                                                                style:
                                                                    TextStyle(
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
                                                          Container(
                                                            width:
                                                                double.infinity,
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
                                                                  Colors.white,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              focusNode:
                                                                  _productBarcode,
                                                              readOnly: true,
                                                              showCursor: false,
                                                              controller:
                                                                  _ctrlSupplyBarcode,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'BanglaBold',
                                                                  fontSize: 16),
                                                              cursorColor:
                                                                  Colors.black,
                                                              enabled: !lock,
                                                              decoration:
                                                                  const InputDecoration(
                                                                //prefixIcon: Icon(Icons.person),
                                                                //prefixIconColor: Colors.black,
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
                                                          Container(
                                                            height:
                                                                height * 0.022,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 0),
                                                            width:
                                                                double.infinity,
                                                            //height: height * 0.05,
                                                            //color: Colors.black,
                                                            child: Text(
                                                              errorProductBarcode,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Bangla',
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromRGBO(
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
                                                  ),

                                                  //mrp
                                                  Container(
                                                    height: double.infinity,
                                                    width: width * 0.08,
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
                                                              'MRP',
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
                                                        Container(
                                                          height:
                                                              height * 0.048,
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.04,
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
                                                            color: Colors.white,
                                                          ),
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _productMRP,
                                                            controller:
                                                                _ctrlSupplyMRP,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'BanglaBold',
                                                                fontSize: 16),
                                                            cursorColor:
                                                                Colors.black,

                                                            enabled: !lock,

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
                                                        Container(
                                                          height:
                                                              height * 0.022,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  bottom: 0),
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.05,
                                                          //color: Colors.black,
                                                          child: Text(
                                                            errorProductMRP,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Bangla',
                                                                fontSize: 13,
                                                                color: Color
                                                                    .fromRGBO(
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
                                                ],
                                              ),
                                            ),

                                            //weight and unit

                                            Container(
                                              height: height * 0.1,
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  bottom: 0, top: 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: double.infinity,
                                                      // width: width*0.08
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 8,
                                                              top: 0,
                                                              bottom: 0),

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
                                                                'Weight',
                                                                style:
                                                                    TextStyle(
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
                                                          Container(
                                                            height:
                                                                height * 0.048,
                                                            width:
                                                                double.infinity,
                                                            //height: height * 0.04,
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
                                                                  Colors.white,
                                                            ),
                                                            child:
                                                                TextFormField(
                                                              readOnly:
                                                                  true, // Prevent system keyboard
                                                              showCursor: false,
                                                              focusNode:
                                                                  _productWeight,
                                                              controller:
                                                                  _ctrlSupplyWeight,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'BanglaBold',
                                                                  fontSize: 16),
                                                              cursorColor:
                                                                  Colors.black,

                                                              enabled: !lock,

                                                              decoration:
                                                                  const InputDecoration(
                                                                //prefixIcon: Icon(Icons.person),
                                                                //prefixIconColor: Colors.black,
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
                                                          Container(
                                                            height:
                                                                height * 0.022,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 0),
                                                            width:
                                                                double.infinity,
                                                            //height: height * 0.05,
                                                            //color: Colors.black,
                                                            child: Text(
                                                              errorProductWeight,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Bangla',
                                                                  fontSize: 13,
                                                                  color: Color
                                                                      .fromRGBO(
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
                                                  ),
                                                  Container(
                                                    height: double.infinity,
                                                    width: width * 0.08,
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
                                                              'Unit',
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
                                                        Container(
                                                          height:
                                                              height * 0.048,
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.04,
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
                                                            color: Colors.white,
                                                          ),
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _productUnit,
                                                            controller:
                                                                _ctrlSupplyUnit,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'BanglaBold',
                                                                fontSize: 16),
                                                            cursorColor:
                                                                Colors.black,

                                                            enabled: !lock,

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
                                                        Container(
                                                          height:
                                                              height * 0.022,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  bottom: 0),
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.05,
                                                          //color: Colors.black,
                                                          child: Text(
                                                            errorProductUnit,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Bangla',
                                                                fontSize: 13,
                                                                color: Color
                                                                    .fromRGBO(
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    if (_showSearchResults)
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(bottom: 15),

                                          //color: Colors.white,
                                          child: ListView.builder(
                                            itemCount: display_list_product1
                                                    .length +
                                                display_list_product2.length,
                                            itemBuilder: (context, index) {
                                              if (index <
                                                  display_list_product1
                                                      .length) {
                                                return searchListCardProduct(
                                                    display_list_product1,
                                                    display_list_product2,
                                                    index,
                                                    0);
                                              } else {
                                                return searchListCardProduct(
                                                    display_list_product2,
                                                    display_list_product1,
                                                    index,
                                                    display_list_product1
                                                        .length);
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,

                                      //height: height * 0.4,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0, left: 5, right: 5),
                                      padding: EdgeInsets.only(top: 0),
                                      //color: Colors.white,
                                      //height: height*0.3,
                                      child: Column(
                                        children: [
                                          //qty
                                          Container(
                                            height: height * 0.1,
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                bottom: 5, top: 0, left: 5),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    height: height * 0.022,
                                                    //color: Colors.white,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0),
                                                    child: const Text('Qty',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              238, 72, 72, 73),
                                                          fontSize: 13,
                                                          fontFamily:
                                                              'BanglaBold',
                                                          //fontWeight: FontWeight.w100
                                                        )),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    height: height * 0.048,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: width * 0.02,
                                                          height:
                                                              double.infinity,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                if (int.parse(
                                                                        _ctrlSupplyQty
                                                                            .text) >
                                                                    0) {
                                                                  _ctrlSupplyQty
                                                                          .text =
                                                                      (int.parse(_ctrlSupplyQty.text) -
                                                                              1)
                                                                          .toString();
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 15),
                                                        ),
                                                        Container(
                                                          height:
                                                              double.infinity,
                                                          width: width * 0.05,
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
                                                            color: Colors.white,
                                                          ),

                                                          child: TextFormField(
                                                            textAlign: TextAlign
                                                                .center,
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _productQty,
                                                            controller:
                                                                _ctrlSupplyQty,
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
                                                        Container(
                                                          width: width * 0.02,
                                                          height:
                                                              double.infinity,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                if (int.parse(
                                                                        _ctrlSupplyQty
                                                                            .text) >=
                                                                    0) {
                                                                  _ctrlSupplyQty
                                                                          .text =
                                                                      (int.parse(_ctrlSupplyQty.text) +
                                                                              1)
                                                                          .toString();
                                                                }
                                                              },
                                                              icon: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                        ),
                                                      ],
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
                                                      errorProductQty,
                                                      style: TextStyle(
                                                          fontFamily: 'Bangla',
                                                          fontSize: 13,
                                                          color: Color.fromRGBO(
                                                              139, 0, 0, 1),
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          //expiry

                                          Container(
                                            height: height * 0.07,
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                bottom: 5, top: 15),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: height * 0.022,
                                                  //color: Colors.white,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 0,
                                                          bottom: 0),
                                                  child: const Text(
                                                      'Expiry Date of Product',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            238, 72, 72, 73),
                                                        fontSize: 13,
                                                        fontFamily:
                                                            'BanglaBold',
                                                        //fontWeight: FontWeight.w100
                                                      )),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                      child: Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 5,
                                                                  top: 5,
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
                                                            color: Colors.white,
                                                          ),
                                                          child: Text(
                                                            _selectedDateE,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'BanglaBold',
                                                                fontSize: 16),
                                                          )),
                                                      onTap: () {
                                                        _selectDateE(context);
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),

                                          //buy and sell
                                          Container(
                                            height: height * 0.1,
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                bottom: 0, top: 10),
                                            child: Row(
                                              children: [
                                                //buy
                                                Expanded(
                                                  child: Container(
                                                    height: double.infinity,
                                                    // width: width*0.08
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 8,
                                                            top: 0,
                                                            bottom: 0),

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
                                                              'Buying Price',
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
                                                        Container(
                                                          height:
                                                              height * 0.048,
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.04,
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
                                                            color: Colors.white,
                                                          ),
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _productBuy,
                                                            controller:
                                                                _ctrlSupplyBuy,
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
                                                                borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            51,
                                                                            154,
                                                                            1),
                                                                    width: 2),
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
                                                        Container(
                                                          height:
                                                              height * 0.022,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  bottom: 0),
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.05,
                                                          //color: Colors.black,
                                                          child: Text(
                                                            errorProductBuy,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Bangla',
                                                                fontSize: 13,
                                                                color: Color
                                                                    .fromRGBO(
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
                                                ),

                                                //sell
                                                Expanded(
                                                  child: Container(
                                                    height: double.infinity,
                                                    // width: width * 0.08,
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
                                                              'Selling Price',
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
                                                        Container(
                                                          height:
                                                              height * 0.048,
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.04,
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
                                                            color: Colors.white,
                                                          ),
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _productSell,
                                                            controller:
                                                                _ctrlSupplySell,
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
                                                        Container(
                                                          height:
                                                              height * 0.022,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 0,
                                                                  left: 0,
                                                                  right: 0,
                                                                  bottom: 0),
                                                          width:
                                                              double.infinity,
                                                          //height: height * 0.05,
                                                          //color: Colors.black,
                                                          child: Text(
                                                            errorProductSell,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Bangla',
                                                                fontSize: 13,
                                                                color: Color
                                                                    .fromRGBO(
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // button
                                    Container(
                                      width: double.infinity,

                                      height: height * 0.05,
                                      margin: const EdgeInsets.only(
                                          bottom: 0,
                                          top: 15,
                                          left: 5,
                                          right: 0),
                                      //padding: EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                          ),
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.only(
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
                                                    onPressed: () async {
                                                      if (_selectedRowB ==
                                                          true) {
                                                        globals.productMap
                                                            .remove(
                                                                selectedCardKey);
                                                      }
                                                      setState(() {});

                                                      _resetFormSupply();
                                                    },
                                                    child: Text('Remove',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'BanglaBold',
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white)))),
                                          ),
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5,
                                                    right: 0,
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
                                                      if (_ctrlSupplyProductName
                                                                  .text ==
                                                              '' ||
                                                          _ctrlSupplyBarcode.text ==
                                                              '' ||
                                                          _ctrlSupplyMRP.text ==
                                                              '' ||
                                                          _ctrlSupplyBuy.text ==
                                                              '' ||
                                                          _ctrlSupplySell.text ==
                                                              '' ||
                                                          _ctrlSupplyQty.text ==
                                                              '' ||
                                                          errorProductName !=
                                                              '' ||
                                                          errorProductBarcode !=
                                                              '' ||
                                                          errorProductMRP !=
                                                              '' ||
                                                          errorProductBuy !=
                                                              '' ||
                                                          errorProductSell !=
                                                              '' ||
                                                          errorProductQty !=
                                                              '') {
                                                        if (_ctrlSupplyProductName
                                                                    .text ==
                                                                '' ||
                                                            errorProductName !=
                                                                '') {
                                                          setState(() {
                                                            errorProductName =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplyBarcode
                                                                    .text ==
                                                                '' ||
                                                            errorProductBarcode !=
                                                                '') {
                                                          setState(() {
                                                            errorProductBarcode =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplyMRP
                                                                    .text ==
                                                                '' ||
                                                            errorProductMRP !=
                                                                '') {
                                                          setState(() {
                                                            errorProductMRP =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplyBuy
                                                                    .text ==
                                                                '' ||
                                                            errorProductBuy !=
                                                                '') {
                                                          setState(() {
                                                            errorProductBuy =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplySell
                                                                    .text ==
                                                                '' ||
                                                            errorProductSell!=
                                                                '') {
                                                          setState(() {
                                                            errorProductSell =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplyQty
                                                                    .text ==
                                                                '0' ||
                                                            errorProductQty!=
                                                                '') {
                                                          setState(() {
                                                            errorProductQty =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                      } else {


                                                        if (_productNotRegistered ==
                                                                false &&
                                                            _productRegistered ==
                                                                true) {
                                                          setState(() {
                                                            lock = true;
                                                            _productNotRegistered =
                                                                false;
                                                            _productRegistered =
                                                                false;
                                                          });

                                                          _onSubmit1();
                                                          print('1');
                                                        }



                                                        if (_productNotRegistered ==
                                                            true) {
                                                          print('2');
                                                          setState(() {
                                                            lock = true;
                                                            _productNotRegistered =
                                                                false;
                                                            _productRegistered =
                                                                false;
                                                          });
                                                          _product.Barcode =
                                                              '${_ctrlSupplyBarcode.text}';
                                                          _product.Name =
                                                              '${_ctrlSupplyProductName.text}';
                                                          _product.Price =
                                                              double.parse(
                                                                  _ctrlSupplyMRP
                                                                      .text);
                                                          _product.MeasurementUnit =
                                                              '${_ctrlSupplyUnit.text}';
                                                          _registerProduct();
                                                          _onSubmit1();
                                                        }
                                                        if (_productNotRegistered == false &&
                                                            _productRegistered ==
                                                                false &&
                                                            lock == false) {
                                                          print('3');
                                                          setState(() {
                                                            lock = true;
                                                            _productNotRegistered =
                                                                false;
                                                            _productRegistered =
                                                                false;
                                                          });

                                                          _product.Barcode =
                                                              '${_ctrlSupplyBarcode.text}';
                                                          _product.Name =
                                                              '${_ctrlSupplyProductName.text}';
                                                          _product.Price =
                                                              double.parse(
                                                                  _ctrlSupplyMRP
                                                                      .text);
                                                          _product.MeasurementUnit =
                                                              '${_ctrlSupplyUnit.text}';
                                                          _registerProduct();
                                                          _onSubmit1();
                                                        }
                                                        if (_productNotRegistered == false &&
                                                            _productRegistered ==
                                                                false &&
                                                            lock == true &&
                                                            _selectedRowB ==
                                                                true) {
                                                          _onSubmit1();
                                                          _selectedRowB = false;
                                                          _selectedRow = '';
                                                          print('yyy');
                                                        } else {
                                                          print('4');
                                                          setState(() {
                                                            lock = true;
                                                            _productNotRegistered =
                                                                false;
                                                            _productRegistered =
                                                                false;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: Text('Add',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'BanglaBold',
                                                            fontSize: 14,
                                                            color: Colors
                                                                .white)))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                    color: Colors.black,
                    margin:
                        const EdgeInsets.only(bottom: 0, right: 0, left: 10),
                    child: VirtualKeyboard(

                        // height: 300,
                        //width: 500,
                        textColor: Colors.white,
                        textController: _controllerText,
                        //customLayoutKeys: _customLayoutKeys,
                        defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
                        //reverseLayout :true,
                        type: isNumericMode
                            ? VirtualKeyboardType.Numeric
                            : VirtualKeyboardType.Alphanumeric,
                        onKeyPress: (key) {
                          _onKeyPress(
                              key,
                              _productSearch.hasFocus
                                  ? searchController
                                  : _productName.hasFocus
                                      ? _ctrlSupplyProductName
                                      : _productBarcode.hasFocus
                                          ? _ctrlSupplyBarcode
                                          : _productMRP.hasFocus
                                              ? _ctrlSupplyMRP
                                              : _productWeight.hasFocus
                                                  ? _ctrlSupplyWeight
                                                  : _productUnit.hasFocus
                                                      ? _ctrlSupplyUnit
                                                      : _productBuy.hasFocus
                                                          ? _ctrlSupplyBuy
                                                          : _productSell
                                                                  .hasFocus
                                                              ? _ctrlSupplySell
                                                              : _productQty
                                                                      .hasFocus
                                                                  ? _ctrlSupplyQty
                                                                  : _none);
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

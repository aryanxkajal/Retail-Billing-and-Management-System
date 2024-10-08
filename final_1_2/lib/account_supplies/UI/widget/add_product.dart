// ignore_for_file: prefer_final_fields

import 'package:barcode1/account_inventory/model/inventory_model.dart';
import 'package:barcode1/account_inventory/operation/inventory_operation.dart';
import 'package:barcode1/account_supplies/model/model_supplier.dart';

import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/account_supplies/operation/operation_supplier.dart';

import 'package:barcode1/account_supplies/operation/operation_supply.dart';

import 'package:barcode1/product_database/model/product_database_model.dart';
import 'package:barcode1/product_database/operation/operation_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../database_helper/loose_database/loose_model.dart';
import '../../../database_helper/loose_database/loose_operation.dart';
import '../../model/model_test.dart';
import 'global_supply.dart' as globals;

import 'package:provider/provider.dart';

import 'package:barcode1/product_database/model/provider_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  //////// BARCODE SCANNER

  String? _barcode;
  late bool visible;

  //// MAIN

  @override
  void initState() {
    super.initState();

    createProduct();

    _refreshProductList1();

    productMap = globals.productMap;

    for (var i in globals.productMap.entries) {
      listNumber += 1;
    }
    //globals.productMap = {};

    _controllerText.text = 'xxxxxxxxxxxxx';

    _ctrlSupplyQty.text = '0';
  }

  ////automatically updates product
  final _dbHelperProduct = ProductOperation();

  final _dbSupplierLoose = LooseOperation();

  Product _product1 = Product();

  Future<void> createProduct() async {
    final userId = 'user1';
    final firestore = FirebaseFirestore.instance;

    ///////////product//////////////
    ///////////product//////////////
    ///////////product//////////////
    ///////////product//////////////

    List<Product> cProduct = [];

    //// fetch form local

    List<Product> lProduct = await _dbHelperProduct.fetchProduct();

    //// fetch form cloud

    try {
      // Replace 'transaction' with the name of your Firestore collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('universal')
          .doc('product')
          .collection('universal')
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        cProduct.add(Product.fromMap(doc.data()));
      }
    } catch (e) {
      print('Error  transactions from Firestore: $e');
    }

    List<Product> updateProduct = [];

    List<Product> createProduct = [];
    List<Product> deleteProduct = [];

    List<Product> extraLocal = findItemsNotInList(
      lProduct,
      cProduct,
      (Product item) => item.Barcode,
    );

    List<Product> extraCloud = findItemsNotInList1(
      cProduct,
      lProduct,
      (Product item) => item.Barcode,
    );

    for (var i in extraLocal) {
      //  print(i.Barcode);
      //  print(i.Name);

      if (i.Barcode!.length != 4) {
        try {
          await firestore
              .collection('universal')
              .doc('product')
              .collection('universal')
              .doc(i.Barcode.toString())
              .set(
                i.toMap(),
              );
        } catch (e) {
          print('Error $e');
        }
      } // await _dbHelperProduct.insertProduct(i);
    }

    for (var i in extraCloud) {
      print(i.Barcode);
      print(i.Name);

      if (i.Barcode!.length != 4) {
        _product.Name = i.Name;
        _product.Barcode = i.Barcode;
        _product.Price = i.Price;
        _product.MeasurementUnit = i.MeasurementUnit;
        await _dbHelperProduct.insertProduct(_product);
        _product = Product();
      }
    }

    _refreshProductList1();
  }

  List<T> findItemsNotInList<T, K>(
      List<T> listA, List<T> listB, K Function(T) keyExtractor) {
    final setA = Set<K>.from(listA.map(keyExtractor));
    final setB = Set<K>.from(listB.map(keyExtractor));

    final itemsInAOnly =
        listA.where((item) => !setB.contains(keyExtractor(item))).toList();
    final itemsInBOnly =
        listB.where((item) => !setA.contains(keyExtractor(item))).toList();

    return [...itemsInAOnly];
  }
   List<T> findItemsNotInList1<T, K>(
      List<T> listA, List<T> listB, K Function(T) keyExtractor) {
    final setA = Set<K>.from(listA.map(keyExtractor));
    final setB = Set<K>.from(listB.map(keyExtractor));

    final itemsInAOnly =
        listA.where((item) => !setB.contains(keyExtractor(item))).toList();
    final itemsInBOnly =
        listB.where((item) => !setA.contains(keyExtractor(item))).toList();

    return [...itemsInAOnly];
  }

  ///////////////////////

  //// List in

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
        'packing': _ctrlSupplyUnit.text == 'l' ? 'l' : 'p',
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
          'packing': _ctrlSupplyUnit.text == 'l' ? 'l' : 'p',
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
        'packing': _ctrlSupplyUnit.text == 'l' ? 'l' : 'p',
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

    _totalAm();
    //globals.totalProducts = productMap.length;
    setState(() {
      productMap1 = productMap;
    });
    _resetProductForm();
  }

  bool _showSearchResults = false;

  // SEARCH BAR
  static List<Product> display_list_product1 = List.from(_productsBarcode);
  static List<Product> display_list_product2 = List.from(_productsName);
  static List<Product> _productsBarcode = [];
  static List<Product> _productsName = [];

  TextEditingController searchController = TextEditingController();

  final _ctrlSupplyWeight = TextEditingController();

  // PRODUCT DATABASE

  static List<Product> _products = [];
  var z1;
  final _dbHelperE2 = ProductOperation();

  var e;

  //final dataProvider = ChangeNotifierProvider((_) => DataModel());

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

  static List<Supplier> display_list_supplier = List.from(_suppliers);
  final _dbHelperSupplier = SupplierOperation();
  static List<Supplier> _suppliers = [];

  String supplierName = '';

  String packing = 'packed';
  bool _packagingColor = false;

  String _selectedRow = '';
  bool _selectedRowB = false;

  _editMap(String x) {
    //print('${x}');

    _ctrlSupplyProductName.text = globals.productMap[x]!['productName']!;
    _ctrlSupplyBarcode.text = globals.productMap[x]!['barcode']!;
    _ctrlSupplyQty.text = globals.productMap[x]!['qty']!;
    _ctrlSupplyBuy.text = globals.productMap[x]!['buy']!;
    _ctrlSupplySell.text = globals.productMap[x]!['sell']!;
    _ctrlSupplyWeight.text = globals.productMap[x]!['weight']!;
    _ctrlSupplyDOE.text = globals.productMap[x]!['doe']!;
    _ctrlSupplyMRP.text = globals.productMap[x]!['mrp']!;
    _ctrlSupplyUnit.text = globals.productMap[x]!['packing']!;

    editKey = x;
  }

  Product _product = Product();

  bool lock = true;
  int _selectedIndex = -1;

  String selectedCardKey = '';

  _totalAm() {
    double total = 0;
    for (var i in globals.productMap.entries) {
      total += double.parse(i.value['buy']!) * double.parse(i.value['qty']!);
    }
    globals.totalAmount = total;

    setState(() {});
  }

  /// Generate barcode

/////////////Basic/////////////////////
/////////////Basic/////////////////////
/////////////Basic/////////////////////

  _registerProduct() async {
    await _dbHelperE2.insertProduct(_product);

    _resetProductForm();
    _refreshProductList1();
    createProduct();
  }

  List<Product> _productList = [];

  List<Product> _productListSearch = [];

  // final _dbHelperProduct = ProductOperation();

  _resetProductForm() {
    setState(() {
      _ctrlProductSearch.text = '';

      // _productNotRegistered = false;
      // _productRegistered = false;

      _ctrlProductSearch.clear();

      _ctrlSupplyBarcode.clear();
      _ctrlSupplyProductName.clear();
      _ctrlSupplyQty.text = '0';
      _ctrlSupplyBuy.clear();
      _ctrlSupplySell.clear();
      _ctrlSupplyWeight.clear();
      _ctrlSupplyDOE.clear();
      _selectedDateE = '';
      _ctrlSupplyMRP.clear();
      _ctrlSupplyUnit.clear();
      _totalAm();
    });
  }

  _resetAll() {
    setState(() {
      _ctrlProductSearch.text = '';
      lock = true;

      globals.productMap = {};

      _productNotRegistered = false;
      _productRegistered = false;

      _ctrlProductSearch.clear();
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

  _refreshProductList1() async {
    List<Product> k = await _dbHelperProduct.fetchProduct();
    setState(() {
      _productList = k;
    });
  }

/////////////keyboard/////////////////////
/////////////keyboard/////////////////////
/////////////keyboard/////////////////////

  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  FocusNode _productWeight = FocusNode();

  String errorProductWeight = '';

  String text = '';

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

      _updateSearchResultsProduct(controller.text.toLowerCase());
    }

    // product barcode
    if (_productBarcode.hasFocus) {
      if (controller.text == '0') {
        controller.text = '';
      }
      if (int.tryParse(controller.text) == null && controller.text.length > 0) {
        errorProductBarcode = 'Invalid';
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
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
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

/////////////Row-1/////////////////////
/////////////Row-1/////////////////////
/////////////Row-1/////////////////////

  Widget cardSupplyCart(
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
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey, // Color of the shadow
          offset: Offset(0, 2), // Offset of the shadow
          blurRadius: 6, // Spread or blur radius of the shadow
          spreadRadius: 0, // How much the shadow should spread
        )
      ]),
      child: Card(
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
                    //number
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

                    //other
                    Expanded(
                      child: Container(
                        height: double.infinity,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                margin: const EdgeInsets.only(left: 0, right: 0),
              )
            ],
          ),
          onTap: () {
            if (_selectedIndex == index) {
              setState(() {
                _selectedRowB = false;
                _selectedRow = '';

                _resetProductForm();

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
            }
          },
        ),
      ),
    );
  }

/////////////Row-2, Column-1, Row-1/////////////////////
/////////////Row-2, Column-1, Row-1/////////////////////
/////////////Row-2, Column-1, Row-1/////////////////////

/////////////Search Bar/////////////////////

  String errorProductSearch = '';
  FocusNode _productSearch = FocusNode();

  TextEditingController _ctrlProductSearch = TextEditingController();

  List<Product> filterProduct(String searchText) {
    return _productList.where((x) {
      final productNameMatches =
          x.Name!.toLowerCase().contains(searchText.toLowerCase());

      final barcodeMatches = x.Barcode!.contains(searchText);
      return productNameMatches || barcodeMatches;
    }).toList();
  }

  void _updateSearchResultsProduct(String searchText) {
    setState(() {
      _productListSearch = filterProduct(searchText);
    });

    _productListSearchAdd();
  }

  _productListSearchAdd() {
    setState(() {
      _productListSearch.add(Product(
        Barcode: '',
        Name: 'Add product',
        Price: 0,
        MeasurementUnit: 'add',
      ));
    });
  }

  Widget searchListCardProduct(
    List<Product> x,
    int index,
  ) {
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
                '${x[index].Name}',
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
                            '${x[index].Barcode}',
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
                            '${x[index].Price} Rs',
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
                            x[index].MeasurementUnit != 'l'
                                ? 'Packed'
                                : 'Loose',
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
        _showSearchResults = false;

        _selectedRowB = false;
        _selectedRow = '';

        _resetProductForm();

        print('p');
        _selectedIndex = -1;
        selectedCardKey = '';

        _refreshProductList(x[index].Name!, x[index].Barcode!,
            x[index].Price.toString(), '${x[index].MeasurementUnit}');

        setState(() {});
      },
    );
  }

  bool _productNotRegistered = false;
  bool _productRegistered = false;

  _barcodeScanner(String barcode) {
    List<Product> k = filterProduct(barcode);

    if (k.length == 1) {
      _refreshProductList(k[0].Name!, k[0].Barcode!, k[0].Price.toString(),
          k[0].MeasurementUnit!);
    } else {
      _refreshProductList('Add product', '', '', '');
      _ctrlSupplyBarcode.text = barcode;
    }
  }

  _refreshProductList(
      String product, String barcode, String price, String unit) async {
    //int x1 = int.parse(x);
    if (product != 'Add product') {
      setState(() {
        print('y');
        _ctrlSupplyProductName.text = product;

        _ctrlSupplyBarcode.text = barcode;

        _ctrlSupplyMRP.text = price;

        _ctrlSupplySell.text = price;

        _ctrlSupplyUnit.text = unit;

        _productRegistered = true;
        lock = true;
        _ctrlProductSearch.text = '';
      });
    } else {
      print('n');
      setState(() {
        _productNotRegistered = true;
        lock = false;
        _resetProductForm();
      });
    }
  }

/////////////ProductName/////////////////////

  String errorProductName = '';
  FocusNode _productName = FocusNode();
  TextEditingController _ctrlSupplyProductName = TextEditingController();

  /////////////Barcode/////////////////////

  String errorProductBarcode = '';

  FocusNode _productBarcode = FocusNode();

  TextEditingController _ctrlSupplyBarcode = TextEditingController();

  /////////////MRP/////////////////////

  String errorProductMRP = '';
  FocusNode _productMRP = FocusNode();
  TextEditingController _ctrlSupplyMRP = TextEditingController();

  /////////////Generate Barcode/////////////////////

  String lastBarcode = '';
  //final _dbSupplierLoose = LooseOperation();
  Loose _loose = Loose();
  static List<Loose> _looses = [];

  _generateBarcode1() async {
    List<Loose> x = await _dbSupplierLoose.fetchLoose();

    // lastBarcode = x.last.barcode!;

    if (_ctrlSupplyProductName.text.isNotEmpty) {
      if (x.isEmpty) {
        _loose.name = _ctrlSupplyProductName.text;
        _loose.barcode = '1000';
        await _dbSupplierLoose.insertLoose(_loose);
        print('sample');
      } else {
        _loose.name = _ctrlSupplyProductName.text;
        _loose.barcode = (int.parse(x.last.barcode!) + 1).toString();

        //_loose.barcode = (int.parse(x.last.barcode!) + 1).toString();
        await _dbSupplierLoose.insertLoose(_loose);

        print('exist');
      }
      _lastBarcode();
    } else {
      print('No product Name');
    }
  }

  _lastBarcode() async {
    List<Loose> x = await _dbSupplierLoose.fetchLoose();

    _ctrlSupplyBarcode.text = x.last.barcode!;
  }

  /////////////packed/loose/////////////////////

  String errorProductUnit = '';
  FocusNode _productUnit = FocusNode();

  TextEditingController _ctrlSupplyUnit = TextEditingController();

/////////////QTY/////////////////////

  String errorProductQty = '';
  FocusNode _productQty = FocusNode();
  final _ctrlSupplyQty = TextEditingController();

/////////////DOE/////////////////////

  String _selectedDateE = '';

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
      });
    } else {
      _selectedDateE = '';
    }
  }

  final _ctrlSupplyDOE = TextEditingController();

/////////////Buy/////////////////////

  FocusNode _productBuy = FocusNode();
  String errorProductBuy = '';
  final _ctrlSupplyBuy = TextEditingController();

  /////////////Sell/////////////////////

  String errorProductSell = '';
  FocusNode _productSell = FocusNode();
  final _ctrlSupplySell = TextEditingController();

  /////////////cardCart/////////////////////
  /////////////cardCart/////////////////////
  /////////////cardCart/////////////////////

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
        onTap: () {
          if (_selectedIndex == index) {
            setState(() {
              _selectedRowB = false;
              _selectedRow = '';

              _resetProductForm();

              print('p');
              _selectedIndex = -1;
              selectedCardKey = '';
            });
          } else {
            setState(() {
              _selectedIndex = index;
              selectedCardKey = globals.productMap.keys.elementAt(index);

              _selectedRowB = true;
              _selectedRow =
                  globals.productMap.values.elementAt(index)['barcode']!;
              _editMap(globals.productMap.keys.elementAt(index));
              print('y');
            });
          }
        },
      ),
    );
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
                          itemCount: globals.productMap.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (globals.productMap.isNotEmpty) {
                              return cardCart(
                                  height,
                                  width,
                                  index,
                                  globals.productMap.values
                                      .elementAt(index)['productName']!,
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
                              return const Text('Select Supplier');
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
                                    text: '${globals.productMap.length}',
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
                                    text: '${globals.totalAmount}',
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
                          left: 10, right: 10, top: 0, bottom: 10),
                      // FORM TO ENTER ADDITIONAL DETAILS ABOUT A PARTICULAR PRODUCT

                      child: Form(
                        child: Row(
                          children: [
                            //row1
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
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Colors.white,
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
                                      child: TextField(
                                        focusNode: _productSearch,
                                        readOnly:
                                            true, // Prevent system keyboard
                                        showCursor: false,

                                        controller: _ctrlProductSearch,
                                        // controller: searchController,
                                        onChanged: (value) {},
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 19),
                                        decoration: InputDecoration(
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      0, 51, 154, 1),
                                                  width: 2),
                                            ),
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
                                                fontWeight: FontWeight.w300),
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            prefixIconColor: Colors.black),
                                      ),
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

                                                    setState(() {
                                                      _barcodeScanner(barcode);

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
                                              // height: height * 0.1,
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  bottom: 0, top: 0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    //height: height * 0.022,
                                                    //color: Colors.white,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: 'Product',
                                                            style: TextStyle(
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
                                                  Container(
                                                    height: height * 0.048,
                                                    width: double.infinity,
                                                    //height: height * 0.04,
                                                    //color: Colors.black,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: !lock !=
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
                                                        ]),
                                                    child: TextFormField(
                                                      maxLines: 1,

                                                      readOnly:
                                                          true, // Prevent system keyboard
                                                      showCursor: false,
                                                      focusNode: _productName,

                                                      controller:
                                                          _ctrlSupplyProductName,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 17),
                                                      cursorColor: Colors.black,

                                                      enabled: !lock,

                                                      decoration:
                                                          InputDecoration(
                                                        // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                                        enabledBorder:
                                                            UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),

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
                                                    // height: height * 0.022,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0),
                                                    width: double.infinity,
                                                    //height: height * 0.05,
                                                    //color: Colors.black,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                errorProductName,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(139,
                                                                      0, 0, 1),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Koulen',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // barcode and mrp and barcode generator

                                            Container(
                                              height: height * 0.11,
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
                                                            //   height:
                                                            //    height * 0.022,
                                                            //color: Colors.white,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                style: DefaultTextStyle.of(
                                                                        context)
                                                                    .style,
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        'Barcode',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
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
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                height * 0.048,
                                                            //color: Colors.black,

                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 0,
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
                                                                    color: !lock !=
                                                                            false
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
                                                                      'Koulen',
                                                                  fontSize: 17),
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
                                                            child: RichText(
                                                              text: TextSpan(
                                                                style: DefaultTextStyle.of(
                                                                        context)
                                                                    .style,
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        errorProductBarcode,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              139,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'Koulen',
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

                                                  //mrp
                                                  _ctrlSupplyUnit.text != 'l'
                                                      ? Container(
                                                          height:
                                                              double.infinity,
                                                          width: width * 0.08,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                //   height: height *
                                                                //     0.022,
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
                                                                            'MRP',
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
                                                              Container(
                                                                height: height *
                                                                    0.048,
                                                                width: double
                                                                    .infinity,
                                                                //height: height * 0.04,
                                                                //color: Colors.black,

                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                3),
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: !lock !=
                                                                                false
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
                                                                  readOnly:
                                                                      true, // Prevent system keyboard
                                                                  showCursor:
                                                                      false,
                                                                  focusNode:
                                                                      _productMRP,
                                                                  controller:
                                                                      _ctrlSupplyMRP,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Koulen',
                                                                      fontSize:
                                                                          17),
                                                                  cursorColor:
                                                                      Colors
                                                                          .black,

                                                                  enabled:
                                                                      !lock,

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
                                                                      (val) => {
                                                                    setState(
                                                                        () {
                                                                      //_inventory.productName = val;
                                                                      //_supply.productName = val;
                                                                    }),
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
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
                                                                //height: height * 0.05,
                                                                //color: Colors.black,
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
                                                                            errorProductMRP,
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              139,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'Koulen',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          height:
                                                              double.infinity,
                                                          width: width * 0.08,
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
                                                                            'i',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.transparent,
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
                                                              Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height:
                                                                      height *
                                                                          0.048,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      color: Colors
                                                                          .black,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: !lock != false
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 0,
                                                                      right: 5,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      right: 0,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                                  child:
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (lock ==
                                                                                false) {
                                                                              _generateBarcode1();
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Generate',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontFamily: 'Koulen',
                                                                                fontSize: 14),
                                                                          ))),
                                                              Container(
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
                                                                            '',
                                                                        style:
                                                                            TextStyle(
                                                                          color: Color.fromRGBO(
                                                                              139,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              'Koulen',
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                //height: height * 0.05,
                                                                //color: Colors.black,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),

                                            //packed/loose

                                            Container(
                                              height: height * 0.08,
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  bottom: 0, top: 0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Container(
                                                    height: double.infinity,
                                                    width: width * 0.18,
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
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      'Packed/Loose',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
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
                                                        Container(
                                                            height:
                                                                height * 0.045,
                                                            width:
                                                                double.infinity,
                                                            //height: height * 0.04,
                                                            //color: Colors.black,
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Container(
                                                                        height: double.infinity,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(3),
                                                                          color: _ctrlSupplyUnit.text == ''
                                                                              ? Colors.grey[300]
                                                                              : _ctrlSupplyUnit.text != 'l'
                                                                                  ? Colors.black
                                                                                  : Colors.grey[300],
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        margin: const EdgeInsets.only(left: 0, right: 10),
                                                                        padding: const EdgeInsets.only(bottom: 0),
                                                                        child: TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (lock ==
                                                                                false) {
                                                                              setState(() {
                                                                                _ctrlSupplyUnit.text = 'p';
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Packed',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 13,
                                                                              fontFamily: 'Koulen',
                                                                              // fontWeight: FontWeight.bold
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                  Expanded(
                                                                    child: Container(
                                                                        height: double.infinity,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(3),
                                                                          color: _ctrlSupplyUnit.text == 'l'
                                                                              ? Colors.black
                                                                              : Colors.grey[300],
                                                                        ),
                                                                        alignment: Alignment.center,
                                                                        margin: const EdgeInsets.only(left: 0, right: 0),
                                                                        padding: const EdgeInsets.only(bottom: 0),
                                                                        child: TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            if (lock ==
                                                                                false) {
                                                                              setState(() {
                                                                                _ctrlSupplyUnit.text = 'l';
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'Loose',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 13,
                                                                                fontFamily: 'Koulen',
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                ])),
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
                                            itemCount:
                                                _productListSearch.length,
                                            itemBuilder: (context, index) {
                                              return searchListCardProduct(
                                                  _productListSearch, index);
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            //row 2
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0, left: 5, right: 5),
                                      padding: EdgeInsets.only(top: 0),
                                      child: Column(
                                        children: [
                                          //qty
                                          Container(
                                            //height: height * 0.1,
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(
                                                bottom: 5, top: 0, left: 5),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    // height: height * 0.022,
                                                    //color: Colors.white,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: (_ctrlSupplyUnit
                                                                        .text ==
                                                                    'l')
                                                                ? 'Qty (Kg)'
                                                                : 'Qty (Pieces)',
                                                            style: TextStyle(
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
                                                  Container(
                                                    width: double.infinity,
                                                    height: height * 0.048,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: width * 0.02,
                                                          height:
                                                              double.infinity,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 15),
                                                          child: IconButton(
                                                              onPressed: () {
                                                                if (double.tryParse(
                                                                        _ctrlSupplyQty
                                                                            .text) ==
                                                                    null) {
                                                                  _ctrlSupplyQty
                                                                          .text =
                                                                      '1';
                                                                } else {
                                                                  if (double.parse(
                                                                          _ctrlSupplyQty
                                                                              .text) >
                                                                      1) {
                                                                    _ctrlSupplyQty
                                                                        .text = (double.parse(_ctrlSupplyQty.text) -
                                                                            1)
                                                                        .toString();
                                                                    errorProductQty =
                                                                        '';
                                                                  }
                                                                }
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .black,
                                                              )),
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
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: _ctrlSupplyBarcode
                                                                              .text !=
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
                                                          width: width * 0.02,
                                                          height:
                                                              double.infinity,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                          child: IconButton(
                                                              onPressed: () {
                                                                if (double.tryParse(
                                                                        _ctrlSupplyQty
                                                                            .text) ==
                                                                    null) {
                                                                  _ctrlSupplyQty
                                                                          .text =
                                                                      '1';
                                                                } else {
                                                                  if (double.parse(
                                                                          _ctrlSupplyQty
                                                                              .text) >=
                                                                      0) {
                                                                    _ctrlSupplyQty
                                                                        .text = (double.parse(_ctrlSupplyQty.text) +
                                                                            1)
                                                                        .toString();
                                                                    errorProductQty =
                                                                        '';
                                                                  }
                                                                }
                                                                setState(() {});
                                                              },
                                                              icon: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            bottom: 0),
                                                    width: double.infinity,
                                                    //height: height * 0.05,
                                                    //color: Colors.black,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                errorProductQty,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(139,
                                                                      0, 0, 1),
                                                              fontSize: 13,
                                                              fontFamily:
                                                                  'Koulen',
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

                                          //expiry

                                          /*            Container(
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
*/

                                          //buy and sell

                                          Container(
                                            height: height * 0.11,
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

                                                          //color: Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  bottom: 0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text: 'Cost',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
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
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: _ctrlSupplyBarcode
                                                                              .text !=
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
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _productBuy,
                                                            controller:
                                                                _ctrlSupplyBuy,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Koulen',
                                                                    fontSize:
                                                                        17),
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
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      errorProductBuy,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            139,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'Koulen',
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

                                                          //color: Colors.white,
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0,
                                                                  right: 0,
                                                                  top: 0,
                                                                  bottom: 0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text: 'Price',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
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
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: _ctrlSupplyBarcode
                                                                              .text !=
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
                                                          child: TextFormField(
                                                            readOnly:
                                                                true, // Prevent system keyboard
                                                            showCursor: false,
                                                            focusNode:
                                                                _productSell,
                                                            controller:
                                                                _ctrlSupplySell,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Koulen',
                                                                    fontSize:
                                                                        17),
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
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style,
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      errorProductSell,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            139,
                                                                            0,
                                                                            0,
                                                                            1),
                                                                    fontSize:
                                                                        13,
                                                                    fontFamily:
                                                                        'Koulen',
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
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: Container()),

                                    // button
                                    Container(
                                      width: double.infinity,

                                      height: height * 0.05,
                                      margin: const EdgeInsets.only(
                                          bottom: 15,
                                          top: 15,
                                          left: 5,
                                          right: 0),
                                      //padding: EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Container(
                                              width: width * 0.11,
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
                                                                      4)))),
                                                  onPressed: () async {
                                                    if (_selectedRowB == true) {
                                                      globals.productMap.remove(
                                                          selectedCardKey);
                                                    }
                                                    setState(() {});

                                                    lock = true;
                                                    _productNotRegistered =
                                                        false;
                                                    _productRegistered = false;

                                                    _selectedRowB = false;
                                                    _selectedRow = '';

                                                    print('p');
                                                    _selectedIndex = -1;
                                                    selectedCardKey = '';

                                                    _resetProductForm();
                                                  },
                                                  child: Text('Remove',
                                                      style: TextStyle(
                                                          fontFamily: 'Koulen',
                                                          fontSize: 15,
                                                          color:
                                                              Colors.white)))),
                                          Container(
                                              width: width * 0.11,
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
                                                                      4)))),
                                                  onPressed: () {
                                                    if (_ctrlSupplyProductName
                                                                .text ==
                                                            '' ||
                                                        _ctrlSupplyBarcode
                                                                .text ==
                                                            '' ||
                                                        _ctrlSupplyBuy.text ==
                                                            '' ||
                                                        _ctrlSupplySell.text ==
                                                            '' ||
                                                        ((double.tryParse(
                                                                    _ctrlSupplyQty
                                                                        .text) ==
                                                                null)
                                                            ? true
                                                            : (double.parse(
                                                                    _ctrlSupplyQty
                                                                        .text) <=
                                                                0)) ||
                                                        errorProductName !=
                                                            '' ||
                                                        errorProductBarcode !=
                                                            '' ||
                                                        errorProductBuy != '' ||
                                                        errorProductSell !=
                                                            '' ||
                                                        errorProductQty != '') {
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
                                                      if (_ctrlSupplyMRP.text ==
                                                              '' ||
                                                          errorProductMRP !=
                                                              '') {
                                                        setState(() {
                                                          errorProductMRP =
                                                              'This field is mandatory';
                                                        });
                                                      }
                                                      if (_ctrlSupplyBuy.text ==
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
                                                          errorProductSell !=
                                                              '') {
                                                        setState(() {
                                                          errorProductSell =
                                                              'This field is mandatory';
                                                        });
                                                      }
                                                      if (((double.tryParse(
                                                                  _ctrlSupplyQty
                                                                      .text) ==
                                                              null)
                                                          ? true
                                                          : (double.parse(
                                                                  _ctrlSupplyQty
                                                                      .text) <=
                                                              0))) {
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
                                                        print('1 x');
                                                      }

                                                      if (_productNotRegistered ==
                                                          true) {
                                                        print('2 x');
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
                                                                _ctrlSupplySell
                                                                    .text);
                                                        _product.MeasurementUnit =
                                                            '${_ctrlSupplyUnit.text}';
                                                        _ctrlSupplyMRP.text =
                                                            _ctrlSupplySell
                                                                .text;
                                                        ;
                                                        _registerProduct();
                                                        _onSubmit1();
                                                      }
                                                      if (_productNotRegistered ==
                                                              false &&
                                                          _productRegistered ==
                                                              false &&
                                                          lock == false) {
                                                        print('3 x');
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
                                                                _ctrlSupplySell
                                                                    .text);
                                                        _product.MeasurementUnit =
                                                            '${_ctrlSupplyUnit.text}';
                                                        _ctrlSupplyMRP.text =
                                                            _ctrlSupplySell
                                                                .text;

                                                        _registerProduct();
                                                        _onSubmit1();
                                                      }
                                                      if (_productNotRegistered ==
                                                              false &&
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
                                                        print('4 x');
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
                                                          fontFamily: 'Koulen',
                                                          fontSize: 15,
                                                          color:
                                                              Colors.white)))),
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
                    height: height * 0.385,
                    decoration: BoxDecoration(color: Colors.black, boxShadow: [
                      BoxShadow(
                        color: Colors.grey,

                        offset: Offset.zero, // Offset of the shadow
                        blurRadius: 6, // Spread or blur radius of the shadow
                        spreadRadius: 0, // How much the shadow should spread
                      )
                    ]),
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
                                  ? _ctrlProductSearch
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

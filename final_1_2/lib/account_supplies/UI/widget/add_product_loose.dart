import 'package:barcode1/account_inventory/model/inventory_model.dart';
import 'package:barcode1/account_inventory/operation/inventory_operation.dart';
import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/account_supplies/operation/operation_supplier.dart';
import 'package:barcode1/account_supplies/operation/operation_supply.dart';
import 'package:barcode1/database_helper/loose_database/loose_model.dart';
import 'package:barcode1/database_helper/loose_database/loose_operation.dart';
import 'package:barcode1/product_database/UI/widget/widget_product1.dart';
import 'package:barcode1/product_database/model/product_database_model.dart';
import 'package:barcode1/product_database/operation/operation_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'global_supply.dart' as globals;

import 'package:provider/provider.dart';

import 'package:barcode1/product_database/model/provider_model.dart';

class AddProductLoose extends StatefulWidget {
  const AddProductLoose({super.key});

  @override
  State<AddProductLoose> createState() => _AddProductLooseState();
}

class _AddProductLooseState extends State<AddProductLoose> {
  //////// BARCODE SCANNER

  String? _barcode;
  late bool visible;

  //// MAIN

  @override
  void initState() {
    super.initState();
    _refreshSupplyList(globals.addPurchaseDate, globals.SupplierId);
    //_refreshSupplierList();
    //8902442232587
    //_refreshBarcodeList();
    //_refreshSupplyList();
    //_refreshSupplyList1();

    productMap = globals.productMapL;

    _ctrlSupplyUnit.text = 'kg';

    if (productMap.isEmpty) {
      listNumber = 0;
    } else {
      listNumber = int.parse(globals.productMapL.entries.last.key);
    }
  }

  //// List in

  Map<String, String> product = {
    'barcode': '',
    'productName': '',
    'buy': '',
    'sell': '',
    'weight': '',
  };
  Map<String, Map<String, String>> productMap = {};

  int listNumber = 0;

  String productName = 'a1';

  int price = 0;
  int qty = 0;

  _productMap() {
    productMap['$listNumber'] = {
      'productName': '$productName',
      'price': '$price',
      'qty': '$qty'
    };
    setState(() {});

    print(productMap);
  }

  static List<Product> _entry = [];

  _onSubmit() async {
    String weight = '';
    _ctrlSupplyUnit.text == 'kg'
        ? _ctrlSupplyWeight.text =
            '${double.parse(_ctrlSupplyWeight.text).toDouble()}'
        : _ctrlSupplyWeight.text =
            '${double.parse(_ctrlSupplyWeight.text) / 1000}';

    _ctrlSupplyUnit.text == 'kg'
        ? _ctrlSupplyBuy.text =
            '${double.parse(_ctrlSupplyBuy.text).toDouble()}'
        : _ctrlSupplyBuy.text = '${double.parse(_ctrlSupplyBuy.text) * 1000}';

    _ctrlSupplyUnit.text == 'kg'
        ? _ctrlSupplySell.text =
            '${double.parse(_ctrlSupplySell.text).toDouble()}'
        : _ctrlSupplySell.text = '${double.parse(_ctrlSupplySell.text) * 1000}';
    listNumber += 1;
    productMap['$listNumber'] = {
      'barcode': '${_ctrlSupplyBarcode.text}',
      'productName': '${_ctrlSupplyProductId.text}',
      'buy': '${_ctrlSupplyBuy.text}',
      'sell': '${_ctrlSupplySell.text}',
      'weight': '${_ctrlSupplyWeight.text}',
      'doe': '${_selectedDateE}',
      'packing': 'l',
    };
    setState(() {});
    // print(productMap);
    _globalMap();
  }

  _onSubmit1() async {
    String weight = '';
    _ctrlSupplyUnit.text == 'kg'
        ? _ctrlSupplyWeight.text =
            '${double.parse(_ctrlSupplyWeight.text).toDouble()}'
        : _ctrlSupplyWeight.text =
            '${double.parse(_ctrlSupplyWeight.text) / 1000}';

    _ctrlSupplyUnit.text == 'kg'
        ? _ctrlSupplyBuy.text =
            '${double.parse(_ctrlSupplyBuy.text).toDouble()}'
        : _ctrlSupplyBuy.text = '${double.parse(_ctrlSupplyBuy.text) * 1000}';

    _ctrlSupplyUnit.text == 'kg'
        ? _ctrlSupplySell.text =
            '${double.parse(_ctrlSupplySell.text).toDouble()}'
        : _ctrlSupplySell.text = '${double.parse(_ctrlSupplySell.text) * 1000}';
    int same = 0;
    if (productMap.isEmpty) {
      listNumber += 1;
      productMap['$listNumber'] = {
        'barcode': '${_ctrlSupplyBarcode.text}',
        'productName': '${_ctrlSupplyProductId.text}',
        'buy': '${_ctrlSupplyBuy.text}',
        'sell': '${_ctrlSupplySell.text}',
        'weight': '${_ctrlSupplyWeight.text}',
        'doe': '${_selectedDateE}',
        'packing': 'l',
      };
      _globalMap();
    } else {
      for (var i in productMap.entries) {
        if (i.value['barcode'] == _ctrlSupplyBarcode.text) {
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
        productMap['$editKey'] = {
          'barcode': '${_ctrlSupplyBarcode.text}',
          'productName': '${_ctrlSupplyProductId.text}',
          'buy': '${_ctrlSupplyBuy.text}',
          'sell': '${_ctrlSupplySell.text}',
          'weight': '${_ctrlSupplyWeight.text}',
          'doe': '${_selectedDateE}',
          'packing': 'l',
        };
      } else {}
    } else {
      listNumber += 1;
      productMap['$listNumber'] = {
        'barcode': '${_ctrlSupplyBarcode.text}',
        'productName': '${_ctrlSupplyProductId.text}',
        'buy': '${_ctrlSupplyBuy.text}',
        'sell': '${_ctrlSupplySell.text}',
        'weight': '${_ctrlSupplyWeight.text}',
        'doe': '${_selectedDateE}',
        'packing': 'l',
      };
    }
    _globalMap();
  }

  double totalAmount = 0;
  int totalProducts = 0;

  _globalMap() {
    globals.productMapL = productMap;
    globals.totalAmountL += double.parse(_ctrlSupplyBuy.text) *
        double.parse(_ctrlSupplyWeight.text);
    setState(() {});

    totalAmount += double.parse(_ctrlSupplyBuy.text) *
        double.parse(_ctrlSupplyWeight.text);

    totalProducts = productMap.length;
  }

  // togglle button
  // one must always be true, means selected.
  List<bool> isSelected = [true, false];

  String _unitSelected = 'kg';

  _selectUnit() {
    if (isSelected[0] == true) {
      _unitSelected = 'kg';
    } else {
      _unitSelected = 'gm';
      //_refreshUnit();
    }
    setState(() {});
  }

  /// Generate barcode
  String lastBarcode = '';
  final _dbSupplierLoose = LooseOperation();
  Loose _loose = Loose();
  static List<Loose> _looses = [];

  _generateBarcode1() async {
    List<Loose> x = await _dbSupplierLoose.fetchLoose();

    // lastBarcode = x.last.barcode!;

    if (_ctrlSupplyProductId.text.isNotEmpty) {
      if (x.isEmpty) {
        _loose.name = _ctrlSupplyProductId.text;
        _loose.barcode = '11111111111';
        await _dbSupplierLoose.insertLoose(_loose);
        print('sample');
      } else {
        _loose.name = _ctrlSupplyProductId.text;
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
    //print('${x.last.name}, ${x.last.barcode}');
    _ctrlSupplyBarcode.text = x.last.barcode!;
 //   _supply.barcode = x.last.barcode;
   // _supply.productName = x.last.name;

    _inventory.barcode = x.last.barcode;
    _inventory.productName = x.last.name;
  }

  //// SUPPLIER

  Supplier _supplier = Supplier();

  static List<Supplier> _suppliers = [];

  final _dbSupplier = SupplierOperation();

  // SEARCH BAR
  static List<Supplier> display_list_supplier = List.from(_suppliers);

  void updateListSupplier(String value) {
    setState(() {
      display_list_supplier = _suppliers
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  _refreshSupplierList() async {
    List<Supplier> x = await _dbSupplier.fetchSupplier();
    setState(() {
      _suppliers = x;
      display_list_supplier = x;
      //globals.x = x;
    });
  }

  //// SUPPLY
  ///

  Supply _supply = Supply();

  static List<Supply> _supplys = [];

  Inventory _inventory = Inventory();

  static List<Inventory> _inventorys = [];

  static List<Supply> display_list1 = List.from(_supplys);

  final _dbHelperE3 = SupplyOperation();
  final _dbHelperE4 = InventoryOperation();

  /*_refreshSupplyList() async {
    List<Supply> k = await _dbHelperE3.fetchSupply();
    setState(() {
      _supplys = k;
      display_list1 = k;
    });
  }*/

  _refreshSupplyList(String d, int s) async {
    final List<int> t = globals.supplier;
    //final List<String> t1 = t.map((number) => number.toString()).toList();
    List<Supply> x = await _dbHelperE3.fetchSupply3(d, s);
    setState(() {
      print('hi');

      if (x.isNotEmpty) {
        _supplys = x;
        display_list1 = x;
     //   print(x[0].productName);
        print('hhh');
      } else {
        print('eeee');
      }
      //_generateList();
      //globals.x = x;
    });
  }

  final _formKeySupply = GlobalKey<FormState>();

  final _ctrlSupplySupplierId = TextEditingController();
  final _ctrlSupplyDate = TextEditingController();
  final _ctrlSupplyBarcode = TextEditingController();
  var _ctrlSupplyProductId = TextEditingController();

  final _ctrlSupplyBuy = TextEditingController();
  final _ctrlSupplySell = TextEditingController();
  final _ctrlSupplyWeight = TextEditingController();

  _resetFormSupply() {
    setState(() {
      _formKeySupply.currentState!.reset();
      _supply.id = null;

   /*   _supply.barcode = null;
      _supply.productName = null;

      _selectedDateE = '';

      _supply.buy = null;
      _supply.sell = null;
      _supply.weight = null;*/

      _ctrlSupplyBarcode.text = ' ';
      _ctrlSupplyProductId.text = ' ';

      _ctrlSupplyBuy.text = ' ';
      _ctrlSupplySell.text = ' ';
      _ctrlSupplyWeight.text = ' ';
    });
  }

  _resetFormInventory() {
    setState(() {
      _formKeySupply.currentState!.reset();
      _inventory.id = null;

      _inventory.barcode = null;
      _inventory.productName = null;

      _inventory.buy = null;
      _inventory.sell = null;
      _inventory.weight = null;
    });
  }

  int index1 = 0;

 /* _showForEditSupply(index) {
    setState(() {
      _supply = _supplys[index];
      _ctrlSupplyDate.text = _supplys[index].date!;
      _ctrlSupplySupplierId.text = _supplys[index].supplierId!;
      _ctrlSupplyBarcode.text = _supplys[index].barcode!;
      _ctrlSupplyProductId.text = _supplys[index].productName!;
      _ctrlSupplyWeight.text = _supplys[index].weight!;
      _ctrlSupplyBuy.text = _supplys[index].buy!;
      _ctrlSupplySell.text = _supplys[index].sell!;
    });
  }*/

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

  _refreshProductList(String x) async {
    //int x1 = int.parse(x);
    try {
      List<Product> z = await _dbHelperE2.fetchProduct1(x);
      z1 = z[0].Name;
      setState(() {
        _inventory.productName = z1;
       // _supply.productName = z1;
        _ctrlSupplyProductId.text = z1;
        _ctrlSupplyBarcode.text = z1;
      });
    } on RangeError {
      globals.b = x;

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => const ProductWidget1(),
      );

      print('object1');
    }
//print(x.toString());
    //return z[0].Name;

    setState(() {
      //_products = z;
      /*if (z[0].Name == null){
        print('error');
      }else{
      z1 = _products[0].Name;}*/

      //print(z[0].Name);

      _ctrlSupplyBarcode.text = x;
      //_supply.barcode = x;

      _inventory.barcode = x;

      //
    });
  }

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

        print(d);

        //globals.chooseDate = ;
        //_selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
    } else {
      _selectedDateE = '';
    }
  }

  var _ctrlSupplyProductName = TextEditingController();
  final _ctrlSupplyQty = TextEditingController();

  final _ctrlSupplyDOE = TextEditingController();

  final _ctrlSupplyMRP = TextEditingController();
  final _ctrlSupplyUnit = TextEditingController();

  //final _ctrlSupplyUnit = TextEditingController();

  int id = 0;
  var oo;

  _submitInventory() async {
    List<Inventory> k = await _dbHelperE4.fetchInventory();

    //print(productMap);
    for (var i in productMap.entries) {
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
            '${int.parse(i.value['weight']!) + int.parse(k.where((element) => element.barcode!.toLowerCase().contains('${i.value['barcode']!}')).toList()[0].weight!)}';
        //_inventory.DOE = '${i.value['doe']}';

        if (_inventory.id == null) {
          print('added');
          await _dbHelperE4.insertInventory(_inventory);
        } else {
          await _dbHelperE4.updateInventory(_inventory);
        }
        //_inventory.id == null;
        setState(() {
          _resetFormInventory();
        });
      } else {
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
          _resetFormInventory();
        });
      }
    }

    //_resetFormInventory();
  }

  TextEditingController searchController = TextEditingController();

  final ScrollController controller = ScrollController();

  String _selectedRow = '';
  bool _selectedRowB = false;

  _editMap(String x) {
    //print('${x}');

    _ctrlSupplyProductId.text = productMap[x]!['productName']!;
    _ctrlSupplyBarcode.text = productMap[x]!['barcode']!;
    // _ctrlSupplyQty.text = productMap[x]!['qty']!;
    _ctrlSupplyBuy.text =
        double.parse(productMap[x]!['buy']!).toInt().toString();
    _ctrlSupplySell.text =
        double.parse(productMap[x]!['sell']!).toInt().toString();
    _ctrlSupplyWeight.text =
        double.parse(productMap[x]!['weight']!).toInt().toString();
    _ctrlSupplyDOE.text = productMap[x]!['doe']!;
    //_ctrlSupplyMRP.text = productMap[x]!['mrp']!;

    editKey = x;
  }

  String editKey = '';

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
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          const Text('Total amount',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 72, 72, 73),
                                  fontSize: 13,
                                  fontFamily: 'Bangla',
                                  fontWeight: FontWeight.bold)),
                          Text(
                            '${totalAmount}',
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
                            '${totalProducts}',
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
                                    onSelectChanged: (value) {
                                      setState(() {
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
                                      });
                                    },
                                    selected: _selectedRow ==
                                            element.value['barcode']!
                                        ? true
                                        : false,
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

  bool lock = true;
  int _selectedIndex = -1;
  String selectedCardKey = '';

  Widget card1(
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
                                          '${weight}',
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

            ///
            ///
          }
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

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  
  FocusNode _productName = FocusNode();
  FocusNode _productBarcode = FocusNode();

  
  FocusNode _productWeight = FocusNode();
 

 
  FocusNode _productBuy = FocusNode();
  FocusNode _productSell = FocusNode();

  
  String errorProductName = '';
  String errorProductBarcode = '';
 
  String errorProductWeight = '';
 

 
  String errorProductBuy = '';
  String errorProductSell = '';

  String text = '';

  
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
                                                  height: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: const Text(
                                                    'Weight',
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
                            itemCount: globals.productMapL.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (globals.productMapL.isNotEmpty) {
                                return card1(
                                    height,
                                    width,
                                    globals.productMapL.keys.elementAt(index),
                                    globals.productMapL.values
                                        .elementAt(index)['productName']!
                                        .toUpperCase(),
                                    globals.productMapL.values
                                        .elementAt(index)['barcode']!
                                        .toUpperCase(),
                                    globals.productMapL.values
                                        .elementAt(index)['weight']!
                                        .toUpperCase(),
                                    globals.productMapL.values
                                        .elementAt(index)['buy']!
                                        .toUpperCase(),
                                    globals.productMapL.values
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
                               // width: double.infinity,
                                margin: const EdgeInsets.only(
                                    bottom: 5, top: 5, left: 5, right: 5),
                                padding: EdgeInsets.only(bottom: 5),
                                child: Column(
                                  children: [
                                    //productName
                                    Container(
                                      height: height * 0.1,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          bottom: 5, top: 0),
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
                                            width: double.infinity,
                                            height: height * 0.048,
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
                                              //focusNode: _focusNodeProduct,
                                              readOnly:
                                                          true, // Prevent system keyboard
                                                      showCursor: false,
                                                      focusNode: _productName,
                                              controller:
                                                  _ctrlSupplyProductId,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'BanglaBold',
                                                  fontSize: 16),
                                              cursorColor: Colors.black,

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
                                   
                                   //barcode
                                    Container(
                                      height: height * 0.1,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          bottom: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: double.infinity,
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
                                                    width:
                                                        double.infinity,
                                                    height: height * 0.048,
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
                                                          
                                                      //focusNode: _focusNodeProduct,
                                                      enabled: false,
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

                                                      //enabled: !lock,

                                                      decoration:
                                                          const InputDecoration(
                                                        //prefixIcon: Icon(Icons.person),
                                                        //prefixIconColor: Colors.black,
                                                        disabledBorder: UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
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
                                                      errorProductBarcode,
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
                                          Container(
                                            height: double.infinity,
                                            width: width * 0.08,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: height * 0.022,
                                                  //color: Colors.white,
                                                  padding:
                                                      const EdgeInsets
                                                              .only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 0,
                                                          bottom: 0),
                                                  child: const Text('',
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
                                                    width: double
                                                        .infinity,
                                                        height: height * 0.048,
                                                    decoration:
                                                        BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                                  5),
                                                      color:
                                                          Colors.black,
                                                    ),
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            left: 0,
                                                            right: 5,
                                                            top: 0,
                                                            bottom: 0),
                                                    margin:
                                                        const EdgeInsets
                                                                .only(
                                                            left: 10,
                                                            right: 0,
                                                            top: 0,
                                                            bottom: 0),
                                                    child: TextButton(
                                                        onPressed: () {
                                                          _generateBarcode1();
                                                        },
                                                        child: Text(
                                                          'Generate',
                                                          style:
                                                              TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontFamily:
                                                                'BanglaBold',
                                                            fontSize:
                                                                12,
                                                          ),
                                                        ))),
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
                                                    
                                                  ),
                                             
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                 
                                 //weight
                                    Container(
                                      height: height * 0.1,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          bottom: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: double.infinity,
                                              // width: width*0.08

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
                                                    height: height * 0.048,
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
                                                      focusNode: _productWeight,
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

                                                      //enabled: !lock,

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
                                                      errorProductWeight,
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
                                          Container(
                                            height: double.infinity,
                                            width: width * 0.04,
                                            margin: const EdgeInsets.only(
                                                left: 10,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: height * 0.022,
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
                                                Expanded(
                                                  child: Container(
                                                     width:
                                                    double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(3),
                                                        color:  Colors.black
                                                            
                                                      ),
                                                      alignment: Alignment.center,
                                                      margin: const EdgeInsets.only(left: 0, right: 2),
                                                      padding: const EdgeInsets.only(bottom: 0),
                                                      child:  
                                                            Text(
                                                          'Kg',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 11,
                                                              fontFamily: 'BanglaBold',
                                                              fontWeight: FontWeight.bold),
                                                        ),),
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
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,

                                    margin: const EdgeInsets.only(
                                        bottom: 5, top: 0, left: 5, right: 5),
                                    padding: EdgeInsets.only(top: 5),
                                    //color: Colors.white,
                                    //height: height*0.3,
                                    child: Column(
                                      children: [
                                        //doe
                                        Container(
                                          height: height * 0.1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 5, top: 15),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: height * 0.022,
                                                //color: Colors.white,
                                                padding: const EdgeInsets.only(
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
                                                      fontFamily: 'BanglaBold',
                                                      //fontWeight: FontWeight.w100
                                                    )),
                                              ),
                                              InkWell(
                                                child: Container(
                                                  height: height * 0.048,
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets
                                                                .only(
                                                            left: 10,
                                                            right: 5,
                                                            top: 5,
                                                            bottom: 0),
                                                    margin: const EdgeInsets
                                                            .only(
                                                        left: 0,
                                                        right: 0,
                                                        top: 2,
                                                        bottom: 0),
                                                    decoration:
                                                        BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(3),
                                                      color: Colors.white,
                                                    ),
                                                    child: Text(
                                                      _selectedDateE,
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black,
                                                          fontFamily:
                                                              'BanglaBold',
                                                          fontSize: 16),
                                                    )),
                                             
                                             onTap: () {
                                               _selectDateE(context);
                                             },
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
                                                    
                                                  ),
                                        
                                            ],
                                          ),
                                        ),
                                       
                                       //buy and sell
                                        Container(
                                          height: height * 0.1,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(
                                              bottom: 5, top: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  // width: width*0.08
                                                  margin: const EdgeInsets.only(
                                                      left: 0,
                                                      right: 8,
                                                      top: 0,
                                                      bottom: 0),

                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: height * 0.022,
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
                                                        height: height * 0.048,
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
                                                      focusNode: _productBuy,
                                                          //focusNode: _focusNodeProduct,
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
                                                      errorProductBuy,
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
                                              Expanded(
                                                child: Container(
                                                  height: double.infinity,
                                                  // width: width * 0.08,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: height * 0.022,
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
                                                        height: height * 0.048,
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
                                                      focusNode: _productSell,
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
                                                      errorProductSell,
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
                                    margin: const EdgeInsets.only(
                                        bottom: 0, top: 22, left: 5, right: 0),
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
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.black),
                                                      shape: MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      5)))),
                                                  onPressed: () async {
                                                    if (_selectedRowB == true) {
                                                      globals.productMapL
                                                          .remove(
                                                              selectedCardKey);
                                                    }
                                                    setState(() {});
                                                    _resetFormSupply();
                                                  },
                                                  child: Text('Remove',
                                                      style: TextStyle(
                                                          fontFamily: 'BanglaBold',
                                                          fontSize: 14,
                                                          color: Colors.white)))),
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
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.black),
                                                      shape: MaterialStatePropertyAll(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      5)))),
                                                  onPressed: () {


                                                    if (_ctrlSupplyProductId
                                                                  .text ==
                                                              '' ||
                                                          _ctrlSupplyBarcode.text ==
                                                              '' ||
                                                         
                                                          _ctrlSupplyBuy.text ==
                                                              '' ||
                                                          _ctrlSupplySell
                                                                  .text ==
                                                              '' ||
                                                          _ctrlSupplyWeight.text ==
                                                              '') {
                                                        if (_ctrlSupplyProductId
                                                                .text ==
                                                            '') {
                                                          setState(() {
                                                            errorProductName =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplyBarcode
                                                                .text ==
                                                            '') {
                                                          setState(() {
                                                            errorProductBarcode =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplyWeight
                                                                .text ==
                                                            '') {
                                                          setState(() {
                                                            errorProductWeight =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        
                                                        if (_ctrlSupplyBuy
                                                                .text ==
                                                            '') {
                                                          setState(() {
                                                            errorProductBuy =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                        if (_ctrlSupplySell
                                                                .text ==
                                                            '') {
                                                          setState(() {
                                                            errorProductSell =
                                                                'This field is mandatory';
                                                          });
                                                        }
                                                       
                                                      } else {



                                                    if (_selectedRowB == true) {
                                                      _onSubmit1();
                                                      _resetFormSupply();
                                                      _selectedRowB = false;
                                                      _selectedRow = '';
                                                    } else {
                                                      _onSubmit1();
                                                      _resetFormSupply();
                                                    }}
                                                  },
                                                  child: Text('Add',
                                                      style: TextStyle(
                                                          fontFamily: 'BanglaBold',
                                                          fontSize: 14,
                                                          color: Colors.white)))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
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
                              
                                   _productName.hasFocus
                                      ? _ctrlSupplyProductId
                                      : _productBarcode.hasFocus
                                          ? _ctrlSupplyBarcode
                                          
                                              : _productWeight.hasFocus
                                                  ? _ctrlSupplyWeight
                                                  
                                                      : _productBuy.hasFocus
                                                          ? _ctrlSupplyBuy
                                                          : _productSell
                                                                  .hasFocus
                                                              ? _ctrlSupplySell
                                                              
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

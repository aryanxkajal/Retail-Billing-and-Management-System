import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:animations/animations.dart';

import 'package:barcode1/account_supplies/UI/widget/choose_supplier(1).dart';
import 'package:barcode1/account_supplies/UI/widget/supplies_dashboard.dart';
import 'package:barcode1/account_supplies/model/model_test.dart';
import 'package:barcode1/shop/operations/operation_store.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../../account_inventory/model/inventory_model.dart';
import '../../../account_inventory/operation/inventory_operation.dart';
import '../../model/model_supplier.dart';
import '../../model/model_supply.dart';
import '../../model/model_transaction.dart';
import '../../operation/operation_supplier.dart';
import '../../operation/operation_supply.dart';

import '../../operation/operation_test.dart';
import '../../operation/operation_transaction.dart';
import 'global_supply.dart' as globals;

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

import '../../../global.dart' as globals;

class SuppliesPage1 extends StatefulWidget {
  const SuppliesPage1({super.key});

  @override
  State<SuppliesPage1> createState() => _SuppliesPage1State();
}

class _SuppliesPage1State extends State<SuppliesPage1>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _mapTest(true);
    _refreshContactList();

    _refreshTListAll();
    _fetchCustomer();
    
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method to avoid memory leaks

    super.dispose();
  }

  _updateSupplier() async {
    if (_supplier.id == null) {
      //_contacts('add');
      // _supplier.contactId = await _contacts('add');

      await _dbHelper1.insertSupplier(_supplier);
    } else {
      await _dbHelper1.updateSupplier(_supplier);
      // _contacts('update');
    }
    _refreshContactList();
    _resetSupplierForm();
    _selectedIndex = -1;
    _tileSelected = false;
    _supplierCardEdit = false;
    _editCardManager('', '', '', '');
    addVendor = false;
    editVendor = false;
    //contactId = '';
  }

  Contact _contact = Contact();

  //Phone _phone = Phone();

  Future<String> _contacts(String x) async {
    List<Supplier> k = await _dbHelper1.fetchSupplier();

    String contactId = '';

    for (var i in k) {
      print(i.name);
      print(i.contactId);
    }

    if (await FlutterContacts.requestPermission()) {
      //List<Contact> contacts = await FlutterContacts.getContacts(withAccounts : true, withPhoto: false, withThumbnail: false);

      if (x == 'add') {
        // Insert new contact
        final newContact = Contact()
          ..name.first = _supplier.name!
          ..phones = [Phone(_supplier.phone!)];
        Contact xx = await newContact.insert();
        contactId = xx.id;

        // print(x.id);
      }

      if (x == 'update') {
        Contact? contact = await FlutterContacts.getContact(
            _supplier.contactId!,
            withAccounts: true);

        contact?.name.first = _supplier.name!;
        contact?.phones = [Phone(_supplier.phone!)];
        await contact?.update();
        // Update contact
      }
    } else {
      print('no connection');
    }
    return contactId;
  }

  Map<String, Map<String, String>> productMa1 = {};
  final _dbHelperT1 = SupplyOperation();

  List<Supply> _supplyAll = [];

  List<Transaction1> _transactionAll = [];

  List<Supply> _supplyAllFilter = [];

  bool loading = false;

  _mapTest(bool x) async {
    loading = true;
    List<Supply> k = await _dbHelperT1.fetchSupply();

    loading = false;
    if (!mounted) return;
    setState(() {});

    _supplyAll = k;

    if (x) {
      _filter(supplierF, packingF, dateF, statusF, customOrderF);
    }
  }

  //////////////////VENDOR///////////////////
  //////////////////VENDOR///////////////////
  //////////////////VENDOR///////////////////
  //////////////////VENDOR///////////////////
  //////////////////VENDOR///////////////////

  final _dbHelper1 = SupplierOperation();

  Supplier _supplier = Supplier();

  int _selectedIndex = -1;
  TextEditingController searchController = TextEditingController();

  static List<Supplier> _suppliers = [];
  static List<Supplier> display_list_supplier = List.from(_suppliers);
  static List<Supplier> _searchResultSupplier = [];
  static List<Supplier> _searchResultSupplier0 = [];

  bool _showSearchResults = false;

  bool _tileSelected = false;

  bool _onFirstPage = true;

  bool addVendor = false;

  bool _supplierCardEdit = false;

  //// FETCH SUPPLIER LIST
  _refreshContactList() async {
    List<Supplier> x = await _dbHelper1.fetchSupplier();
    //x.sort((a, b) => a.name!.compareTo(b.name!));
    if (!mounted) return;
    setState(() {
      _suppliers = x;

      display_list_supplier = x;
      _searchResultSupplier = x;
      _searchResultSupplier0 = x;
      //globals.x = x;
    });
  }

  //// SUPPLIER SEARCH
  void updateList(String value) {
    setState(() {
      _searchResultSupplier = display_list_supplier
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  ///////////////// SUPLIER

  ///////////////// SUPPLY /////////////////////////
  ///////////////// SUPPLY /////////////////////////
  ///////////////// SUPPLY /////////////////////////
  ///////////////// SUPPLY /////////////////////////

  final _dbHelperE3 = SupplyOperation();

  Supply _supply = Supply();

  List<Supply> _supplyList = [];

  List<Supply> _supplyAddPayment = [];

  List<String> date = [];
  List<String> dateL = [];
  List<String> pack = [];

  List<String> dateTest = ['1', '2', '3'];

  static List<Supply> display_list1 = [];
  static List<Supply> display_list_p = [];
  static List<Supply> display_list_l = [];

  Map<String, List<Supply>> map = {};

  Map<String, Map<String, String>> productMapE = {};

  int _selectedIndexSupply = -1;

  double selectedSupplyTotal = 0;

  bool _plus = false;
  bool _transaction = false;

  bool order = false;
  bool transaction = false;

  bool _showSupplyCardSelected = false;
  bool _showSupplyCardShowDetails = false;

  List<Supply> xxxyyy = [];

  List<Transaction1> xxxyyyT = [];

  _refreshSupplyListAll() async {
    List<Supply> k = await _dbHelperE3.fetchSupply();

    date = [];
    map = {};
    pack = [];
    _supplyList = k;
    xxxyyy = k;
    setState(() {});
    _refreshSupplyListAll1();
    // _filter(supplierF, statusF, '6month', packingF, customOrderF);

    // _date(k);
  }

  _refreshSupplyListAll1() {
    _filter('', packingF, dateF, statusF, customOrderF);
  }

  _refreshTListAll() async {
    loading = true;
    List<Transaction1> k = await _dbHelperT.fetchTransaction();

    loading = false;
    if (!mounted) return;
    setState(() {});

    date = [];
    map = {};
    pack = [];

    xxxyyyT = k;
    _transactionAll = k;

    _filter(supplierF, packingF, dateF, statusF, customOrderF);

    // _date(k);
  }

  _refreshSupplyListX(int s) async {
    List<Supply> k = await _dbHelperE3.fetchSupplySupplier(s);

    date = [];
    map = {};
    pack = [];
    _supplyList = k;

    _date(k);
  }

  _date(List<Supply> k) {
    //List<String> date = [];

    for (var i in k) {
      //print(i.date);
      if (map.containsKey(i.date)) {
        map[i.date!]!.add(i);
      } else {
        date.add(i.date!);
        pack.add(i.packing!);

        map[i.date!] = [];
        map[i.date!]!.add(i);
      }
    }
    //print(map);
    setState(() {});
  }

  ///////////update delivery status/////////////////////

  _updateDeliveryStatus(int index) async {
    await _dbHelperE3.updateSupply(_supply);
    _supply = Supply();
    _mapTest(true);
    //_submitInventory(index);
    _updateDeliveryInventory(index);
  }

  _updateDeliveryInventory(int index) async {
    List<Inventory> k = await _dbHelperI.fetchInventory();

    Map<String, Map<String, String>> produc = await _returnMap(index);

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
              '(${j.productName}, ${j.qty})( ${i.value['productName']}, ${i.value['qty']})');
          _inventory = j;

          _inventory.qty =
              (double.parse(j.qty!) + double.parse(i.value['qty']!)).toString();
          _inventory.buy = '${((buy * qty + buy1 * qty1) / (qty + qty1))}';
          await _dbHelperI.updateInventory(_inventory);
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

        _inventory.supplierId = _supplyAllFilter[index].supplierId!;
        _inventory.date = DateTime.now().toString();
        _inventory.weightLoose = '0';

        await _dbHelperI.insertInventory(_inventory);
        _inventory = Inventory();
      }
    }
  }

  _deleteSupply() {
    _dbHelperE3.deleteSupply(_supply.id!);
    _refreshSupplyListX(globals.SupplierId);
  }

  void _selectTile(int index) {
    if (_selectedIndex == index) {
      _selectedIndex = -1;
      _tileSelected = false;
      _onFirstPage = true;
      addVendor = false;

      map = {};
      date = [];

      _searchResultT = [];

      // _refreshSupplyListAll();
      _filter('', packingF, dateF, statusF, customOrderF);
    } else {
      _filter(_searchResultSupplier[index].id!.toString(), packingF, dateF,
          statusF, customOrderF);

      // _refreshSupplyListX(_searchResultSupplier[index].id!);
      globals.SupplierId = _searchResultSupplier[index].id!;
      //  _refreshTransactiontList(_searchResultSupplier[index].id!);
      if (addVendor) {
        _selectedIndex = index;
        _tileSelected = false;
        _onFirstPage = false;
      } else {
        _selectedIndex = index;
        _tileSelected = true;
        _onFirstPage = false;
      }
    }
    setState(() {});
  }

/*
  Widget supplierCard(
      int index, double height, double width, BuildContext context) {
    return !(_selectedIndex == index && _supplierCardEdit != false)
        ? Card(
            elevation: 0,
            color: _selectedIndex != index ? Colors.white : Colors.black,
            margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
            //   elevation: _selectedIndex != index ? 0 : 5,
            child: InkWell(
                child: Container(
                    height: 74,
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    //  margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      //  color: _selectedIndex != index ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),

                    //padding: EdgeInsets.only(top: 10),

                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          margin: EdgeInsets.only(right: 10, left: 10),
                          alignment: Alignment.center,
                          child: Text(
                            _searchResultSupplier[index].name![0].toUpperCase(),
                            style: TextStyle(
                                color: _selectedIndex != index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20,
                                fontFamily: 'BanglaBold'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    capitalizeFirstLetterOfEachWord(
                                        '${_searchResultSupplier[index].name!}'),
                                    style: TextStyle(
                                      fontFamily: 'BanglaBold',
                                      fontSize: 20,
                                      color: _selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${_searchResultSupplier[index].phone!}',
                                    style: TextStyle(
                                      //fontFamily: 'Koulen',
                                      fontSize: 15,
                                      color: _selectedIndex == index
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  globals.mainSupplier = index;
                  globals.SupplierId = _searchResultSupplier[index].id!;
                  _selectTile(index); // Update selected index

                  setState(() {});

                  _editCardManager(
                    _searchResultSupplier[index].name!,
                    _searchResultSupplier[index].phone!,
                    _searchResultSupplier[index].address!,
                  );

                  date = [];
                  map = {};

                  // Update selected index
                }),
          )
        : Card(
            color: Color.fromRGBO(244, 244, 244, 1),
            elevation: 0,
            child: InkWell(
                child: Container(
                    height: height * 0.45,
                    width: double.infinity,
                    padding: const EdgeInsets.only(bottom: 0, top: 7),
                    margin: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(244, 244, 244, 1),
                    ),

                    //padding: EdgeInsets.only(top: 10),

                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 55,
                            height: 55,
                            // width: double.infinity,
                            //height: double.infinity,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                            margin: EdgeInsets.only(right: 10, left: 10),
                            alignment: Alignment.center,
                            child: Text(
                              'a',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Koulen'),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.07,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 5, top: 25),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: height * 0.022,
                                //color: Colors.white,
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 0, bottom: 0),
                                child: const Text('Enter Vendor Name*',
                                    style: TextStyle(
                                      color: Color.fromARGB(238, 72, 72, 73),
                                      fontSize: 13,
                                      fontFamily: 'BanglaBold',
                                      //fontWeight: FontWeight.w100
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  //height: height * 0.04,
                                  //color: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 0, bottom: 0),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 2, bottom: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    //focusNode: _focusNodeProduct,
                                    controller: _ctrlSupplierName,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'BanglaBold',
                                        fontSize: 16),
                                    cursorColor: Colors.black,

                                    //enabled: !lock,

                                    decoration: const InputDecoration(
                                      //prefixIcon: Icon(Icons.person),
                                      //prefixIconColor: Colors.black,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

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
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.07,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: height * 0.022,
                                //color: Colors.white,
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 0, bottom: 0),
                                child: const Text('Phone',
                                    style: TextStyle(
                                      color: Color.fromARGB(238, 72, 72, 73),
                                      fontSize: 13,
                                      fontFamily: 'BanglaBold',
                                      //fontWeight: FontWeight.w100
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  //height: height * 0.04,
                                  //color: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 0, bottom: 0),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 2, bottom: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    //focusNode: _focusNodeProduct,
                                    controller: _ctrlSupplierPhone,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'BanglaBold',
                                        fontSize: 16),
                                    cursorColor: Colors.black,

                                    //enabled: !lock,

                                    decoration: const InputDecoration(
                                      //prefixIcon: Icon(Icons.person),
                                      //prefixIconColor: Colors.black,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

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
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.07,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 5, top: 10),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: height * 0.022,
                                //color: Colors.white,
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 0, bottom: 0),
                                child: const Text('Address',
                                    style: TextStyle(
                                      color: Color.fromARGB(238, 72, 72, 73),
                                      fontSize: 13,
                                      fontFamily: 'BanglaBold',
                                      //fontWeight: FontWeight.w100
                                    )),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  //height: height * 0.04,
                                  //color: Colors.black,
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 0, bottom: 0),
                                  margin: const EdgeInsets.only(
                                      left: 0, right: 0, top: 2, bottom: 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    //focusNode: _focusNodeProduct,
                                    controller: _ctrlSupplierAddress,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'BanglaBold',
                                        fontSize: 16),
                                    cursorColor: Colors.black,

                                    //enabled: !lock,

                                    decoration: const InputDecoration(
                                      //prefixIcon: Icon(Icons.person),
                                      //prefixIconColor: Colors.black,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),

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
                            ],
                          ),
                        ),
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
                                        left: 5, right: 5, top: 5, bottom: 0),
                                    height: double.infinity,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)))),
                                        onPressed: () async {
                                          if (addVendor == false) {
                                            await _dbHelper1.deleteSupplier(
                                                _searchResultSupplier[index]
                                                    .id!);
                                            _refreshContactList();
                                            _resetSupplierForm();
                                            _selectedIndex = -1;
                                            _tileSelected = false;
                                            _supplierCardEdit = false;
                                            _editCardManager('', '', '');
                                            addVendor = false;
                                            setState(() {});
                                          } else {
                                            _resetSupplierForm();
                                            _selectedIndex = -1;
                                            _tileSelected = false;
                                            _supplierCardEdit = false;
                                            _onFirstPage = true;
                                            _editCardManager('', '', '');
                                            addVendor = false;
                                            _searchResultSupplier.removeAt(0);
                                          }
                                          //_resetFormSupply();}
                                        },
                                        child: Text('Delete',
                                            style: TextStyle(
                                                fontFamily: 'BanglaBold',
                                                fontSize: 14,
                                                color: Colors.white)))),
                              ),
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(
                                        left: 5, right: 0, top: 5, bottom: 0),
                                    height: double.infinity,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                            shape: MaterialStatePropertyAll(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)))),
                                        onPressed: () {
                                          if (addVendor == true) {
                                            _supplier.name =
                                                _ctrlSupplierName.text;
                                            _supplier.phone =
                                                _ctrlSupplierPhone.text;
                                            _supplier.address =
                                                _ctrlSupplierAddress.text;
                                            _updateSupplier();
                                            //_resetFormSupply();
                                          } else {
                                            _supplier.id =
                                                _searchResultSupplier[index].id;
                                            _supplier.name =
                                                _ctrlSupplierName.text;
                                            _supplier.phone =
                                                _ctrlSupplierPhone.text;
                                            _supplier.address =
                                                _ctrlSupplierAddress.text;
                                            _updateSupplier();
                                          }
                                        },
                                        child: Text('Done',
                                            style: TextStyle(
                                                fontFamily: 'BanglaBold',
                                                fontSize: 14,
                                                color: Colors.white)))),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                onTap: () {
                  if (addVendor == true) {
                    _selectedIndex = -1;
                    _tileSelected = false;
                    _supplierCardEdit = false;
                    _editCardManager('', '', '');
                    addVendor = false;
                    _onFirstPage = !_onFirstPage;

                    _searchResultSupplier.removeAt(0);
                  } else {
                    _onFirstPage = !_onFirstPage;
                    _selectedIndex = -1;
                    _tileSelected = false;
                    _supplierCardEdit = false;
                    _editCardManager('', '', '');
                    addVendor = false;
                  }

                  // Update selected index
                }),
          );
  }
*/
  _editCardManager(
      String name, String phone, String address, String contactId) {
    _ctrlSupplierName.text = name;
    _ctrlSupplierPhone.text = phone;
    _ctrlSupplierAddress.text = address;
    _ctrlSupplierContactId.text = contactId;

    setState(() {});
  }

  _resetSupplierForm() {
    setState(() {
      _ctrlSupplierName.clear();
      _ctrlSupplierPhone.clear();
      _ctrlSupplierAddress.clear();
      _ctrlSupplierContactId.clear();
      _supplier.id = null;
    });
  }

  String capitalizeFirstLetterOfEachWord(String sentence) {
    List<String> words = sentence.split(' ');
    List<String> capitalizedWords = [];

    for (var word in words) {
      if (word.isNotEmpty) {
        capitalizedWords.add(word[0].toUpperCase() + word.substring(1));
      }
    }

    return capitalizedWords.join(' ');
  }

  Map<String, Map<String, String>> productMax = {};

  _returnMap(int index) {
    if (_supplyAllFilter.isNotEmpty) {
      String jsonString = _supplyAllFilter[index].productList!;

      Map<String, dynamic> stringMap = json.decode(jsonString);

      Map<String, Map<String, String>> productMa = {};

      stringMap.forEach((key, value) {
        productMa[key] = Map<String, String>.from(value);
      });

      return productMa;
    }
  }

  _returnMapAll(int index) {
    if (_supplyAll.isNotEmpty) {
      String jsonString = _supplyAll[index].productList!;

      Map<String, dynamic> stringMap = json.decode(jsonString);

      Map<String, Map<String, String>> productMa = {};

      stringMap.forEach((key, value) {
        productMa[key] = Map<String, String>.from(value);
      });

      return productMa;
    }
  }

  // inventory
  _deleteInventory(int index) async {
    List<Inventory> k = await _dbHelperI.fetchInventory();

    Map<String, Map<String, String>> produc = _returnMap(index);

    for (var h in produc.entries) {
      // print(h.value['productName']);

      for (var i in k) {
        if (i.barcode == h.value['barcode']) {
          // print(i.productName);
          _inventory = i;
          _inventory.qty =
              (double.parse(i.qty!) - double.parse(h.value['qty']!)).toString();
          await _dbHelperI.updateInventory(_inventory);
        }
      }
    }

    _mapTest(true);
  }

  var oo;
  int id = 0;
// inventory

  _submitInventory(int index) async {
    List<Inventory> k = await _dbHelperI.fetchInventory();

    Map<String, Map<String, String>> produc = _returnMap(index);

    _inventory.supplierId = _supplyAllFilter[index].supplierId!;
    _inventory.date = DateTime.now().toString();

    //print(productMap);
    for (var i in produc.entries) {
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

        _inventory.packing = '${i.value['packing']}' == 'l' ? 'l' : 'p';

        _inventory.productName = '${i.value['productName']}';
        _inventory.barcode = '${i.value['barcode']}';
        _inventory.qty =
            '${double.parse(i.value['qty']!) + double.parse(k.where((element) => element.barcode!.toLowerCase().contains('${i.value['barcode']!}')).toList()[0].qty!)}';
        _inventory.buy = '${i.value['buy']}';
        _inventory.sell = '${i.value['sell']}';
        _inventory.weight = '${i.value['weight']}';
        _inventory.DOE = '${i.value['doe']}';
        _inventory.mrp = '${i.value['mrp']}';

        if (_inventory.id == null) {
          print('added');
          await _dbHelperI.insertInventory(_inventory);
        } else {
          await _dbHelperI.updateInventory(_inventory);
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
          await _dbHelperI.insertInventory(_inventory);
        } else {
          await _dbHelperI.updateInventory(_inventory);
        }
        setState(() {
          //_resetFormInventory();
        });
      }
    }

    //_resetFormInventory();
    _mapTest(true);
  }

  Inventory _inventory = Inventory();

  final _dbHelperI = InventoryOperation();
/*
  _updateInventory(String barcode, String packing, String order) async {
    List<Inventory> k = await _dbHelperI.fetchInventory();

    if (packing == 'p') {
      for (var i in xxxyyy) {
        if (i.orderId == order) {
          for (var j in k) {
            if (j.barcode == i.barcode) {
              _inventory = j;
              _inventory.qty = (double.parse(j.qty!) - double.parse(i.qty!)).toString();
              await _dbHelperI.updateInventory(_inventory);
            }
          }
        }
      }
    } else{
      for (var i in xxxyyy) {
        if (i.orderId == order) {
          for (var j in k) {
            if (j.barcode == i.barcode) {
              _inventory = j;
              _inventory.weight = (double.parse(j.weight!) - double.parse(i.weight!)).toString();
              await _dbHelperI.updateInventory(_inventory);
            }
          }
        }
      }
    }
  }
*/
  _deleteTransactionOrder(String orderId) async {
    for (var i in _searchResultT) {
      if (i.orderId == orderId) {
        await _dbHelperTransaction1.deleteTransaction(i.id!);
      }
    }
    _refreshTListAll();
  }

  _deleteSupplyOrder(String orderId, int index) async {
    for (var i in _supplyAllFilter) {
      if (i.orderId == orderId) {
        await _dbHelperE3.deleteSupply(i.id!);
      }
    }

    _deleteInventory(index);
  }

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

////////////////// TransactionPage //////////////////////
////////////////// TransactionPage //////////////////////
////////////////// TransactionPage //////////////////////
////////////////// TransactionPage //////////////////////

  int _selectedIndexTransaction = -1;
  bool _showTCardDetails = false;
  bool addTransaction = false;

  bool paid = true;

  String paymentMode = 'cash';

  String orderCustom = 'custom';

  String orderId = '';

  final _dbHelperT = TransactionOperation();

  static List<Transaction1> _searchResultT = [];

  final _ctrlTAmount = TextEditingController();
  final _ctrlTDescription = TextEditingController();

  Transaction1 _transaction1 = Transaction1();

  final _dbHelperTransaction1 = TransactionOperation();

  _refreshTransactiontList(int id) async {
    List<Transaction1> x =
        await _dbHelperT.fetchTransactionSupplierId(id.toString());
    setState(() {
      _searchResultT = x;
      //globals.x = x;
    });
  }

  _transaction11() async {
    int x = 0;
    x = await _dbHelperTransaction1.insertTransaction(_transaction1);

    _refreshTransactiontList(globals.SupplierId);

    if (orderCustom == 'order') {
      transaction = false;
      order = true;
      _refreshSupplyListX(globals.SupplierId);
    }

    addTransaction = false;

    _ctrlTAmount.clear();
    _ctrlTDescription.clear();

    _transaction1 = Transaction1();

    paid = true;
    paymentMode = 'cash';
    orderCustom = 'custom';
    orderId = '';

    print(x);
    // setState(() {});
    _refreshTListAll();
    setState(() {});
  }

  _updateSupplyAmt() async {
    await _dbHelperE3.updateSupply(_supply);
    //_refreshSupplyListX(globals.SupplierId);
    _mapTest(true);
    _transaction1 = Transaction1();
    _ctrlTAmount.clear();
    _ctrlTDescription.clear();
    _refreshTListAll();
    //setState(() {});
  }

  /////////////////////Add Purchase Packed///////////////////////
  /////////////////////Add Purchase Packed///////////////////////
  /////////////////////Add Purchase Packed///////////////////////
  /////////////////////Add Purchase Packed///////////////////////
  ///

  String packaging = '';

  String supplierF = '';
  String packingF = '';
  String dateF = '1month';
  String statusF = '';

  String customOrderF = '';

  _filter(String supplier1, String packing1, String date1, String status1,
      String customOrder1) {
    supplierF = supplier1;
    packingF = packing1;
    dateF = date1;
    statusF = status1;
    customOrderF = customOrder1;

    //_mapTest(false);

    List<Supply> x = [];

    List<Transaction1> x1 = [];
    globals.supplyAll = [];

    for (var i in _supplyAll) {
      if ((supplier1 != '' ? i.supplierId == supplier1 : true) &&
          (packing1 != '' ? i.packing == packing1[0].toLowerCase() : true) &&
          (status1 != ''
              ? (status1 == 'pending'
                  ? (i.deliveryStatus == 'pending' || i.paidStatus == 'partial')
                  : status1 == 'completed'
                      ? (i.deliveryStatus == 'delivered' &&
                          i.paidStatus == 'full')
                      : true)
              : true) &&
          (date1 != ''
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

    for (var i in _transactionAll) {
      if ((supplier1 != '' ? i.supplierId == supplier1 : true) &&
          (customOrder1 != '' ? i.orderCustom == customOrder1 : true) &&
          (date1 != ''
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
        x1.add(i);
      }
    }

    date = [];

    map = {};

    pack = [];

    // _balance(supplier1, x1, x);
    _supplyAllx = x;

    _deliverySupply();
    _paymentSupply();

    _grid();

    _searchResultT = x1;
    // _transactionAll = x1;

    // _date(x);

    _supplyAllFilter = x;

    //refreshSupplierDashboard();

    //_supplyAll = x;

    // print(x);

    if (status1 == '' && customOrder1 == '') {
      _balanceX(x, x1);
    }
    if (!mounted) return;
    setState(() {});
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

/*
  _today(String date) {
    return _parseDateTime(date.trim().substring(0, date.length - 1), 1);
  }

  _yesterday(String date) {
    String x = formatDate(
        DateTime.now().toString().split(' ')[0].split('-').toString());

    String f = formatDate(date.split(' ')[0].split('-').toString());

    String xDate = (int.parse(x.split(' ')[2].substring(0, 2)) - 1).toString();
    String xMonth = x.split(' ')[1];
    String xYear = x.split(' ')[0].substring(1, 5);

    String fDate = f.split(' ')[2].substring(0, 2);
    String fMonth = f.split(' ')[1];
    String fYear = f.split(' ')[0].substring(1, 5);

    // String xDate = (int.parse(x.split(' ')[2]) -1).toString();

    print('${xDate} - ${xMonth}');

    return (xDate == fDate && xMonth == fMonth && xYear == fYear)
        ? true
        : false;
  }

  _week(String date) {
    return _parseDateTime(date.trim().substring(0, date.length - 1), 7);
  }

  _month(String date) {
    return _parseDateTime(date.trim().substring(0, date.length - 1), 30);
  }

  _6month(String date) {
    return _parseDateTime(date.trim().substring(0, date.length - 1), 30 * 6);
  }

  _year(String date) {
    return _parseDateTime(date.trim().substring(0, date.length - 1), 30 * 12);
  }

  bool _parseDateTime(String date, int duration) {
    DateTime x = DateTime.parse(date);
    if (x.isAfter(DateTime.now().subtract(Duration(days: duration)))) {
      return true;
    } else {
      return false;
    }
  }*/

///////////////Transaction Filter//////////////////////
///////////////Transaction Filter//////////////////////

  ///
  ///keyboard
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;
  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

  ////transaction
  FocusNode _customPayment = FocusNode();
  FocusNode _description = FocusNode();

  String errorCustomPayment = '';

  _onKeyPress(VirtualKeyboardKey key, TextEditingController controller) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      if (key.text == '_') {
        controller.text = controller.text + '-';
      } else {
        controller.text =
            controller.text + (shiftEnabled ? key.capsText! : key.text!);
      }
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

    if (_orderSearch.hasFocus) {
      //_showSearchResults = true;

      updateList(controller.text.toLowerCase());
    }

    //partial paymnet

    if (_customPayment.hasFocus) {
      if (double.tryParse(controller.text) == null &&
          controller.text.length > 0) {
        errorCustomPayment = 'Invalid';
      } else {
        errorCustomPayment = '';
      }
    } else {
      errorCustomPayment = '';
    }

    // supplier phone edit

    if (_supplierPhone.hasFocus) {
      if ((int.tryParse(controller.text) == null) ||
          (controller.text.length < 10) ||
          (controller.text.length > 10)) {
        errorSupplierPhone = 'Invalid';
      } else {
        errorSupplierPhone = '';
      }
    } else {
      errorSupplierPhone = '';
    }

    // Update the screen

    if (_orderSearch.hasFocus) {
      _updateSearchResults(controller.text.toLowerCase());

      //updateList(_ctrlSearch.text);
    }

    // Update the screen
    setState(() {});
  }

  List<Supplier> filterProduct(String searchText) {
    return _searchResultSupplier0.where((x) {
      final productNameMatches =
          x.name!.toLowerCase().contains(searchText.toLowerCase());

      final barcodeMatches = x.phone!.contains(searchText);
      return productNameMatches || barcodeMatches;
    }).toList();
  }

  void _updateSearchResults(String searchText) {
    setState(() {
      _searchResultSupplier = filterProduct(searchText);
    });
  }

  double _paidAmount = 0;
  double _receivedAmount = 0;
  double _balanceAmount = 0;

  _balance(String s) {
    double p = 0;
    double r = 0;
    double b = 0;

    for (var i in xxxyyyT) {
      if (i.supplierId == s) {
        if (i.paidReceived == 'paid') {
          p += double.parse(i.amount!);
        } else {
          r += double.parse(i.amount!);
        }
      }
    }
    _paidAmount = p;
    _receivedAmount = r;
    _balanceAmount = p - r;
    print('paid: $r');
    setState(() {});
  }

  ////Supplier edit
  FocusNode _supplierName = FocusNode();
  FocusNode _supplierPhone = FocusNode();
  FocusNode _supplierAddress = FocusNode();
  FocusNode _search = FocusNode();

  String errorSupplierName = '';
  String errorSupplierPhone = '';

  final _ctrlSupplierName = TextEditingController();
  final _ctrlSupplierPhone = TextEditingController();
  final _ctrlSupplierAddress = TextEditingController();
  final _ctrlSupplierContactId = TextEditingController();

  final _ctrlOwed = TextEditingController();

  FocusNode _orderSearch = FocusNode();

  String errorOrderSearch = '';

  final _ctrlOrderSearch = TextEditingController();

  String searchFilter = 'productName';

  bool vendorList = false;

  bool addVendorIcon = false;
  bool editVendorIcon = false;
  bool openVendorIcon = true;

  bool dateList = false;
  bool statusList = false;
  bool orderTransactionList = false;
  bool orderCustomList = false;
  bool editVendor = false;

  _findVendor(String x) {
    for (var i in display_list_supplier) {
      if (i.id.toString() == x) {
        return i.name;
      }
    }
  }

  Widget _supplyCard(
      double height, double width, int index, BuildContext context) {
    if (_supplyAllFilter.isNotEmpty) {
      String? jsonString = _supplyAllFilter[index].productList;

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

      productMax = productMa;
      productMa1 = productMa;
    }

    //List<Supply> supply1 = productMa1['${productMa1[index]!.keys}'].values!;

    double totalMrp = 0;
    double totalAmount = 0;

    for (var i in productMa1.entries) {
      totalAmount = totalAmount +
          double.parse(i.value['buy']!) * double.parse(i.value['qty']!);

      totalMrp = totalMrp +
          double.parse(i.value['mrp']!) * double.parse(i.value['qty']!);
    }
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      reverse: false,
      transitionBuilder: (Widget child, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
        );
      },
      child: _selectedIndexSupply != index
          ? Card(
              color: Color.fromRGBO(244, 244, 244, 1),
              elevation: 0,
              margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
              child: InkWell(
                  child: Dismissible(
                    key: Key(_supplyAllFilter[index].id.toString()),
                    confirmDismiss: (direction) async {
                      print('yes');

                      if (_selectedIndexSupply == index) {
                        // _selectedIndexSupply = -1;
                        // _showSupplyCardSelected = false;
                      } else {
                        _selectedIndexSupply = index;
                        _showSupplyCardSelected = true;
                        _showSupplyCardShowDetails = true;
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
                      padding: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Show Details',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Koulen'),
                      ),
                    ),

                    child: Container(
                      //height: height * 0.22,
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
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
                      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        children: [
                          Container(
                            // height: double.infinity,
                            width: width * 0.09,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.black,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              (_supplyAllFilter[index].paidStatus == 'full' &&
                                      _supplyAllFilter[index].deliveryStatus ==
                                          'delivered')
                                  ? 'completed'
                                  : 'pending',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Koulen'),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          //pending/completed
                                          /*  Container(
                                            // height: double.infinity,
                                            width: width * 0.09,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.black,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              (_supplyAllFilter[index]
                                                              .paidStatus ==
                                                          'full' &&
                                                      _supplyAllFilter[index]
                                                              .deliveryStatus ==
                                                          'delivered')
                                                  ? 'completed'
                                                  : 'pending',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Koulen'),
                                            ),
                                          ),
*/
                                          //Vendor
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              //width: width * 0.08,
                                              margin: EdgeInsets.only(
                                                  right: 25, left: 0),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // width: double.infinity,
                                                    // height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Vendor',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        _findVendor('${_supplyAllFilter[index].supplierId}') ==
                                                                null
                                                            ? '-'
                                                            : _findVendor(
                                                                '${_supplyAllFilter[index].supplierId}'),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),

                                          //order no.
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              // width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    //  width: double.infinity,
                                                    // height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Order No.',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        '${_supplyAllFilter[index].orderId}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //order date
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              // width: width * 0.1,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // width: double.infinity,
                                                    //height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Order Date',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        '${formatDate('${_supplyAllFilter[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[0]} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[1].substring(0, 3)} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[2]}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),

                                          //delivery status
                                          Expanded(
                                            child: Container(
                                              // height: double.infinity,
                                              // width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    //  width: double.infinity,
                                                    // height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Delivery Status',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      //  width: double.infinity,
                                                      child: Text(
                                                        _supplyAllFilter[index]
                                                                    .deliveryStatus ==
                                                                'delivered'
                                                            ? 'Completed'
                                                            : 'Pending',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),

                                          //total item
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              //  width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    //width: double.infinity,
                                                    //height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Total Item(s)',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        productMa1.length
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //payment status
                                          /*  Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Payment Status',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    //  width: double.infinity,
                                                    child: Text(
                                                      _supplyAllFilter[index]
                                                                  .paidStatus ==
                                                              'full'
                                                          ? 'Completed'
                                                          : 'Pending',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //total amount
                                          Container(
                                            //height: double.infinity,
                                            //  width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Total Amt.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      totalAmount
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //paid amount
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Paid Amt.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      double.parse(
                                                                  _supplyAllFilter[
                                                                          index]
                                                                      .paidAmt!)
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //paid amount
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Pending Amt.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      (totalAmount -
                                                                  double.parse(
                                                                      _supplyAllFilter[
                                                                              index]
                                                                          .paidAmt!))
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          //order margin
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Order Margin',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      '${(totalMrp - totalAmount).toStringAsFixed(2)}' +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        */
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          //pending/completed
                                          /* Container(
                                            // height: double.infinity,
                                            width: width * 0.09,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.black,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              (_supplyAllFilter[index]
                                                              .paidStatus ==
                                                          'full' &&
                                                      _supplyAllFilter[index]
                                                              .deliveryStatus ==
                                                          'delivered')
                                                  ? 'completed'
                                                  : 'pending',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Koulen'),
                                            ),
                                          ),

                                          //Vendor
                                          Container(
                                            //height: double.infinity,
                                            //width: width * 0.08,
                                            margin: EdgeInsets.only(
                                                right: 25, left: 20),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Vendor',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      _findVendor('${_supplyAllFilter[index].supplierId}') ==
                                                              null
                                                          ? '-'
                                                          : _findVendor(
                                                              '${_supplyAllFilter[index].supplierId}'),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          //order no.
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //  width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Order No.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      '${_supplyAllFilter[index].orderId}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //order date
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.1,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Order Date',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      '${formatDate('${_supplyAllFilter[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[0]} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[1].substring(0, 3)} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[2]}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          //delivery status
                                          Container(
                                            // height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 0),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //  width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Delivery Status',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    //  width: double.infinity,
                                                    child: Text(
                                                      _supplyAllFilter[index]
                                                                  .deliveryStatus ==
                                                              'delivered'
                                                          ? 'Completed'
                                                          : 'Pending',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            height: double.infinity,
                                          )),
                                          //total item
                                          Container(
                                            //height: double.infinity,
                                            //  width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Total Item(s)',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      productMa1.length
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                         */ //payment status
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              // width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    //width: double.infinity,
                                                    //height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Payment Status',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      //  width: double.infinity,
                                                      child: Text(
                                                        _supplyAllFilter[index]
                                                                    .paidStatus ==
                                                                'full'
                                                            ? 'Completed'
                                                            : 'Pending',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //total amount
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              //  width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // width: double.infinity,
                                                    //height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Total Amt.',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        totalAmount
                                                                .toStringAsFixed(
                                                                    2) +
                                                            ' \u{20B9}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //paid amount
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              // width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // width: double.infinity,
                                                    // height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Paid Amt.',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        double.parse(_supplyAllFilter[
                                                                        index]
                                                                    .paidAmt!)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            ' \u{20B9}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //paid amount
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              // width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    // width: double.infinity,
                                                    // height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Pending Amt.',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        (totalAmount -
                                                                    double.parse(
                                                                        _supplyAllFilter[index]
                                                                            .paidAmt!))
                                                                .toStringAsFixed(
                                                                    2) +
                                                            ' \u{20B9}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),

                                          //order margin
                                          Expanded(
                                            child: Container(
                                              //height: double.infinity,
                                              // width: width * 0.08,
                                              margin:
                                                  EdgeInsets.only(right: 25),
                                              alignment: Alignment.center,
                                              //color: Colors.black,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    //width: double.infinity,
                                                    // height: height * 0.03,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        bottom: 5),
                                                    child: const Text(
                                                      'Order Margin',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            92, 94, 98, 1),
                                                        fontSize: 15,
                                                        fontFamily: 'Koulen',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.center,
                                                      // width: double.infinity,
                                                      child: Text(
                                                        '${(totalMrp - totalAmount).toStringAsFixed(2)}' +
                                                            ' \u{20B9}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontFamily: 'Koulen',
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                      )),
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
                    ),
                  ),
                  onTap: () {}),
            )
          : _showSupplyCardShowDetails == false
              ? Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                  child: InkWell(
                      child: Container(
                        height: height * 0.19,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: height * 0.15,
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 15),
                              child: Row(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.09,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.black,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      (_supplyAllFilter[index].paidStatus ==
                                                  'full' &&
                                              _supplyAllFilter[index]
                                                      .deliveryStatus ==
                                                  'delivered')
                                          ? 'completed'
                                          : 'pending',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Koulen'),
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    //color: Colors.black,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.03,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: const Text('Order No.',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 73),
                                                  fontSize: 13,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              '${_supplyAllFilter[index].orderId}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    //color: Colors.black,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.03,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: const Text('Order Date',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 73),
                                                  fontSize: 13,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              '${formatDate('${_supplyAllFilter[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[0]} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[1].substring(0, 3)}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              '${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[2]}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    //color: Colors.black,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.03,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: const Text('Delivery Status',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 73),
                                                  fontSize: 13,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              _supplyAllFilter[index]
                                                          .deliveryStatus ==
                                                      'delivered'
                                                  ? 'Completed'
                                                  : 'Pending',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: double.infinity,
                                  )),
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.08,
                                    margin: EdgeInsets.only(right: 20),
                                    alignment: Alignment.center,
                                    //color: Colors.black,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.03,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: const Text('Total Item(s)',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 73),
                                                  fontSize: 13,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              productMa1.length.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    //color: Colors.black,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.03,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: const Text('Payment Status',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 73),
                                                  fontSize: 13,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              _supplyAllFilter[index]
                                                          .paidStatus ==
                                                      'full'
                                                  ? 'Completed'
                                                  : 'Pending',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    //color: Colors.black,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.03,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: const Text('Total Amount',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 73),
                                                  fontSize: 13,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              totalAmount.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: width * 0.08,
                                    margin: EdgeInsets.only(right: 10),
                                    alignment: Alignment.center,
                                    //color: Colors.black,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: height * 0.03,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: const Text('Paid Amount',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 72, 72, 73),
                                                  fontSize: 13,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              _supplyAllFilter[index]
                                                  .paidAmt
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Bangla',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                // color: Colors.black,
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 20),
                                child: TextButton(
                                  child: Text('Show Details',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 72, 72, 73),
                                          fontSize: 13,
                                          fontFamily: 'Bangla',
                                          fontWeight: FontWeight.bold)),
                                  onPressed: () {
                                    _showSupplyCardShowDetails = true;
                                    setState(() {});
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        if (_selectedIndexSupply == index) {
                          _selectedIndexSupply = -1;
                          _showSupplyCardSelected = false;
                        } else {
                          _selectedIndexSupply = index;
                          _showSupplyCardSelected = true;
                        }
                        setState(() {});
                      }),
                )
              : Card(
                  color: Colors.white,
                  elevation: 0,
                  margin: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                  child: InkWell(
                      child: Container(
                        height: height * 0.6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              // Color of the shadow
                              offset: Offset.zero, // Offset of the shadow
                              blurRadius:
                                  6, // Spread or blur radius of the shadow
                              spreadRadius:
                                  0, // How much the shadow should spread
                            )
                          ],
                          // color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        //padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                        margin: EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          children: [
                            Container(
                              height: height * 0.22,
                              width: double.infinity,
                              padding:
                                  EdgeInsets.only(top: 15, bottom: 0, left: 15),
                              margin: EdgeInsets.only(left: 0, right: 0),
                              child: Row(
                                children: [
                                  Container(
                                    // height: double.infinity,
                                    width: width * 0.09,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.black,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      (_supplyAllFilter[index].paidStatus ==
                                                  'full' &&
                                              _supplyAllFilter[index]
                                                      .deliveryStatus ==
                                                  'delivered')
                                          ? 'completed'
                                          : 'pending',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Koulen'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  //pending/completed
                                                  /*  Container(
                                            // height: double.infinity,
                                            width: width * 0.09,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.black,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              (_supplyAllFilter[index]
                                                              .paidStatus ==
                                                          'full' &&
                                                      _supplyAllFilter[index]
                                                              .deliveryStatus ==
                                                          'delivered')
                                                  ? 'completed'
                                                  : 'pending',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Koulen'),
                                            ),
                                          ),
*/
                                                  //Vendor
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      //width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25, left: 0),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            // width: double.infinity,
                                                            // height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Vendor',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                _findVendor('${_supplyAllFilter[index].supplierId}') ==
                                                                        null
                                                                    ? '-'
                                                                    : _findVendor(
                                                                        '${_supplyAllFilter[index].supplierId}'),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //order no.
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      // width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            //  width: double.infinity,
                                                            // height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Order No.',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                '${_supplyAllFilter[index].orderId}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //order date
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      // width: width * 0.1,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            // width: double.infinity,
                                                            //height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Order Date',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                '${formatDate('${_supplyAllFilter[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[0]} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[1].substring(0, 3)} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[2]}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //delivery status
                                                  Expanded(
                                                    child: Container(
                                                      // height: double.infinity,
                                                      // width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            //  width: double.infinity,
                                                            // height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Delivery Status',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              //  width: double.infinity,
                                                              child: Text(
                                                                _supplyAllFilter[index]
                                                                            .deliveryStatus ==
                                                                        'delivered'
                                                                    ? 'Completed'
                                                                    : 'Pending',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //total item
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      //  width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            //width: double.infinity,
                                                            //height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Total Item(s)',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                productMa1
                                                                    .length
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //payment status
                                                  /*  Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Payment Status',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    //  width: double.infinity,
                                                    child: Text(
                                                      _supplyAllFilter[index]
                                                                  .paidStatus ==
                                                              'full'
                                                          ? 'Completed'
                                                          : 'Pending',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //total amount
                                          Container(
                                            //height: double.infinity,
                                            //  width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Total Amt.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      totalAmount
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //paid amount
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Paid Amt.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      double.parse(
                                                                  _supplyAllFilter[
                                                                          index]
                                                                      .paidAmt!)
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //paid amount
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Pending Amt.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      (totalAmount -
                                                                  double.parse(
                                                                      _supplyAllFilter[
                                                                              index]
                                                                          .paidAmt!))
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          //order margin
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Order Margin',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      '${(totalMrp - totalAmount).toStringAsFixed(2)}' +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        */
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  //pending/completed
                                                  /* Container(
                                            // height: double.infinity,
                                            width: width * 0.09,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.black,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              (_supplyAllFilter[index]
                                                              .paidStatus ==
                                                          'full' &&
                                                      _supplyAllFilter[index]
                                                              .deliveryStatus ==
                                                          'delivered')
                                                  ? 'completed'
                                                  : 'pending',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: 'Koulen'),
                                            ),
                                          ),

                                          //Vendor
                                          Container(
                                            //height: double.infinity,
                                            //width: width * 0.08,
                                            margin: EdgeInsets.only(
                                                right: 25, left: 20),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Vendor',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      _findVendor('${_supplyAllFilter[index].supplierId}') ==
                                                              null
                                                          ? '-'
                                                          : _findVendor(
                                                              '${_supplyAllFilter[index].supplierId}'),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          //order no.
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //  width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Order No.',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      '${_supplyAllFilter[index].orderId}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          //order date
                                          Container(
                                            //height: double.infinity,
                                            // width: width * 0.1,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Order Date',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      '${formatDate('${_supplyAllFilter[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[0]} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[1].substring(0, 3)} ${formatDate('${_supplyAllFilter[index].date.toString().split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[2]}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),

                                          //delivery status
                                          Container(
                                            // height: double.infinity,
                                            // width: width * 0.08,
                                            margin: EdgeInsets.only(right: 0),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //  width: double.infinity,
                                                  // height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Delivery Status',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    //  width: double.infinity,
                                                    child: Text(
                                                      _supplyAllFilter[index]
                                                                  .deliveryStatus ==
                                                              'delivered'
                                                          ? 'Completed'
                                                          : 'Pending',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            height: double.infinity,
                                          )),
                                          //total item
                                          Container(
                                            //height: double.infinity,
                                            //  width: width * 0.08,
                                            margin: EdgeInsets.only(right: 25),
                                            alignment: Alignment.center,
                                            //color: Colors.black,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //width: double.infinity,
                                                  //height: height * 0.03,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: const Text(
                                                    'Total Item(s)',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    alignment: Alignment.center,
                                                    // width: double.infinity,
                                                    child: Text(
                                                      productMa1.length
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                        fontFamily: 'Koulen',
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                         */ //payment status
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      // width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            //width: double.infinity,
                                                            //height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Payment Status',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              //  width: double.infinity,
                                                              child: Text(
                                                                _supplyAllFilter[index]
                                                                            .paidStatus ==
                                                                        'full'
                                                                    ? 'Completed'
                                                                    : 'Pending',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //total amount
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      //  width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            // width: double.infinity,
                                                            //height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Total Amt.',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                totalAmount
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    ' \u{20B9}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //paid amount
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      // width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            // width: double.infinity,
                                                            // height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Paid Amt.',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                double.parse(_supplyAllFilter[index]
                                                                            .paidAmt!)
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    ' \u{20B9}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  //paid amount
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      // width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            // width: double.infinity,
                                                            // height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Pending Amt.',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                (totalAmount -
                                                                            double.parse(_supplyAllFilter[index]
                                                                                .paidAmt!))
                                                                        .toStringAsFixed(
                                                                            2) +
                                                                    ' \u{20B9}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //order margin
                                                  Expanded(
                                                    child: Container(
                                                      //height: double.infinity,
                                                      // width: width * 0.08,
                                                      margin: EdgeInsets.only(
                                                          right: 25),
                                                      alignment:
                                                          Alignment.center,
                                                      //color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            //width: double.infinity,
                                                            // height: height * 0.03,
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            child: const Text(
                                                              'Order Margin',
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
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              // width: double.infinity,
                                                              child: Text(
                                                                '${(totalMrp - totalAmount).toStringAsFixed(2)}' +
                                                                    ' \u{20B9}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen',
                                                                  //fontWeight: FontWeight.bold
                                                                ),
                                                              )),
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
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                //height: 40,
                                color: Color.fromARGB(255, 255, 255, 255),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    dataTextStyle: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Koulen',
                                        color: Colors.black),

                                    headingTextStyle: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Koulen',
                                      color: Color.fromRGBO(92, 94, 98, 1),
                                    ),

                                    //horizontalMargin: width*0.2,
                                    //columnSpacing: width * 0.01,

                                    columns: const [
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('Product Name')),
                                      DataColumn(label: Text('Barcode')),
                                      DataColumn(label: Text('Cost')),
                                      DataColumn(label: Text('mrp')),
                                      DataColumn(label: Text('Margin')),
                                      DataColumn(label: Text('Total')),
                                    ],
                                    rows: productMa1
                                        .entries // Loops through dataColumnText, each iteration assigning the value to element
                                        .map(
                                          ((element) => DataRow(
                                                color:
                                                    const MaterialStatePropertyAll(
                                                        Colors.white),
                                                cells: <DataCell>[
                                                  //Extracting from Map element the value

                                                  DataCell(Text(
                                                      '${element.value['qty']}')),

                                                  DataCell(Text(
                                                      '${element.value['productName']}')),

                                                  DataCell(Text(
                                                      '${element.value['barcode']}')),

                                                  DataCell(Text(
                                                    '${element.value['buy']}' +
                                                        ' \u{20B9}',
                                                  )),

                                                  DataCell(Text(
                                                    '${element.value['mrp']}' +
                                                        ' \u{20B9}',
                                                  )),

                                                  DataCell(Text(
                                                    '${(double.parse(element.value['mrp']!) - double.parse(element.value['buy']!)).toStringAsFixed(2)}' +
                                                        ' \u{20B9}',
                                                  )),

                                                  DataCell(Text(
                                                    '${double.parse(element.value['buy']!) * double.parse(element.value['qty']!)}' +
                                                        ' \u{20B9}',
                                                  )),
                                                ],
                                              )),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: height * 0.06,
                              // color: Colors.black,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: double.infinity,
                                    ),
                                  ),
                                  Container(
                                      width: width * 0.13,
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 5),
                                      height: double.infinity,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)))),
                                          onPressed: () async {
                                            Map<String, Map<String, String>>
                                                produc =
                                                await _returnMap(index);

                                            producX = produc;

                                            if (globals.printerConnected) {
                                              screenshotController
                                                  .captureFromWidget(
                                                      xxxxPrint(
                                                          height, width, index),
                                                      //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

                                                      delay:
                                                          Duration(seconds: 1),
                                                      targetSize: Size(
                                                          380,
                                                          //fixed= 390, card =
                                                          (800 +
                                                              30 +
                                                              (50 *
                                                                      (producX.length *
                                                                          1.4))
                                                                  .toDouble())))
                                                  .then((capturedImage) {
                                                printCapturedImage(
                                                  capturedImage,
                                                );
                                                // Handle captured image
                                              });
                                            }
                                            /* if(globals.printerConnected){
                                            _printOrder(
                                                index, height, width, true);} else{
                                                  print('printer not connected');
                                                }*/
                                          },
                                          child: Text('Print',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  fontSize: 14,
                                                  color: Colors.white)))),
                                  Container(
                                      width: width * 0.13,
                                      margin: EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 5),
                                      height: double.infinity,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)))),
                                          onPressed: () async {
                                            Map<String, Map<String, String>>
                                                produc =
                                                await _returnMap(index);

                                            producX = produc;

                                            screenshotController
                                                .captureFromWidget(
                                                    xxxxPrint(
                                                        height, width, index),
                                                    //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

                                                    delay: Duration(seconds: 1),
                                                    targetSize: Size(
                                                        380,
                                                        //fixed= 390, card =
                                                        (800 +
                                                            30 +
                                                            (50 *
                                                                    (producX.length *
                                                                        1.4))
                                                                .toDouble())))
                                                .then((capturedImage) {
                                              shareCapturedImage(
                                                  capturedImage, 'Invoice');
                                              // Handle captured image
                                            });
                                          },
                                          child: Text('Share',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  fontSize: 14,
                                                  color: Colors.white)))),
                                  if (_supplyAllFilter[index].deliveryStatus !=
                                      'delivered')
                                    Container(
                                        width: width * 0.13,
                                        margin: EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5),
                                        height: double.infinity,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.black),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5)))),
                                            onPressed: () async {
                                              if ('${_supplyAllFilter[index].deliveryStatus}' ==
                                                  'pending') {
                                                _supply =
                                                    _supplyAllFilter[index];
                                                _supply.deliveryStatus =
                                                    'delivered';
                                                _supply.deliveryDate =
                                                    '${DateTime.now().toString().split(' ')[0].split('-').reversed.join('/')} - ${DateTime.now().toString().split(' ')[1].split('.')[0].substring(0, 5)}';

                                                _updateDeliveryStatus(index);
                                              }
                                            },
                                            child: Text('Marks as Delivered',
                                                style: TextStyle(
                                                    fontFamily: 'Koulen',
                                                    fontSize: 14,
                                                    color: Colors.white)))),
                                  if (_supplyAllFilter[index].paidStatus !=
                                      'full')
                                    Container(
                                        width: width * 0.1,
                                        margin: EdgeInsets.only(
                                            left: 5,
                                            right: 0,
                                            top: 5,
                                            bottom: 5),
                                        height: double.infinity,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.black),
                                                shape: MaterialStatePropertyAll(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5)))),
                                            onPressed: () {
                                              order = false;
                                              transaction = true;
                                              addTransaction = true;

                                              paid = true;
                                              orderCustom = 'order';

                                              orderId = _supplyAllFilter[index]
                                                  .orderId!;
                                              globals.SupplierId = int.parse(
                                                  _supplyAllFilter[index]
                                                      .supplierId!);

                                              _supplyAddPayment
                                                  .add(_supplyAllFilter[index]);

                                              selectedSupplyTotal = totalAmount;

                                              selectedSupplyPaidAmt =
                                                  double.parse(
                                                      _supplyAllFilter[index]
                                                          .paidAmt!);

                                              setState(() {});
                                            },
                                            child: Text('Add Payment',
                                                style: TextStyle(
                                                    fontFamily: 'Koulen',
                                                    fontSize: 14,
                                                    color: Colors.white)))),
                                  Container(
                                      width: width * 0.1,
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
                                      height: double.infinity,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)))),
                                          onPressed: () async {
                                            _deleteSupplyOrder(
                                                _supplyAllFilter[index]
                                                    .orderId!,
                                                index);
                                            _deleteTransactionOrder(
                                              _supplyAllFilter[index].orderId!,
                                            );
                                            // _refreshSupplyListAll();
                                          },
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  fontSize: 14,
                                                  color: Colors.white)))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (_selectedIndexSupply == index) {
                          _selectedIndexSupply = -1;
                          _showSupplyCardSelected = false;
                          _showSupplyCardShowDetails = false;
                        } else {
                          _selectedIndexSupply = index;
                          _showSupplyCardSelected = true;
                        }
                        setState(() {});
                      }),
                ),
    );
  }

  Widget xxxxPrint(double height, double width, int index) {
    double t = 0;

    double d = 0;

    for (var i in producX.entries) {
      t = t + double.parse(i.value['buy']!) * double.parse(i.value['qty']!);
      //d = d + double.parse(i.value['disc']!) * double.parse(i.value['qty']!);

      print(i.value['productName']!);

      print(double.parse(i.value['buy']!) * double.parse(i.value['qty']!));
    }
    //totalPrice = t;
    // _ctrlpayment.text = totalPrice.toString();

    //disc = d;

    String customerName = '';
    String customerPhone = '';
    String customerAddress = '';

    for (var i in display_list_supplier) {
      if (i.id.toString() == _supplyAllFilter[index].supplierId) {
        customerName = i.name!;
        customerPhone = i.phone!;
        customerAddress = i.address!;
      }
    }

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
              '${globals.storeName}',
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
              '${globals.storePhone}',
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
              '${globals.storeAddress.toUpperCase()}',
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
                                'COST',
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
                  itemCount: producX.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (producX.isNotEmpty) {
                      return cardPrintX(height, width, index, context);
                    } else {
                      return const Text('Select Supplier');
                    }
                  }),
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
                    text: '${producX.length}',
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
                    text: '${t.toStringAsFixed(2)}' + ' \u{20B9}',
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
                    text: 'Delivery Status  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text:
                        '${_supplyAllFilter[index].deliveryStatus!.toUpperCase()}',
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
                    text: _supplyAllFilter[index].paidStatus == 'full'
                        ? 'COMPLETE'
                        : 'Partial',
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
                    text:
                        '${double.parse(_supplyAllFilter[index].paidAmt!).toStringAsFixed(2)}',
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
                    text:
                        '${_supplyAllFilter[index].paymentMode!.toUpperCase()}',
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
                    text: 'Vendor Details  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Bangla',
                    ),
                  ),
                  TextSpan(
                    text: '${customerName.toUpperCase()} - ${customerPhone}',
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
              //height: height * 0.04,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 4, right: 5),
              margin: const EdgeInsets.only(top: 0, right: 0),
              child: Text(
                '36STORES.COM',
                textAlign: TextAlign.right,
                style: TextStyle(
                  //color: Color.fromRGBO(92, 94, 98, 1),
                  color: Colors.black,
                  fontSize: 28,
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

  Widget cardPrintX(
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
                        '${producX.values.elementAt(index)['productName']!.toUpperCase()}',
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
                                  '${producX.values.elementAt(index)['mrp']!}',
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
                                  '${double.parse(producX.values.elementAt(index)['buy']!).toStringAsFixed(2)}',
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
                                  '${producX.values.elementAt(index)['qty']!}',
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
                                  '${(double.parse(producX.values.elementAt(index)['buy']!) * double.parse(producX.values.elementAt(index)['qty']!)).toStringAsFixed(2)}',
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

  double selectedSupplyPaidAmt = 0;

  Widget cardTransaction(
      double height, double width, int index, BuildContext context) {
    int dateIndex = 0;

    for (var i in _supplyList) {
      if (i.orderId == _searchResultT[index].orderId) {
        dateIndex = date.indexOf(i.date!);
      } else {}
    }

    // List<Supply> supply1 = map['${date[dateIndex]}']!;

    double totalAmount = 0;

    return _selectedIndexTransaction != index
        ? Card(
            elevation: 0,
            margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            child: InkWell(
                child: Container(
                  height: height * 0.13,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
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
                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                  child: Row(
                    children: [
                      Container(
                        height: double.infinity,
                        width: width * 0.09,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.black,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          (_searchResultT[index].paidReceived == 'paid')
                              ? 'paid'
                              : 'received',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Koulen'),
                        ),
                      ),
                      //Vendor
                      Container(
                        //height: double.infinity,
                        //width: width * 0.08,
                        margin: EdgeInsets.only(right: 25, left: 20),
                        alignment: Alignment.center,
                        //color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              // width: double.infinity,
                              // height: height * 0.03,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Vendor',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                // width: double.infinity,
                                child: Text(
                                  _findVendor(
                                      '${_transactionAll[index].supplierId}'),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Koulen',
                                    //fontWeight: FontWeight.bold
                                  ),
                                )),
                          ],
                        ),
                      ),

                      Container(
                        height: double.infinity,
                        // width: width * 0.08,
                        margin: EdgeInsets.only(right: 25),
                        alignment: Alignment.center,
                        //color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              //  width: double.infinity,
                              //height: height * 0.03,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Transaction Id',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                //  width: double.infinity,
                                child: Text(
                                  '${_searchResultT[index].id}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Koulen',
                                    //fontWeight: FontWeight.bold
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        //  width: width * 0.1,
                        margin: EdgeInsets.only(right: 25),
                        alignment: Alignment.center,
                        //color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              // width: double.infinity,
                              // height: height * 0.03,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Date',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                // width: double.infinity,
                                child: Text(
                                  '${formatDate('${_searchResultT[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[0]} ${formatDate('${_searchResultT[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[1].substring(0, 3)} ${formatDate('${_searchResultT[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[2]}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Koulen',
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: double.infinity,
                      )),
                      Container(
                        height: double.infinity,
                        // width: width * 0.08,
                        margin: EdgeInsets.only(right: 25),
                        alignment: Alignment.center,
                        //color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              //width: double.infinity,
                              // height: height * 0.03,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Order/Custom',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                //width: double.infinity,
                                child: Text(
                                  _searchResultT[index]
                                              .orderCustom
                                              .toString() ==
                                          'order'
                                      ? 'Order'
                                      : 'Custom',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Koulen',
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        height: double.infinity,
                        // width: width * 0.08,
                        margin: EdgeInsets.only(right: 25),
                        alignment: Alignment.center,
                        //color: Colors.black,
                        child: Column(
                          children: [
                            Container(
                              //width: double.infinity,
                              //height: height * 0.03,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 5),
                              child: const Text(
                                'Description',
                                style: TextStyle(
                                  color: Color.fromRGBO(92, 94, 98, 1),
                                  fontSize: 15,
                                  fontFamily: 'Koulen',
                                ),
                              ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                // width: double.infinity,
                                child: Text(
                                  _searchResultT[index].description == ''
                                      ? '-'
                                      : _searchResultT[index]
                                          .description
                                          .toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Koulen',
                                  ),
                                )),
                          ],
                        ),
                      ),
                      if (addTransaction == false)
                        Container(
                          height: double.infinity,
                          //width: width * 0.08,
                          margin: EdgeInsets.only(right: 25),
                          alignment: Alignment.center,
                          //color: Colors.black,
                          child: Column(
                            children: [
                              Container(
                                //width: double.infinity,
                                //height: height * 0.03,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 5),
                                child: const Text(
                                  'Payment Mode',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 15,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  //  width: double.infinity,
                                  child: Text(
                                    _searchResultT[index]
                                                .paymentMode
                                                .toString() ==
                                            'cash'
                                        ? 'Cash'
                                        : _searchResultT[index]
                                                    .paymentMode
                                                    .toString() ==
                                                'card'
                                            ? 'Card'
                                            : _searchResultT[index]
                                                        .paymentMode
                                                        .toString() ==
                                                    'wallet'
                                                ? 'Wallet'
                                                : 'UPI',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Koulen',
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      if (addTransaction == false)
                        Container(
                          height: double.infinity,
                          //width: width * 0.08,
                          margin: EdgeInsets.only(right: 25),
                          alignment: Alignment.center,
                          //color: Colors.black,
                          child: Column(
                            children: [
                              Container(
                                // width: double.infinity,
                                // height: height * 0.03,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 5),
                                child: const Text(
                                  'Amount',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 15,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  // width: double.infinity,
                                  child: Text(
                                    double.parse(_searchResultT[index].amount!)
                                            .toStringAsFixed(2) +
                                        ' \u{20B9}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Koulen',
                                    ),
                                  )),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                onTap: () {
                  if (_selectedIndexTransaction == index) {
                    _selectedIndexTransaction = -1;
                    // _showSupplyCardSelected = false;
                  } else {
                    _selectedIndexTransaction = index;
                    //_showSupplyCardSelected = true;
                  }
                  setState(() {});
                }),
          )
        : Card(
            color: Colors.white,
            elevation: 0,
            margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            child: InkWell(
                child: Container(
                  height: height * 0.185,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
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
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.13,
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                        child: Row(
                          children: [
                            Container(
                              height: double.infinity,
                              width: width * 0.09,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.black,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                (_searchResultT[index].paidReceived == 'paid')
                                    ? 'paid'
                                    : 'received',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Koulen'),
                              ),
                            ),
                            //Vendor
                            Container(
                              //height: double.infinity,
                              //width: width * 0.08,
                              margin: EdgeInsets.only(right: 25, left: 20),
                              alignment: Alignment.center,
                              //color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    // height: height * 0.03,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      'Vendor',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 15,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      // width: double.infinity,
                                      child: Text(
                                        _findVendor(
                                            '${_transactionAll[index].supplierId}'),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Koulen',
                                          //fontWeight: FontWeight.bold
                                        ),
                                      )),
                                ],
                              ),
                            ),

                            Container(
                              height: double.infinity,
                              // width: width * 0.08,
                              margin: EdgeInsets.only(right: 25),
                              alignment: Alignment.center,
                              //color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                    //  width: double.infinity,
                                    //height: height * 0.03,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      'Transaction Id',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 15,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      //  width: double.infinity,
                                      child: Text(
                                        '${_searchResultT[index].id}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Koulen',
                                          //fontWeight: FontWeight.bold
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              //  width: width * 0.1,
                              margin: EdgeInsets.only(right: 25),
                              alignment: Alignment.center,
                              //color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    // height: height * 0.03,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      'Date',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 15,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      // width: double.infinity,
                                      child: Text(
                                        '${formatDate('${_searchResultT[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[0]} ${formatDate('${_searchResultT[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[1].substring(0, 3)} ${formatDate('${_searchResultT[index].date!.split(' ')[0].split('-').reversed.join('/')}  ').split(' ')[2]}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Koulen',
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              height: double.infinity,
                            )),
                            Container(
                              height: double.infinity,
                              // width: width * 0.08,
                              margin: EdgeInsets.only(right: 25),
                              alignment: Alignment.center,
                              //color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                    //width: double.infinity,
                                    // height: height * 0.03,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      'Order/Custom',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 15,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      //width: double.infinity,
                                      child: Text(
                                        _searchResultT[index]
                                                    .orderCustom
                                                    .toString() ==
                                                'order'
                                            ? 'Order'
                                            : 'Custom',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Koulen',
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              // width: width * 0.08,
                              margin: EdgeInsets.only(right: 25),
                              alignment: Alignment.center,
                              //color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                    //width: double.infinity,
                                    //height: height * 0.03,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(bottom: 5),
                                    child: const Text(
                                      'Description',
                                      style: TextStyle(
                                        color: Color.fromRGBO(92, 94, 98, 1),
                                        fontSize: 15,
                                        fontFamily: 'Koulen',
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      // width: double.infinity,
                                      child: Text(
                                        _searchResultT[index].description == ''
                                            ? '-'
                                            : _searchResultT[index]
                                                .description
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Koulen',
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            if (addTransaction == false)
                              Container(
                                height: double.infinity,
                                //width: width * 0.08,
                                margin: EdgeInsets.only(right: 25),
                                alignment: Alignment.center,
                                //color: Colors.black,
                                child: Column(
                                  children: [
                                    Container(
                                      //width: double.infinity,
                                      //height: height * 0.03,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: const Text(
                                        'Payment Mode',
                                        style: TextStyle(
                                          color: Color.fromRGBO(92, 94, 98, 1),
                                          fontSize: 15,
                                          fontFamily: 'Koulen',
                                        ),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        //  width: double.infinity,
                                        child: Text(
                                          _searchResultT[index]
                                                      .paymentMode
                                                      .toString() ==
                                                  'cash'
                                              ? 'Cash'
                                              : _searchResultT[index]
                                                          .paymentMode
                                                          .toString() ==
                                                      'card'
                                                  ? 'Card'
                                                  : _searchResultT[index]
                                                              .paymentMode
                                                              .toString() ==
                                                          'wallet'
                                                      ? 'Wallet'
                                                      : 'UPI',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Koulen',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            if (addTransaction == false)
                              Container(
                                height: double.infinity,
                                //width: width * 0.08,
                                margin: EdgeInsets.only(right: 25),
                                alignment: Alignment.center,
                                //color: Colors.black,
                                child: Column(
                                  children: [
                                    Container(
                                      // width: double.infinity,
                                      // height: height * 0.03,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: const Text(
                                        'Amount',
                                        style: TextStyle(
                                          color: Color.fromRGBO(92, 94, 98, 1),
                                          fontSize: 15,
                                          fontFamily: 'Koulen',
                                        ),
                                      ),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        // width: double.infinity,
                                        child: Text(
                                          double.parse(_searchResultT[index]
                                                      .amount!)
                                                  .toStringAsFixed(2) +
                                              ' \u{20B9}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Koulen',
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (_searchResultT[index].orderCustom == 'order')
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            // color: Colors.black,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 20),
                            child: Text(
                              'Order Id: ${_searchResultT[index].orderId}',
                              style: TextStyle(
                                color: Color.fromRGBO(92, 94, 98, 1),
                                fontSize: 15,
                                fontFamily: 'Koulen',
                              ),
                            ),
                          ),
                        ),
                      if (_searchResultT[index].orderCustom == 'custom')
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.only(right: 20),
                            width: double.infinity,
                            child: Container(
                                width: width * 0.1,
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 5, bottom: 5),
                                height: double.infinity,
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
                                      await _dbHelperT.deleteTransaction(
                                          _searchResultT[index].id!);
                                      /*_refreshTransactiontList(int.parse(
                                          _searchResultT[index].supplierId!));*/
                                      _refreshTListAll();
                                      //_resetFormSupply();}
                                    },
                                    child: Text('Delete',
                                        style: TextStyle(
                                            fontFamily: 'BanglaBold',
                                            fontSize: 14,
                                            color: Colors.white)))),
                          ),
                        ),
                    ],
                  ),
                ),
                onTap: () {
                  if (_selectedIndexTransaction == index) {
                    _selectedIndexTransaction = -1;
                    //_showSupplyCardSelected = false;
                  } else {
                    _selectedIndexTransaction = index;
                    //_showSupplyCardSelected = true;
                  }
                  setState(() {});
                }),
          );
  }

///////////////////////VENDOR///////////////////////////

  Widget EditAdd() {
    return Expanded(
        child: //_onFirstPage?

            InkWell(
      child: Container(
          key: UniqueKey(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4),
              topLeft: Radius.circular(4),
            ),
            color: Colors.white,
          ),
          height: double.infinity,
          alignment: Alignment.center,
          child: globals.SupplierName != ''
              ? TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  focusNode: _orderSearch,
                  readOnly: true, // Prevent system keyboard
                  showCursor: false,

                  controller: _ctrlOrderSearch,
                  // controller: searchController,
                  onChanged: (value) {
                    updateList(value.toLowerCase());
                  },
                  onTap: () {
                    if (vendorList == false) {
                      // _ctrlOrderSearch.clear();
                      vendorList = !vendorList;

                      addVendorIcon = true;
                      editVendorIcon = false;

                      // _selectedIndex = -1;
                      // _tileSelected = false;
                      //_supplierCardEdit = true;
                      // _editCardManager('', '', '');
                      // addVendor = false;

                      _supplierCardEdit = true;
                    } else {
                      vendorList = !vendorList;
                      _orderSearch.unfocus();

                      addVendor = false;

                      editVendor = false;
                      addVendorIcon = true;
                      editVendorIcon = false;
                      _editCardManager('', '', '', '');
                      _resetSupplierForm();

                      _refreshContactList();

                      _supplierCardEdit = false;
                    }

                    //vendorList = !vendorList;

                    setState(() {});
                  },
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Koulen'),
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(0, 51, 154, 1), width: 2),
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
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor:
                        vendorList == true ? Colors.black : Colors.white,
                  ),
                )
              : Text(
                  'All',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Koulen'),
                )),
      onTap: () {
        if (vendorList == false) {
          // _ctrlOrderSearch.clear();
          vendorList = !vendorList;

          addVendorIcon = true;
          editVendorIcon = false;

          // _selectedIndex = -1;
          // _tileSelected = false;
          //_supplierCardEdit = true;
          // _editCardManager('', '', '');
          // addVendor = false;

          _supplierCardEdit = true;
        } else {
          vendorList = !vendorList;
          _orderSearch.unfocus();

          addVendor = false;

          editVendor = false;
          addVendorIcon = true;
          editVendorIcon = false;
          _editCardManager('', '', '', '');
          _resetSupplierForm();

          _refreshContactList();

          _supplierCardEdit = false;
        }

        //vendorList = !vendorList;

        setState(() {});
      },
    ));
  }

/////////////Printer//////////////////////
/////////////Printer//////////////////////
/////////////Printer//////////////////////

  bool pdfView = false;
  bool pdfViewWhatsapp = false;
  String filePath1 = '';

  late Uint8List pdfData;
/*
  Widget cardPrint(
      double height, double width, int index, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 0, right: 0),
      // height: height * 0.15,
      decoration: BoxDecoration(
        //color: Colors.black,
        color: _selectedIndex == index ? Colors.black : Colors.white,
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
                    text: '${_searchResultT[index].date}',
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
                        '${DateFormat('yyyy-MM-dd').format(DateTime.parse(_searchResultT[index].date!.trim())).toString()}',
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
                              text: _searchResultT[index]
                                  .paidReceived!
                                  .toUpperCase(),
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

  ScreenshotController screenshotController = ScreenshotController();

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

  Future<void> shareCapturedImage(Uint8List jpegBytes, String x) async {
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
        text: "${globals.storeName.toUpperCase()}: ${x.toUpperCase()}",
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
                  itemCount: _searchResultT.length,
                  //cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_searchResultT.isNotEmpty) {
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
              '${globals.storeName}',
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
              '${globals.storePhone}',
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
              '${globals.storeAddress.toUpperCase()}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),

          Container(
            width: double.infinity,
            //height: 65,

            // color: Colors.black,
            //  margin: EdgeInsets.only(bottom: 2),
            child: Text(
              'Transaction Report',
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
                  itemCount: _searchResultT.length,
                  //cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_searchResultT.isNotEmpty) {
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
                    text: 'Vendor Details  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Bangla',
                    ),
                  ),
                  TextSpan(
                    text: '${globals.SupplierName.toUpperCase()}' != ''
                        ? '${globals.SupplierName.toUpperCase()}'
                        : 'All',
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
                    text: 'Time Period  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 18,
                      //fontFamily: 'Bangla',
                    ),
                  ),
                  TextSpan(
                    text: dateF == 'today'
                        ? 'Today'
                        : dateF == 'yesterday'
                            ? 'Yesterday'
                            : dateF == 'week'
                                ? 'Last Week'
                                : dateF == '1month'
                                    ? 'Last Month'
                                    : dateF == '6month'
                                        ? 'Last 6 Months'
                                        : dateF == '1year'
                                            ? 'Last Year'
                                            : 'All',
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

          if (globals.SupplierName != '')
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
                      text: 'Balance  ',
                      style: TextStyle(
                        //color: Color.fromRGBO(92, 94, 98, 1),
                        color: Colors.black,
                        fontSize: 18,
                        //fontFamily: 'Bangla',
                      ),
                    ),
                    TextSpan(
                      text: (globals.SupplierName != '' && _tileSelected)
                          ? '${(balance).toStringAsFixed(2)}' + ' \u{20B9}'
                          : '',
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
              //height: height * 0.04,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, left: 4, right: 5),
              margin: const EdgeInsets.only(top: 0, right: 0),
              child: Text(
                '36STORES.COM',
                textAlign: TextAlign.right,
                style: TextStyle(
                  //color: Color.fromRGBO(92, 94, 98, 1),
                  color: Colors.black,
                  fontSize: 28,
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
            child: Row(
              children: [
                Expanded(child: Container()),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '',
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
                    text:
                        '${producX.values.elementAt(index)['productName']!.toUpperCase()}',
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
                                  '${producX.values.elementAt(index)['mrp']!}',
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
                              text: '',
                              //'${((double.parse(producX.values.elementAt(index)['disc']!) / double.parse(producX.values.elementAt(index)['mrp']!)) * 100).toStringAsFixed(2)}',
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
                                  '${producX.values.elementAt(index)['qty']!}',
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
                                  '${(double.parse(producX.values.elementAt(index)['buy']!) * double.parse(producX.values.elementAt(index)['qty']!)).toStringAsFixed(2)}',
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

  final _dbHelperS = StoreOperation();

  Future<Widget> orderXXXX(double height, double width, int index) async {
    var k = await _dbHelperS.fetchStore();

    double totalPrice = 0;

    for (var i in producX.entries) {
      totalPrice = totalPrice +
          (double.parse(i.value['buy']!) * double.parse(i.value['qty']!));
    }

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
              '${k.last.name!}',
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
              '${k.last.phone!}',
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
              '${k.last.address!}',
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
                        text: 'Date  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          //fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
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
                  itemCount: producX.length,
                  //cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (producX.isNotEmpty) {
                      return cardPrintOrder(height, width, index, context);
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
                    text: 'Total Prod.  ',
                    style: TextStyle(
                      //color: Color.fromRGBO(92, 94, 98, 1),
                      color: Colors.black,
                      fontSize: 27,
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '${producX.length}',
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
                      //fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '${totalPrice}',
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

  Map<String, Map<String, String>> producX = {};

  _printOrder(int index, double height, double width, bool print) async {
    Map<String, Map<String, String>> produc = await _returnMap(index);

    producX = produc;

    //orderXXXX(height, width, index);

    if (print) {
      screenshotController
          .captureFromWidget(await orderXXXX(height, width, index),
              //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

              delay: Duration(seconds: 1),
              targetSize: Size(
                  380,
                  //fixed= 390, card =
                  (400 + 30 + (50 * (producX.length * 1.4)).toDouble())))
          .then((capturedImage) {
        printCapturedImage(capturedImage);
        // Handle captured image
      });
    } else {
      screenshotController
          .captureFromWidget(await orderXXXX(height, width, index),
              //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

              delay: Duration(seconds: 1),
              targetSize: Size(
                  380,
                  //fixed= 390, card =
                  (400 + 30 + (50 * (producX.length * 1.4)).toDouble())))
          .then((capturedImage) {
        shareCapturedImage(capturedImage, '');
        // Handle captured image
      });
    }
  }

  _balanceX(List<Supply> x, List<Transaction1> x1) async {
    double debit = 0;
    double credit = 0;
    double total = 0;

    List<Map<String, Map<String, String>>> producList = [];

    for (var i in x) {
      Map<String, Map<String, String>> produc =
          await _returnMapAll(_supplyAll.indexOf(i));
      //producList.add(produc);

      for (var j in produc.entries) {
        total = total +
            (double.parse(j.value['buy']!) * double.parse(j.value['qty']!));
      }
    }

    for (var i in x1) {
      if (i.paidReceived == 'paid') {
        debit = debit + double.parse(i.amount!);
      } else {
        credit = credit + double.parse(i.amount!);
      }
    }

    print('debit $debit');
    print('credit $credit');
    print('total $total');

    print('balance ${(debit - credit) - total}');

    balance = (debit - credit) - total;
  }

  double balance = 0;

  _updateSupplyAmtCustom() async {
    double inputAmt = double.tryParse(_ctrlTAmount.text) != null
        ? double.parse(_ctrlTAmount.text)
        : 0;

    if (globals.SupplierId != '') {
      var k = await _dbHelperE3.fetchSupply();

      for (var i in k) {
        if (i.supplierId == globals.SupplierId.toString()) {
          //print('hi');
          // print(i.id);

          if (_supplyAllFilter.isNotEmpty) {
            String? jsonString = i.productList;

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

            productMax = productMa;
            productMa1 = productMa;
          }

          //List<Supply> supply1 = productMa1['${productMa1[index]!.keys}'].values!;

          double totalMrp = 0;
          double totalAmount = 0;

          for (var i in productMa1.entries) {
            totalAmount = totalAmount +
                double.parse(i.value['buy']!) * double.parse(i.value['qty']!);

            totalMrp = totalMrp +
                double.parse(i.value['mrp']!) * double.parse(i.value['qty']!);
          }

          print('supplier  ' + i.supplierId!);
          print('status  ' + i.paidStatus!);
          print('paid  ' + i.paidAmt!);
          print('total  ' + totalAmount.toString());
          print('diff  ' + (totalAmount - double.parse(i.paidAmt!)).toString());

          print('input  ' + (inputAmt).toString());

          print('-------------------------------');

          if (inputAmt > 0) {
            if (i.paidStatus == 'partial') {
              if (inputAmt < (totalAmount - double.parse(i.paidAmt!))) {
                i.paidAmt = (double.parse(i.paidAmt!) + inputAmt).toString();
                i.paidStatus = 'partial';
                inputAmt = 0;
                _supply = i;
                _supply.paidAmt = i.paidAmt;
                _supply.paidStatus = i.paidStatus;
                await _dbHelperE3.updateSupply(_supply);
                _supply = Supply();
              } else if (inputAmt == (totalAmount - double.parse(i.paidAmt!))) {
                i.paidAmt = (double.parse(i.paidAmt!) + inputAmt).toString();
                i.paidStatus = 'full';
                inputAmt = 0;
                _supply = i;
                _supply.paidAmt = i.paidAmt;
                _supply.paidStatus = i.paidStatus;
                await _dbHelperE3.updateSupply(_supply);
                _supply = Supply();
              } else if (inputAmt > (totalAmount - double.parse(i.paidAmt!))) {
                inputAmt = inputAmt - (totalAmount - double.parse(i.paidAmt!));
                i.paidAmt = (totalAmount).toString();
                i.paidStatus = 'full';
                _supply = i;
                _supply.paidAmt = i.paidAmt;
                _supply.paidStatus = i.paidStatus;
                await _dbHelperE3.updateSupply(_supply);
                _supply = Supply();
              }
            }
          }

          print('supplier  ' + i.supplierId!);
          print('status  ' + i.paidStatus!);
          print('paid  ' + i.paidAmt!);
          print('total  ' + totalAmount.toString());
          print('diff  ' + (totalAmount - double.parse(i.paidAmt!)).toString());
          print('input  ' + (inputAmt).toString());
          print('xxxxxxxxxcxxxxxxxxxxxxxxxxxxx');
          //print('input  ' + (inputAmt).toString());
        }
      }

      // await _dbHelperE3.updateSupply(_supply);

      _mapTest(true);
      _transaction1 = Transaction1();
      _ctrlTAmount.clear();
      _ctrlTDescription.clear();
      _refreshTListAll();
      //setState(() {});}
    }
  }

  bool chooseSupplier = false;

  bool dashboard = true;

  // Callback function to trigger setState in SupplierDashboard
  void refreshSupplierDashboard() {
    print('Refresh callback called');
    setState(() {});
  }

  ///////////dashboard//////////////////////
  ///////////dashboard//////////////////////
  ///////////dashboard//////////////////////
  ///////////dashboard//////////////////////

  List<Supply> _deliverySalesAll = [];
  List<Supply> _paymentSupplyAll = [];

  final _dbHelperSupplier = SupplierOperation();

  final _dbHelperSupply = SupplyOperation();

  List<Supply> _salesAll0 = [];
  List<Supply> _salesAll = [];

  List<Supply> _supplyAll0 = [];
  List<Supply> _supplyAllx = [];

  _deliverySupply() {
    _deliverySalesAll = [];
    if (_supplyAllx.isNotEmpty) {
      for (var i in _supplyAllx) {
        if (i.deliveryStatus == 'pending') {
          _deliverySalesAll.add(i);
        }
      }
    }
    // _timer();
  }

  _paymentSupply() {
    _paymentSupplyAll = [];
    if (_supplyAllx.isNotEmpty) {
      for (var i in _supplyAllx) {
        if (i.paidStatus == 'partial') {
          _paymentSupplyAll.add(i);
        }
      }
    }
    // _timer();
  }

  _updateDeliveryStatusx() async {
    await _dbHelperSupply.updateSupply(_supplyx);

    //_fetchSales();

    setState(() {});
    _supplyx = Supply();
  }

  _fetchCustomer() async {
    List<Supplier> k = await _dbHelperSupplier.fetchSupplier();

    customerAll = k;
  }

  Map<String, Map<String, String>> _mapToListSalesD(Supply x) {
    String? jsonString = x.productList;

    Map<String, dynamic>? stringMap;

    if (jsonString != null) {
      stringMap = json.decode(jsonString);
    }

    Map<String, Map<String, String>> productMa = {};
    if (stringMap != null) {
      stringMap.forEach((key, value) {
        productMa[key] = Map<String, String>.from(value);
      });
    }

    return productMa;
  }

  List<Supplier> customerAll = [];

  Supply _supplyx = Supply();

  Widget CardDelivery(
      double height, double width, int index, BuildContext context) {
    String name1 = '';

    for (var i in customerAll) {
      if (i.id.toString() == _deliverySalesAll[index].supplierId)
        //print(i.name);
        name1 = i.name!;
    }

    return Dismissible(
      key: Key(_deliverySalesAll[index].id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.

      direction: DismissDirection.endToStart,

      //direction: DismissDirection.horizontal,

      onDismissed: (direction) {
        int index1 = 0;

        for (var i in _supplyAllFilter) {
          if (i.id == _deliverySalesAll[index].id) {
            index1 = _supplyAllFilter.indexOf(i);
          }
        }

        // _sales = _deliverySalesAll[index];
        _supply = _supplyAllFilter[index1];
        _supply.deliveryStatus = 'delivered';
        _supply.deliveryDate =
            '${DateTime.now().toString().split(' ')[0].split('-').reversed.join('/')} - ${DateTime.now().toString().split(' ')[1].split('.')[0].substring(0, 5)}';

        _updateDeliveryStatus(index1);
        // Remove the item from the data source.
        //_deliverySalesAll.removeAt(index);
        _deliverySalesAll.removeAt(index);

        // _updateDeliveryStatusx();

        //_supply = _supplyAllFilter[index];
        //_supply.deliveryStatus = 'delivered';

        // Then show a snackbar.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('dismissed')));
      },
      // Show a red background as the item is swiped away.
      background: Container(
        margin: EdgeInsets.only(bottom: 8, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Color.fromRGBO(2, 120, 174, 1),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Text(
          'Delivered!',
          textAlign: TextAlign.right,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: 'Koulen'),
        ),
      ),

      child: InkWell(
        child: Container(
          height: height * 0.09,
          width: double.infinity,

          margin: EdgeInsets.only(
            bottom: 8,
          ),
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey, // Color of the shadow
                offset: Offset.zero, // Offset of the shadow
                blurRadius: 6, // Spread or blur radius of the shadow
                spreadRadius: 0, // How much the shadow should spread
              )
            ],
            // borderRadius: BorderRadius.circular(4),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
            color: Colors.white,
          ),
          //padding: const EdgeInsets.only( top: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                //height: 40,
                alignment: Alignment.centerLeft,
                //color: const Color.fromRGBO(244, 244, 244, 1),

                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Vendor  ',
                        style: TextStyle(
                          color: Color.fromRGBO(92, 94, 98, 1),
                          fontSize: 12,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: '${name1}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
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
                    //alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: double.infinity,
                          margin: EdgeInsets.only(right: 20),
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'purchase date  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 11,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${DateFormat('dd-MM-yy').format(DateTime.parse(_deliverySalesAll[index].date.toString().trim())).toString()}',
                                  //'${f.length}',
                                  style: TextStyle(
                                    color: Color.fromRGBO(2, 120, 174, 1),
                                    fontSize: 18,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: double.infinity,
                          margin: EdgeInsets.only(right: 20),
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'order no  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(92, 94, 98, 1),
                                    fontSize: 11,
                                    fontFamily: 'Koulen',
                                  ),
                                ),
                                TextSpan(
                                  text: '${_deliverySalesAll[index].orderId}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Koulen',
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
        onLongPress: () {
          /* setState(() {
            order = true;
            transaction = false;
            dashboard = false;
            _filter(supplierF, packingF, dateF, statusF, customOrderF);
          });
          int index = 0;
          for (var i in _supplyAllFilter) {
            if (i.id == _deliverySalesAll[index].orderId) {
              index = _supplyAllFilter.indexOf(i);
            }
          }*/

          /*_scrollToElement(
            _supplyAllFilter.length - index - 1,
          );*/
        },
      ),
    );
  }

  // Define a GlobalKey for the ListView

  Widget CardPayments(
      double height, double width, int index, BuildContext context) {
    String name1 = '';

    for (var i in customerAll) {
      if (i.id.toString() == _paymentSupplyAll[index].supplierId)
        //print(i.name);
        name1 = i.name!;
    }

    Map<String, Map<String, String>> f =
        _mapToListSalesD(_paymentSupplyAll[index]);

    double orderAmount = 0;

    for (var i in f.entries) {
      orderAmount +=
          double.parse(i.value['buy']!) * double.parse(i.value['qty']!);
    }

    return Container(
      height: height * 0.09,
      width: double.infinity,

      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // Color of the shadow
            offset: Offset.zero, // Offset of the shadow
            blurRadius: 6, // Spread or blur radius of the shadow
            spreadRadius: 0, // How much the shadow should spread
          )
        ],
        // borderRadius: BorderRadius.circular(4),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
        color: Colors.white,
      ),
      //padding: const EdgeInsets.only( top: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            //height: 40,
            alignment: Alignment.centerLeft,
            //color: const Color.fromRGBO(244, 244, 244, 1),

            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: 'Vendor  ',
                    style: TextStyle(
                      color: Color.fromRGBO(92, 94, 98, 1),
                      fontSize: 12,
                      fontFamily: 'Koulen',
                    ),
                  ),
                  TextSpan(
                    text: '${name1}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
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
                //alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      margin: EdgeInsets.only(right: 20),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'purchase date  ',
                              style: TextStyle(
                                color: Color.fromRGBO(92, 94, 98, 1),
                                fontSize: 11,
                                fontFamily: 'Koulen',
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${DateFormat('dd-MM-yy').format(DateTime.parse(_paymentSupplyAll[index].date.toString().trim())).toString()}',
                              //'${f.length}',
                              style: TextStyle(
                                color: Color.fromRGBO(2, 120, 174, 1),
                                fontSize: 18,
                                fontFamily: 'Koulen',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      margin: EdgeInsets.only(left: 15),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'pending amt  ',
                              style: TextStyle(
                                color: Color.fromRGBO(92, 94, 98, 1),
                                fontSize: 11,
                                fontFamily: 'Koulen',
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${(orderAmount - double.parse(_paymentSupplyAll[index].paidAmt!)).toStringAsFixed(2)}' +
                                      ' \u{20B9}',
                              //'${f.length}',
                              style: TextStyle(
                                color: Color.fromARGB(255, 230, 43, 30),
                                fontSize: 18,
                                fontFamily: 'Koulen',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: double.infinity,
                      margin: EdgeInsets.only(right: 20),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'order no  ',
                              style: TextStyle(
                                color: Color.fromRGBO(92, 94, 98, 1),
                                fontSize: 11,
                                fontFamily: 'Koulen',
                              ),
                            ),
                            TextSpan(
                              text: '${_paymentSupplyAll[index].orderId}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Koulen',
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
    );
  }

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

  List<Inventory> productsSold = [];

  List<MapEntry<String, Map<String, dynamic>>> profitProduct = [];

  final ScrollController _scrollControllerx = ScrollController();

  void _scrollToElement(int x, double height) {
    // Calculate the scroll offset based on the item height and index
    double offset = x * 180; // Adjust 56.0 based on your item height

    // Scroll to the calculated offset
    _scrollControllerx.animateTo(
      offset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  final ScrollController _scrollControllerPayment = ScrollController();
  void _scrollToElementPayment(int x, double height) {
    // Calculate the scroll offset based on the item height and index
    double offset = x * height * 0.22; // Adjust 56.0 based on your item height

    // Scroll to the calculated offset
    _scrollControllerPayment.animateTo(
      offset,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

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

    for (var i in _supplyAllx) {
      receievedPayments1 = receievedPayments1 + double.parse(i.paidAmt!);

      String? jsonString = i.productList;

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
            double.parse(i.value['buy']!) * double.parse(i.value['qty']!);

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

      totalProfit1 = totalProfit1 + (totalMrp - totalBuy);

      totalOrders1 = totalOrders1 + 1;

      if (i.deliveryStatus == 'pending') {
        homeDelivery1 = homeDelivery1 + 1;
      }
    }

    Map<String, Map<String, dynamic>> productInfo = {};

    productMapAll.forEach((key, product) {
      String productName = product["productName"];
      double price = double.tryParse(product["sell"]) ?? 0.0;
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        body:
            //if(chooseSupplier == false)
            Row(
          children: [
            if (packaging == '')
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
                        'Vendor',
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
                      //height: height * 0.06,
                      margin: EdgeInsets.only(left: 15, right: 15, top: 0),
                      decoration: BoxDecoration(),
                      child: Row(
                        children: [
                          EditAdd(),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              color: Colors.white,
                            ),
                            //margin: EdgeInsets.only(left: 5),
                            width: width * 0.04,
                            height: double.infinity,
                            child: IconButton(
                                onPressed: () {
                                  //list not opened
                                  if (vendorList == false) {
                                    vendorList = !vendorList;

                                    addVendorIcon = true;
                                    editVendorIcon = false;

                                    // _selectedIndex = -1;
                                    //_tileSelected = false;
                                    //_supplierCardEdit = true;
                                    // _editCardManager('', '', '');
                                    // addVendor = false;
                                  }

                                  // list opened and add icon showing
                                  else if (addVendorIcon == true &&
                                      _tileSelected == false &&
                                      vendorList == true) {
                                    //     _selectedIndex = -1;
                                    //_tileSelected = false;
                                    _supplierCardEdit = false;
                                    _editCardManager('', '', '', '');

                                    _supplierCardEdit = !_supplierCardEdit;

                                    _searchResultSupplier = [
                                      Supplier(name: '', phone: '', address: '')
                                    ];

                                    /* _searchResultSupplier.insert(
                                                      0,
                                                      Supplier(
                                                          name: '',
                                                          phone: '',
                                                          address: ''));*/

                                    // _selectedIndex = 0;
                                    // _tileSelected = false;
                                    _onFirstPage = false;

                                    addVendor = true;

                                    setState(() {});
                                  }
                                  // list opened and edit icon showing
                                  else if (editVendorIcon == true &&
                                      _tileSelected == true &&
                                      vendorList == true) {
                                    // _selectedIndex = -1;
                                    // _tileSelected = false;
                                    // _supplierCardEdit = false;

                                    _searchResultSupplier = [
                                      Supplier(name: '', phone: '', address: '')
                                    ];

                                    editVendor = true;

                                    addVendor = false;

                                    _supplierCardEdit = !_supplierCardEdit;

                                    setState(() {});
                                  }
                                  setState(() {});
                                },
                                icon: (addVendorIcon == true &&
                                        vendorList == true &&
                                        _tileSelected == false)
                                    ? Icon(
                                        Icons.person_add,
                                        color: Colors.black,
                                      )
                                    : (editVendorIcon == true &&
                                            vendorList == true &&
                                            _tileSelected == true)
                                        ? Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          )),
                          ),
                        ],
                      ),
                    ),
                    if (!vendorList)
                      Container(
                        width: double.infinity,
                        height: height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.transparent),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                        child: Text(
                          'Balance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Koulen',
                          ),
                        ),
                      ),
                    if (!vendorList)
                      Container(
                        width: double.infinity,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 15, right: 15, top: 0),
                        child: Text(
                          balance.toStringAsFixed(2) + ' \u{20B9}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: balance < 0
                                ? Color.fromARGB(255, 230, 43, 30)
                                : Color.fromARGB(255, 64, 177, 68),
                            fontSize: 23,
                            fontFamily: 'Koulen',
                          ),
                        ),
                      ),
                    if (!vendorList)
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.black,
                        margin: EdgeInsets.only(left: 5, right: 5, top: 60),
                      ),
                    if (!vendorList)
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
                            order = false;
                            transaction = false;
                            dashboard = true;
                            _filter(supplierF, packingF, dateF, statusF,
                                customOrderF);
                          });
                        },
                      ),
                    if (!vendorList)
                      InkWell(
                        child: Container(
                          width: double.infinity,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: order
                                  ? Color.fromRGBO(38, 40, 40, 1)
                                  : Colors.transparent),
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Text(
                            'Purchases',
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
                            order = true;
                            transaction = false;
                            dashboard = false;
                            _filter(supplierF, packingF, dateF, statusF,
                                customOrderF);
                          });
                        },
                      ),
                    if (!vendorList)
                      InkWell(
                        child: Container(
                          width: double.infinity,
                          height: height * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: transaction
                                  ? Color.fromRGBO(38, 40, 40, 1)
                                  : Colors.transparent),
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                          alignment: Alignment.center,
                          child: Text(
                            'Transactions',
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
                            order = false;
                            transaction = true;
                            dashboard = false;
                            _filter(supplierF, packingF, dateF, statusF,
                                customOrderF);
                          });
                        },
                      ),
                    if (vendorList)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5)),
                            //color: const Color.fromRGBO(244, 244, 244, 1),
                            // color: Colors.black,
                          ),
                          margin: EdgeInsets.only(
                            bottom: 10,
                            top: 0,
                            left: 3,
                            right: 3,
                          ),
                          width: double.infinity,
                          //height: height * 0.7,
                          alignment: Alignment.centerLeft,
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 0, left: 10, right: 10),
                                child: ListView.builder(
                                  itemCount: _searchResultSupplier.length,
                                  itemBuilder: (context, index) {
                                    return !(addVendor || editVendor)
                                        ? Card(
                                            elevation: 0,
                                            color: _selectedIndex != index
                                                ? Colors.white
                                                : Colors.black,
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 5),
                                            //   elevation: _selectedIndex != index ? 0 : 5,
                                            child: InkWell(
                                                child: Container(
                                                    height: 60,
                                                    width: double.infinity,

                                                    //  margin: EdgeInsets.only(bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: _selectedIndex !=
                                                              index
                                                          ? Colors.white
                                                          : Colors.black,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey, // Color of the shadow
                                                          offset: Offset(0,
                                                              2), // Offset of the shadow
                                                          blurRadius:
                                                              6, // Spread or blur radius of the shadow
                                                          spreadRadius:
                                                              0, // How much the shadow should spread
                                                        ),
                                                      ],
                                                      //  color: _selectedIndex != index ? Colors.white : Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),

                                                    //padding: EdgeInsets.only(top: 10),

                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                _selectedIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 10),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            _searchResultSupplier[
                                                                            index]
                                                                        .name !=
                                                                    ''
                                                                ? _searchResultSupplier[
                                                                        index]
                                                                    .name![0]
                                                                    .toUpperCase()
                                                                : '',
                                                            style: TextStyle(
                                                                color: _selectedIndex !=
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                fontSize: 20,
                                                                fontFamily:
                                                                    'BanglaBold'),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height:
                                                                double.infinity,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    '${_searchResultSupplier[index].name!.toUpperCase()}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Koulen',
                                                                      fontSize:
                                                                          18,
                                                                      color: _selectedIndex ==
                                                                              index
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    '${_searchResultSupplier[index].phone!}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Koulen',
                                                                      fontSize:
                                                                          14,
                                                                      color: _selectedIndex ==
                                                                              index
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                onTap: () {
                                                  ////

                                                  if (_selectedIndex == index) {
                                                    _selectedIndex = -1;
                                                    _tileSelected = false;
                                                    _onFirstPage = true;
                                                    addVendor = false;

                                                    editVendorIcon = false;

                                                    map = {};
                                                    date = [];

                                                    _paidAmount = 0;
                                                    _receivedAmount = 0;
                                                    _balanceAmount = 0;

                                                    _searchResultT = [];

                                                    // _refreshSupplyListAll();
                                                    _filter('', packingF, dateF,
                                                        statusF, customOrderF);

                                                    _ctrlOrderSearch.clear();
                                                    globals.mainSupplier = -1;
                                                    globals.SupplierName = '';
                                                    globals.SupplierId = 0;
                                                    _editCardManager(
                                                        '', '', '', '');
                                                  } else {
                                                    editVendorIcon = true;

                                                    _tileSelected = true;

                                                    _selectedIndex = index;

                                                    _ctrlOrderSearch.text =
                                                        _searchResultSupplier[
                                                                index]
                                                            .name!;
                                                    globals.mainSupplier =
                                                        index;
                                                    globals.SupplierName =
                                                        _searchResultSupplier[
                                                                index]
                                                            .name!;
                                                    globals.SupplierId =
                                                        _searchResultSupplier[
                                                                index]
                                                            .id!;
                                                    //      _selectTile(
                                                    //        index); // Update selected index

                                                    setState(() {});

                                                    _editCardManager(
                                                        _searchResultSupplier[
                                                                index]
                                                            .name!,
                                                        _searchResultSupplier[
                                                                index]
                                                            .phone!,
                                                        _searchResultSupplier[
                                                                index]
                                                            .address!,
                                                        _searchResultSupplier[
                                                                index]
                                                            .contactId!);

                                                    date = [];
                                                    map = {};
                                                    _filter(
                                                        _searchResultSupplier[
                                                                index]
                                                            .id!
                                                            .toString(),
                                                        packingF,
                                                        dateF,
                                                        statusF,
                                                        customOrderF);

                                                    // _refreshSupplyListX(_searchResultSupplier[index].id!);

                                                    //  _refreshTransactiontList(_searchResultSupplier[index].id!);
                                                  }
                                                  /* if (_tileSelected) {
                                                            editVendorIcon = true;
                                                            addVendorIcon = false;
                                                          } else {
                                                            editVendorIcon =
                                                                false;
                                                            addVendorIcon = true;
                                                          }*/
                                                  setState(() {});

                                                  // Update selected index
                                                }),
                                          )
                                        : Card(
                                            color: Color.fromRGBO(
                                                244, 244, 244, 1),
                                            elevation: 0,
                                            child: InkWell(
                                                child: Container(
                                                    height: height * 0.453,
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5,
                                                            top: 7,
                                                            left: 10,
                                                            right: 10),
                                                    margin: EdgeInsets.only(
                                                        bottom: 0),
                                                    decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey, // Color of the shadow
                                                          offset: Offset(0,
                                                              2), // Offset of the shadow
                                                          blurRadius:
                                                              6, // Spread or blur radius of the shadow
                                                          spreadRadius:
                                                              0, // How much the shadow should spread
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Color.fromRGBO(
                                                          244, 244, 244, 1),
                                                    ),

                                                    //padding: EdgeInsets.only(top: 10),

                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            width: 55,
                                                            height: 55,
                                                            // width: double.infinity,
                                                            //height: double.infinity,

                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 10,
                                                                    left: 10),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              'X',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Koulen'),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: height * 0.1,
                                                          width:
                                                              double.infinity,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 0,
                                                                  top: 15),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: height *
                                                                    0.022,
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
                                                                child: const Text(
                                                                    'Enter Vendor Name*',
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
                                                                height: height *
                                                                    0.048,
                                                                //color: Colors.black,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        top: 5,
                                                                        bottom:
                                                                            0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey, // Color of the shadow
                                                                      offset: Offset(
                                                                          0,
                                                                          2), // Offset of the shadow
                                                                      blurRadius:
                                                                          6, // Spread or blur radius of the shadow
                                                                      spreadRadius:
                                                                          0, // How much the shadow should spread
                                                                    ),
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
                                                                  readOnly:
                                                                      true, // Prevent system keyboard
                                                                  showCursor:
                                                                      false,
                                                                  focusNode:
                                                                      _supplierName,
                                                                  controller:
                                                                      _ctrlSupplierName,
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
                                                                //height: height * 0.05,
                                                                //color: Colors.black,
                                                                child: Text(
                                                                  errorSupplierName,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Koulen',
                                                                      fontSize:
                                                                          13,
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
                                                        Container(
                                                          height: height * 0.1,
                                                          width:
                                                              double.infinity,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 0,
                                                                  top: 0),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: height *
                                                                    0.022,
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
                                                                child: const Text(
                                                                    'Phone',
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
                                                                height: height *
                                                                    0.048,
                                                                //color: Colors.black,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        top: 5,
                                                                        bottom:
                                                                            0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey, // Color of the shadow
                                                                      offset: Offset(
                                                                          0,
                                                                          2), // Offset of the shadow
                                                                      blurRadius:
                                                                          6, // Spread or blur radius of the shadow
                                                                      spreadRadius:
                                                                          0, // How much the shadow should spread
                                                                    ),
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
                                                                  readOnly:
                                                                      true, // Prevent system keyboard
                                                                  showCursor:
                                                                      false,
                                                                  focusNode:
                                                                      _supplierPhone,
                                                                  controller:
                                                                      _ctrlSupplierPhone,
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
                                                                //height: height * 0.05,
                                                                //color: Colors.black,
                                                                child: Text(
                                                                  errorSupplierPhone,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Koulen',
                                                                      fontSize:
                                                                          13,
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
                                                        Container(
                                                          height: height * 0.1,
                                                          width:
                                                              double.infinity,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 0,
                                                                  top: 0),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: height *
                                                                    0.022,
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
                                                                child: const Text(
                                                                    'Address',
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
                                                                height: height *
                                                                    0.048,
                                                                //color: Colors.black,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        top: 5,
                                                                        bottom:
                                                                            0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey, // Color of the shadow
                                                                      offset: Offset(
                                                                          0,
                                                                          2), // Offset of the shadow
                                                                      blurRadius:
                                                                          6, // Spread or blur radius of the shadow
                                                                      spreadRadius:
                                                                          0, // How much the shadow should spread
                                                                    ),
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
                                                                  readOnly:
                                                                      true, // Prevent system keyboard
                                                                  showCursor:
                                                                      false,
                                                                  focusNode:
                                                                      _supplierAddress,
                                                                  controller:
                                                                      _ctrlSupplierAddress,
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
                                                                //height: height * 0.05,
                                                                //color: Colors.black,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //buttons
                                                        Container(
                                                          width:
                                                              double.infinity,

                                                          height: height * 0.05,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 0,
                                                                  top: 0,
                                                                  left: 5,
                                                                  right: 0),
                                                          //padding: EdgeInsets.only(bottom: 5),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 20,
                                                              ),
                                                              //delete button
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5,
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                0),
                                                                        height:
                                                                            double.infinity,
                                                                        child: ElevatedButton(
                                                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                                                                            onPressed: () async {
                                                                              if (addVendor == false) {
                                                                                await _dbHelper1.deleteSupplier(globals.SupplierId);

                                                                                Contact? contact = await FlutterContacts.getContact(_supplier.contactId!, withAccounts: true);

                                                                                await contact?.delete();

                                                                                _resetSupplierForm();
                                                                                _selectedIndex = -1;
                                                                                _tileSelected = false;
                                                                                _supplierCardEdit = false;
                                                                                _editCardManager('', '', '', '');
                                                                                addVendor = false;
                                                                                editVendor = false;

                                                                                //_searchResultSupplier.clear();
                                                                                setState(() {});
                                                                                _refreshContactList();
                                                                              } else {
                                                                                _resetSupplierForm();
                                                                                //_selectedIndex = -1;
                                                                                // _tileSelected = false;
                                                                                //_supplierCardEdit = false;
                                                                                //_onFirstPage = true;
                                                                                //_editCardManager('', '', '');
                                                                                addVendor = false;
                                                                                editVendor = false;
                                                                                _refreshContactList();
                                                                                _editCardManager('', '', '', '');
                                                                                //_searchResultSupplier.removeAt(0);
                                                                              }
                                                                              //_resetFormSupply();}
                                                                            },
                                                                            child: Text('Delete', style: TextStyle(fontFamily: 'Koulen', fontSize: 14, color: Colors.white)))),
                                                              ),
                                                              //edit button
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                0,
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                0),
                                                                        height:
                                                                            double.infinity,
                                                                        child: ElevatedButton(
                                                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                                                                            onPressed: () {
                                                                              if (_ctrlSupplierName.text == '' || _ctrlSupplierPhone.text == '') {
                                                                                if (_ctrlSupplierName.text == '') {
                                                                                  errorSupplierName = 'Invalid';
                                                                                }
                                                                                if (_ctrlSupplierPhone.text == '') {
                                                                                  errorSupplierPhone = 'Invalid';
                                                                                }
                                                                                setState(() {});
                                                                              } else {
                                                                                if (addVendor == true) {
                                                                                  _supplier.name = _ctrlSupplierName.text;
                                                                                  _supplier.phone = _ctrlSupplierPhone.text;
                                                                                  _supplier.address = _ctrlSupplierAddress.text;
                                                                                  _supplier.contactId = _ctrlSupplierContactId.text;
                                                                                  _updateSupplier();
                                                                                  //_resetFormSupply();
                                                                                } else if (editVendor == true) {
                                                                                  _supplier.id = globals.SupplierId;
                                                                                  _supplier.name = _ctrlSupplierName.text;
                                                                                  _supplier.phone = _ctrlSupplierPhone.text;
                                                                                  _supplier.address = _ctrlSupplierAddress.text;
                                                                                  _supplier.contactId = _ctrlSupplierContactId.text;
                                                                                  _updateSupplier();
                                                                                }
                                                                              }
                                                                            },
                                                                            child: Text('Done', style: TextStyle(fontFamily: 'Koulen', fontSize: 14, color: Colors.white)))),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                                onTap: () {
                                                  /*if (addVendor == true) {
                                                            _selectedIndex = -1;
                                                            _tileSelected = false;
                                                            _supplierCardEdit =
                                                                false;
                                                            _editCardManager(
                                                                '', '', '');
                                                            addVendor = false;
                                                            _onFirstPage =
                                                                !_onFirstPage;
                        
                                                            _searchResultSupplier
                                                                .removeAt(0);
                                                          } else {
                                                            _onFirstPage =
                                                                !_onFirstPage;
                                                            _selectedIndex = -1;
                                                            _tileSelected = false;
                                                            _supplierCardEdit =
                                                                false;
                                                            _editCardManager(
                                                                '', '', '');
                                                            addVendor = false;
                                                          }
                                                          if (_tileSelected) {
                                                            editVendorIcon = true;
                                                            addVendorIcon = false;
                                                          } else {
                                                            editVendorIcon =
                                                                false;
                                                            addVendorIcon = true;
                                                          }
                                                          setState(() {});*/

                                                  // Update selected index
                                                }),
                                          );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            //ROW 1

            if (packaging == '')
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(
                    right: 10, left: 5, top: 5, bottom: 0),
                height: double.infinity,
                child: Column(
                  children: [
                    if (!dashboard)
                      Container(
                        width: double.infinity,
                        height: height * 0.075,
                        //color: Colors.black,
                        margin: EdgeInsets.only(bottom: 10, left: 5),

                        child: Row(
                          children: [
                            //supplier
                            /*     Container(
                            height: double.infinity,
                            width: width * 0.2,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  // height: height * 0.03,
                                  alignment: Alignment.centerLeft,
                                  //margin: EdgeInsets.only(bottom: 5),
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Vendor',
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
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey, // Color of the shadow
                                        offset:
                                            Offset.zero, // Offset of the shadow
                                        blurRadius:
                                            6, // Spread or blur radius of the shadow
                                        spreadRadius:
                                            0, // How much the shadow should spread
                                      )
                                    ]),
                                    child: Row(
                                      children: [
                                        EditAdd(),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(4),
                                              topRight: Radius.circular(4),
                                            ),
                                            color: Colors.white,
                                          ),
                                          //margin: EdgeInsets.only(left: 5),
                                          width: width * 0.04,
                                          height: double.infinity,
                                          child: IconButton(
                                              onPressed: () {
                                                //list not opened
                                                if (vendorList == false) {
                                                  vendorList = !vendorList;

                                                  addVendorIcon = true;
                                                  editVendorIcon = false;

                                                  // _selectedIndex = -1;
                                                  //_tileSelected = false;
                                                  //_supplierCardEdit = true;
                                                  // _editCardManager('', '', '');
                                                  // addVendor = false;
                                                }

                                                // list opened and add icon showing
                                                else if (addVendorIcon ==
                                                        true &&
                                                    _tileSelected == false &&
                                                    vendorList == true) {
                                                  //     _selectedIndex = -1;
                                                  //_tileSelected = false;
                                                  _supplierCardEdit = false;
                                                  _editCardManager(
                                                      '', '', '', '');

                                                  _supplierCardEdit =
                                                      !_supplierCardEdit;

                                                  _searchResultSupplier = [
                                                    Supplier(
                                                        name: '',
                                                        phone: '',
                                                        address: '')
                                                  ];

                                                  /* _searchResultSupplier.insert(
                                                      0,
                                                      Supplier(
                                                          name: '',
                                                          phone: '',
                                                          address: ''));*/

                                                  // _selectedIndex = 0;
                                                  // _tileSelected = false;
                                                  _onFirstPage = false;

                                                  addVendor = true;

                                                  setState(() {});
                                                }
                                                // list opened and edit icon showing
                                                else if (editVendorIcon ==
                                                        true &&
                                                    _tileSelected == true &&
                                                    vendorList == true) {
                                                  // _selectedIndex = -1;
                                                  // _tileSelected = false;
                                                  // _supplierCardEdit = false;

                                                  _searchResultSupplier = [
                                                    Supplier(
                                                        name: '',
                                                        phone: '',
                                                        address: '')
                                                  ];

                                                  editVendor = true;

                                                  addVendor = false;

                                                  _supplierCardEdit =
                                                      !_supplierCardEdit;

                                                  setState(() {});
                                                }
                                                setState(() {});
                                              },
                                              icon: (addVendorIcon == true &&
                                                      vendorList == true &&
                                                      _tileSelected == false)
                                                  ? Icon(
                                                      Icons.person_add,
                                                      color: Colors.black,
                                                    )
                                                  : (editVendorIcon == true &&
                                                          vendorList == true &&
                                                          _tileSelected == true)
                                                      ? Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .keyboard_arrow_down,
                                                          color: Colors.black,
                                                        )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
*/
                            /*   //divider
                          Container(
                            height: double.infinity,
                            width: 1,
                            color: Color.fromARGB(255, 72, 72, 73),
                            margin: EdgeInsets.only(left: 10, right: 10),
                          ),
                          //balance
                          Container(
                            height: double.infinity,
                            width: width * 0.095,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  // height: height * 0.03,
                                  alignment: Alignment.centerLeft,

                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Balance',
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
                                    alignment: Alignment.centerLeft,
                                    width: double.infinity,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      padding: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          boxShadow: [
                                            BoxShadow(
                                              color: (globals.SupplierName !=
                                                          '' &&
                                                      _tileSelected)
                                                  ? Colors.grey
                                                  : Colors
                                                      .white, // Color of the shadow
                                              // Color of the shadow
                                              offset: Offset
                                                  .zero, // Offset of the shadow
                                              blurRadius:
                                                  6, // Spread or blur radius of the shadow
                                              spreadRadius:
                                                  0, // How much the shadow should spread
                                            )
                                          ]),
                                      child: Text(
                                        (globals.SupplierName != '' &&
                                                _tileSelected)
                                            ? balance.toStringAsFixed(2) +
                                                ' \u{20B9}'
                                            : '',
                                        style: TextStyle(
                                            fontFamily: 'Koulen',
                                            fontSize: 21,
                                            //fontWeight: FontWeight.bold,
                                            color: balance < 0
                                                ? Colors.red
                                                : Colors.green),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
*/
                            //divider
                            /* Container(
                            height: double.infinity,
                            width: 1,
                            color: Color.fromARGB(255, 72, 72, 73),
                            margin: EdgeInsets.only(left: 10, right: 10),
                          ),*/
                            //vendor order
                            Container(
                              height: double.infinity,
                              width: transaction == false
                                  ? width * 0.05
                                  : width * 0.06,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    // height: height * 0.03,
                                    alignment: Alignment.centerLeft,

                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: order == true
                                                ? 'Add Purchase'
                                                : 'Add Transaction',
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
                                      alignment: Alignment.centerLeft,
                                      width: double.infinity,
                                      child: Container(
                                        width: 50,
                                        height: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color: globals.SupplierName != ''
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
                                        child: TextButton(
                                          onPressed: () {
                                            // _updateSupplyAmtCustom();

                                            if (globals.SupplierName != '') {
                                              if (order) {
                                                packaging = 'p';

                                                setState(() {});
                                              } else {
                                                addTransaction = true;
                                                setState(() {});
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.white),
                                              shape: MaterialStatePropertyAll(
                                                BeveledRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                              )),
                                          child: Text(
                                            '+',
                                            style: TextStyle(
                                                //fontFamily: 'Koulen',
                                                fontSize: 21,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
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

                            //filters
                            Container(
                              height: double.infinity,
                              width: width * 0.26,
                              //color: Colors.black,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: order == true
                                                ? 'Filter - Date - Order Status'
                                                : 'Filter - Date - Transaction Type',
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
                                                    color: dateList
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
                                            padding: EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  dateF == 'today'
                                                      ? 'Today'
                                                      : dateF == 'yesterday'
                                                          ? 'Yesterday'
                                                          : dateF == 'week'
                                                              ? 'Last Week'
                                                              : dateF ==
                                                                      '1month'
                                                                  ? 'Last Month'
                                                                  : dateF ==
                                                                          '6month'
                                                                      ? 'Last 6 Months'
                                                                      : dateF ==
                                                                              '1year'
                                                                          ? 'Last Year'
                                                                          : 'All',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontFamily: 'Koulen',
                                                  ),
                                                ),
                                                Expanded(child: Container()),
                                                PopupMenuButton(
                                                  color: Colors.white,
                                                  offset: Offset(-105, 65),

                                                  // Color of the shadow

                                                  //offset: const Offset(-120, 45),
                                                  shape: BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)),

                                                  icon: Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      color: Colors.black,
                                                      size: 20),
                                                  //initialValue: 2,
                                                  onOpened: () {
                                                    dateList = true;
                                                    setState(() {});
                                                  },

                                                  initialValue: 0,
                                                  onCanceled: () {
                                                    dateList = false;
                                                    setState(() {});
                                                    print(
                                                        "You have canceled the menu selection.");
                                                  },
                                                  shadowColor: Colors.grey,
                                                  onSelected: (value) {
                                                    dateList = false;
                                                    setState(() {});
                                                    switch (value) {
                                                      case 0:
                                                        //do something
                                                        setState(() {
                                                          //packaging = '';
                                                          _filter(
                                                              supplierF,
                                                              packingF,
                                                              'today',
                                                              statusF,
                                                              customOrderF);
                                                        });
                                                        break;
                                                      case 1:
                                                        //do something
                                                        setState(() {
                                                          //packaging = 'Packed';

                                                          _filter(
                                                              supplierF,
                                                              packingF,
                                                              'yesterday',
                                                              statusF,
                                                              customOrderF);
                                                        });
                                                        break;
                                                      case 2:
                                                        //do something
                                                        setState(() {
                                                          //packaging = 'Loose';

                                                          _filter(
                                                              supplierF,
                                                              packingF,
                                                              'week',
                                                              statusF,
                                                              customOrderF);
                                                        });
                                                        break;
                                                      case 3:
                                                        //do something
                                                        setState(() {
                                                          //packaging = 'Loose';

                                                          _mapTest(true);
                                                          _filter(
                                                              supplierF,
                                                              packingF,
                                                              '1month',
                                                              statusF,
                                                              customOrderF);
                                                        });
                                                        break;
                                                      case 4:
                                                        //do something
                                                        setState(() {
                                                          //packaging = 'Loose';
                                                          _filter(
                                                              supplierF,
                                                              packingF,
                                                              '6month',
                                                              statusF,
                                                              customOrderF);
                                                        });
                                                        break;
                                                      case 5:
                                                        //do something
                                                        setState(() {
                                                          //packaging = 'Loose';
                                                          _filter(
                                                              supplierF,
                                                              packingF,
                                                              '1year',
                                                              statusF,
                                                              customOrderF);
                                                        });
                                                        break;
                                                      case 6:
                                                        //do something
                                                        setState(() {
                                                          //packaging = 'Loose';
                                                          _filter(
                                                              supplierF,
                                                              packingF,
                                                              ' ',
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
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                          )),
                                                      const PopupMenuItem(
                                                          value: 1,
                                                          child: Center(
                                                            child: Text(
                                                              'Yesterday',
                                                              style: TextStyle(
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
                                                              'Last Week',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                          )),
                                                      const PopupMenuItem(
                                                          value: 3,
                                                          child: Center(
                                                            child: Text(
                                                              'Last Month',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                          )),
                                                      const PopupMenuItem(
                                                          value: 4,
                                                          child: Center(
                                                            child: Text(
                                                              'Last 6 Months',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                          )),
                                                      const PopupMenuItem(
                                                          value: 5,
                                                          child: Center(
                                                            child: Text(
                                                              'Last Year',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Koulen',
                                                              ),
                                                            ),
                                                          )),
                                                      const PopupMenuItem(
                                                          value: 6,
                                                          child: Center(
                                                            child: Text(
                                                              'All',
                                                              style: TextStyle(
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

                                          //order status
                                          if (order == true)
                                            Container(
                                              height: double.infinity,
                                              width: width * 0.1,
                                              margin: EdgeInsets.only(
                                                left: 15,
                                              ),
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: statusList
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
                                                    statusF == ''
                                                        ? 'Both'
                                                        : statusF,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                  Expanded(child: Container()),
                                                  PopupMenuButton(
                                                    offset: Offset(-10, 65),
                                                    color: Colors.white,
                                                    shadowColor: Colors.grey,
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
                                                      statusList = true;
                                                      setState(() {});
                                                    },

                                                    initialValue: 0,
                                                    onCanceled: () {
                                                      statusList = false;
                                                      setState(() {});
                                                      print(
                                                          "You have canceled the menu selection.");
                                                    },
                                                    onSelected: (value) {
                                                      statusList = false;
                                                      setState(() {});
                                                      switch (value) {
                                                        case 0:
                                                          //do something
                                                          setState(() {
                                                            //packaging = '';
                                                            _filter(
                                                                supplierF,
                                                                packingF,
                                                                dateF,
                                                                '',
                                                                customOrderF);
                                                          });
                                                          break;
                                                        case 1:
                                                          //do something
                                                          setState(() {
                                                            //packaging = 'Packed';
                                                            _filter(
                                                                supplierF,
                                                                packingF,
                                                                dateF,
                                                                'pending',
                                                                customOrderF);
                                                          });
                                                          break;
                                                        case 2:
                                                          //do something
                                                          setState(() {
                                                            //packaging = 'Loose';
                                                            _filter(
                                                                supplierF,
                                                                packingF,
                                                                dateF,
                                                                'completed',
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
                                                                'Both',
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
                                                            value: 1,
                                                            child: Center(
                                                              child: Text(
                                                                'Pending',
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
                                                                'Completed',
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

                                          // order/custom
                                          if (order != true)
                                            Container(
                                              height: double.infinity,
                                              width: width * 0.09,
                                              margin: EdgeInsets.only(
                                                left: 15,
                                              ),
                                              alignment: Alignment.centerLeft,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: orderCustomList
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
                                                    customOrderF == ''
                                                        ? 'Both'
                                                        : customOrderF,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
                                                    ),
                                                  ),
                                                  Expanded(child: Container()),
                                                  PopupMenuButton(
                                                    offset: Offset(-2, 65),
                                                    color: Colors.white,
                                                    shadowColor: Colors.grey,
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
                                                      orderCustomList = true;
                                                      setState(() {});
                                                    },

                                                    initialValue: 0,
                                                    onCanceled: () {
                                                      orderCustomList = false;
                                                      setState(() {});
                                                      print(
                                                          "You have canceled the menu selection.");
                                                    },
                                                    onSelected: (value) {
                                                      orderCustomList = false;
                                                      setState(() {});
                                                      switch (value) {
                                                        case 0:
                                                          //do something
                                                          setState(() {
                                                            //packaging = '';
                                                            _filter(
                                                                supplierF,
                                                                packingF,
                                                                dateF,
                                                                statusF,
                                                                '');
                                                          });
                                                          break;
                                                        case 1:
                                                          //do something
                                                          setState(() {
                                                            //packaging = 'Packed';
                                                            _filter(
                                                                supplierF,
                                                                packingF,
                                                                dateF,
                                                                statusF,
                                                                'order');
                                                          });
                                                          break;
                                                        case 2:
                                                          //do something
                                                          setState(() {
                                                            //packaging = 'Loose';
                                                            _filter(
                                                                supplierF,
                                                                packingF,
                                                                dateF,
                                                                statusF,
                                                                'custom');
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
                                                                'Both',
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
                                                            value: 1,
                                                            child: Center(
                                                              child: Text(
                                                                'Order',
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
                                                                'Custom',
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
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '',
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
                                        alignment: Alignment.centerLeft,
                                        width: double.infinity,
                                        child: (loading)
                                            ? CircularProgressIndicator()
                                            : Container()),
                                  ),
                                ],
                              ),
                            ),
                            //print

                            Expanded(
                              child: Container(
                                height: double.infinity,
                              ),
                            ),

                            //divider
                            if (order == false)
                              Container(
                                height: double.infinity,
                                width: 1,
                                color: Color.fromARGB(255, 72, 72, 73),
                                margin: EdgeInsets.only(left: 10, right: 10),
                              ),
                            //print
                            if (order == false)
                              Container(
                                height: double.infinity,
                                width: width * 0.08,
                                margin: EdgeInsets.only(
                                  left: 0,
                                ),
                                alignment: Alignment.center,
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
                                              text: 'Transaction Report',
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
                                        child: Container(
                                          width: 70,
                                          height: double.infinity,
                                          decoration: BoxDecoration(boxShadow: [
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
                                            onPressed: () {
                                              if (globals.printerConnected) {
                                                screenshotController
                                                    .captureFromWidget(
                                                        xxxx(height, width),
                                                        //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)

                                                        delay: Duration(
                                                            seconds: 0),
                                                        targetSize: Size(
                                                            380,
                                                            //fixed= 390, card =
                                                            (700 +
                                                                30 +
                                                                (50 *
                                                                        (_searchResultT.length *
                                                                            1.4))
                                                                    .toDouble())))
                                                    .then((capturedImage) {
                                                  printCapturedImage(
                                                      capturedImage);
                                                  // Handle captured image
                                                });
                                              }
                                            },
                                            style: ButtonStyle(
                                                alignment: Alignment.center,
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.black),
                                                shape: MaterialStatePropertyAll(
                                                  BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)),
                                                )),
                                            child: Text(
                                              'Print',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            //print
                            //print
                            /* if (order == false)
                            Container(
                              height: double.infinity,
                              width: width * 0.098,
                              margin: EdgeInsets.only(
                                left: 0,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Print Transaction Receipt',
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
                                      alignment: Alignment.centerLeft,
                                      width: double.infinity,
                                      child: Container(
                                        width: 70,
                                        height: double.infinity,
                                        decoration: BoxDecoration(boxShadow: [
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
                                          onPressed: () {
                                            screenshotController
                                                .captureFromWidget(
                                                    xxxx(height, width),
                                                    //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)
        
                                                    delay: Duration(seconds: 0),
                                                    targetSize: Size(
                                                        380,
                                                        //fixed= 390, card =
                                                        (400 +
                                                            30 +
                                                            (50 *
                                                                    (_searchResultT
                                                                            .length *
                                                                        1.4))
                                                                .toDouble())))
                                                .then((capturedImage) {
                                              printCapturedImage(capturedImage);
                                              // Handle captured image
                                            });
                                          },
                                          style: ButtonStyle(
                                              alignment: Alignment.center,
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.white),
                                              shape: MaterialStatePropertyAll(
                                                BeveledRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                              )),
                                          child: Text(
                                            'Print',
                                            style: TextStyle(
                                                fontFamily: 'Koulen',
                                                fontSize: 15,
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
        
                                    /*child: InkWell(
                                      child: Container(
                                        height: 70,
                                        //width: 50,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          //color: Colors.white,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Center(
                                            child: Icon(
                                          FontAwesomeIcons
                                              .print, // FontAwesome icon for YouTube
                                          size:
                                              35, // Set the size of the icon as needed
                                          color: Color.fromRGBO(0, 134, 193,
                                              1), // Set the color of the icon
                                          shadows: [
                                            Shadow(
                                              blurRadius: 1,
                                              color: Colors.grey,
                                              offset: Offset.zero,
                                            ),
                                          ],
                                        )),
                                      ),
                                      onTap: () {
                                        screenshotController
                                            .captureFromWidget(
                                                xxxx(height, width),
                                                //card(height, width, no, product, qty, mrp, disc, total, barcode, index, context)
        
                                                delay: Duration(seconds: 0),
                                                targetSize: Size(
                                                    380,
                                                    //fixed= 390, card =
                                                    (400 +
                                                        30 +
                                                        (50 *
                                                                (_searchResultT
                                                                        .length *
                                                                    1.4))
                                                            .toDouble())))
                                            .then((capturedImage) {
                                          printCapturedImage(capturedImage);
                                          // Handle captured image
                                        });
                                      },
                                    ),*/
                                  ),
                                ],
                              ),
                            ),
        */
                            //divider

                            //order/transaction
                            /*   Container(
                            height: double.infinity,
                            width: width * 0.11,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Order/Transaction',
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
                                    //  height: height * 0.06,
                                    width: double.infinity,
                                    padding: EdgeInsets.only(left: 5),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
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
                                        color: Colors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            order == true
                                                ? 'Orders'
                                                : 'Transactions',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'Koulen',
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: PopupMenuButton(
                                            offset: Offset(4, 50),
                                            color: Colors.white,
                                            shadowColor: Colors.grey,
                                            shape: BeveledRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2)),

                                            icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                                size: 25),
                                            //initialValue: 2,

                                            initialValue: 0,
                                            onOpened: () {
                                              orderTransactionList = true;
                                              setState(() {});
                                            },
                                            onCanceled: () {
                                              orderTransactionList = false;
                                              setState(() {});
                                              print(
                                                  "You have canceled the menu selection.");
                                            },
                                            onSelected: (value) {
                                              orderTransactionList = false;
                                              setState(() {});
                                              switch (value) {
                                                case 1:
                                                  //do something
                                                  setState(() {
                                                    order = true;
                                                    transaction = false;
                                                    _filter(
                                                        supplierF,
                                                        packingF,
                                                        dateF,
                                                        statusF,
                                                        customOrderF);
                                                  });
                                                  break;
                                                case 2:
                                                  //do something
                                                  setState(() {
                                                    order = false;
                                                    transaction = true;
                                                    _filter(
                                                        supplierF,
                                                        packingF,
                                                        dateF,
                                                        statusF,
                                                        customOrderF);
                                                  });
                                                  break;
                                                default:
                                                  {
                                                    print("Invalid choice");
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
                                                        'Orders',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontFamily: 'Koulen',
                                                        ),
                                                      ),
                                                    )),
                                                const PopupMenuItem(
                                                    value: 2,
                                                    child: Center(
                                                      child: Text(
                                                        'Transactions',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontFamily: 'Koulen',
                                                        ),
                                                      ),
                                                    )),
                                              ];
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                       */
                          ],
                        ),
                      ),
                    Expanded(
                      child: Container(
                        child: Stack(children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    height: double.infinity,
                                    child:
                                        (order == true && transaction == false)
                                            ? GestureDetector(
                                                child: Container(
                                                  // height: height * 0.8,
                                                  width: double.infinity,

                                                  child: Column(
                                                    children: [
                                                      if (packaging == '')
                                                        Expanded(
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            margin:
                                                                EdgeInsets.only(
                                                              bottom: 5,
                                                            ),
                                                            color: Colors
                                                                .transparent,
                                                            child: /*AnimatedList(
                                                              key:
                                                                  _listKey, // Assign the GlobalKey here
                                                              initialItemCount: _supplyAllFilter
                                                                            .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index,
                                                                      animation) {
                                                                // Replace this with your list item widget
                                                                return _supplyCard(
                                                                          height,
                                                                          width,
                                                                          _supplyAllFilter.length -
                                                                              index -
                                                                              1,
                                                                          context);
                                                              },
                                                            ),*/

                                                                ListView
                                                                    .builder(
                                                                        controller:
                                                                            _scrollControllerx,
                                                                        itemCount:
                                                                            _supplyAllFilter
                                                                                .length,
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int index) {
                                                                          return InkWell(
                                                                            child: _supplyCard(
                                                                                height,
                                                                                width,
                                                                                _supplyAllFilter.length - index - 1,
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
                                                                                if (i.id == _deliverySalesAll[index].orderId) {
                                                                                  index = _supplyAllFilter.indexOf(i);
                                                                                }
                                                                              }

                                                                              _scrollToElement(
                                                                                _supplyAllFilter.length - index - 1,height
                                                                              );
                                                                            },*/
                                                                          );
                                                                        }),
                                                          ),
                                                        ),
                                                     /* if (_supplierCardEdit ||
                                                          _orderSearch
                                                              .hasFocus ||
                                                          editVendor ||
                                                          addVendor)
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: height * 0.39,
                                                          alignment:
                                                              FractionalOffset
                                                                  .centerRight,
                                                          child: Container(
                                                            width:
                                                                width * 0.776,
                                                            height:
                                                                double.infinity,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5,
                                                                    right: 0,
                                                                    left: 0),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey,
                                                                    // Color of the shadow
                                                                    offset: Offset
                                                                        .zero, // Offset of the shadow
                                                                    blurRadius:
                                                                        6, // Spread or blur radius of the shadow
                                                                    spreadRadius:
                                                                        0, // How much the shadow should spread
                                                                  )
                                                                ]),
                                                            child:
                                                                VirtualKeyboard(

                                                                    // height: 300,

                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    textController:
                                                                        _controllerText,
                                                                    //customLayoutKeys: _customLayoutKeys,
                                                                    defaultLayouts: [
                                                                      VirtualKeyboardDefaultLayouts
                                                                          .English
                                                                    ],
                                                                    //reverseLayout :true,
                                                                    type: isNumericMode
                                                                        ? VirtualKeyboardType
                                                                            .Numeric
                                                                        : VirtualKeyboardType
                                                                            .Alphanumeric,
                                                                    onKeyPress:
                                                                        (key) {
                                                                      _onKeyPress(
                                                                          key,
                                                                          _customPayment.hasFocus
                                                                              ? _ctrlTAmount
                                                                              : _orderSearch.hasFocus
                                                                                  ? _ctrlOrderSearch
                                                                                  : _description.hasFocus
                                                                                      ? _ctrlTDescription
                                                                                      : _supplierName.hasFocus
                                                                                          ? _ctrlSupplierName
                                                                                          : _supplierPhone.hasFocus
                                                                                              ? _ctrlSupplierPhone
                                                                                              : _supplierAddress.hasFocus
                                                                                                  ? _ctrlSupplierAddress
                                                                                                  : _none);
                                                                    }),
                                                          ),
                                                        )
                                                   */ ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  if (vendorList) {
                                                    vendorList = !vendorList;
                                                    _orderSearch.unfocus();

                                                    addVendor = false;

                                                    editVendor = false;
                                                    addVendorIcon = true;
                                                    editVendorIcon = false;
                                                    _editCardManager(
                                                        '', '', '', '');
                                                    _resetSupplierForm();

                                                    _refreshContactList();

                                                    _supplierCardEdit = false;
                                                  }
                                                },
                                              )
                                            : transaction == true
                                                ? GestureDetector(
                                                    child: Container(
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(
                                                        bottom: 5,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      // height: double.infinity,
                                                                      child: ListView.builder(
                                                                          itemCount: _searchResultT.length,
                                                                          itemBuilder: (BuildContext context, int index) {
                                                                            return cardTransaction(
                                                                                height,
                                                                                width,
                                                                                _searchResultT.length - index - 1,
                                                                                context);
                                                                          }),
                                                                    ),
                                                                  ),
                                                                  if (addTransaction)
                                                                    Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height: height *
                                                                          0.375,
                                                                      color: Colors
                                                                          .black,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          left:
                                                                              0),
                                                                      child:
                                                                          VirtualKeyboard(

                                                                              // height: 300,
                                                                              //width: 500,
                                                                              textColor: Colors
                                                                                  .white,
                                                                              textController:
                                                                                  _controllerText,
                                                                              //customLayoutKeys: _customLayoutKeys,
                                                                              defaultLayouts: [
                                                                                VirtualKeyboardDefaultLayouts.English
                                                                              ],
                                                                              //reverseLayout :true,
                                                                              type: isNumericMode ? VirtualKeyboardType.Numeric : VirtualKeyboardType.Alphanumeric,
                                                                              onKeyPress: (key) {
                                                                                _onKeyPress(
                                                                                    key,
                                                                                    _customPayment.hasFocus
                                                                                        ? _ctrlTAmount
                                                                                        : _description.hasFocus
                                                                                            ? _ctrlTDescription
                                                                                            : _none);
                                                                              }),
                                                                    )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          if (addTransaction)
                                                            Container(
                                                              height: double
                                                                  .infinity,
                                                              width:
                                                                  width * 0.2,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Column(
                                                                children: [
                                                                  //Paid Received

                                                                  Container(
                                                                    // height: height * 0.1,
                                                                    width: double
                                                                        .infinity,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            0,
                                                                        top: 0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              height * 0.022,
                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          child: const Text(
                                                                              'Paid/Received',
                                                                              style: TextStyle(
                                                                                color: Color.fromARGB(238, 72, 72, 73),
                                                                                fontSize: 13,
                                                                                fontFamily: 'BanglaBold',
                                                                                //fontWeight: FontWeight.w100
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.07,
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              InkWell(
                                                                                  child: Container(
                                                                                    width: width * 0.022,
                                                                                    // height: height * 0.022,
                                                                                    decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), shape: BoxShape.circle),
                                                                                    alignment: Alignment.center,
                                                                                    child: Container(
                                                                                      width: width * 0.008,
                                                                                      // height: height * 0.022,
                                                                                      decoration: BoxDecoration(color: paid ? Colors.black : Colors.transparent, shape: BoxShape.circle),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      paid = !paid;
                                                                                    });
                                                                                  }),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                height: double.infinity,
                                                                                width: width * 0.05,
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                child: Text(
                                                                                  'Paid',
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
                                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), shape: BoxShape.circle),
                                                                                  alignment: Alignment.center,
                                                                                  child: Container(
                                                                                    width: width * 0.008,
                                                                                    // height: height * 0.022,
                                                                                    decoration: BoxDecoration(color: !paid ? Colors.black : Colors.transparent, shape: BoxShape.circle),
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    paid = !paid;
                                                                                  });
                                                                                },
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                height: double.infinity,
                                                                                width: width * 0.06,
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                child: Text(
                                                                                  'Received',
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
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  //Payment Mode

                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            0,
                                                                        top:
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              height * 0.022,
                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          child: const Text(
                                                                              'Payment Mode',
                                                                              style: TextStyle(
                                                                                color: Color.fromARGB(238, 72, 72, 73),
                                                                                fontSize: 13,
                                                                                fontFamily: 'BanglaBold',
                                                                                //fontWeight: FontWeight.w100
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              height * 0.07,
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              InkWell(
                                                                                  child: Container(
                                                                                    width: width * 0.022,
                                                                                    // height: height * 0.022,
                                                                                    decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), shape: BoxShape.circle),
                                                                                    alignment: Alignment.center,
                                                                                    child: Container(
                                                                                      width: width * 0.008,
                                                                                      // height: height * 0.022,
                                                                                      decoration: BoxDecoration(color: paymentMode == 'cash' ? Colors.black : Colors.transparent, shape: BoxShape.circle),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      paymentMode = 'cash';
                                                                                    });
                                                                                  }),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                height: double.infinity,
                                                                                width: width * 0.05,
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                child: Text(
                                                                                  'Cash',
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
                                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), shape: BoxShape.circle),
                                                                                  alignment: Alignment.center,
                                                                                  child: Container(
                                                                                    width: width * 0.008,
                                                                                    // height: height * 0.022,
                                                                                    decoration: BoxDecoration(color: paymentMode == 'card' ? Colors.black : Colors.transparent, shape: BoxShape.circle),
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    paymentMode = 'card';
                                                                                  });
                                                                                },
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                height: double.infinity,
                                                                                width: width * 0.06,
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                child: Text(
                                                                                  'Card',
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
                                                                        Container(
                                                                          height:
                                                                              height * 0.07,
                                                                          width:
                                                                              double.infinity,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              InkWell(
                                                                                  child: Container(
                                                                                    width: width * 0.022,
                                                                                    // height: height * 0.022,
                                                                                    decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), shape: BoxShape.circle),
                                                                                    alignment: Alignment.center,
                                                                                    child: Container(
                                                                                      width: width * 0.008,
                                                                                      // height: height * 0.022,
                                                                                      decoration: BoxDecoration(color: paymentMode == 'wallet' ? Colors.black : Colors.transparent, shape: BoxShape.circle),
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      paymentMode = 'wallet';
                                                                                    });
                                                                                  }),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                height: double.infinity,
                                                                                width: width * 0.05,
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                child: Text(
                                                                                  'Wallet',
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
                                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1), shape: BoxShape.circle),
                                                                                  alignment: Alignment.center,
                                                                                  child: Container(
                                                                                    width: width * 0.008,
                                                                                    // height: height * 0.022,
                                                                                    decoration: BoxDecoration(color: paymentMode == 'upi' ? Colors.black : Colors.transparent, shape: BoxShape.circle),
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    paymentMode = 'upi';
                                                                                  });
                                                                                },
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.centerLeft,
                                                                                height: double.infinity,
                                                                                width: width * 0.06,
                                                                                margin: const EdgeInsets.only(left: 5, right: 5),
                                                                                child: Text(
                                                                                  'UPI',
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
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  /// amount paid/received
                                                                  Container(
                                                                    height:
                                                                        height *
                                                                            0.1,
                                                                    width: double
                                                                        .infinity,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            5,
                                                                        top:
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              height * 0.022,
                                                                          //color: Colors.white,
                                                                          padding: const EdgeInsets.only(
                                                                              left: 0,
                                                                              right: 0,
                                                                              top: 0,
                                                                              bottom: 0),
                                                                          child: const Text(
                                                                              'Amount',
                                                                              style: TextStyle(
                                                                                color: Color.fromARGB(238, 72, 72, 73),
                                                                                fontSize: 13,
                                                                                fontFamily: 'BanglaBold',
                                                                                //fontWeight: FontWeight.w100
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              double.infinity,
                                                                          //height: height * 0.04,
                                                                          //color: Colors.black,
                                                                          height:
                                                                              height * 0.048,
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
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(3),
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          child:
                                                                              TextFormField(
                                                                            readOnly:
                                                                                true, // Prevent system keyboard
                                                                            showCursor:
                                                                                false,
                                                                            focusNode:
                                                                                _customPayment,

                                                                            controller:
                                                                                _ctrlTAmount,
                                                                            style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontFamily: 'BanglaBold',
                                                                                fontSize: 16),
                                                                            cursorColor:
                                                                                Colors.black,

                                                                            //enabled: !lock,

                                                                            decoration:
                                                                                const InputDecoration(
                                                                              //prefixIcon: Icon(Icons.person),
                                                                              //prefixIconColor: Colors.black,
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
                                                                          margin: const EdgeInsets.only(
                                                                              top: 0,
                                                                              left: 0,
                                                                              right: 0,
                                                                              bottom: 0),
                                                                          width:
                                                                              double.infinity,
                                                                          //height: height * 0.05,
                                                                          //color: Colors.black,
                                                                          child:
                                                                              Text(
                                                                            errorCustomPayment,
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

                                                                  //button
                                                                  Container(
                                                                    width: double
                                                                        .infinity,

                                                                    height:
                                                                        height *
                                                                            0.05,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            0,
                                                                        top: 22,
                                                                        left: 5,
                                                                        right:
                                                                            0),
                                                                    //padding: EdgeInsets.only(bottom: 5),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              40,
                                                                        ),
                                                                        Expanded(
                                                                          child: Container(
                                                                              margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 0),
                                                                              height: double.infinity,
                                                                              child: ElevatedButton(
                                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                                                                                  onPressed: () async {
                                                                                    addTransaction = false;

                                                                                    _ctrlTAmount.clear();
                                                                                    _ctrlTDescription.clear();
                                                                                    setState(() {});
                                                                                    //_resetFormSupply();}
                                                                                  },
                                                                                  child: Text('Clear', style: TextStyle(fontFamily: 'BanglaBold', fontSize: 14, color: Colors.white)))),
                                                                        ),
                                                                        Expanded(
                                                                          child: Container(
                                                                              margin: EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 0),
                                                                              height: double.infinity,
                                                                              child: ElevatedButton(
                                                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)))),
                                                                                  onPressed: () {
                                                                                    if ((_ctrlTAmount.text == '') || (order == true ? double.parse(_ctrlTAmount.text) > selectedSupplyTotal - selectedSupplyPaidAmt : false)) {
                                                                                      if (_ctrlTAmount.text == '') {
                                                                                        errorCustomPayment = 'Please enter amount';
                                                                                      } else {
                                                                                        errorCustomPayment = 'Amount should be equal to or less than : ${selectedSupplyTotal - selectedSupplyPaidAmt}';
                                                                                      }

                                                                                      setState(() {});
                                                                                    } else {
                                                                                      _transaction1.supplierId = globals.SupplierId.toString();
                                                                                      _transaction1.amount = _ctrlTAmount.text.toString();
                                                                                      _transaction1.date = DateTime.now().toString();
                                                                                      _transaction1.description = _ctrlTDescription.text.toString();
                                                                                      _transaction1.orderCustom = orderCustom;
                                                                                      _transaction1.paidReceived = paid == true ? 'paid' : 'received';
                                                                                      _transaction1.paymentMode = paymentMode;
                                                                                      _transaction1.orderId = orderId;

                                                                                      if (orderCustom == 'order') {
                                                                                        for (var i in _supplyAddPayment) {
                                                                                          _supply = i;
                                                                                          if (paid == true) {
                                                                                            _supply.paidAmt = (double.parse(_ctrlTAmount.text) + double.parse(i.paidAmt!)).toString();
                                                                                          } else {
                                                                                            _supply.paidAmt = (-double.parse(_ctrlTAmount.text) + double.parse(i.paidAmt!)).toString();
                                                                                          }

                                                                                          _supply.paidStatus = (selectedSupplyTotal != (double.parse(_ctrlTAmount.text) + selectedSupplyPaidAmt)) ? 'partial' : 'full';

                                                                                          _updateSupplyAmt();
                                                                                          _supply = Supply();
                                                                                          _supplyAddPayment = [];
                                                                                          selectedSupplyPaidAmt = 0;
                                                                                          selectedSupplyTotal = 0;
                                                                                        }
                                                                                        setState(() {
                                                                                          _transaction11();
                                                                                        });
                                                                                      } else {
                                                                                        _transaction11();
                                                                                        if (paid == true) {
                                                                                          _updateSupplyAmtCustom();
                                                                                        }
                                                                                        //_updateSupplyAmtCustom();
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: Text('Add', style: TextStyle(fontFamily: 'BanglaBold', fontSize: 14, color: Colors.white)))),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      if (vendorList) {
                                                        vendorList =
                                                            !vendorList;
                                                        _orderSearch.unfocus();

                                                        addVendor = false;

                                                        editVendor = false;
                                                        addVendorIcon = true;
                                                        editVendorIcon = false;
                                                        _editCardManager(
                                                            '', '', '', '');
                                                        _resetSupplierForm();

                                                        _refreshContactList();

                                                        _supplierCardEdit =
                                                            false;
                                                      }
                                                    },
                                                  )
                                                : Container(
                                                    color: const Color.fromRGBO(
                                                        244, 244, 244, 1),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: width * 0.22,
                                                          height:
                                                              double.infinity,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 0,
                                                                  left: 0,
                                                                  bottom: 10,
                                                                  top: 0),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: height *
                                                                    0.045,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              4),
                                                                      bottomLeft:
                                                                          Radius.circular(
                                                                              4)),
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10,
                                                                        left: 5,
                                                                        right:
                                                                            2),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                  height: double
                                                                      .infinity,
                                                                  width: width *
                                                                      0.15,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                  child:
                                                                      InkWell(
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              12),
                                                                      child:
                                                                          Text(
                                                                        'Pending Deliveries!',
                                                                        textAlign:
                                                                            TextAlign.center,
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
                                                                child:
                                                                    Container(
                                                                        width: double
                                                                            .infinity,
                                                                        //height: height * 0.8,

                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                10,
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5),
                                                                        child: ListView
                                                                            .builder(
                                                                          itemCount:
                                                                              _deliverySalesAll.length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return CardDelivery(
                                                                                height,
                                                                                width,
                                                                                (_deliverySalesAll.length - index) - 1,
                                                                                context);
                                                                          },
                                                                        )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height:
                                                                double.infinity,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 0,
                                                                    left: 0,
                                                                    bottom: 10,
                                                                    top: 0),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height:
                                                                      height *
                                                                          0.045,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topRight:
                                                                            Radius.circular(
                                                                                4),
                                                                        bottomRight:
                                                                            Radius.circular(4)),
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              2,
                                                                          right:
                                                                              5),
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    height: double
                                                                        .infinity,
                                                                    width:
                                                                        width *
                                                                            0.15,
                                                                    margin: EdgeInsets.only(
                                                                        left: 0,
                                                                        bottom:
                                                                            0),
                                                                    child:
                                                                        InkWell(
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        width: double
                                                                            .infinity,
                                                                        padding:
                                                                            EdgeInsets.only(left: 12),
                                                                        child:
                                                                            Text(
                                                                          'Pending Payments!',
                                                                          textAlign:
                                                                              TextAlign.center,
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

                                                                      margin: const EdgeInsets.only(top: 0, bottom: 10, left: 8, right: 5),
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
                                                                                (_paymentSupplyAll.length - index) - 1,
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
                                                        Container(
                                                          width: width * 0.228,
                                                          height:
                                                              double.infinity,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 0,
                                                                  left: 0,
                                                                  bottom: 0,
                                                                  top: 0),
                                                          child: Column(
                                                            children: [
                                                              // Today bar
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: height *
                                                                    0.045,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            5,
                                                                        left: 5,
                                                                        right:
                                                                            0),
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 5,
                                                                        right:
                                                                            10),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height: double
                                                                          .infinity,
                                                                      width: width *
                                                                          0.15,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              0,
                                                                          bottom:
                                                                              0),
                                                                      child:
                                                                          InkWell(
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          width:
                                                                              double.infinity,
                                                                          padding:
                                                                              EdgeInsets.only(left: 12),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Text(
                                                                                dateF == 'today'
                                                                                    ? 'Today'
                                                                                    : dateF == 'yesterday'
                                                                                        ? 'Yesterday'
                                                                                        : dateF == 'week'
                                                                                            ? 'Last Week'
                                                                                            : dateF == '1month'
                                                                                                ? 'Last Month'
                                                                                                : dateF == '6month'
                                                                                                    ? 'Last 6 Months'
                                                                                                    : dateF == '1year'
                                                                                                        ? 'Last Year'
                                                                                                        : 'All',
                                                                                style: TextStyle(
                                                                                    fontFamily: 'Koulen',
                                                                                    color: Colors.white,
                                                                                    //  fontWeight: FontWeight.bold,
                                                                                    fontSize: 18),
                                                                              ),
                                                                              PopupMenuButton(
                                                                                offset: const Offset(-120, 65),
                                                                                shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),

                                                                                icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
                                                                                //initialValue: 2,

                                                                                initialValue: 0,
                                                                                onCanceled: () {
                                                                                  print("You have canceled the menu selection.");
                                                                                },
                                                                                onOpened: () {
                                                                                  Vibration.vibrate(duration: 100);
                                                                                },
                                                                                onSelected: (value) {
                                                                                  switch (value) {
                                                                                    case 0:
                                                                                      //do something
                                                                                      setState(() {
                                                                                        Vibration.vibrate(duration: 100);
                                                                                        //packaging = '';
                                                                                        _filter(supplierF, packingF, 'today', statusF, customOrderF);
                                                                                      });
                                                                                      break;
                                                                                    case 1:
                                                                                      //do something
                                                                                      setState(() {
                                                                                        Vibration.vibrate(duration: 100);
                                                                                        //packaging = 'Packed';
                                                                                        _filter(supplierF, packingF, 'yesterday', statusF, customOrderF);
                                                                                      });
                                                                                      break;
                                                                                    case 2:
                                                                                      //do something
                                                                                      setState(() {
                                                                                        Vibration.vibrate(duration: 100);
                                                                                        //packaging = 'Loose';
                                                                                        _filter(supplierF, packingF, 'week', statusF, customOrderF);
                                                                                      });
                                                                                      break;
                                                                                    case 3:
                                                                                      //do something
                                                                                      setState(() {
                                                                                        Vibration.vibrate(duration: 100);
                                                                                        //packaging = 'Loose';
                                                                                        _filter(supplierF, packingF, '1month', statusF, customOrderF);
                                                                                      });
                                                                                      break;
                                                                                    case 4:
                                                                                      //do something
                                                                                      setState(() {
                                                                                        Vibration.vibrate(duration: 100);
                                                                                        //packaging = 'Loose';
                                                                                        _filter(supplierF, packingF, '6month', statusF, customOrderF);
                                                                                      });
                                                                                      break;
                                                                                    case 5:
                                                                                      //do something
                                                                                      setState(() {
                                                                                        Vibration.vibrate(duration: 100);
                                                                                        //packaging = 'Loose';
                                                                                        _filter(supplierF, packingF, '1year', statusF, customOrderF);
                                                                                      });
                                                                                      break;
                                                                                    default:
                                                                                      {
                                                                                        print("Invalid choice");
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
                                                                                            style: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 17),
                                                                                          ),
                                                                                        )),
                                                                                    const PopupMenuItem(
                                                                                        value: 1,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Yesterday',
                                                                                            style: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 17),
                                                                                          ),
                                                                                        )),
                                                                                    const PopupMenuItem(
                                                                                        value: 2,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Last Week',
                                                                                            style: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 17),
                                                                                          ),
                                                                                        )),
                                                                                    const PopupMenuItem(
                                                                                        value: 3,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Last Month',
                                                                                            style: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 17),
                                                                                          ),
                                                                                        )),
                                                                                    const PopupMenuItem(
                                                                                        value: 4,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Last 6 Months',
                                                                                            style: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 17),
                                                                                          ),
                                                                                        )),
                                                                                    const PopupMenuItem(
                                                                                        value: 5,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'Last Year',
                                                                                            style: TextStyle(fontFamily: 'Koulen', color: Colors.black, fontSize: 17),
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
                                                                    Expanded(
                                                                        child:
                                                                            Container()),
                                                                    Container(
                                                                      height: double
                                                                          .infinity,
                                                                      width: width *
                                                                          0.05,
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0),
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                        left: 0,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Container(
                                                                          alignment: Alignment.centerRight,
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
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      right: 0,
                                                                      left: 8),
                                                                  height: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      //1
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          margin: EdgeInsets.only(
                                                                              top: 10,
                                                                              bottom: 10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                //height: height * 0.06,
                                                                                width: double.infinity,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text('Total Purchase count',
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 19,
                                                                                      fontFamily: 'Koulen',
                                                                                    )),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(right: 0),
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                      color: Color.fromRGBO(2, 120, 174, 1),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey, // Color of the shadow
                                                                                          offset: Offset.zero, // Offset of the shadow
                                                                                          blurRadius: 6, // Spread or blur radius of the shadow
                                                                                          spreadRadius: 0, // How much the shadow should spread
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(4)),
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    totalOrders.toString(),
                                                                                    style: TextStyle(color: Colors.white, fontFamily: 'Koulen', fontSize: 40),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //2
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          margin: EdgeInsets.only(
                                                                              top: 10,
                                                                              bottom: 10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                // height: height * 0.06,
                                                                                width: double.infinity,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text('Total Purchase Amount',
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 19,
                                                                                      fontFamily: 'Koulen',
                                                                                    )),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(right: 0),
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                      color: Color.fromRGBO(2, 120, 174, 1),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey, // Color of the shadow
                                                                                          offset: Offset.zero, // Offset of the shadow
                                                                                          blurRadius: 6, // Spread or blur radius of the shadow
                                                                                          spreadRadius: 0, // How much the shadow should spread
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(4)),
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    totalRevenue.toString() + ' \u{20B9}',
                                                                                    style: TextStyle(color: Colors.white, fontFamily: 'Koulen', fontSize: 40),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      //3
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          margin: EdgeInsets.only(
                                                                              top: 10,
                                                                              bottom: 10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                // height: height * 0.06,
                                                                                width: double.infinity,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text('Total Margin',
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 19,
                                                                                      fontFamily: 'Koulen',
                                                                                    )),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(right: 0),
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                      color: Color.fromRGBO(2, 120, 174, 1),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey, // Color of the shadow
                                                                                          offset: Offset.zero, // Offset of the shadow
                                                                                          blurRadius: 6, // Spread or blur radius of the shadow
                                                                                          spreadRadius: 0, // How much the shadow should spread
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(4)),
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    totalProfit.toString() + ' \u{20B9}',
                                                                                    style: TextStyle(color: Colors.white, fontFamily: 'Koulen', fontSize: 40),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      //4
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              double.infinity,
                                                                          margin: EdgeInsets.only(
                                                                              top: 10,
                                                                              bottom: 10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                //height: height * 0.06,
                                                                                width: double.infinity,
                                                                                alignment: Alignment.centerLeft,
                                                                                child: Text('Avg Purchase Amount',
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 19,
                                                                                      fontFamily: 'Koulen',
                                                                                    )),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(right: 0),
                                                                                  width: double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                      color: Color.fromRGBO(2, 120, 174, 1),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey, // Color of the shadow
                                                                                          offset: Offset.zero, // Offset of the shadow
                                                                                          blurRadius: 6, // Spread or blur radius of the shadow
                                                                                          spreadRadius: 0, // How much the shadow should spread
                                                                                        )
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(4)),
                                                                                  alignment: Alignment.center,
                                                                                  child: Text(
                                                                                    orderSize.toStringAsFixed(2) + ' \u{20B9}',
                                                                                    style: TextStyle(color: Colors.white, fontFamily: 'Koulen', fontSize: 40),
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
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    )
                  
                 , if (_supplierCardEdit ||
                                                          _orderSearch
                                                              .hasFocus ||
                                                          editVendor ||
                                                          addVendor)
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: height * 0.39,
                                                          alignment:
                                                              FractionalOffset
                                                                  .centerRight,
                                                          child: Container(
                                                            width:
                                                                width * 0.776,
                                                            height:
                                                                double.infinity,
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 5,
                                                                    right: 0,
                                                                    left: 0),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .black,
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey,
                                                                    // Color of the shadow
                                                                    offset: Offset
                                                                        .zero, // Offset of the shadow
                                                                    blurRadius:
                                                                        6, // Spread or blur radius of the shadow
                                                                    spreadRadius:
                                                                        0, // How much the shadow should spread
                                                                  )
                                                                ]),
                                                            child:
                                                                VirtualKeyboard(

                                                                    // height: 300,

                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    textController:
                                                                        _controllerText,
                                                                    //customLayoutKeys: _customLayoutKeys,
                                                                    defaultLayouts: [
                                                                      VirtualKeyboardDefaultLayouts
                                                                          .English
                                                                    ],
                                                                    //reverseLayout :true,
                                                                    type: isNumericMode
                                                                        ? VirtualKeyboardType
                                                                            .Numeric
                                                                        : VirtualKeyboardType
                                                                            .Alphanumeric,
                                                                    onKeyPress:
                                                                        (key) {
                                                                      _onKeyPress(
                                                                          key,
                                                                          _customPayment.hasFocus
                                                                              ? _ctrlTAmount
                                                                              : _orderSearch.hasFocus
                                                                                  ? _ctrlOrderSearch
                                                                                  : _description.hasFocus
                                                                                      ? _ctrlTDescription
                                                                                      : _supplierName.hasFocus
                                                                                          ? _ctrlSupplierName
                                                                                          : _supplierPhone.hasFocus
                                                                                              ? _ctrlSupplierPhone
                                                                                              : _supplierAddress.hasFocus
                                                                                                  ? _ctrlSupplierAddress
                                                                                                  : _none);
                                                                    }),
                                                          ),
                                                        )
                                                   
                  ],
                ),
              )),

            if (packaging == 'p') ChooseSupplier()
          ],
        ),
      ),
    );
  }
}

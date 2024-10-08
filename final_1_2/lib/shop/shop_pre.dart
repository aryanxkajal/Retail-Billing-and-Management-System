import 'package:barcode1/product_database/model/product_database_model.dart';
import 'package:barcode1/shop/operations/operation_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../database_helper/database_helper.dart';
import '../main.dart';
import '../verify/phone_auth_service.dart';
import 'model/model_store.dart';

import 'package:barcode1/product_database/operation/operation_product.dart';

import 'package:barcode1/account_customer/model/model_customer.dart';
import 'package:barcode1/account_customer/operation/operation_customer.dart';
import 'package:barcode1/account_inventory/operation/inventory_operation.dart';
import 'package:barcode1/account_sales/model/model_sales.dart';
import 'package:barcode1/account_sales/model/model_sales_transaction.dart';
import 'package:barcode1/account_sales/operation/operation_sales.dart';
import 'package:barcode1/account_sales/operation/operation_sales_transaction.dart';
import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/account_supplies/model/model_transaction.dart';
import 'package:barcode1/account_supplies/operation/operation_supplier.dart';
import 'package:barcode1/account_supplies/operation/operation_supply.dart';
import 'package:barcode1/account_supplies/operation/operation_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../account_inventory/model/inventory_model.dart';
import '../product_database/model/product_database_model.dart';
import '../product_database/operation/operation_product.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class PreStorePage extends StatefulWidget {
  const PreStorePage({super.key});

  @override
  State<PreStorePage> createState() => _PreStorePageState();
}

class _PreStorePageState extends State<PreStorePage> {
  @override
  void initState() {
    super.initState();

    //_fetchStore();
    //_fetchRegisterationNumber();

    //WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  List<int> x = [
    123456789,
    987654321,
    246813579,
    135792468,
    111111111,
    222222222,
    333333333,
    444444444,
    555555555,
    666666666,
    777777777,
    888888888,
    999999999,
    100000000,
    200000000,
    300000000,
    400000000,
    500000000,
    600000000,
    700000000,
    800000000,
    900000000,
    123000000,
    234000000,
    345000000,
    456000000,
    567000000,
    678000000,
    789000000,
    890000000,
    911111111,
    922222222,
    933333333,
    944444444,
    955555555,
    966666666,
    977777777,
    988888888,
    999000000,
    111100000,
    222200000,
    333300000,
    444400000,
    555500000,
    666600000,
    777700000,
    888800000,
    999900000,
    111110000,
    222220000,
    333330000,
    444440000,
    555550000,
    666660000,
    777770000,
    888880000,
    999990000,
    111111100,
    222222200,
    333333300,
    444444400,
    555555500,
    666666600,
    777777700,
    888888800,
    999999900,
    111111111,
    222222222,
    333333333,
    444444444,
    555555555,
    666666666,
    777777777,
    888888888,
    999999999,
    123456789,
    987654321,
    246813579,
    135792468,
    987123456,
    123987456,
    123012345,
    543210987,
    987654320,
    135792467,
    864209753,
    908172635,
    253641789,
    456789123,
    987654320,
    987123456,
    123987456,
    123012345,
    543210987,
    987654320,
    135792467,
    864209753,
    908172635,
    253641789,
    456789123,
  ];

  Future<bool> _fetchRegisterationNumber(String r) async {
    final firestore = FirebaseFirestore.instance;

    bool found = false;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('registeration').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        if (doc.data().containsValue(r) && doc.data()['name'] == '') {
          print(doc.data());
          //foundI = doc.data()['index'];
          found = true;
        }
      }
    } catch (e) {
      print('Error fetching transactions from Firestore: $e');
    }
    return found;
  }

  _registerFirebase() async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('registeration').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        if (doc.data().containsValue(_ctrlShopWebsite.text)) {
          print(doc.data());
          //foundI = doc.data()['index'];
          firestore.collection('registeration').doc(doc.id).set({
            'name': _ctrlShopName.text,
            'phone': _ctrlShopPhone.text,
            'address': _ctrlShopAdd.text,
            'website': '',
            'date': DateTime.now().toString(),
            'registerationNumber': doc.data()['registerationNumber'],
            'licenseDuration': '1'
          }).then((value) => print('store added'));
        }
      }
    } catch (e) {
      print('Error fetching transactions from Firestore: $e');
    }
    createProduct();
  }

  Product _product1 = Product();
  final _dbHelperProduct = ProductOperation();

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
      print('Error fetching transactions from Firestore: $e');
    }

    List<Product> updateProduct = [];

    List<Product> createProduct = [];
    List<Product> deleteProduct = [];

    if (cProduct.isNotEmpty) {
      print('gi');
      for (var i in cProduct) {
        _product1.Barcode = i.Barcode;

        _product1.MeasurementUnit = i.MeasurementUnit;
        _product1.Name = i.Name;
        _product1.Price = i.Price;

        print(i.Name);
        //await _dbHelperProduct.insertProduct(_product1);

        await _dbHelperProduct.insertProduct(_product1);
      }
    }
    _sync();
    // _supplier();
  }

  _fetchStore() async {
    var store = await _dbHelperStore.fetchStore();

    if (store.isNotEmpty) {
      setState(() {
        _store = store.last;
        _ctrlShopName.text = store.last.name!;
        _ctrlShopPhone.text = store.last.phone!;
        _ctrlShopAdd.text = store.last.address!;
        _ctrlShopWebsite.text = store.last.website!;
      });
    } else {
      setState(() {
        _store = Store();
        _ctrlShopName.text = '';
        _ctrlShopPhone.text = '';
        _ctrlShopAdd.text = '';
        _ctrlShopWebsite.text = '';
      });
    }
  }

  final TextEditingController _ctrlShopName = TextEditingController();
  final FocusNode _shopName = FocusNode();
  String errorShopName = '';

  final TextEditingController _ctrlShopPhone = TextEditingController();
  final FocusNode _shopPhone = FocusNode();
  String errorShopPhone = '';

  final TextEditingController _ctrlShopAdd = TextEditingController();
  final FocusNode _shopAdd = FocusNode();
  String errorShopAdd = '';

  final TextEditingController _ctrlShopWebsite = TextEditingController();
  final FocusNode _shopWebsite = FocusNode();
  String errorShopWebsite = '';

  final TextEditingController _ctrlOtp = TextEditingController();
  final FocusNode _shopOtp = FocusNode();
  String errorShopOtp = '';

  Store _store = Store();

  final _dbHelperStore = StoreOperation();

  // Holds the text that user typed.

  // CustomLayoutKeys _customLayoutKeys;
  // True if shift enabled.
  bool shiftEnabled = false;

  // is true will show the numeric keyboard.
  bool isNumericMode = false;

  TextEditingController _controllerText = TextEditingController();
  TextEditingController _none = TextEditingController();

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

    if (_shopPhone.hasFocus) {
      if (_ctrlShopPhone.text.length != 10) {
        errorShopPhone = 'Phone Number must be 10 digits!';
      } else {
        errorShopPhone = '';
      }
      setState(() {});
    }

    /* if (_shopWebsite.hasFocus) {
      if (_ctrlShopWebsite.text.length != 9) {
        errorShopWebsite = 'key must be 9 digits';
      } else {
        errorShopWebsite = '';
      }
      setState(() {});
    }*/

    // Update the screen
    setState(() {});
  }

  bool update = false;

  String registerationNumber = '645982300';

  //////////
  ///
  int s = 0;

  final _dbHelperSupplier = SupplierOperation();
  final _dbHelperSupply = SupplyOperation();
  final _dbHelperTransaction1 = TransactionOperation();

  final _dbHelperI = InventoryOperation();

  //final _dbHelperProduct = ProductOperation();

  final _dbHelperCustomer = CustomerOperation();
  final _dbHelperSales = SalesOperation();
  final _dbHelperSalesTransaction = SalesTransactionOperation();

  List<String> names100 = [
    'Aarav',
    'Aarna',
    'Advait',
    'Akshay',
    'Amara',
    'Ananya',
    'Aarohi',
    'Arya',
    'Amit',
    'Amita',
    'Amitabh',
    'Bhavya',
    'Chaitanya',
    'Chandrakant',
    'Deepak',
    'Dhruv',
    'Divya',
    'Gaurav',
    'Gayatri',
    'Harsh',
    'Isha',
    'Ishita',
    'Jagdish',
    'Jay',
    'Jayant',
    'Kabir',
    'Kamala',
    'Kavita',
    'Lakshmi',
    'Lalita',
    'Madhav',
    'Madhavi',
    'Manisha',
    'Mihir',
    'Nandini',
    'Nikhil',
    'Nisha',
    'Om',
    'Pooja',
    'Pranav',
    'Pratik',
    'Priya',
    'Rajesh',
    'Rajiv',
    'Rahul',
    'Rashi',
    'Ravi',
    'Rishi',
    'Rohit',
    'Rucha',
    'Sakshi',
    'Sameer',
    'Sampada',
    'Sanjay',
    'Sarika',
    'Shakti',
    'Shalini',
    'Shantanu',
    'Sheetal',
    'Shreya',
    'Shubham',
    'Smita',
    'Sonal',
    'Subhash',
    'Sumeet',
    'Sumit',
    'Sunil',
    'Suresh',
    'Sushant',
    'Swati',
    'Tanisha',
    'Tara',
    'Uday',
    'Ujjwala',
    'Uma',
    'Upendra',
    'Urmila',
    'Vikas',
    'Vikram',
    'Vimal',
    'Vinay',
    'Yogesh',
    'Yogita',
  ];

  List<String> names50 = [
    'Aarav',
    'Aarna',
    'Advait',
    'Akshay',
    'Amara',
    'Ananya',
    'Aarohi',
    'Arya',
    'Amit',
    'Amita',
    'Amitabh',
    'Bhavya',
    'Chaitanya',
    'Chandrakant',
    'Deepak',
    'Dhruv',
    'Divya',
    'Gaurav',
    'Gayatri',
    'Harsh',
    'Isha',
    'Ishita',
    'Jagdish',
    'Jay',
    'Jayant',
    'Kabir',
    'Kamala',
    'Kavita',
    'Lakshmi',
    'Lalita',
    'Madhav',
    'Madhavi',
    'Manisha',
    'Mihir',
    'Nandini',
    'Nikhil',
    'Nisha',
    'Om',
    'Pooja',
    'Pranav',
    'Pratik',
    'Priya',
    'Rajesh',
    'Rajiv',
    'Rahul',
    'Rashi',
    'Ravi',
    'Rishi',
    'Rohit',
    'Rucha',
    'Sakshi',
  ];

  _supplier() async {
    for (var i in names50) {
      await _dbHelperSupplier.insertSupplier(Supplier(
          contactId: '11',
          name: '${i}',
          phone: '${9999999000 + names100.indexOf(i)}',
          address: '-'));
    }
    _supply();
  }

  String orderid1 = '';

  _supply() async {
    List<Supplier> supplier = await _dbHelperSupplier.fetchSupplier();
    List<Product> product = await _dbHelperProduct.fetchProduct();
    List<Product> product10 = product.sublist(0, 10);

    int orderid = 0;

    for (var s in supplier) {
      for (int i = 1; i < 11; i++) {
        orderid = orderid + 1;
        await _dbHelperSupply.insertSupply(Supply(
          supplierId: s.id.toString(),
          date: i < 2
              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'
              : i < 3
                  ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))} 00:00:00.000000'
                  : i < 4
                      ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                      : i < 6
                          ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                          : i < 9
                              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 180)))} 00:00:00.000000'
                              : '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)))} 00:00:00.000000',
          packing: 'p',
          productList:
              '{"1":{"barcode":"${product10[0].Barcode}","productName":"${product10[0].Name}","qty":"1.0","buy":"90","sell":"99.0","weight":"","doe":"","packing":"p","mrp":"99.0"},"2":{"barcode":"${product10[1].Barcode}","productName":"${product10[1].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"3":{"barcode":"${product10[2].Barcode}","productName":"${product10[2].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"4":{"barcode":"${product10[3].Barcode}","productName":"${product10[3].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"5":{"barcode":"${product10[4].Barcode}","productName":"${product10[4].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"6":{"barcode":"${product10[5].Barcode}","productName":"${product10[5].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"7":{"barcode":"${product10[6].Barcode}","productName":"${product10[6].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"8":{"barcode":"${product10[7].Barcode}","productName":"${product10[7].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"9":{"barcode":"${product10[8].Barcode}","productName":"${product10[8].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"10":{"barcode":"${product10[9].Barcode}","productName":"${product10[9].Name}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"}}',
          orderId: orderid.toString(),
          deliveryStatus: 'delivered',
          deliveryDate: DateTime.now().toString(),
          paidStatus: 'full',
          paidAmt: '4710',
          paymentMode: 'cash',
        ));

        await _dbHelperTransaction1.insertTransaction(Transaction1(
            supplierId: s.id.toString(),
            date: i < 2
                ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'
                : i < 3
                    ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))} 00:00:00.000000'
                    : i < 4
                        ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                        : i < 6
                            ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                            : i < 9
                                ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 180)))} 00:00:00.000000'
                                : '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)))} 00:00:00.000000',
            orderCustom: 'order',
            paidReceived: 'paid',
            amount: '4710',
            orderId: orderid.toString(),
            paymentMode: 'cash'));

        print(orderid);
        orderid1 = orderid.toString();
        setState(() {});
      }
    }

    print('database created successfully');
    orderid1 = 'database created successfully';
    setState(() {});
    _createInventory();
  }

  Inventory _inventory = Inventory();

  String inventoryId = '';

  List<String> loose = [
    'Rice',
    'Wheat',
    'Quinoa',
    'Oats',
    'Maize',
    'Potato',
    'Tomato',
    'Carrot',
    'Cucumber',
    'Broccoli',
    'Apple',
    'Banana',
    'Orange',
    'Grapes',
    'Mango',
    'Chickpeas',
    'Lentils',
    'Black Beans',
    'Green Peas',
    'Red Kidney Beans',
    'Spinach',
    'Kale',
    'Lettuce',
    'Cauliflower',
    'Bell Pepper',
    'Eggplant',
    'Zucchini',
    'Onion',
    'Garlic',
    'Ginger',
    'Strawberry',
    'Pineapple',
    'Blueberry',
    'Avocado',
    'Lemon',
    'Lime',
    'Peach',
    'Pear',
    'Cherry',
    'Papaya',
    'Watermelon',
    'Kiwi',
    'Cantaloupe',
    'Cabbage',
    'Squash',
    'Pumpkin',
  ];

  List<int> loosePrice = [
    50,
    30,
    200,
    100,
    30,
    30,
    40,
    30,
    30,
    50,
    120,
    25,
    50,
    80,
    20,
    90,
    90,
    90,
    50,
    90,
    30,
    40,
    20,
    50,
    40,
    30,
    30,
    30,
    40,
    40,
    30,
    40,
    30,
    50,
    30,
    30,
    50,
    40,
    30,
    50,
    30,
    20,
    40,
    30,
    40,
    20,
  ];

  _createInventory() async {
    List<Product> product = await _dbHelperProduct.fetchProduct();
    for (var i in product) {
      await _dbHelperI.insertInventory(Inventory(
        packing: 'p',
        productName: '${i.Name}',
        barcode: '${i.Barcode}',
        qty: '${product.indexOf(i) + 1}',
        buy: '${(i.Price! - (0.1 * i.Price!)).toStringAsFixed(2)}',
        sell: '${i.Price}',
        weight: '0',
        DOE: '0',
        mrp: '${i.Price}',
        supplierId: '0',
        date: DateTime.now().toString(),
        weightLoose: '0',
      ));

      inventoryId = product.indexOf(i).toString();
      setState(() {});
    }
    for (var i in loose) {
      await _dbHelperI.insertInventory(Inventory(
        packing: 'l',
        productName: '${i}',
        barcode: '${1000 + loose.indexOf(i)}',
        qty: '${loose.indexOf(i) + 1}',
        buy:
            '${(loosePrice[loose.indexOf(i)] - (0.1 * loosePrice[loose.indexOf(i)])).toStringAsFixed(2)}',
        sell: '${loosePrice[loose.indexOf(i)]}',
        weight: '0',
        DOE: '0',
        mrp: '${loosePrice[loose.indexOf(i)]}',
        supplierId: '0',
        date: DateTime.now().toString(),
        weightLoose: '0',
      ));

      inventoryId = loose.indexOf(i).toString();
      setState(() {});
    }
    inventoryId = 'database created successfully';
    setState(() {});
    _customer();
  }

  _customer() async {
    for (var i in names100) {
      await _dbHelperCustomer.insertCustomer(Customer(
          name: '${i}',
          phone: '${9999999000 + names100.indexOf(i)}',
          points: '4',
          address: 'address'));
    }
    _sales();
  }

  String orderidSales1 = '';
  bool loading = false;

  _sales() async {
    List<Customer> supplier = await _dbHelperCustomer.fetchCustomer();
    List<Product> product = await _dbHelperProduct.fetchProduct();
    List<Product> product10 = product.sublist(0, 10);
    int orderidSales = 0;

    for (var s in supplier) {
      for (int i = 1; i < 11; i++) {
        orderidSales = orderidSales + 1;
        await _dbHelperSales.insertSales(Sales(
          date: i < 2
              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'
              : i < 3
                  ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))} 00:00:00.000000'
                  : i < 4
                      ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                      : i < 6
                          ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                          : i < 9
                              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 180)))} 00:00:00.000000'
                              : '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)))} 00:00:00.000000',
          customerName: supplier.indexOf(s).toString(),
          customerNumber: supplier.indexOf(s).toString(),
          productName:
              '{"1":{"barcode":"${product10[0].Barcode}","productName":"${product10[0].Name}","qty":"1.0","buy":"${product10[0].Price! - (0.1 * product10[0].Price!)}","price":"${product10[0].Price!}","disc":"0.0","mrp":"${product10[0].Price!}"},"2":{"barcode":"${product10[1].Barcode}","productName":"${product10[1].Name}","qty":"1.0","buy":"${product10[1].Price! - (0.1 * product10[1].Price!)}","price":"${product10[1].Price!}","disc":"0.0","mrp":"${product10[1].Price!}"},"3":{"barcode":"${product10[2].Barcode}","productName":"${product10[2].Name}","qty":"1.0","buy":"${product10[2].Price! - (0.1 * product10[2].Price!)}","price":"${product10[2].Price!}","disc":"0.0","mrp":"${product10[2].Price!}"},"4":{"barcode":"${product10[3].Barcode}","productName":"${product10[3].Name}","qty":"1.0","buy":"${product10[3].Price! - (0.1 * product10[3].Price!)}","price":"${product10[3].Price!}","disc":"0.0","mrp":"${product10[3].Price!}"},"5":{"barcode":"${product10[4].Barcode}","productName":"${product10[4].Name}","qty":"1.0","buy":"${product10[4].Price! - (0.1 * product10[4].Price!)}","price":"${product10[4].Price!}","disc":"0.0","mrp":"${product10[4].Price!}"},"6":{"barcode":"${product10[5].Barcode}","productName":"${product10[5].Name}","qty":"1.0","buy":"${product10[5].Price! - (0.1 * product10[5].Price!)}","price":"${product10[5].Price!}","disc":"0.0","mrp":"${product10[5].Price!}"},"7":{"barcode":"${product10[6].Barcode}","productName":"${product10[6].Name}","qty":"1.0","buy":"${product10[6].Price! - (0.1 * product10[6].Price!)}","price":"${product10[6].Price!}","disc":"0.0","mrp":"${product10[6].Price!}"},"8":{"barcode":"${product10[7].Barcode}","productName":"${product10[7].Name}","qty":"1.0","buy":"${product10[7].Price! - (0.1 * product10[7].Price!)}","price":"${product10[7].Price!}","disc":"0.0","mrp":"${product10[7].Price!}"},"9":{"barcode":"${product10[8].Barcode}","productName":"${product10[8].Name}","qty":"1.0","buy":"${product10[8].Price! - (0.1 * product10[8].Price!)}","price":"${product10[8].Price!}","disc":"0.0","mrp":"${product10[8].Price!}"},"10":{"barcode":"${product10[9].Barcode}","productName":"${product10[9].Name}","qty":"1.0","buy":"${product10[9].Price! - (0.1 * product10[9].Price!)}","price":"${product10[9].Price!}","disc":"0.0","mrp":"${product10[9].Price!}"}}',
          orderId: orderidSales.toString(),
          deliveryStatus: 'delivered',
          deliveryMode: 'store',
          deliveryDate: DateTime.now().toString(),
          paidStatus: 'full',
          paidAmount: '2000',
          paymentMode: 'cash',
        ));

        await _dbHelperSalesTransaction.insertSalesTransaction(SalesTransaction(
            supplierId: s.id.toString(),
            date: i < 2
                ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'
                : i < 3
                    ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))} 00:00:00.000000'
                    : i < 4
                        ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                        : i < 6
                            ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                            : i < 9
                                ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 180)))} 00:00:00.000000'
                                : '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)))} 00:00:00.000000',
            orderCustom: 'order',
            paidReceived: 'paid',
            amount: '4710',
            orderId: orderidSales.toString(),
            paymentMode: 'cash'));

        print(orderidSales);
        orderidSales1 = orderidSales.toString();
        setState(() {});
      }
    }

    print('database created successfully');
    orderidSales1 = 'database created successfully';
    setState(() {});
    _pop();
  }

  _pop() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  //////////////
  ///
  ///
  ///
  final PhoneAuthService _phoneAuthService = PhoneAuthService();

  _sync() async {
    try {
      // Replace 'transaction' with the name of your Firestore collection
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_ctrlShopPhone.text)
          .collection(_ctrlShopPhone.text)
          .doc('details')
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> storeDetails = snapshot.data()!;
        print(storeDetails['registeredPhone']);
        print('already');
        return storeDetails;
      } else {
        // Data not found
         print('user not found');
        _registerUser();
        return null;
      }
    } catch (e) {
      print('Error fetching transactions from Firestore: $e');
    }
  }

  _registerUser() async{
     try {
      // Replace 'transaction' with the name of your Firestore collection
       await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_ctrlShopPhone.text)
          .collection(_ctrlShopPhone.text)
          .doc('details')
          .set(
            {
            'name': _ctrlShopName.text,
            'phone': _ctrlShopPhone.text,
            'registeredPhone': _ctrlShopPhone.text,
            'address': _ctrlShopAdd.text,
            'website': '',
            'date': DateTime.now().toString(),
            'registerationNumber': '${_ctrlShopWebsite.text}',
            'licenseDuration': '1'
          }
          ).then((value) => print('store added'));

     
    } catch (e) {
      print('Error fetching transactions from Firestore: $e');
    }

  }

  String? _verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        body: !loading
            ? Container(
                width: double.infinity,
                //height: height * 0.9,
                color: const Color.fromRGBO(244, 244, 244, 1),
                padding: const EdgeInsets.only(bottom: 0, top: 50),

                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                margin: const EdgeInsets.only(
                                    bottom: 0, top: 0, left: 40),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 110,
                                      //color: Colors.white,

                                      child: Text(
                                        'Store Registration!',
                                        style: TextStyle(
                                            fontSize: 80,
                                            //fontWeight: FontWeight.w500,
                                            fontFamily: 'Koulen'),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 30, top: 0),
                                      child: Text(
                                        '(Register your store to use the app)',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:
                                                Color.fromRGBO(92, 94, 98, 1),
                                            //fontWeight: FontWeight.w500,
                                            fontFamily: 'Koulen'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                //height: height * 0.375,
                                margin:
                                    const EdgeInsets.only(bottom: 0, top: 0),

                                child: Column(
                                  children: [
                                    // shop name
                                    /*                              Container(
                                      // height: height * 0.16,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0),
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
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Store Name',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
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
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            margin: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
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
                                            child: TextFormField(
                                              maxLines: 1,

                                              readOnly:
                                                  true, // Prevent system keyboard
                                              showCursor: false,
                                              focusNode: _shopName,

                                              controller: _ctrlShopName,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Koulen',
                                                  fontSize: 17),
                                              cursorColor: Colors.black,

                                              // enabled: !update,

                                              decoration: InputDecoration(
                                                // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),

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
                                        ],
                                      ),
                                    ),

                                    // shop phone
                                    Container(
                                      // height: height * 0.16,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0),
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
                                            margin: EdgeInsets.only(
                                                bottom: 10, top: 20),
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Phone Number',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
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
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            margin: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
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
                                            child: TextFormField(
                                              maxLines: 1,

                                              readOnly:
                                                  true, // Prevent system keyboard
                                              showCursor: false,
                                              focusNode: _shopPhone,

                                              controller: _ctrlShopPhone,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Koulen',
                                                  fontSize: 17),
                                              cursorColor: Colors.black,

                                              //enabled: !lock,

                                              decoration: InputDecoration(
                                                // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),

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
                                        ],
                                      ),
                                    ),

                                    // shop address
                                    Container(
                                      // height: height * 0.16,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0),
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
                                            margin: EdgeInsets.only(
                                                bottom: 10, top: 20),
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Address',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
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
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            margin: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
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
                                            child: TextFormField(
                                              maxLines: 1,

                                              readOnly:
                                                  true, // Prevent system keyboard
                                              showCursor: false,
                                              focusNode: _shopAdd,

                                              controller: _ctrlShopAdd,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Koulen',
                                                  fontSize: 17),
                                              cursorColor: Colors.black,

                                              //enabled: !lock,

                                              decoration: InputDecoration(
                                                // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),

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
                                        ],
                                      ),
                                    ),
*/
                                    // registeration code

                                    //registeration key
                                    Container(
                                      //  height: height * 0.16,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0),
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
                                            margin: EdgeInsets.only(
                                                bottom: 10, top: 20),
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Registeration Key',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
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
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            margin: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
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
                                            child: TextFormField(
                                              maxLines: 1,

                                              readOnly:
                                                  true, // Prevent system keyboard
                                              showCursor: false,
                                              focusNode: _shopWebsite,

                                              controller: _ctrlShopWebsite,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Koulen',
                                                  fontSize: 17),
                                              cursorColor: Colors.black,

                                              //enabled: !lock,

                                              decoration: InputDecoration(
                                                // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),

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
                                            height: height * 0.022,

                                            margin: EdgeInsets.only(
                                                bottom: 10, top: 0),
                                            width: double.infinity,
                                            //height: height * 0.05,
                                            //color: Colors.black,
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: errorShopWebsite,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          139, 0, 0, 1),
                                                      fontSize: 13,
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

                                    // shop phone
                                    Container(
                                      // height: height * 0.16,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0),
                                      child: Row(
                                        children: [
                                          Expanded(
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
                                                    margin: EdgeInsets.only(
                                                        bottom: 10, top: 0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text:
                                                                'Phone Number',
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
                                                            left: 10,
                                                            right: 10,
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
                                                      maxLines: 1,

                                                      readOnly:
                                                          true, // Prevent system keyboard
                                                      showCursor: false,
                                                      focusNode: _shopPhone,

                                                      controller:
                                                          _ctrlShopPhone,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 17),
                                                      cursorColor: Colors.black,

                                                      //enabled: !lock,

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
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.08,
                                            margin: EdgeInsets.only(left: 8),
                                            //color: Colors.white,

                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: double.infinity,
                                                  height: height * 0.022,
                                                  //color: Colors.white,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 0,
                                                          bottom: 0),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10, top: 0),
                                                  child: RichText(
                                                    text: TextSpan(
                                                      style:
                                                          DefaultTextStyle.of(
                                                                  context)
                                                              .style,
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: '',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
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
                                                  //  alignment: Alignment.centerRight,
                                                  height: height * 0.048,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
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
                                                  child: TextButton(
                                                      onPressed: () async {
                                                        String phoneNumber =
                                                            '+91' +
                                                                _ctrlShopPhone
                                                                    .text
                                                                    .trim();
                                                        //ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(phoneNumber );
                                                        String? errorMessage =
                                                            await _phoneAuthService
                                                                .signUpWithPhone(
                                                                    phoneNumber);

                                                        if (errorMessage ==
                                                            null) {
                                                          // Save the verificationId for later use
                                                          // For example, you can store it in a state variable

                                                          // Show OTP input field
                                                        } else {
                                                          // Display an error message to the user
                                                          // You can use a Flutter Toast or a SnackBar for this
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  errorMessage),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        'generate otp',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Koulen',
                                                            fontSize: 15),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                    //otp
                                    Container(
                                      // height: height * 0.16,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 50, top: 0),
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
                                            margin: EdgeInsets.only(
                                                bottom: 10, top: 20),
                                            child: RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'Otp',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          92, 94, 98, 1),
                                                      fontSize: 15,
                                                      fontFamily: 'Koulen',
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
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            margin: const EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
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
                                            child: TextFormField(
                                              maxLines: 1,

                                              readOnly:
                                                  true, // Prevent system keyboard
                                              showCursor: false,
                                              focusNode: _shopOtp,

                                              controller: _ctrlOtp,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Koulen',
                                                  fontSize: 17),
                                              cursorColor: Colors.black,

                                              //enabled: !lock,

                                              decoration: InputDecoration(
                                                // Wrap the TextFormField with GestureDetector to capture horizontal swipes

                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),

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
                                        ],
                                      ),
                                    ),

                                    //button
                                    Container(
                                      height: height * 0.05,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0),
                                      child: Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Container(
                                            width: width * 0.15,
                                            decoration:
                                                BoxDecoration(boxShadow: [
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
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      Colors.black,
                                                    ),
                                                    shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)))),
                                                onPressed: () async {
                                                  if (_ctrlShopWebsite.text ==
                                                      '1234') {
                                                    String otp =
                                                        _ctrlOtp.text.trim();
                                                    //_otp(otp);
                                                    // UserCredential userCredential = await confirmationResult.confirm(x);
                                                    String? errorMessage =
                                                        await _phoneAuthService
                                                            .signInWithPhone(
                                                                otp);

                                                    if (errorMessage == null) {
                                                      _store.codeVerified = 'y';
                                                      _store.name =
                                                          _ctrlShopName.text;
                                                      _store.phone =
                                                          _ctrlShopPhone.text;
                                                      _store.address =
                                                          _ctrlShopAdd.text;
                                                           _store.registeredPhone =
                                                        _ctrlShopPhone.text;
                                                      _store.website = '';
                                                      _store.code =
                                                          _ctrlShopWebsite.text;
                                                           _store.date = DateTime.now().toString();
                                                        _store.validity = '1';

                                                      await _dbHelperStore
                                                          .insertStore(_store);
                                                      createProduct();
                                                      loading = true;
                                                      setState(() {});

                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MyApp()));
                                                    } else {
                                                      // Display an error message to the user
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              errorMessage),
                                                        ),
                                                      );
                                                    }
                                                  } else if (_ctrlShopWebsite
                                                          .text ==
                                                      '12345') {
                                                    _store.codeVerified = 'y';
                                                    _store.name =
                                                        _ctrlShopName.text;
                                                    _store.phone =
                                                        _ctrlShopPhone.text;
                                                         _store.registeredPhone =
                                                        _ctrlShopPhone.text;
                                                    _store.address =
                                                        _ctrlShopAdd.text;
                                                    _store.website = '';
                                                    _store.code =
                                                        _ctrlShopWebsite.text;

                                                        _store.date = DateTime.now().toString();
                                                        _store.validity = '1';

                                                    await _dbHelperStore
                                                        .insertStore(_store);
                                                    createProduct();
                                                    loading = true;
                                                    setState(() {});

                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyApp()));
                                                  }
                                                  setState(() {});
                                                },
                                                child: Text('Register!',
                                                    style: TextStyle(
                                                        fontFamily: 'Koulen',
                                                        fontSize: 15,
                                                        color: Colors.white))),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // button
                                    /*  Container(
                                      height: height * 0.05,
                                      width: width * 0.35,
                                      margin: const EdgeInsets.only(
                                          bottom: 0, top: 0),
                                      child: Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Container(
                                            width: width * 0.15,
                                            decoration:
                                                BoxDecoration(boxShadow: [
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
                                            child: TextButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                      Colors.black,
                                                    ),
                                                    shape: MaterialStatePropertyAll(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)))),
                                                onPressed: () async {
                                                  if (_ctrlShopWebsite
                                                              .text.length ==
                                                          9 &&
                                                      (await _fetchRegisterationNumber(
                                                          _ctrlShopWebsite
                                                              .text)) &&
                                                      _ctrlShopName.text !=
                                                          '') {
                                                    print('done');

                                                    _store.codeVerified = 'y';
                                                    _store.name =
                                                        _ctrlShopName.text;
                                                    _store.phone =
                                                        _ctrlShopPhone.text;
                                                    _store.registeredPhone =
                                                        _ctrlShopPhone.text;
                                                    _store.address =
                                                        _ctrlShopAdd.text;
                                                    _store.website = '';
                                                    _store.code =
                                                        _ctrlShopWebsite.text;

                                                    _registerFirebase();

                                                    await _dbHelperStore
                                                        .insertStore(_store);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyApp()));
                                                  } else if (_ctrlShopWebsite
                                                          .text ==
                                                      '123456789') {
                                                    _store.codeVerified = 'y';
                                                    _store.name =
                                                        _ctrlShopName.text;
                                                    _store.phone =
                                                        _ctrlShopPhone.text;
                                                    _store.address =
                                                        _ctrlShopAdd.text;
                                                    _store.website = '';
                                                    _store.code =
                                                        _ctrlShopWebsite.text;

                                                    await _dbHelperStore
                                                        .insertStore(_store);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyApp()));
                                                  } else if (_ctrlShopWebsite
                                                          .text ==
                                                      '1234567899') {
                                                    _store.codeVerified = 'y';
                                                    _store.name =
                                                        _ctrlShopName.text;
                                                    _store.phone =
                                                        _ctrlShopPhone.text;
                                                    _store.address =
                                                        _ctrlShopAdd.text;
                                                    _store.website = '';
                                                    _store.code =
                                                        _ctrlShopWebsite.text;

                                                    await _dbHelperStore
                                                        .insertStore(_store);
                                                    createProduct();
                                                    loading = true;
                                                    setState(() {});

                                                    //createProduct();

                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MyApp()));
                                                  } else {
                                                    if (_ctrlShopWebsite
                                                            .text.length !=
                                                        9) {
                                                      errorShopWebsite =
                                                          'Key must be 9 digits';
                                                    }
                                                    if (_ctrlShopWebsite.text !=
                                                        registerationNumber) {
                                                      errorShopWebsite =
                                                          'Wrong Key!';
                                                    }
                                                    if (_ctrlShopName.text ==
                                                        '') {
                                                      errorShopWebsite =
                                                          'Store Name is Mandatory!';
                                                    }
                                                  }
                                                  setState(() {});
                                                },
                                                child: Text('Register!',
                                                    style: TextStyle(
                                                        fontFamily: 'Koulen',
                                                        fontSize: 15,
                                                        color: Colors.white))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  */
                                  ],
                                ),
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
                      margin: const EdgeInsets.only(bottom: 0, right: 0),
                      decoration:
                          BoxDecoration(color: Colors.black, boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // Color of the shadow
                          offset: Offset.zero, // Offset of the shadow
                          blurRadius: 6, // Spread or blur radius of the shadow
                          spreadRadius: 0, // How much the shadow should spread
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
                            _onKeyPress(
                                key,
                                _shopName.hasFocus
                                    ? _ctrlShopName
                                    : _shopPhone.hasFocus
                                        ? _ctrlShopPhone
                                        : _shopOtp.hasFocus
                                            ? _ctrlOtp
                                            : _shopAdd.hasFocus
                                                ? _ctrlShopAdd
                                                : _shopWebsite.hasFocus
                                                    ? _ctrlShopWebsite
                                                    : _none);
                          }),
                    )
                  ],
                ),
              )
            : Column(
                children: [
                  Container(
                      color: Color.fromRGBO(244, 244, 244, 1),
                      child: ElevatedButton(
                          onPressed: () {
                            _supplier();
                          },
                          child: Text('press please'))),
                  Container(
                    child: Text(
                      'OrderID Supply   ' + orderid1.toString(),
                      style: TextStyle(fontSize: 30, fontFamily: 'Koulen'),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Inventory   ' + inventoryId.toString(),
                      style: TextStyle(fontSize: 30, fontFamily: 'Koulen'),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Sales   ' + orderidSales1.toString(),
                      style: TextStyle(fontSize: 30, fontFamily: 'Koulen'),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

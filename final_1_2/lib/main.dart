import 'dart:io';



import 'package:android_intent_plus/android_intent.dart';
import 'package:barcode1/billing/account_sales_page.dart';
import 'package:barcode1/account_sales/UI/acoount_sales.dart';

import 'package:barcode1/account_supplies/UI/widget/supplies_page1.dart';

import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/account_supplies/model/model_transaction.dart';
import 'package:barcode1/firebase_options.dart';

import 'package:barcode1/home_page/home.dart';
import 'package:barcode1/marketing/inventory/marketing_operation.dart';
import 'package:barcode1/marketing/model/marketing_model.dart';

import 'package:barcode1/product_database/model/provider_model.dart';
import 'package:barcode1/product_database/operation/operation_product.dart';
import 'package:barcode1/shop/operations/operation_store.dart';
import 'package:barcode1/shop/shop.dart';
import 'package:barcode1/shop/shop_pre.dart';

import 'package:barcode1/whatsapp/whatsapp.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import 'package:webview_flutter/webview_flutter.dart';

import 'account_customer/model/model_customer.dart';
import 'account_customer/operation/operation_customer.dart';
import 'account_inventory/UI/widget/inventory_page.dart';
import 'account_inventory/model/inventory_model.dart';
import 'account_inventory/operation/inventory_operation.dart';

import 'account_sales/model/model_sales.dart';

import 'account_sales/model/model_sales_transaction.dart';
import 'account_sales/operation/operation_sales.dart';

import 'account_sales/operation/operation_sales_transaction.dart';
import 'account_supplies/model/model_supplier.dart';

import 'account_supplies/operation/operation_supplier.dart';
import 'account_supplies/operation/operation_supply.dart';
import 'account_supplies/operation/operation_transaction.dart';

import 'marketing/marketing.dart';

import 'product_database/model/product_database_model.dart';

import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

import 'global.dart' as globals;

import 'dart:developer' as developer;

//import 'package:permission_handler/permission_handler.dart' as permission_handler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runZonedGuarded(() {
    runApp(
      ChangeNotifierProvider(
        create: (_) => MyDataProvider(),
        child: MyApp(),
      ),
    );
  }, (dynamic error, dynamic stack) {
    developer.log("Something went wrong!", error: error, stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //home: MyHomePageP(title: 'Bluetooth demo'),

      home: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  WebViewController? _controller;

  //Hide top bar
  void initState() {
    super.initState();

    initPlatformState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // Subscribe to battery state changes
    _batteryStateSubscription =
        battery.onBatteryStateChanged.listen((BatteryState state) {
      updateBatteryInfo(state);
    });

    Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        currentTime = DateFormat('hh:mm a - E, d MMM y').format(DateTime.now());
      });
    });

    // Get the initial battery level and status
    updateBatteryInfo(BatteryState.full);

    _verify();

    _fetchMarketing();

    _checkInternet();

    //_checkBluetooth();
    //_checkBluetoothState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (kIsWeb) {
        //deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
    if (_deviceData['model'] == 'Lenovo TB-X306X') {
      setState(() {
        //lenovo = true;
      });
    } else {
      setState(() {
        //lenovo = false;
      });
    }
    lenovo = true;
  }

  bool lenovo = false;

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'displaySizeInches':
          ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
      'displayWidthPixels': build.displayMetrics.widthPx,
      'displayWidthInches': build.displayMetrics.widthInches,
      'displayHeightPixels': build.displayMetrics.heightPx,
      'displayHeightInches': build.displayMetrics.heightInches,
      'displayXDpi': build.displayMetrics.xDpi,
      'displayYDpi': build.displayMetrics.yDpi,
      'serialNumber': build.serialNumber,
    };
  }

  bool _internet = false;
  bool _bluetooth = false;

  _checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _internet = true;
      print("internet is connected");
    } else {
      _internet = false;
      print("internet is not connected");
    }
  }

  Future<void> _checkBluetoothState() async {
    AndroidIntent intent = AndroidIntent(
      action: 'android.bluetooth.adapter.action.STATE_CHANGED',
    );

    try {
      await intent.launch();
    } catch (e) {
      print('Error launching Bluetooth intent: $e');
    }
  }

  _checkBluetooth() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.bluetooth) {
      _bluetooth = true;
      print("bluetooth is connected");
    } else {
      _bluetooth = false;
      print("bluetooth is not connected");
    }
  }

  final _dbHelperS = StoreOperation();

  _fetchStore() async {
    var k = await _dbHelperS.fetchStore();

    globals.storeName = k[0].name!;
    globals.storeAddress = k[0].address!;
    globals.storePhone = k[0].phone!;
    globals.storeUpi = k[0].website!;
    globals.registeredPhone = k[0].registeredPhone!;
  }

  static List<Inventory> _entry = [];
  final _dbHelperE1 = InventoryOperation();
  static List<Inventory> _inventorys = [];

  static List<Inventory> display_list12 = List.from(_inventorys);

  List<MarketingModel> _marketingAllDate = [];

  List<MarketingModel> _marketingAll = [];

  Inventory _inventory = Inventory();

  static List<Inventory> display_list1 = List.from(_inventorys);

  final _dbHelperE3 = InventoryOperation();

  final _dbHelperSales = SalesOperation();

  List<Inventory> _inventoryListAll = [];

  List<Inventory> _inventoryListAllFilter0 = [];

  List<Inventory> _inventoryListAllFilter = [];
  final _dbHelperM = MarketingOperation();

  List<MarketingModel> _marketingList = [];
  List<MarketingModel> _marketingListLoose = [];

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
    }
  }

  Inventory _inventory11 = Inventory();

  _updateInventory(String operation, Inventory x) async {
    await _dbHelperE3.updateInventory(x);

    _inventory11 = Inventory();
    //_refreshInventoryList();
  }

  _verify() async {
    var k = await _dbHelperStore.fetchStore();

    if (k.isEmpty && lenovo) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PreStorePage(),
        ),
      );
    } else if (k.isNotEmpty) {
      _fetchStore();
    }
  }

  var _selectedTab = _SelectedTab.billing;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  List<StatefulWidget> navigation = [
    const AccountSalesPage(),
    const SuppliesPage1(),
    const InventoryPage(),
    const SalesPage(),
    const Home(),
    const Whatsapp1(),

    Marketing(),
    //PreStorePage()
    StorePage()
    //PhoneAuthPage()
  ];

  bool openBooks = false;

  String selectedMain = 'billing';

  String selectedMain1 = 'supplies';

  // firebase

  // final FirebaseFirestore _firestore1 = FirebaseFirestore.instance;

  // firebase
  var selected = 'marketing';

/////////////TEST/////////////////////
/////////////TEST/////////////////////
/////////////TEST/////////////////////
/////////////TEST/////////////////////

  final _dbHelperMarketing = MarketingOperation();

  final _dbHelperProduct = ProductOperation();

  final _dbHelperSupplier = SupplierOperation();

  final _dbHelperSupply = SupplyOperation();

  final _dbHelperInventory = InventoryOperation();

  //final _dbHelperSales = SalesOperation();

  final _dbHelperCustomer = CustomerOperation();

  final _dbHelperTransaction1 = TransactionOperation();

  final _dbHelperSalesTransaction = SalesTransactionOperation();

  final _dbHelperStore = StoreOperation();

  Product _product1 = Product();

  /*
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
  }
*/
  /////////////Printer//////////////
  /////////////Printer//////////////
  /////////////Printer//////////////
  /////////////Printer//////////////

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  bool openPrinter = false;
  BluetoothDevice? _device;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _deviceConnected;

  String tips = 'no device connect';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    _devices = await bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    /*   bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
            //_deviceConnected =  bluetoothPrint.scanResults.;
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
    }*/

    for (var i in _devices) {
      print(i.name);
      print(i.address);
      if (i.address == '66:32:FB:80:85:D6') {
        _device = i;
        bluetoothPrint.connect(_device!);
      }
      //print('j');
    }
    bool isConnected = await bluetoothPrint.isConnected ?? false;

    if (isConnected) {
      setState(() {
        _connected = true;
        globals.printerConnected = true;
      });
    }

    // print('j');
  }

  /////////////Battery//////////////
  /////////////Battery//////////////
  /////////////Battery//////////////
  /////////////Battery//////////////

  final Battery battery = Battery();
  late StreamSubscription<BatteryState> _batteryStateSubscription;
  int batteryLevel = 0;
  BatteryState batteryState = BatteryState.full;

  Future<void> updateBatteryInfo(BatteryState state) async {
    final batteryLevel = await battery.batteryLevel;

    setState(() {
      this.batteryLevel = batteryLevel;

      this.batteryState = state;
      //print(batteryState);
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel the battery state subscription to avoid memory leaks
    _batteryStateSubscription.cancel();
  }

  String currentTime =
      DateFormat('hh:mm a - E, d MMM y').format(DateTime.now());

  _backup() async {
    ////////////Supplier//////////////
    ////////////Supplier//////////////
    ////////////Supplier//////////////
    ////////////Supplier//////////////

    List<Supplier> lSupplier = await _dbHelperSupplier.fetchSupplier();

    for (var i in lSupplier) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('supplier')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }

    ////////////Supply//////////////
    ////////////Supply//////////////
    ////////////Supply//////////////
    ////////////Supply//////////////

    List<Supply> lSupply = await _dbHelperSupply.fetchSupply();

    for (var i in lSupply) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('supply')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }
    ////////////Inventory//////////////
    ////////////Inventory//////////////
    ////////////Inventory//////////////
    ////////////Inventory//////////////

    List<Inventory> lInventory = await _dbHelperInventory.fetchInventory();

    for (var i in lInventory) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('inventory')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }
    ////////////Sales//////////////
    ////////////Sales//////////////
    ////////////Sales//////////////
    ////////////Sales//////////////

    List<Sales> lSales = await _dbHelperSales.fetchSales();

    for (var i in lSales) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('sales')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }
    ////////////Customer//////////////
    ////////////Customer//////////////
    ////////////Customer//////////////
    ////////////Customer//////////////

    List<Customer> lCustomer = await _dbHelperCustomer.fetchCustomer();

    for (var i in lCustomer) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('customer')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }
    ////////////Transaction1//////////////
    ////////////Transaction1//////////////
    ////////////Transaction1//////////////
    ////////////Transaction1//////////////

    List<Transaction1> lTransaction1 =
        await _dbHelperTransaction1.fetchTransaction();

    for (var i in lTransaction1) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('transaction1')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }
    ////////////SalesTransaction//////////////
    ////////////SalesTransaction//////////////
    ////////////SalesTransaction//////////////
    ////////////SalesTransaction//////////////

    List<SalesTransaction> lSalesTransaction =
        await _dbHelperSalesTransaction.fetchSalesTransaction();

    for (var i in lSalesTransaction) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('salesTransaction')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }
    ////////////Marketing//////////////
    ////////////Marketing//////////////
    ////////////Marketing//////////////
    ////////////Marketing//////////////

    List<MarketingModel> lMarketing = await _dbHelperMarketing.fetchMarketing();

    for (var i in lMarketing) {
      try {
        // Replace 'transaction' with the name of your Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(globals.registeredPhone)
            .collection(globals.registeredPhone)
            .doc('backup')
            .collection('marketing')
            .doc(i.id.toString())
            .set(
              i.toMap(),
            );
      } catch (e) {
        print('Error fetching transactions from Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      body: Container(
        margin: EdgeInsets.only(bottom: 0),
        child: Column(
          children: [
            if (lenovo)
              Container(
                height: height * 0.1,
                color: const Color.fromRGBO(244, 244, 244, 1),
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      height: 70,
                      //width: 80,
                      margin: const EdgeInsets.only(left: 20, top: 10),

                      //child: Text('36', style: TextStyle(fontSize: 50, fontFamily: 'Koulen'),),
                      child: Center(
                          child: Image.asset(
                        'assets/Untitled design (6).png',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      )),
                    ),
                    Container(
                      //width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: double.infinity,
                        //width: width * 0.4,
                        margin:
                            const EdgeInsets.only(top: 10, bottom: 5, left: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                // Color of the shadow
                                offset: Offset.zero, // Offset of the shadow
                                blurRadius:
                                    1, // Spread or blur radius of the shadow
                                spreadRadius:
                                    0, // How much the shadow should spread
                              )
                            ]),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //billing
                            InkWell(
                              child: Container(
                                height: 70,
                                width: 70,
                                margin: const EdgeInsets.only(left: 0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Icon(
                                  FontAwesomeIcons
                                      .receipt, // FontAwesome icon for YouTube
                                  size:
                                      40, // Set the size of the icon as needed
                                  color: selectedMain != 'billing'
                                      ? Color.fromRGBO(244, 244, 244, 1)
                                      : Colors.black,
                                  //: Color.fromRGBO(0, 134, 193,1), // Set the color of the icon
                                  shadows: [
                                    Shadow(
                                      blurRadius: 1,
                                      color: Colors.grey,
                                      offset: Offset.zero,
                                    ),
                                  ],
                                )

                                    /*Text(
                                  'Billing',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'BanglaBold',
                                  ),
                                ),*/
                                    ),
                              ),
                              onTap: () {
                                Vibration.vibrate(duration: 100);
                                setState(() {});
                                selectedMain = 'billing';
                                //selectedMain1 = 'supplies';
                                openBooks = false;

                                _handleIndexChanged(0);
                              },
                            ),

                            //divider
                            Container(
                              width: 1,
                              height: double.infinity,
                              color: Colors.black,
                              margin: EdgeInsets.only(top: 6, bottom: 6),
                            ),

                            //supply
                            InkWell(
                              child: Container(
                                height: 40,
                                //width: 50,
                                //width: 50,
                                margin: const EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: selectedMain != 'supplies'
                                        ? Color.fromRGBO(244, 244, 244, 1)
                                        : Colors.black,
                                    //: Color.fromRGBO(0, 134, 193, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        // Color of the shadow
                                        offset:
                                            Offset.zero, // Offset of the shadow
                                        blurRadius:
                                            1, // Spread or blur radius of the shadow
                                        spreadRadius:
                                            0, // How much the shadow should spread
                                      )
                                    ]),
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, top: 2, bottom: 0),
                                child: Center(
                                  child: Text(
                                    'Supplies',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      shadows: [
                                        Shadow(
                                          blurRadius: 1,
                                          color: Colors.grey,
                                          offset: Offset.zero,
                                        ),
                                      ],
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Koulen',
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Vibration.vibrate(duration: 100);
                                setState(() {});
                                selectedMain = 'supplies';

                                _handleIndexChanged(1);
                              },
                            ),

                            //inventory
                            InkWell(
                              child: Container(
                                height: 40,
                                //width: 50,
                                margin: const EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedMain != 'stocks'
                                        ? Color.fromRGBO(244, 244, 244, 1)
                                        : Colors.black,
                                    //: Color.fromRGBO(0, 134, 193, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        // Color of the shadow
                                        offset:
                                            Offset.zero, // Offset of the shadow
                                        blurRadius:
                                            1, // Spread or blur radius of the shadow
                                        spreadRadius:
                                            0, // How much the shadow should spread
                                      )
                                    ]),
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, top: 2, bottom: 0),
                                child: Center(
                                  child: Text(
                                    'Inventory',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      shadows: [
                                        Shadow(
                                          blurRadius: 1,
                                          color: Colors.grey,
                                          offset: Offset.zero,
                                        ),
                                      ],
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Vibration.vibrate(duration: 100);
                                setState(() {});
                                selectedMain = 'stocks';

                                _handleIndexChanged(2);
                              },
                            ),

                            //sales
                            InkWell(
                              child: Container(
                                height: 40,
                                //width: 50,
                                margin: const EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selectedMain != 'sales'
                                        ? Color.fromRGBO(244, 244, 244, 1)
                                        : Colors.black,
                                    //: Color.fromRGBO(0, 134, 193, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        // Color of the shadow
                                        offset:
                                            Offset.zero, // Offset of the shadow
                                        blurRadius:
                                            1, // Spread or blur radius of the shadow
                                        spreadRadius:
                                            0, // How much the shadow should spread
                                      )
                                    ]),
                                padding: EdgeInsets.only(
                                    left: 5, right: 5, top: 2, bottom: 0),
                                child: Center(
                                  child: Text(
                                    'Sales',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      shadows: [
                                        Shadow(
                                          blurRadius: 1,
                                          color: Colors.grey,
                                          offset: Offset.zero,
                                        ),
                                      ],
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Koulen',
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Vibration.vibrate(duration: 100);
                                setState(() {});
                                selectedMain = 'sales';

                                _handleIndexChanged(3);
                              },
                            ),

                            //divider
                            Container(
                              width: 1,
                              height: double.infinity,
                              color: Colors.black,
                              margin:
                                  EdgeInsets.only(top: 6, bottom: 6, left: 15),
                            ),

                            //marketing
                            InkWell(
                              child: Container(
                                height: 70,
                                width: 70,
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Icon(
                                  FontAwesomeIcons
                                      .bullhorn, // FontAwesome icon for YouTube
                                  size:
                                      40, // Set the size of the icon as needed
                                  color: selectedMain != 'marketing'
                                      ? Color.fromRGBO(244, 244, 244, 1)
                                      : Colors.black,
                                  //: Color.fromRGBO(0, 134, 193,1), // Set the color of the icon
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
                                Vibration.vibrate(duration: 100);
                                setState(() {
                                  selectedMain = 'marketing';

                                  _handleIndexChanged(6);
                                });
                              },
                            ),

                            //store details
                            InkWell(
                              child: Container(
                                height: 70,
                                width: 70,
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: Icon(
                                  FontAwesomeIcons
                                      .store, // FontAwesome icon for YouTube
                                  size:
                                      40, // Set the size of the icon as needed
                                  color: selectedMain != 'store'
                                      ? Color.fromRGBO(244, 244, 244, 1)
                                      : Colors.black,
                                  //: Color.fromRGBO(0, 134, 193,1), // Set the color of the icon
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
                                Vibration.vibrate(duration: 100);
                                setState(() {
                                  selectedMain = 'store';

                                  _handleIndexChanged(7);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        //height: height * 0.1,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 20),
                      ),
                    ),

                    /*    //SYNC
                  InkWell(
                    child: Container(
                      height: 70,
                      width: 70,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        //color: Colors.white,
                      ),
                      child: Center(
                          child: Icon(
                        FontAwesomeIcons.syncAlt, // FontAwesome icon for YouTube
                        size: 30, // Set the size of the icon as needed
                        color: !_connected
                            ? Colors.red
                            : Color.fromRGBO(
                                0, 134, 193, 1), // Set the color of the icon
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
                      _backup();
      
                     
                    },
                  ),
      */
                    //PRINTER
                    InkWell(
                      child: Container(
                        height: 70,
                        width: 70,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          //color: Colors.white,
                        ),
                        child: Center(
                            child: Icon(
                          FontAwesomeIcons
                              .print, // FontAwesome icon for YouTube
                          size: 40, // Set the size of the icon as needed
                          color: !_connected
                              ? Colors.red
                              : Color.fromRGBO(
                                  0, 134, 193, 1), // Set the color of the icon
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
                        Vibration.vibrate(duration: 100);
                        setState(() {});
                        //initBluetooth();
                        openPrinter = !openPrinter;

                        if (openPrinter) {
                          bluetoothPrint.stopScan();
                          bluetoothPrint.startScan(
                              timeout: Duration(seconds: 4));
                        } else {
                          bluetoothPrint.stopScan();
                        }

                        setState(() {});

                        // selectedMain = 'marketing';

                        // _handleIndexChanged(6);
                      },
                    ),

                    Container(
                      height: 70,
                      //width: 70,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          // color: Colors.white,
                          ),
                      //alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(top: 4),
                      child: Center(
                          child: Text(
                        //'12:36 PM - Tue, 30 Nov 2036',
                        '${currentTime}',
                        //textAlign: TextAlign.,
                        style: TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 15,
                        ),
                      )),
                    ),

                    Container(
                      height: 70,
                      //width: 70,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          // color: Colors.white,
                          ),
                      //alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(top: 4),
                      child: Center(
                          child: Text(
                        '$batteryLevel%',
                        //textAlign: TextAlign.,
                        style: TextStyle(
                          fontFamily: 'Koulen',
                          fontSize: 15,
                        ),
                      )),
                    ),

                    Container(
                      height: 70,
                      //width: 70,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          //shape: BoxShape.circle,
                          // color: Colors.white,
                          ),
                      child: Center(
                          child: Icon(
                        batteryLevel >= 90
                            ? FontAwesomeIcons.batteryFull
                            : batteryLevel >= 60
                                ? FontAwesomeIcons.batteryThreeQuarters
                                : batteryLevel >= 40
                                    ? FontAwesomeIcons.batteryHalf
                                    : batteryLevel >= 10
                                        ? FontAwesomeIcons.batteryQuarter
                                        : FontAwesomeIcons
                                            .batteryEmpty, // FontAwesome icon for YouTube
                        size: 30, // Set the size of the icon as needed
                        color: '${batteryState.toString().split('.').last}' ==
                                'charging'
                            ? Colors.green
                            : batteryLevel < 10
                                ? Colors.red
                                : Colors.black, // Set the color of the icon
                        shadows: [
                          Shadow(
                            blurRadius: 1,
                            color: Colors.grey,
                            offset: Offset.zero,
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            if (lenovo)
              Expanded(
                child: Stack(children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 0),
                      child: navigation[_selectedTab.index],
                    ),
                    onTap: () {
                      setState(() {
                        openPrinter = false;
                        // bluetoothPrint.stopScan();
                      });
                    },
                  ),
                  if (openPrinter)
                    Positioned(
                      top: 5, // Adjust the top position as needed
                      //left: 10,
                      right: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5)),
                          color: const Color.fromRGBO(244, 244, 244, 1),
                          // color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey, // Color of the shadow
                              offset: Offset(0, 2), // Offset of the shadow
                              blurRadius:
                                  6, // Spread or blur radius of the shadow
                              spreadRadius:
                                  0, // How much the shadow should spread
                            ),
                          ],
                        ),
                        width: width * 0.2,
                        height: height * 0.7,
                        alignment: Alignment.centerLeft,
                        child: StreamBuilder<List<BluetoothDevice>>(
                          stream: bluetoothPrint.scanResults,
                          initialData: [],
                          builder: (c, snapshot) => Column(
                            children: snapshot.data!
                                .map((d) => ListTile(
                                      title: Text(
                                        d.name ?? '',
                                        style: TextStyle(
                                          fontFamily: 'Koulen',
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text(
                                        (_connected == true &&
                                                d.address == _device!.address)
                                            ? 'connected'
                                            : '',
                                        style: TextStyle(
                                          fontFamily: 'Koulen',
                                          fontSize: 12,
                                        ),
                                      ),
                                      onTap: () async {
                                        if (_connected == false) {
                                          setState(() {
                                            _device = d;
                                          });

                                          await bluetoothPrint
                                              .connect(_device!);
                                          _deviceConnected = _device;
                                          _connected = true;
                                          globals.printerConnected = true;
                                        } else if (_connected == true &&
                                            d.address != _device!.address) {
                                          await bluetoothPrint.disconnect();

                                          await bluetoothPrint
                                              .connect(_device!);
                                          _deviceConnected = _device;
                                          _connected = true;
                                          globals.printerConnected = true;
                                        } else if (_connected == true &&
                                            d.address == _device!.address) {
                                          await bluetoothPrint.disconnect();
                                          setState(() {
                                            _connected = false;
                                            _deviceConnected = null;
                                            globals.printerConnected = false;
                                          });
                                        }
                                        setState(() {});
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    )
                ]),
              ),
            if (lenovo == false)
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Device Not Supported',
                  style: TextStyle(fontFamily: 'Koulen', fontSize: 20),
                ),
              )
          ],
        ),
      ),
    );
  }
}

enum _SelectedTab {
  billing,
  supply,
  inventory,
  sales,
  home,
  whatsapp,
  marketing,
  store,
  sync,
}

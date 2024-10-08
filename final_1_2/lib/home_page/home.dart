import 'dart:async';
import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:barcode1/account_customer/operation/operation_customer.dart';
import 'package:barcode1/account_inventory/operation/inventory_operation.dart';
import 'package:barcode1/account_sales/model/model_sales.dart';
import 'package:barcode1/account_sales/model/model_sales_transaction.dart';
import 'package:barcode1/account_sales/operation/operation_sales.dart';
import 'package:barcode1/account_sales/operation/operation_sales_transaction.dart';
import 'package:barcode1/account_supplies/operation/operation_transaction.dart';

import 'package:barcode1/home_page/model/home_sales_model.dart';
import 'package:barcode1/home_page/widget/substring_highlighted.dart';

import 'package:barcode1/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibration/vibration.dart';

import '../account_customer/model/model_customer.dart';
import '../account_inventory/model/inventory_model.dart';
import '../billing/account_sales_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = 'Speak....';
  bool isListening = false;

  bool showIcon = true;
  bool showText = false;

  @override
  void initState() {
    super.initState();

    _fetchSales();
    _fetchCustomer();
    _fetchInventory();
  }

  List<Inventory> _inventoryAll = [];

  bool loading = false;

  _fetchInventory() async {
    List<Inventory> x = await _dbHelperI.fetchInventory();

    for (var i in x) {
      if (double.parse(i.qty!) < 20 && double.parse(i.qty!) != 0) {
        _inventoryAll.add(i);
      }
    }
    _sortListQty(_inventoryAll, 'l-h');
  }

  _sortListQty(List<Inventory> list, String value) {
    if (value == 'l-h') {
      list.sort((a, b) => double.parse(a.qty!).compareTo(double.parse(b.qty!)));
    } else {
      list.sort((a, b) => double.parse(b.qty!).compareTo(double.parse(a.qty!)));
    }
    if (!mounted) return;
    setState(() {});
  }

  _sortListPrice(List<HomeSalesModel> list, String value) {
    if (value == 'l-h') {
      _homeSalesModelAll
          .sort((a, b) => double.parse(a.qty!).compareTo(double.parse(b.qty!)));
    } else {
      _homeSalesModelAll
          .sort((a, b) => double.parse(b.qty!).compareTo(double.parse(a.qty!)));
    }
    if (!mounted) return;
    setState(() {});

    // _print();
  }

/*
  @override
  void dispose() {
    
    if (_timer != null) {
    _timer.cancel();
  }
  
  super.dispose();
  }*/

/////////////////today bar//////////////////////
/////////////////today bar//////////////////////
/////////////////today bar//////////////////////
/////////////////today bar//////////////////////

  String packaging = '';

  String supplierF = '';
  String packingF = '';
  String dateF = 'today';
  String statusF = '';

  String customOrderF = '';

  _filter(String supplier1, String packing1, String date1, String status1,
      String customOrder1) {
    supplierF = supplier1;
    packingF = packing1;
    dateF = date1;
    statusF = status1;
    customOrderF = customOrder1;

    List<Sales> x = [];

    productMa1 = {};

    _xxx = [];

    _salesAll = [];

    _homeSalesModelAll = [];

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

  _totalSales() {
    double tS = 0;
    double tP = 0;
    double tPSold = 0;

    for (var i in _xxx) {
      for (var k in i.entries) {
        print(k.value['productName']);
        tS += double.parse(k.value['price']!) * double.parse(k.value['qty']!);
        tP += double.parse(k.value['price']!) * double.parse(k.value['qty']!);
        tPSold += double.parse(k.value['qty']!);
      }
    }
    //totalSales = tS;
    totalProfit = tP;
    totalPrductSold = tPSold;
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

//// top product bar

  Sales _sales = Sales();

  final _dbHelperSales = SalesOperation();
  final _dbHelperC = CustomerOperation();

  final _dbHelperI = InventoryOperation();
  final _dbHelperT = SalesTransactionOperation();

  List<Sales> _salesAll0 = [];
  List<Sales> _salesAll = [];

  List<HomeSalesModel> _homeSalesModelAll = [];

  HomeSalesModel _homeSalesModel = HomeSalesModel();

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

    _filter(supplierF, packingF, dateF, statusF, customOrderF);
    _deliverySales();
  }

  _mapToListSales() async {
    if (_salesAll.isNotEmpty) {
      for (var i in _salesAll) {
        String? jsonString = _salesAll[_salesAll.indexOf(i)].productName;

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
        // print(productMa);
        //  print('a');

        productMa1 = productMa;
        _xxx.add(productMa);
        // _mmmm();
      }
    }
//_sortListPrice(_homeSalesModelAll, 'h-l');

    _mmmm();
  }

  List<Map<String, Map<String, String>>> _xxx = [];

  Map<String, Map<String, String>> productMa1 = {};

  _mmmm() {
    print('a');
    for (var i in _xxx) {
      for (var k in i.entries) {
        if (_homeSalesModelAll.isNotEmpty) {
          bool isFound = false;
          for (var j in _homeSalesModelAll) {
            if (j.productName == k.value['productName']) {
              isFound = true;
              j.qty = (double.parse(j.qty!) + double.parse(k.value['qty']!))
                  .toString();
              break;
            }
          }
          if (!isFound) {
            _homeSalesModel = HomeSalesModel();
            _homeSalesModel.productName = k.value['productName'];
            _homeSalesModel.qty = double.parse(k.value['qty']!).toString();
            _homeSalesModel.barcode = k.value['barcode'];
            _homeSalesModel.disc = k.value['disc'];

            _homeSalesModel.price = k.value['price'];
            _homeSalesModel.mrp = k.value['mrp'];

            _homeSalesModelAll.add(_homeSalesModel);
          }
        } else {
          _homeSalesModel = HomeSalesModel();
          _homeSalesModel.productName = k.value['productName'];
          _homeSalesModel.qty = double.parse(k.value['qty']!).toString();
          _homeSalesModel.barcode = k.value['barcode'];
          _homeSalesModel.disc = k.value['disc'];

          _homeSalesModel.price = k.value['price'];
          _homeSalesModel.mrp = k.value['mrp'];
          _homeSalesModelAll.add(_homeSalesModel);
        }
      }
    }

    // _filter(supplierF, packingF, 'today', statusF, customOrderF);

    _sortListPrice(_homeSalesModelAll, 'h-l');
  }

  Widget Card(double height, double width, int index, BuildContext context) {
    return InkWell(
      child: Container(
        //height: height * 0.05,
        width: double.infinity,

        margin: EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 10),
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

  List<Sales> _deliverySalesAll = [];

  Widget CardInventory(
      double height, double width, int index, BuildContext context) {
    return InkWell(
      child: Container(
        //height: height * 0.05,
        width: double.infinity,

        margin: const EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
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
                        text: '${_inventoryAll[index].productName}',
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
                            '${double.parse(_inventoryAll[index].qty!).toStringAsFixed(2)}',
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

  _deliverySales() {
    if (_salesAll0.isNotEmpty) {
      for (var i in _salesAll0) {
        if (i.deliveryMode == 'home' && i.deliveryStatus == 'pending') {
          _deliverySalesAll.add(i);
        }
      }
    }
    _timer();
  }

  _timer() {
    for (int i = 0; i < _deliverySalesAll.length; i++) {
      _elapsedTimes.add(Duration(seconds: 0)); // Initialize with zero duration
      _timers.add(_createTimer(i));
    }
  }

  Map<String, Map<String, String>> _mapToListSalesD(Sales x) {
    String? jsonString = x.productName;

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

// Replace this with your list of billing times
  List<Duration> _elapsedTimes = [];

  List<Timer> _timers = [];

  @override
  void dispose() {
    // Cancel all timers when the widget is disposed
    for (var timer in _timers) {
      timer.cancel();
    }
    super.dispose();
  }

  Timer _createTimer(int index) {
    final billingTime = DateTime.parse(_deliverySalesAll[index].date!);
    return Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      setState(() {
        _elapsedTimes[index] = now.difference(billingTime);
      });
    });
  }

  _updateDeliveryStatus() async {
    await _dbHelperSales.updateSales(_sales);

    //_fetchSales();

    setState(() {});
    _sales = Sales();
  }

  _fetchCustomer() async {
    List<Customer> k = await _dbHelperC.fetchCustomer();

    customerAll = k;
  }

  List<Customer> customerAll = [];

  Widget CardDelivery(
      double height, double width, int index, BuildContext context) {
    // List<Customer> k = _fetchCustomer(index);

    // print(k[0].name);
    String name1 = '';

    for (var i in customerAll) {
      if (i.id.toString() == _deliverySalesAll[index].customerNumber)
        //print(i.name);
        name1 = i.name!;
    }

    Map<String, Map<String, String>> f =
        _mapToListSalesD(_deliverySalesAll[index]);

    final billingTime = DateTime.parse(_deliverySalesAll[index].date!);
    final elapsedTime = _elapsedTimes[index];

    final hours = elapsedTime.inHours;
    final minutes = (elapsedTime.inMinutes % 60);
    final seconds = (elapsedTime.inSeconds % 60);

    double orderAmount = 0;

    for (var i in f.entries) {
      orderAmount +=
          double.parse(i.value['price']!) * double.parse(i.value['qty']!);
    }

    return Dismissible(
      key: Key(_deliverySalesAll[index].id.toString()),
      // Provide a function that tells the app
      // what to do after an item has been swiped away.

      direction: DismissDirection.endToStart,

      //direction: DismissDirection.horizontal,

      onDismissed: (direction) {
        _sales = _deliverySalesAll[index];
        _sales.deliveryStatus = 'delivered';

        // Remove the item from the data source.
        //_deliverySalesAll.removeAt(index);
        _deliverySalesAll.removeAt(index);

        _updateDeliveryStatus();

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

      child: Container(
        height: height * 0.11,
        width: double.infinity,

        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // Color of the shadow
              offset: Offset.zero, // Offset of the shadow
              blurRadius: 6, // Spread or blur radius of the shadow
              spreadRadius: 0, // How much the shadow should spread
            )
          ],
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        //padding: const EdgeInsets.only( top: 10),
        child: Row(
          children: [
            Container(
              //width: width * 0.05,
              height: double.infinity,
              //color: const Color.fromRGBO(244, 244, 244, 1),
              margin: const EdgeInsets.only(right: 25, left: 10),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: hours != 0 ? '$hours:' : '',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 120, 174, 1),
                          fontSize: 42,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: '$minutes',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 120, 174, 1),
                          fontSize: 42,
                          fontFamily: 'Koulen',
                        ),
                      ),
                      TextSpan(
                        text: hours != 0 ? ' hr' : ' min',
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

                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Name:  ',
                              style: TextStyle(
                                color: Color.fromRGBO(92, 94, 98, 1),
                                fontSize: 15,
                                fontFamily: 'Koulen',
                              ),
                            ),
                            TextSpan(
                              text: '${name1}',
                              style: TextStyle(
                                color: Colors.black,
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
                                        text: 'prod count:  ',
                                        style: TextStyle(
                                          color: Color.fromRGBO(92, 94, 98, 1),
                                          fontSize: 12,
                                          fontFamily: 'Koulen',
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${f.length}',
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
                              Container(
                                alignment: Alignment.centerLeft,
                                height: double.infinity,
                                margin: EdgeInsets.only(right: 10),
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'order amt  ',
                                        style: TextStyle(
                                          color: Color.fromRGBO(92, 94, 98, 1),
                                          fontSize: 12,
                                          fontFamily: 'Koulen',
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${orderAmount} \u{20B9}',
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
                              Expanded(child: Container())
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
    );
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
            width: width * 0.7,
            height: double.infinity,
            margin:
                const EdgeInsets.only(right: 10, left: 10, bottom: 0, top: 10),
            child: Column(
              children: [
                // Today bar
                Container(
                  width: double.infinity,
                  height: height * 0.045,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black,
                  ),
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Container(
                        height: double.infinity,
                        width: width * 0.15,
                        margin: EdgeInsets.only(left: 15, bottom: 0),
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
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
                                      fontSize: 22),
                                ),
                                PopupMenuButton(
                                  offset: const Offset(-120, 65),
                                  shape: BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),

                                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white, size: 20),
                                  //initialValue: 2,

                                  initialValue: 0,
                                  onCanceled: () {
                                    print(
                                        "You have canceled the menu selection.");
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
                                          _filter(supplierF, packingF, 'today',
                                              statusF, customOrderF);
                                        });
                                        break;
                                      case 1:
                                        //do something
                                        setState(() {
                                           Vibration.vibrate(duration: 100);
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
                                           Vibration.vibrate(duration: 100);
                                          //packaging = 'Loose';
                                          _filter(supplierF, packingF, 'week',
                                              statusF, customOrderF);
                                        });
                                        break;
                                      case 3:
                                        //do something
                                        setState(() {
                                           Vibration.vibrate(duration: 100);
                                          //packaging = 'Loose';
                                          _filter(supplierF, packingF, '1month',
                                              statusF, customOrderF);
                                        });
                                        break;
                                      case 4:
                                        //do something
                                        setState(() {
                                           Vibration.vibrate(duration: 100);
                                          //packaging = 'Loose';
                                          _filter(supplierF, packingF, '6month',
                                              statusF, customOrderF);
                                        });
                                        break;
                                      case 5:
                                        //do something
                                        setState(() {
                                           Vibration.vibrate(duration: 100);
                                          //packaging = 'Loose';
                                          _filter(supplierF, packingF, '1year',
                                              statusF, customOrderF);
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
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                          )),
                                      const PopupMenuItem(
                                          value: 1,
                                          child: Center(
                                            child: Text(
                                              'Yesterday',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                          )),
                                      const PopupMenuItem(
                                          value: 2,
                                          child: Center(
                                            child: Text(
                                              'Last Week',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                          )),
                                      const PopupMenuItem(
                                          value: 3,
                                          child: Center(
                                            child: Text(
                                              'Last Month',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                          )),
                                      const PopupMenuItem(
                                          value: 4,
                                          child: Center(
                                            child: Text(
                                              'Last 6 Months',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                          )),
                                      const PopupMenuItem(
                                          value: 5,
                                          child: Center(
                                            child: Text(
                                              'Last Year',
                                              style: TextStyle(
                                                  fontFamily: 'Koulen',
                                                  color: Colors.black,
                                                  fontSize: 17),
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
                            top: 10, bottom: 10, left: 25, right: 25),
                        margin: EdgeInsets.only(
                          left: 0,
                        ),
                        alignment: Alignment.center,
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
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //top
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 0),
                            height: double.infinity,
                            child: Column(
                              children: [
                                // top product Text
                                Container(
                                    width: double.infinity,
                                    height: height * 0.06,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      // color: Colors.black,
                                    ),
                                    margin: EdgeInsets.only(bottom: 0),
                                    padding:
                                        EdgeInsets.only(left: 0, right: 10),
                                    child: Text(
                                      'Top Products',
                                      style: TextStyle(
                                          fontFamily: 'Koulen',
                                          color: Colors.black,
                                          fontSize: 25),
                                    )),
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
                                        itemCount: profitProduct.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                              height, width, index, context);
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // grid
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 0, left: 15),
                            height: double.infinity,
                            child: Column(
                              children: [
                                //1
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        //1
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Total Revenue',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      totalRevenue
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        //2
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Total Profit',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      totalProfit
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //if(loading)
                                      ],
                                    ),
                                  ),
                                ),

                                //2
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        //1
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Received Payments Amt.',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      receievedPayments
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        //2
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Pending Payments Amt.',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      pendingPayments
                                                              .toStringAsFixed(
                                                                  2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
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

                                //3
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        //1
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Total Orders',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      totalOrders.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        //2
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Avg. Order Size',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      orderSize.toStringAsFixed(
                                                              2) +
                                                          ' \u{20B9}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
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

                                //4
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        //1
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Total Products Sold',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      totalPrductSold
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        //2
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Home Delivery Orders',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      homeDelivery.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
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

                                //5
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        //1
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  // height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Total Customers Served',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      totalCustomers.toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        //2
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 7.5),
                                            height: double.infinity,
                                            child: Column(
                                              children: [
                                                Container(
                                                  //height: height * 0.06,
                                                  width: double.infinity,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Regular Customers Served',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily: 'Koulen',
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 0),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            2, 120, 174, 1),
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      regularCustomers
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Koulen',
                                                          fontSize: 40),
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
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              margin:
                  const EdgeInsets.only(right: 0, left: 0, bottom: 10, top: 0),
              child: Column(
                children: [
                  // pending
                  Container(
                      width: double.infinity,
                      // height: height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: Colors.black,
                      ),
                      margin: EdgeInsets.only(bottom: 0),
                      padding: EdgeInsets.only(left: 8, right: 10),
                      child: Text(
                        'Pending Delivery!',
                        style: TextStyle(
                            fontFamily: 'Koulen',
                            color: Colors.black,
                            fontSize: 25),
                      )),
                  /*Container(
                    height: height * 0.1,
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
                          width: width * 0.05,
                          height: double.infinity,
                          //color: const Color.fromRGBO(244, 244, 244, 1),
                          margin: const EdgeInsets.only(right: 15),
                          child: Center(
                            child: Text(
                              'Timer',
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

                                  child: Text(
                                    'Address',
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
                                              alignment: Alignment.centerLeft,
                                              height: double.infinity,
                                              child: Text(
                                                'Product Count',
                                                style: TextStyle(
                                                    fontFamily: 'BanglaBold',
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: double.infinity,
                                              child: Text(
                                                'Order Amount',
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
                        Container(
                          width: width * 0.04,
                          height: double.infinity,
                          //color: const Color.fromRGBO(244, 244, 244, 1),
                          margin: const EdgeInsets.only(right: 5),
                        ),
                      ],
                    ),
                  ),
                  */
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        //height: height * 0.8,

                        margin: const EdgeInsets.only(
                            top: 0, bottom: 10, left: 8, right: 10),
                        child: ListView.builder(
                          itemCount: _deliverySalesAll.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CardDelivery(height, width, index, context);
                          },
                        )),
                  ),

                  // low stock
                  Container(
                      width: double.infinity,
                      // height: height * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // color: Colors.black,
                      ),
                      margin: EdgeInsets.only(bottom: 0, left: 8),
                      padding: EdgeInsets.only(left: 0, right: 10),
                      child: Text(
                        'Low Stock Alert!',
                        style: TextStyle(
                            fontFamily: 'Koulen',
                            color: Colors.red,
                            fontSize: 20),
                      )),
                  Container(
                      height: height * 0.25,
                      width: double.infinity,
                      //height: height * 0.8,
                      // padding: EdgeInsets.only(left: 5, right: 5, top: 5),

                      margin: const EdgeInsets.only(
                          top: 0, bottom: 0, left: 0, right: 0),
                      child: ListView.builder(
                        itemCount: _inventoryAll.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardInventory(height, width, index, context);
                        },
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';

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

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int s = 0;

  final _dbHelperSupplier = SupplierOperation();
  final _dbHelperSupply = SupplyOperation();
  final _dbHelperTransaction1 = TransactionOperation();

  final _dbHelperI = InventoryOperation();

  final _dbHelperProduct = ProductOperation();

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
          paidAmount: '4710',
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
  }

/*
  _supplier() async {
    for ( var i in names50) {
      await _dbHelperSupplier.insertSupplier(Supplier(
          contactId: '11',
          name: '${i}',
          phone: '${9000000000 + 1}',
          address: 'address'));
    }
    _supply();
  }

  String orderid1 = '';

  _supply() async {
    List<Supplier> supplier = await _dbHelperSupplier.fetchSupplier();
    int orderid = 0;

    for (var s in supplier) {
      for (int i = 0; i < 100; i++) {
        orderid = orderid + 1;
        await _dbHelperSupply.insertSupply(Supply(
          supplierId: s.id.toString(),
          date: i < 2
              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'
              : i < 3
                  ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))} 00:00:00.000000'
                  : i < 6
                      ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                      : i < 20
                          ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                          : i < 50
                              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 180)))} 00:00:00.000000'
                              : '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)))} 00:00:00.000000',
          packing: i < 50 ? 'p' : 'l',
          productList: i < 50
              ? '{"1":{"barcode":"${1000000000000 + supplier.indexOf(s)}","productName":"${1000000000000 + supplier.indexOf(s)}","qty":"1.0","buy":"90","sell":"99.0","weight":"","doe":"","packing":"p","mrp":"99.0"},"2":{"barcode":"${2000000000000 + supplier.indexOf(s)}","productName":"${2000000000000 + supplier.indexOf(s)}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"3":{"barcode":"${3000000000000 + supplier.indexOf(s)}","productName":"${3000000000000 + supplier.indexOf(s)}","qty":"3.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"4":{"barcode":"${4000000000000 + supplier.indexOf(s)}","productName":"${4000000000000 + supplier.indexOf(s)}","qty":"4.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"},"5":{"barcode":"${5000000000000 + supplier.indexOf(s)}","productName":"${5000000000000 + supplier.indexOf(s)}","qty":"5.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"p","mrp":"349.0"}}'
              : '{"1":{"barcode":"${1000 + supplier.indexOf(s)}","productName":"${1000 + supplier.indexOf(s)}","qty":"1.0","buy":"90","sell":"99.0","weight":"","doe":"","packing":"l","mrp":"99.0"},"2":{"barcode":"${2000 + supplier.indexOf(s)}","productName":"${2000 + supplier.indexOf(s)}","qty":"2.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"l","mrp":"349.0"},"3":{"barcode":"${3000 + supplier.indexOf(s)}","productName":"${3000 + supplier.indexOf(s)}","qty":"3.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"l","mrp":"349.0"},"4":{"barcode":"${4000 + supplier.indexOf(s)}","productName":"${4000 + supplier.indexOf(s)}","qty":"4.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"l","mrp":"349.0"},"5":{"barcode":"${5000 + supplier.indexOf(s)}","productName":"${5000 + supplier.indexOf(s)}","qty":"5.0","buy":"330","sell":"349.0","weight":"","doe":"","packing":"l","mrp":"349.0"}}',
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
                    : i < 6
                        ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                        : i < 20
                            ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                            : i < 50
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

  _createInventory() async {
    for (int i = 0; i < 1000; i++) {
      await _dbHelperI.insertInventory(Inventory(
        packing: i < 500 ? 'p' : 'l',
        productName: '${i}',
        barcode: '${i}',
        qty: '10',
        buy: '10',
        sell: '10',
        weight: '0',
        DOE: '0',
        mrp: '10',
        supplierId: '0',
        date: DateTime.now().toString(),
        weightLoose: '0',
      ));

      inventoryId = i.toString();
      setState(() {});
    }
    inventoryId = 'database created successfully';
    setState(() {});
    _customer();
  }

  _customer() async {
    for (int i = 0; i < 500; i++) {
      await _dbHelperCustomer.insertCustomer(Customer(
          name: '${i}',
          phone: '${9000000000 + 1}',
          points: '4',
          address: 'address'));
    }
    _sales();
  }

  String orderidSales1 = '';

  _sales() async {
    List<Customer> supplier = await _dbHelperCustomer.fetchCustomer();
    int orderidSales = 0;

    for (var s in supplier) {
      for (int i = 0; i < 100; i++) {
        orderidSales = orderidSales + 1;
        await _dbHelperSales.insertSales(Sales(
          date: i < 2
              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'
              : i < 3
                  ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))} 00:00:00.000000'
                  : i < 6
                      ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                      : i < 20
                          ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                          : i < 50
                              ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 180)))} 00:00:00.000000'
                              : '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)))} 00:00:00.000000',
          customerName: supplier.indexOf(s).toString(),
          customerNumber: supplier.indexOf(s).toString(),
          productName:
              '{"1":{"productName":"${1000000000000 + supplier.indexOf(s)}","price":"99.0","mrp":"99.0","buy":"90","barcode":"${1000000000000 + supplier.indexOf(s)}","qty":"1","disc":"0.0"},"2":{"productName":"${2000000000000 + supplier.indexOf(s)}","price":"349.0","mrp":"349.0","buy":"330","barcode":"${2000000000000 + supplier.indexOf(s)}","qty":"1","disc":"0.0"},"3":{"productName":"${3000000000000 + supplier.indexOf(s)}","price":"349.0","mrp":"349.0","buy":"330","barcode":"${3000000000000 + supplier.indexOf(s)}","qty":"1","disc":"0.0"},"4":{"productName":"${4000000000000 + supplier.indexOf(s)}","price":"349.0","mrp":"349.0","buy":"330","barcode":"${4000000000000 + supplier.indexOf(s)}","qty":"1","disc":"0.0"},"5":{"productName":"${5000000000000 + supplier.indexOf(s)}","price":"349.0","mrp":"349.0","buy":"330","barcode":"${5000000000000 + supplier.indexOf(s)}","qty":"1","disc":"0.0"}}',
          orderId: orderidSales.toString(),
          deliveryStatus: 'delivered',
          deliveryMode: 'store',
          deliveryDate: DateTime.now().toString(),
          paidStatus: 'full',
          paidAmount: '4710',
          paymentMode: 'cash',
        ));

        await _dbHelperSalesTransaction.insertSalesTransaction(SalesTransaction(
            supplierId: s.id.toString(),
            date: i < 2
                ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 0)))} 00:00:00.000000'
                : i < 3
                    ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)))} 00:00:00.000000'
                    : i < 6
                        ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)))} 00:00:00.000000'
                        : i < 20
                            ? '${DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 30)))} 00:00:00.000000'
                            : i < 50
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
  }
*/
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
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

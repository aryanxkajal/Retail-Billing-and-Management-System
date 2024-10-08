import 'dart:io';

import 'package:barcode1/account_inventory/model/inventory_model.dart';
import 'package:barcode1/account_sales/model/model_sales.dart';
import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/database_helper/loose_database/loose_model.dart';
import 'package:barcode1/product_database/model/product_database_model.dart';


import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../account_customer/model/model_customer.dart';
import '../account_sales/model/model_sales_order.dart';
import '../account_sales/model/model_sales_transaction.dart';
import '../account_supplies/model/model_order.dart';
import '../account_supplies/model/model_transaction.dart';
import '../billing/quick_add/quick_add_model.dart';
import '../marketing/model/marketing_model.dart';
import '../shop/model/model_store.dart';


class DatabaseHelper {
  static const _databaseName = 'ContactDatabase87.db';
  static const _databaseVersion = 1;

  //singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    if (kDebugMode) {
      print(dbPath);
    }
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    //create tables
    await db.execute('''
      CREATE TABLE ${Supplier.tbl}(
        ${Supplier.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Supplier.colName} TEXT NOT NULL,
        ${Supplier.colPhone} TEXT,
         ${Supplier.colContactId} TEXT,

        ${Supplier.colAddress} TEXT
      )
      ''');
    await db.execute('''
      CREATE TABLE ${Supply.tbl}(
        ${Supply.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Supply.colDate} TEXT NOT NULL,
        ${Supply.colSupplierId} TEXT NOT NULL,
        ${Supply.colPacking} TEXT NOT NULL,
       
        ${Supply.colProductList} TEXT NOT NULL,
        
        ${Supply.colOrderId} TEXT,


       
        ${Supply.colDeliveryStatus} TEXT,
        ${Supply.colDeliveryDate} TEXT,

        ${Supply.colPaidStatus} TEXT,
        ${Supply.colPaymentMode} TEXT,
        ${Supply.colPaidAmt} TEXT,
        ${Supply.colRemarks} TEXT

      )
      ''');

    await db.execute('''
      CREATE TABLE ${Inventory.tbl}(
         ${Inventory.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Inventory.colDate} TEXT NOT NULL,
        ${Inventory.colSupplierId} TEXT NOT NULL,
        ${Inventory.colPacking} TEXT NOT NULL,
        ${Inventory.colBarcode} TEXT NOT NULL,
        ${Inventory.colProductName} TEXT NOT NULL,
        ${Inventory.colQty} TEXT,
        ${Inventory.colWeight} TEXT,
        ${Inventory.colDOE} TEXT,
        ${Inventory.colBuy} TEXT,
        ${Inventory.colSell} TEXT,

        ${Inventory.colMrp} TEXT,

        ${Inventory.colWeightLoose} TEXT

        
       
      )
      ''');
    await db.execute('''
      CREATE TABLE ${Sales.tbl}(
        ${Sales.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Sales.colCustomerNumber} TEXT DEFAULT '1',
        ${Sales.colCustomerName} TEXT,
        ${Sales.colDate} TEXT,
        ${Sales.colProductName} TEXT,
        
        ${Sales.colPaidStatus} TEXT,

        ${Sales.colPaymentMode} TEXT,
        ${Sales.colDeliveryMode} TEXT,
        ${Sales.colDeliveryStatus} TEXT,
        ${Sales.colDeliveryDate} TEXT,
        ${Sales.colPaidAmount} TEXT,
        ${Sales.colOrderId} TEXT
        
      )
      ''');

    await db.execute('''
      CREATE TABLE ${Loose.tbl}(
        ${Loose.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Loose.colName} TEXT NOT NULL,
        ${Loose.colBarcode} TEXT NOT NULL

        
        
      )
      ''');

    await db.execute('''
      CREATE TABLE ${Customer.tbl}(
        ${Customer.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Customer.colName} TEXT NOT NULL,
        ${Customer.colPhone} TEXT NOT NULL,
        ${Customer.colAddress} TEXT NOT NULL,
        ${Customer.colPoints} TEXT NOT NULL

      )
      ''');

      await db.execute('''
      CREATE TABLE ${Store.tbl}(
        ${Store.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Store.colName} TEXT,
        ${Store.colPhone} TEXT,
        ${Store.colAddress} TEXT,
        ${Store.colCodeVerified} TEXT,
        ${Store.colCode} TEXT,
        ${Store.colRegisteredPhone} TEXT,
        ${Store.colDate} TEXT,
        ${Store.colValidity} TEXT,
        ${Store.colWebsite} TEXT

      )
      ''');

    await db.execute('''
      CREATE TABLE ${Transaction1.tbl}(
        ${Transaction1.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Transaction1.colSupplierId} TEXT,
        ${Transaction1.colDate} TEXT,
        ${Transaction1.colOrderCustom} TEXT,
        ${Transaction1.colPaidReceived} TEXT,
        ${Transaction1.colAmount} TEXT,
        ${Transaction1.colDescription} TEXT,
        ${Transaction1.colOrderId} TEXT,
        ${Transaction1.colPaymentMode} TEXT

      )
      ''');
    await db.execute('''
      CREATE TABLE ${OrderId.tbl}(
        ${OrderId.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${OrderId.colX} TEXT
        

      )
      ''');

    await db.execute('''
      CREATE TABLE ${SalesTransaction.tbl}(
        ${SalesTransaction.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${SalesTransaction.colSupplierId} TEXT,
        ${SalesTransaction.colDate} TEXT,
        ${SalesTransaction.colOrderCustom} TEXT,
        ${SalesTransaction.colPaidReceived} TEXT,
        ${SalesTransaction.colAmount} TEXT,
        ${SalesTransaction.colDescription} TEXT,
        ${SalesTransaction.colOrderId} TEXT,
        ${SalesTransaction.colPaymentMode} TEXT

      )
      ''');
    await db.execute('''
      CREATE TABLE ${SalesOrderId.tbl}(
        ${SalesOrderId.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${SalesOrderId.colX} TEXT
        

      )
      ''');

       await db.execute('''
      CREATE TABLE ${QuickAdd.tbl}(
        ${QuickAdd.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${QuickAdd.colBarcode} TEXT,
        ${QuickAdd.colProductName} TEXT
        

      )
      ''');

       await db.execute('''
      CREATE TABLE ${MarketingModel.tbl}(
         ${MarketingModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${MarketingModel.colDate} TEXT NOT NULL,
       
        ${MarketingModel.colPacking} TEXT NOT NULL,
        ${MarketingModel.colBarcode} TEXT NOT NULL,
        ${MarketingModel.colProductName} TEXT NOT NULL,
        
        ${MarketingModel.colSellAfter} TEXT,
        ${MarketingModel.colBuy} TEXT,
        ${MarketingModel.colSell} TEXT,

        ${MarketingModel.colMrp} TEXT

        

        
       
      )
      ''');

      await db.execute('''
      CREATE TABLE ${Product.tbl}(
         ${Product.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Product.colName} TEXT,
        ${Product.colBarcode} TEXT,
       
        ${Product.colPrice} REAL,
        ${Product.colMeasurementUnit} TEXT
        

        

        
       
      )
      ''');
  }
}

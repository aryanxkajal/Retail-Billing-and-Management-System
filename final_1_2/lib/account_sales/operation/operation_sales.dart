import 'package:barcode1/account_sales/model/model_sales.dart';

import 'package:barcode1/database_helper/database_helper.dart';

import 'package:sqflite/sqflite.dart';

class SalesOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertSales(Sales contact) async {
    Database? db = await database;
    return await db!.insert(Sales.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateSales(Sales contact) async {
    Database? db = await database;
    return await db!.update(Sales.tbl, contact.toMap(),
        where: '${Sales.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteSales(int id) async {
    Database? db = await database;
    return await db!
        .delete(Sales.tbl, where: '${Sales.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Sales>> fetchSales() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Sales.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Sales.fromMap(x)).toList();
  }

  Future<List<Sales>> fetchSales1(String d) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(Sales.tbl,
    where: 'date = ? ', whereArgs: [d]);

  List<Sales> blogs = [];
  results.forEach((result) {
    Sales blog = Sales.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}

Future<List<Sales>> fetchSalesId(int id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(Sales.tbl,
    where: 'id = ? ', whereArgs: [id]);

  List<Sales> blogs = [];
  results.forEach((result) {
    Sales blog = Sales.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}

Future<List<Sales>> fetchSalesCustomer(String supplier) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(Sales.tbl, where: 'customerName = ? ', whereArgs: [supplier]);

    List<Sales> blogs = [];
    results.forEach((result) {
      Sales blog = Sales.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }

// fetch suppy with date and supplier
Future<List<Sales>> fetchSales2(String productName ) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(Sales.tbl,
    where: 'productName = ? ', whereArgs: [productName]);

  List<Sales> blogs = [];
  results.forEach((result) {
    Sales blog = Sales.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}
 Future<List<Sales>> fetchSalesSupplier(String supplier) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(Sales.tbl, where: 'customerNumber = ? ', whereArgs: [supplier]);

    List<Sales> blogs = [];
    results.forEach((result) {
      Sales blog = Sales.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }
}
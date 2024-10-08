
import 'package:barcode1/database_helper/database_helper.dart';

import 'package:sqflite/sqflite.dart';

import '../model/model_sales_transaction.dart';



class SalesTransactionOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertSalesTransaction(SalesTransaction contact) async {
    Database? db = await database;
    return await db!.insert(SalesTransaction.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateSalesTransaction(SalesTransaction contact) async {
    Database? db = await database;
    return await db!.update(SalesTransaction.tbl, contact.toMap(),
        where: '${SalesTransaction.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteSalesTransaction(int id) async {
    Database? db = await database;
    return await db!
        .delete(SalesTransaction.tbl, where: '${SalesTransaction.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<SalesTransaction>> fetchSalesTransaction() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(SalesTransaction.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => SalesTransaction.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<SalesTransaction>> fetchSalesTransactionDate(List<int> d) async {
    List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      SalesTransaction.tbl,
      where: 'id IN (${List.filled(x.length, '?').join(',')})',
      whereArgs: x,
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => SalesTransaction.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<SalesTransaction>> fetchSalesTransactionDate1(String d) async {
   // List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      SalesTransaction.tbl,
      where: 'id IN (?)',
      whereArgs: [d],
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => SalesTransaction.fromMap(x)).toList();
  }

  Future<List<SalesTransaction>> fetchSalesTransactionSupplierId(String id) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(SalesTransaction.tbl, where: 'supplierId = ? ', whereArgs: [id]);

    List<SalesTransaction> blogs = [];
    results.forEach((result) {
      SalesTransaction blog = SalesTransaction.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }
}



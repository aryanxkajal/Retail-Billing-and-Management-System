
import 'package:barcode1/database_helper/database_helper.dart';

import 'package:sqflite/sqflite.dart';

import '../model/model_transaction.dart';

class TransactionOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertTransaction(Transaction1 contact) async {
    Database? db = await database;
    return await db!.insert(Transaction1.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateTransaction(Transaction1 contact) async {
    Database? db = await database;
    return await db!.update(Transaction1.tbl, contact.toMap(),
        where: '${Transaction1.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteTransaction(int id) async {
    Database? db = await database;
    return await db!
        .delete(Transaction1.tbl, where: '${Transaction1.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Transaction1>> fetchTransaction() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Transaction1.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Transaction1.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Transaction1>> fetchTransactionDate(List<int> d) async {
    List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Transaction1.tbl,
      where: 'id IN (${List.filled(x.length, '?').join(',')})',
      whereArgs: x,
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Transaction1.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Transaction1>> fetchTransactionDate1(String d) async {
   // List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Transaction1.tbl,
      where: 'id IN (?)',
      whereArgs: [d],
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Transaction1.fromMap(x)).toList();
  }

  Future<List<Transaction1>> fetchTransactionSupplierId(String id) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(Transaction1.tbl, where: 'supplierId = ? ', whereArgs: [id]);

    List<Transaction1> blogs = [];
    results.forEach((result) {
      Transaction1 blog = Transaction1.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }
}



import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/account_supplies/model/model_supply.dart';
import 'package:barcode1/database_helper/database_helper.dart';
import 'package:barcode1/database_helper/existing_database.dart';
import 'package:sqflite/sqflite.dart';

import '../model/model_test.dart';

class SupplyOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertSupply(Supply contact) async {
    Database? db = await database;
    return await db!.insert(Supply.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateSupply(Supply contact) async {
    Database? db = await database;
    return await db!.update(Supply.tbl, contact.toMap(),
        where: '${Supply.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteSupply(int id) async {
    Database? db = await database;
    return await db!
        .delete(Supply.tbl, where: '${Supply.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Supply>> fetchSupply() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Supply.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Supply.fromMap(x)).toList();
  }

  // only date

  Future<List<Supply>> fetchSupplyDate(String d) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(Supply.tbl, where: 'date = ? ', whereArgs: [d]);

    List<Supply> blogs = [];
    results.forEach((result) {
      Supply blog = Supply.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }


// only supplier
  Future<List<Supply>> fetchSupplySupplier(int supplier) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(Supply.tbl, where: 'supplierId = ? ', whereArgs: [supplier]);

    List<Supply> blogs = [];
    results.forEach((result) {
      Supply blog = Supply.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }



  // fetch - date and supplier
  Future<List<Supply>> fetchSupply3(String date, int d) async {
    //List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Supply.tbl,
        where:
            'supplierId IN (?) AND date IN (?)',
        whereArgs: [d, date]);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Supply.fromMap(x)).toList();
  }
}

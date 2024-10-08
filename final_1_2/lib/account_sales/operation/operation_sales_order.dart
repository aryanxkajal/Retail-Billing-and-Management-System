
import 'package:barcode1/database_helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../model/model_sales_order.dart';

class SalesOrderOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertSalesOrderId(SalesOrderId contact) async {
    Database? db = await database;
    return await db!.insert(SalesOrderId.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateSalesOrderId(SalesOrderId contact) async {
    Database? db = await database;
    return await db!.update(SalesOrderId.tbl, contact.toMap(),
        where: '${SalesOrderId.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteSalesOrderId(int id) async {
    Database? db = await database;
    return await db!
        .delete(SalesOrderId.tbl, where: '${SalesOrderId.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<SalesOrderId>> fetchO() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(SalesOrderId.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => SalesOrderId.fromMap(x)).toList();
  }

  // only date

  Future<List<SalesOrderId>> fetchSupply1(String d) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(SalesOrderId.tbl, where: 'id = ? ', whereArgs: [d]);

    List<SalesOrderId> blogs = [];
    results.forEach((result) {
      SalesOrderId blog = SalesOrderId.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }


// only supplier
  Future<List<SalesOrderId>> fetchSupplySupplier(int supplier) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(SalesOrderId.tbl, where: 'supplierId = ? ', whereArgs: [supplier]);

    List<SalesOrderId> blogs = [];
    results.forEach((result) {
     SalesOrderId blog = SalesOrderId.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }



  // fetch - date and supplier
  Future<List<SalesOrderId>> fetchSupply3(String date, int d) async {
    //List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(SalesOrderId.tbl,
        where:
            'supplierId IN (?) AND date IN (?)',
        whereArgs: [d, date]);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => SalesOrderId.fromMap(x)).toList();
  }
}

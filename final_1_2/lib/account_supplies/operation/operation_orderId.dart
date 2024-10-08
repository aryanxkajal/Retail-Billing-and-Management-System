import 'package:barcode1/account_supplies/model/model_order.dart';
import 'package:barcode1/database_helper/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class OrderOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertOrderId(OrderId contact) async {
    Database? db = await database;
    return await db!.insert(OrderId.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateSupply(OrderId contact) async {
    Database? db = await database;
    return await db!.update(OrderId.tbl, contact.toMap(),
        where: '${OrderId.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteSupply(int id) async {
    Database? db = await database;
    return await db!
        .delete(OrderId.tbl, where: '${OrderId.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<OrderId>> fetchO() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(OrderId.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => OrderId.fromMap(x)).toList();
  }

  // only date

  Future<List<OrderId>> fetchSupply1(String d) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(OrderId.tbl, where: 'id = ? ', whereArgs: [d]);

    List<OrderId> blogs = [];
    results.forEach((result) {
      OrderId blog = OrderId.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }


// only supplier
  Future<List<OrderId>> fetchSupplySupplier(int supplier) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(OrderId.tbl, where: 'supplierId = ? ', whereArgs: [supplier]);

    List<OrderId> blogs = [];
    results.forEach((result) {
      OrderId blog = OrderId.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }



  // fetch - date and supplier
  Future<List<OrderId>> fetchSupply3(String date, int d) async {
    //List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(OrderId.tbl,
        where:
            'supplierId IN (?) AND date IN (?)',
        whereArgs: [d, date]);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => OrderId.fromMap(x)).toList();
  }
}

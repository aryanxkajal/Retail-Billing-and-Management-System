import 'package:barcode1/account_inventory/model/inventory_model.dart';


import 'package:barcode1/database_helper/database_helper.dart';

import 'package:sqflite/sqflite.dart';

class InventoryOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertInventory(Inventory contact) async {
    Database? db = await database;
    return await db!.insert(Inventory.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateInventory(Inventory contact) async {
    Database? db = await database;
    return await db!.update(Inventory.tbl, contact.toMap(),
        where: '${Inventory.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteInventory(int id) async {
    Database? db = await database;
    return await db!
        .delete(Inventory.tbl, where: '${Inventory.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Inventory>> fetchInventory() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Inventory.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Inventory.fromMap(x)).toList();
  }

  // retrieve - p(Id)

  Future<List<Inventory>> fetchInventoryId(int id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(Inventory.tbl,
    where: 'id = ? ', whereArgs: [id]);

  List<Inventory> blogs = [];
  results.forEach((result) {
    Inventory blog = Inventory.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}

 Future<List<Inventory>> fetchInventoryBarcode(int id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(Inventory.tbl,
    where: 'id = ? ', whereArgs: [id]);

  List<Inventory> blogs = [];
  results.forEach((result) {
    Inventory blog = Inventory.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}
}

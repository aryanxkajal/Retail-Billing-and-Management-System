
import 'package:barcode1/database_helper/database_helper.dart';

import 'package:sqflite/sqflite.dart';

import '../model/model_store.dart';



class StoreOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertStore(Store contact) async {
    Database? db = await database;
    return await db!.insert(Store.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateStore(Store contact) async {
    Database? db = await database;
    return await db!.update(Store.tbl, contact.toMap(),
        where: '${Store.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteStore(int id) async {
    Database? db = await database;
    return await db!
        .delete(Store.tbl, where: '${Store.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Store>> fetchStore() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Store.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Store.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Store>> fetchStoreDate(List<int> d) async {
    List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Store.tbl,
      where: 'id IN (${List.filled(x.length, '?').join(',')})',
      whereArgs: x,
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Store.fromMap(x)).toList();
  }

  }



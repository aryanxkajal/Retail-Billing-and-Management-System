


import 'package:barcode1/billing/quick_add/quick_add_model.dart';
import 'package:barcode1/database_helper/database_helper.dart';

import 'package:sqflite/sqflite.dart';

class QuickAddOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertQuickAdd(QuickAdd contact) async {
    Database? db = await database;
    return await db!.insert(QuickAdd.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateQuickAdd(QuickAdd contact) async {
    Database? db = await database;
    return await db!.update(QuickAdd.tbl, contact.toMap(),
        where: '${QuickAdd.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteQuickAdd(int id) async {
    Database? db = await database;
    return await db!
        .delete(QuickAdd.tbl, where: '${QuickAdd.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<QuickAdd>> fetchQuickAdd() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(QuickAdd.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => QuickAdd.fromMap(x)).toList();
  }

  // retrieve - p(Id)

  Future<List<QuickAdd>> fetchQuickAddId(int id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(QuickAdd.tbl,
    where: 'id = ? ', whereArgs: [id]);

  List<QuickAdd> blogs = [];
  results.forEach((result) {
    QuickAdd blog = QuickAdd.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}

 Future<List<QuickAdd>> fetchQuickAddBarcode(int id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(QuickAdd.tbl,
    where: 'id = ? ', whereArgs: [id]);

  List<QuickAdd> blogs = [];
  results.forEach((result) {
    QuickAdd blog = QuickAdd.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}
}

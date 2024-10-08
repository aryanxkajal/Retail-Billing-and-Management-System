


import 'package:barcode1/database_helper/database_helper.dart';

import 'package:sqflite/sqflite.dart';

import '../model/marketing_model.dart';

class MarketingOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertMarketing(MarketingModel contact) async {
    Database? db = await database;
    return await db!.insert(MarketingModel.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateMarketing(MarketingModel contact) async {
    Database? db = await database;
    return await db!.update(MarketingModel.tbl, contact.toMap(),
        where: '${MarketingModel.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteMarketing(int id) async {
    Database? db = await database;
    return await db!
        .delete(MarketingModel.tbl, where: '${MarketingModel.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<MarketingModel>> fetchMarketing() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(MarketingModel.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => MarketingModel.fromMap(x)).toList();
  }

  // retrieve - p(Id)

  Future<List<MarketingModel>> fetchMarketingId(int id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(MarketingModel.tbl,
    where: 'id = ? ', whereArgs: [id]);

  List<MarketingModel> blogs = [];
  results.forEach((result) {
    MarketingModel blog = MarketingModel.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}

 Future<List<MarketingModel>> fetchMarketingBarcode(int id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(MarketingModel.tbl,
    where: 'id = ? ', whereArgs: [id]);

  List<MarketingModel> blogs = [];
  results.forEach((result) {
    MarketingModel blog = MarketingModel.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}
}

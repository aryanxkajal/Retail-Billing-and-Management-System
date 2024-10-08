import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/database_helper/barcode/barcode_model.dart';
import 'package:barcode1/database_helper/database_helper.dart';
import 'package:barcode1/database_helper/existing_database.dart';
import 'package:sqflite/sqflite.dart';

class BarcodeOperation {
  final database = ExistingDatabase.instance.database;

  Future<int> insertBarcode(Barcode contact) async {
    Database? db = await database;
    return await db!.insert(Barcode.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateBarcode(Barcode contact) async {
    Database? db = await database;
    return await db!.update(Barcode.tbl, contact.toMap(),
        where: '${Barcode.colId}=?', whereArgs: [contact.Id]);
  }

//contact - delete
  Future<int> deleteBarcode(int id) async {
    Database? db = await database;
    return await db!
        .delete(Barcode.tbl, where: '${Barcode.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Barcode>> fetchBarcode() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Barcode.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Barcode.fromMap(x)).toList();
  }
  // fetch blogs of a particular user
Future<List<Barcode>> fetchUserBlogs(String Value) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(Barcode.tbl,
    where: "Value = ?", whereArgs: [Value]);

  List<Barcode> blogs = [];
  results.forEach((result) {
    Barcode blog = Barcode.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}
}

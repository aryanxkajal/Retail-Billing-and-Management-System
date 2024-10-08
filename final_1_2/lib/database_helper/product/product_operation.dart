
import 'package:barcode1/database_helper/existing_database.dart';
import 'package:barcode1/database_helper/product/product_model.dart';
import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';

class ProductOperation {
  //final database = ExistingDatabase.instance.database;
  final database = DatabaseHelper.instance.database;

  Future<int> insertProduct(Product contact) async {
    Database? db = await database;
    return await db!.insert(Product.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateProduct(Product contact) async {
    Database? db = await database;
    return await db!.update(Product.tbl, contact.toMap(),
        where: '${Product.colId}=?', whereArgs: [contact.Id]);
  }

//contact - delete
  Future<int> deleteProduct(int id) async {
    Database? db = await database;
    return await db!
        .delete(Product.tbl, where: '${Product.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Product>> fetchProduct() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Product.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Product.fromMap(x)).toList();
  }
   // fetch blogs of a particular user
Future<List<Product>> fetchProduct1(int Id) async {
  Database? db = await database;
  List<Map<String, dynamic>> results = await db!.query(Product.tbl,
    where: "Id = ?", whereArgs: [Id]);

  List<Product> blogs = [];
  results.forEach((result) {
    Product blog = Product.fromMap(result);
    blogs.add(blog);
  });
  return blogs;
}
}

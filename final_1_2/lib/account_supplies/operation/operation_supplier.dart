import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/database_helper/database_helper.dart';
import 'package:barcode1/database_helper/existing_database.dart';
import 'package:sqflite/sqflite.dart';

class SupplierOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertSupplier(Supplier contact) async {
    Database? db = await database;
    return await db!.insert(Supplier.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateSupplier(Supplier contact) async {
    Database? db = await database;
    return await db!.update(Supplier.tbl, contact.toMap(),
        where: '${Supplier.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteSupplier(int id) async {
    Database? db = await database;
    return await db!
        .delete(Supplier.tbl, where: '${Supplier.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Supplier>> fetchSupplier() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Supplier.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Supplier.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Supplier>> fetchSupplierDate(List<int> d) async {
    List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Supplier.tbl,
      where: 'id IN (${List.filled(x.length, '?').join(',')})',
      whereArgs: x,
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Supplier.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Supplier>> fetchSupplierDate1(String d) async {
   // List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Supplier.tbl,
      where: 'id IN (?)',
      whereArgs: [d],
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Supplier.fromMap(x)).toList();
  }

  Future<List<Supplier>> fetchSupplierId(int id) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(Supplier.tbl, where: 'id = ? ', whereArgs: [id]);

    List<Supplier> blogs = [];
    results.forEach((result) {
      Supplier blog = Supplier.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }
}



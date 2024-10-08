import 'package:barcode1/account_supplies/model/model_supplier.dart';
import 'package:barcode1/database_helper/database_helper.dart';
import 'package:barcode1/database_helper/existing_database.dart';
import 'package:sqflite/sqflite.dart';

import '../model/model_customer.dart';

class CustomerOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertCustomer(Customer contact) async {
    Database? db = await database;
    return await db!.insert(Customer.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateCustomer(Customer contact) async {
    Database? db = await database;
    return await db!.update(Customer.tbl, contact.toMap(),
        where: '${Customer.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteCustomer(int id) async {
    Database? db = await database;
    return await db!
        .delete(Customer.tbl, where: '${Customer.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Customer>> fetchCustomer() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Customer.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Customer.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Customer>> fetchCustomerDate(List<int> d) async {
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
        : contacts.map((x) => Customer.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Customer>> fetchCustomerDate1(String d) async {
   // List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Customer.tbl,
      where: 'id IN (?)',
      whereArgs: [d],
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Customer.fromMap(x)).toList();
  }

  Future<List<Customer>> fetchCustomerId(String id) async {
    Database? db = await database;
    List<Map<String, dynamic>> results =
        await db!.query(Customer.tbl, where: 'name = ? ', whereArgs: [id]);

    List<Customer> blogs = [];
    results.forEach((result) {
      Customer blog = Customer.fromMap(result);
      blogs.add(blog);
    });
    return blogs;
  }
}



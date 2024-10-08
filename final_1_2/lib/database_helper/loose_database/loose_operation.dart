import 'package:barcode1/database_helper/database_helper.dart';
import 'package:barcode1/database_helper/loose_database/loose_model.dart';
import 'package:sqflite/sqflite.dart';

class LooseOperation {
  final database = DatabaseHelper.instance.database;

  Future<int> insertLoose(Loose contact) async {
    Database? db = await database;
    return await db!.insert(Loose.tbl, contact.toMap());
  }

//contact - update
  Future<int> updateLoose(Loose contact) async {
    Database? db = await database;
    return await db!.update(Loose.tbl, contact.toMap(),
        where: '${Loose.colId}=?', whereArgs: [contact.id]);
  }

//contact - delete
  Future<int> deleteLoose(int id) async {
    Database? db = await database;
    return await db!
        .delete(Loose.tbl, where: '${Loose.colId}=?', whereArgs: [id]);
  }

//contact - retrieve all
  Future<List<Loose>> fetchLoose() async {
    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(Loose.tbl);
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Loose.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Loose>> fetchLooseDate(List<int> d) async {
    List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Loose.tbl,
      where: 'id IN (${List.filled(x.length, '?').join(',')})',
      whereArgs: x,
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Loose.fromMap(x)).toList();
  }

  // fetch - p(colId)
  Future<List<Loose>> fetchLooseDate1(String d) async {
    // List x = d;

    Database? db = await database;
    List<Map<String, dynamic>> contacts = await db!.query(
      Loose.tbl,
      where: 'id IN (?)',
      whereArgs: [d],
    );
    // ignore: prefer_is_empty
    return contacts.length == 0
        ? []
        : contacts.map((x) => Loose.fromMap(x)).toList();
  }
}

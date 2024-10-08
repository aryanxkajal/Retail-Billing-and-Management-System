import 'dart:io';



import 'package:flutter/services.dart';

import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';


class ExistingDatabase {

  

  //singleton class
  ExistingDatabase._();
  static final ExistingDatabase instance = ExistingDatabase._();

  Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'final11.db');

    // Copy the database file from the assets directory to the device's file system
  ByteData data = await rootBundle.load(join('assets', 'final11.db'));
  List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(path).writeAsBytes(bytes);
    
    return await openDatabase(path);
  }
  
  }

  

  

  

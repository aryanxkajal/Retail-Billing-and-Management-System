// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class Product {
  static const tbl = 'Product';
  static const colId = 'Id';
  static const colName = 'Name';
  static const colPrice = 'Price';
  static const colMeasurementUnit = 'MeasurementUnit';
  

  Product(
      {this.Id,
      this.Name,
      this.Price,
      this.MeasurementUnit
      });

  int? Id;
  String? Name;
  String? MeasurementUnit;
  double? Price;
  

  Product.fromMap(Map<String, dynamic> map) {
    Id = map[colId];
    Name = map[colName];
    Price = map[colPrice];
    MeasurementUnit = map[colMeasurementUnit];
    
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: Name,
      colPrice: Price,
      colMeasurementUnit: MeasurementUnit
      
    };
    if (Id != null) {
      map[colId] = Id;
    }
    return map;
  }
}

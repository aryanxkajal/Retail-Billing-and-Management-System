// ignore_for_file: non_constant_identifier_names



class Product {
  static const tbl = 'productDatabase';
  static const colBarcode = 'Value';
  static const colId = 'Id';
  static const colName = 'Name';
  static const colPrice = 'Price';
  static const colMeasurementUnit = 'MeasurementUnit';


  

  Product(
      {this.Id,
      this.Barcode,
      this.Name,
      this.Price,
      this.MeasurementUnit
      });

  int? Id;
  String? Barcode;
  String? Name;
  String? MeasurementUnit;
  double? Price;
  

  Product.fromMap(Map<String, dynamic> map) {
    Id = map[colId];
    Barcode = map[colBarcode];
    Name = map[colName];
    Price = map[colPrice];
    MeasurementUnit = map[colMeasurementUnit];
    
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colBarcode: Barcode,
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

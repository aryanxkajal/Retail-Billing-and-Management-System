// ignore_for_file: non_constant_identifier_names

class Barcode {
  static const tbl = 'Barcode';
  static const colId = 'Id';
  static const colProductId = 'ProductId';
  static const colValue = 'Value';
  

  Barcode(
      {this.Id,
      this.ProductId,
      this.Value,
      });

  int? Id;
  int? ProductId;
  String? Value;
  

  Barcode.fromMap(Map<String, dynamic> map) {
    Id = map[colId];
    ProductId = map[colProductId];
    Value = map[colValue];
    
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colProductId: ProductId,
      colValue: Value,
      
    };
    if (Id != null) {
      map[colId] = Id;
    }
    return map;
  }
}

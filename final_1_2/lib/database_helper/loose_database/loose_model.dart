class Loose {
  static const tbl = 'loose';
  static const colId = 'id';
  static const colName = 'name';
  static const colBarcode = 'barcode';

  Loose({
    this.id,
    this.name,
    this.barcode,
  });

  int? id;
  String? name;
  String? barcode;

  Loose.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    barcode = map[colBarcode];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colBarcode: barcode,
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}

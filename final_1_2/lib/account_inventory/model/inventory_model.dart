class Inventory {
  static const tbl = 'inventory';
  static const colId = 'id';
  static const colDate = 'date';
  static const colSupplierId = 'supplierId';
  static const colPacking = 'packing';
  static const colBarcode = 'barcode';
  static const colProductName = 'productName';
  static const colQty = 'qty';
  static const colWeight = 'weight';
  static const colDOE = 'DOE';

  static const colBuy = 'buy';
  static const colSell = 'sell';

  static const colWeightLoose = 'weightLoose';

  static const colMrp = 'mrp';

  

  Inventory({
    this.id,
    this.date,
    this.supplierId,
    this.barcode,
    this.productName,
    this.qty,
    this.buy,
    this.sell,
    this.packing,
    this.weight,
    this.DOE,
    this.weightLoose,

    this.mrp,
   
  });

  int? id;
  String? date;
  String? supplierId;
  String? packing;
  String? barcode;
  String? productName;
  String? qty;
  String? weight;
  String? DOE;
  String? buy;
  String? sell;

  String? weightLoose;

  String? mrp;

  

  Inventory.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    date = map[colDate];
    supplierId = map[colSupplierId];
    packing = map[colPacking];
    barcode = map[colBarcode];
    productName = map[colProductName];
    qty = map[colQty];
    weight = map[colWeight];
    DOE = map[colDOE];
    buy = map[colBuy];
    sell = map[colSell];

    weightLoose = map[colWeightLoose];

    mrp = map[colMrp];

   
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colDate: date,
      colSupplierId: supplierId,
      colPacking: packing,
      colBarcode: barcode,
      colProductName: productName,
      colQty: qty,
      colWeight: weight,
      colDOE: DOE,
      colBuy: buy,
      colSell: sell,
      colWeightLoose: weightLoose,

      colMrp: mrp,
      
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}

class QuickAdd {
  static const tbl = 'quickAdd';
  static const colId = 'id';
  
  static const colBarcode = 'barcode';
  static const colProductName = 'productName';
  

  

  QuickAdd({
    this.id,
    
    this.barcode,
    this.productName,
    
   
  });

  int? id;
 
  String? barcode;
  String? productName;
 

  

  QuickAdd.fromMap(Map<String, dynamic> map) {
    id = map[colId];
   
    barcode = map[colBarcode];
    productName = map[colProductName];
  

   
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
    
      colBarcode: barcode,
      colProductName: productName,
      
      
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
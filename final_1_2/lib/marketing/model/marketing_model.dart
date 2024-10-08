class MarketingModel {
  static const tbl = 'marketing';
  static const colId = 'id';
  static const colDate = 'date';
  
  static const colPacking = 'packing';
  static const colBarcode = 'barcode';
  static const colProductName = 'productName';
 
  
  static const colSellAfter = 'sellAfter';

  static const colBuy = 'buy';
  static const colSell = 'sell';



  static const colMrp = 'mrp';

  

  MarketingModel({
    this.id,
    this.date,
    
    this.barcode,
    this.productName,
   
    this.buy,
    this.sell,
    this.packing,
   
    this.sellAfter,
   

    this.mrp,
   
  });

  int? id;
  String? date;
  
  String? packing;
  String? barcode;
  String? productName;
 
 
  String? sellAfter;
  String? buy;
  String? sell;

 

  String? mrp;

  

  MarketingModel.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    date = map[colDate];
    
    packing = map[colPacking];
    barcode = map[colBarcode];
    productName = map[colProductName];
    
    sellAfter = map[colSellAfter];
    buy = map[colBuy];
    sell = map[colSell];

   

    mrp = map[colMrp];

   
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colDate: date,
      
      colPacking: packing,
      colBarcode: barcode,
      colProductName: productName,
      
      colSellAfter: sellAfter,
      colBuy: buy,
      colSell: sell,
      

      colMrp: mrp,
      
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}

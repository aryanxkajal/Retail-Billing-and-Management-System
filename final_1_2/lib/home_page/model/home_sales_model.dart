class HomeSalesModel {
  
  
  
  static const colBarcode = 'barcode';
  static const colProductName = 'productName';
  static const colQty = 'qty';
 
 

  static const colPrice = 'price';
  static const colMrp = 'mrp';

  static const colDisc = 'disc';
  static const colDate = 'date';





  

  HomeSalesModel({
    
    this.barcode,
    this.productName,
    this.qty,
    this.price,
    
    this.disc,
    

    this.mrp,

    this.date,
   
  });

  
  String? barcode;
  String? productName;
  String? qty;
  String? price;
  String? disc;
 

  String? mrp;
  String? date;

  

  HomeSalesModel.fromMap(Map<String, dynamic> map) {
   
    barcode = map[colBarcode];
    productName = map[colProductName];
    qty = map[colQty];
    price = map[colPrice];
    disc = map[colDisc];

    mrp = map[colMrp];
    date = map[colDate];

   
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
     
      colBarcode: barcode,
      colProductName: productName,
      colQty: qty,
      colPrice: price,
      colDisc: disc,


      colMrp: mrp,
      colDate: date,
      
    };
   
    return map;
  }
}

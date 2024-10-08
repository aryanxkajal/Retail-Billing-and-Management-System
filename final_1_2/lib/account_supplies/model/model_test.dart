class Supply1 {
  static const tbl = 'supply';
  static const colId = 'id';
  static const colDate = 'date';
  static const colSupplierId = 'supplierId';

  static const colPacking = 'packing';

 
  static const colProductName = 'productName';
  
 

  
  static const colDeliveryStatus = 'deliveryStatus';
  static const colDeliveryDate = 'deliveryDate';
  
  static const colPaidStatus = 'paidStatus';
  static const colPaymentMode = 'paymentMode';
  static const colPaidAmt = 'paidAmt';
  static const colRemarks = 'remarks';

   static const colOrderId = 'orderId';
  







  Supply1({
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

    this.MRP,
    this.deliveryStatus,
    this.deliveryDate,
    this.paidStatus,
    this.paymentMode,
    this.paidAmt,
    this.remarks,
    this.orderId,




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

  String? MRP;
  String? deliveryStatus;
  String? deliveryDate;
  
  String? paidStatus;
  String? paymentMode;
  String? paidAmt;
  String? remarks;
  String? orderId;

  Supply1.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    date = map[colDate];
    supplierId = map[colSupplierId];
    packing = map[colPacking];
    
    productName = map[colProductName];
    
    deliveryStatus = map[colDeliveryStatus];
    deliveryDate = map[colDeliveryDate];

    paidStatus = map[colPaidStatus];
    paymentMode = map[colPaymentMode];
    paidAmt = map[colPaidAmt];
    remarks = map[colRemarks];
    orderId = map[colOrderId];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colDate: date,
      colSupplierId: supplierId,
      colPacking: packing,
     
      colProductName: productName,
      
      colDeliveryStatus: deliveryStatus,
      colDeliveryDate: deliveryDate,

      colPaidStatus: paidStatus,
      colPaymentMode: paymentMode,
      colPaidAmt: paidAmt,
      colRemarks: remarks,
      colOrderId: orderId,
      

    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}

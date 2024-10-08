class Supply {
  static const tbl = 'supply';
  static const colId = 'id';
  static const colDate = 'date';
  static const colSupplierId = 'supplierId';

  static const colPacking = 'packing';

  
  static const colProductList = 'productList';
  




  
  static const colDeliveryStatus = 'deliveryStatus';
  static const colDeliveryDate = 'deliveryDate';
  
  static const colPaidStatus = 'paidStatus';
  static const colPaymentMode = 'paymentMode';
  static const colPaidAmt = 'paidAmt';
  static const colRemarks = 'remarks';

   static const colOrderId = 'orderId';
  







  Supply({
    this.id,
    this.date,
    this.supplierId,
    
    this.productList,
    
    this.packing,
    

    
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
 
  String? productList;
  

 
  String? deliveryStatus;
  String? deliveryDate;
  
  String? paidStatus;
  String? paymentMode;
  String? paidAmt;
  String? remarks;
  String? orderId;

  Supply.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    date = map[colDate];
    supplierId = map[colSupplierId];
    packing = map[colPacking];
   
    productList = map[colProductList];

   
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

      colProductList: productList,
     
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

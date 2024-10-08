class Sales {
  static const tbl = 'sales';
  static const colId = 'id';

  static const colCustomerNumber = 'customerNumber';
  static const colCustomerName = 'customerName';
  static const colDate = 'date';

  static const colProductName = 'productName';
  

  static const colPaymentMode = 'paymentMode';

  static const colDeliveryMode = 'deliveryMode';
  static const colDeliveryStatus = 'deliveryStatus';
  static const colDeliveryDate = 'deliveryDate';


  static const colPaidAmount = 'paidAmount';
  static const colPaidStatus = 'paidStatus';

  static const colOrderId = 'orderId';



  Sales({
    this.id,
    this.customerNumber,
    this.customerName,
    this.date,
    this.productName,
    

    this.paymentMode,
    this.deliveryMode,
    this.deliveryStatus,
    
    this.deliveryDate,
    this.paidAmount,
    this.paidStatus,

    this.orderId,
  });

  int? id;
  String? customerNumber;
  String? customerName;
  String? date;
  String? productName;
  
  
  String? paymentMode;
  String? deliveryMode;
  String? deliveryStatus;
  String? deliveryDate;
  String? paidAmount;
  String? paidStatus;

  String? orderId;

  Sales.fromMap(Map<String, dynamic> map) {
    id = map[colId];

    customerNumber = map[colCustomerNumber];
    customerName = map[colCustomerName];
    date = map[colDate];
    productName = map[colProductName];
   

    paymentMode = map[colPaymentMode];
    deliveryMode = map[colDeliveryMode];
    deliveryStatus = map[colDeliveryStatus];
    deliveryDate = map[colDeliveryDate];
    paidAmount = map[colPaidAmount];
    paidStatus = map[colPaidStatus];

    orderId = map[colOrderId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colCustomerNumber: customerNumber,
      colCustomerName: customerName,
      colDate: date,
      colProductName: productName,
      

      colPaymentMode: paymentMode,
      colDeliveryMode: deliveryMode,
      colDeliveryStatus: deliveryStatus,
      colDeliveryDate: deliveryDate,
      colPaidAmount: paidAmount,
      colPaidStatus: paidStatus,

      colOrderId: orderId,


    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}

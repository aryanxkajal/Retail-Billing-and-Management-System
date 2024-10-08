class SalesTransaction {
  static const tbl = 'salesTransaction';
  static const colId = 'id';
  static const colSupplierId = 'supplierId';
  static const colOrderCustom = 'orderCustom';
  static const colPaidReceived = 'paidReceived';

  static const colAmount = 'amount';
  static const colDescription = 'description';

  static const colPaymentMode = 'paymentMode';

  static const colDate = 'date';

  static const colOrderId = 'orderId';

  SalesTransaction(
      {this.id,
      this.supplierId,
      this.orderCustom,
      this.paidReceived,
      this.amount,
      this.description,
      this.paymentMode,
      this.date,
      this.orderId});

  int? id;
  String? supplierId;
  String? orderCustom;
  String? paidReceived;

  String? amount;
  String? description;

  String? paymentMode;

  String? date;

  String? orderId;

  SalesTransaction.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    supplierId = map[colSupplierId];
    orderCustom = map[colOrderCustom];
    paidReceived = map[colPaidReceived];

    amount = map[colAmount];
    description = map[colDescription];

    paymentMode = map[colPaymentMode];

    date = map[colDate];

    orderId = map[colOrderId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colSupplierId: supplierId,
      colOrderCustom: orderCustom,
      colPaidReceived: paidReceived,
      colAmount: amount,
      colDescription: description,
      colPaymentMode: paymentMode,
      colDate: date,
      colOrderId: orderId
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}

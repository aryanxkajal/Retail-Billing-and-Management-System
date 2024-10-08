class Customer {

  static const tbl = 'customer';
  static const colId = 'id';
  static const colName = 'name';
  static const colPhone = 'phone';

  static const colAddress = 'address';
  static const colPoints = 'points';

  

  Customer({this.id,this.name, this.phone, this.address, this.points});

  int? id;
  String? name;
  String? phone;

  String? address;

  String? points;
  

  Customer.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    phone = map[colPhone];

    address = map[colAddress];
    points = map[colPoints];
    
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colPhone: phone, colAddress: address, colPoints: points};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
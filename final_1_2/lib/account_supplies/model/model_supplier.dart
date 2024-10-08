class Supplier {

  static const tbl = 'supplier';
  static const colId = 'id';
  static const colName = 'name';
  static const colPhone = 'phone';
  static const colAddress = 'address';
  static const colContactId = 'contactId';
  

  Supplier({this.id,this.name, this.phone, this.address, this.contactId});

  int? id;
  String? name;
  String? phone;
  String? address;
  String? contactId;
  

  Supplier.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    phone = map[colPhone];
    address = map[colAddress];
    contactId = map[colContactId];
    
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colPhone: phone, colAddress: address, colContactId: contactId};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
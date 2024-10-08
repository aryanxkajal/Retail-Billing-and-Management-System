class Store {

  static const tbl = 'store';
  static const colId = 'id';
  static const colName = 'name';
  static const colPhone = 'phone';

  static const colAddress = 'address';
  static const colWebsite = 'website';

  static const colCodeVerified = 'codeVerified';
  static const colCode = 'code';

  static const colRegisteredPhone= 'registeredPhone';

  static const colDate= 'date';
  static const colValidity= 'validity';



  

  Store({this.id,this.name, this.phone, this.address, this.website, this.codeVerified, this.code, this.registeredPhone, this.date, this.validity});

  int? id;
  String? name;
  String? phone;

  String? address;

  String? website;

  String? codeVerified;
  String? code;

  String? registeredPhone;

  String? date;
  String? validity;
  

  Store.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    phone = map[colPhone];

    address = map[colAddress];
    website = map[colWebsite];

    codeVerified = map[colCodeVerified];
    code = map[colCode];

    registeredPhone = map[colRegisteredPhone];

    date = map[colDate];
    validity = map[colValidity];
    
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colPhone: phone, colAddress: address, colWebsite: website, colCodeVerified: codeVerified, colCode: code, colRegisteredPhone: registeredPhone, colDate: date, colValidity: validity};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
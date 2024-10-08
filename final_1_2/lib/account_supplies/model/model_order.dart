class OrderId {
  static const tbl = 'OrderId';
  static const colId = 'id';
  static const colX = 'x';
  
  

  OrderId(
      {this.id,
      this.x,
      
      });

  int? id;
  String? x;
  

  OrderId.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    x = map[colX];
    
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colX: x,
      
    };
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}
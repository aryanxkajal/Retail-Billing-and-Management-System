class SalesOrderId {
  static const tbl = 'salesOrderId';
  static const colId = 'id';
  static const colX = 'x';
  
  

  SalesOrderId(
      {this.id,
      this.x,
      
      });

  int? id;
  String? x;
  

  SalesOrderId.fromMap(Map<String, dynamic> map) {
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
class WareHouse {
  String? oid;
  String? wCode;
  String? wName;

  WareHouse({this.oid, this.wCode, this.wName});

  WareHouse.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    wCode = json['wCode'];
    wName = json['wName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['wCode'] = wCode;
    data['wName'] = wName;
    return data;
  }
}
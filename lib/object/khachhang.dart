class Customer {
  String? oid;
  String? shortName;
  String? customerName;

  Customer({this.oid, this.shortName, this.customerName});

  Customer.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    shortName = json['shortName'];
    customerName = json['customerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['shortName'] = shortName;
    data['customerName'] = customerName;
    return data;
  }
}

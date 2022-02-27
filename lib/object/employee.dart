class Employee {
  String? oid;
  String? empCode;
  String? employeeName;

  Employee({this.oid, this.empCode, this.employeeName});

  Employee.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    empCode = json['empCode'];
    employeeName = json['employeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['empCode'] = empCode;
    data['employeeName'] = employeeName;
    return data;
  }
}

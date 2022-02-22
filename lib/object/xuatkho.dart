class IN02M {
  String? oid;
  String? voucherNo;
  DateTime? voucherDate;
  String? remark;
  String? employeeID;
  String? employeeName;
  String? createDate;
  String? createBy;
  String? remark2;
  String? customerID;
  String? customerName;
  String? seris;

  IN02M(
      {this.oid,
      this.voucherNo,
      this.voucherDate,
      this.remark,
      this.employeeID,
      this.employeeName,
      this.createDate,
      this.createBy,
      this.remark2,
      this.customerID,
      this.customerName,
      this.seris});

  IN02M.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    voucherNo = json['voucherNo'];
    voucherDate = DateTime.parse( json['voucherDate']);
    remark = json['remark'];
    employeeID = json['employeeID'];
    employeeName = json['employeeName'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    remark2 = json['remark2'];
    customerID = json['customerID'];
    customerName = json['customerName'];
    seris = json['seris'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['voucherNo'] = voucherNo;
    data['voucherDate'] = voucherDate;
    data['remark'] = remark;
    data['employeeID'] = employeeID;
    data['employeeName'] = employeeName;
    data['createDate'] = createDate;
    data['createBy'] = createBy;
    data['remark2'] = remark2;
    data['customerID'] = customerID;
    data['customerName'] = customerName;
    data['seris'] = seris;
    return data;
  }
}

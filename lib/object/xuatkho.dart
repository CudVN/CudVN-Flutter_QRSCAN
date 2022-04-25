import 'package:qr_code/object/xuatkho_tojson.dart';

class IN02M {
  String? oid;
  String? codeName;
  String? voucherNo;
  String? voucherDate;
  String? remark;
  String? employeeID;
  String? employeeName;
  String? createDate;
  String? createBy;
  String? whID;
  String? whName;
  String? remark2;
  String? customerID;
  String? customerName;
  bool? tempIssue;
  List<SerialViewItem>? seris;

  IN02M(
      {this.oid,
      this.codeName,
      this.voucherNo,
      this.voucherDate,
      this.remark,
      this.employeeID,
      this.employeeName,
      this.createDate,
      this.createBy,
      this.whID,
      this.whName,
      this.remark2,
      this.customerID,
      this.customerName,
      this.tempIssue,
      this.seris});

  IN02M.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    codeName = json['codeName'];
    voucherNo = json['voucherNo'];
    voucherDate = json['voucherDate'];
    remark = json['remark'];
    employeeID = json['employeeID'];
    employeeName = json['employeeName'];
    createDate = json['createDate'];
    createBy = json['createBy'];
    whID = json['whid'];
    whName = json['whName'];
    remark2 = json['remark2'];
    customerID = json['customerID'];
    customerName = json['customerName'];
    tempIssue = json['tempIssue'];
    seris = json['seris'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['codeName'] = codeName;
    data['voucherNo'] = voucherNo;
    data['voucherDate'] = voucherDate;
    data['remark'] = remark;
    data['employeeID'] = employeeID;
    data['employeeName'] = employeeName;
    data['createDate'] = createDate;
    data['createBy'] = createBy;
    data['whid'] = whID;
    data['whName'] = whName;
    data['remark2'] = remark2;
    data['customerID'] = customerID;
    data['customerName'] = customerName;
    data['tempIssue'] = tempIssue;
    List<Map<String, dynamic>>? _seris =
        seris != null ? seris!.map((e) => e.toJson()).toList() : null;
    data['seris'] = _seris;
    return data;
  }
}

class SerialView {
  String? oid;
  String? iN02ID;
  String? whid;
  String? wCode;
  String? itemID;
  String? itemName;
  String? umid;
  String? umName;
  double? length;
  double? width;
  double? height;
  double? quantity;
  String? lotNumber;
  String? serialNumber;
  String? crackSize;
  double? crackAcreage;
  double? actualQty;
  String? remark;
  String? iN01DetailID;
  double? unitPrice;
  double? amount;

  SerialView(
      {this.oid,
      this.iN02ID,
      this.whid,
      this.wCode,
      this.itemID,
      this.itemName,
      this.umid,
      this.umName,
      this.length,
      this.width,
      this.height,
      this.quantity,
      this.lotNumber,
      this.serialNumber,
      this.crackSize,
      this.crackAcreage,
      this.actualQty,
      this.remark,
      this.iN01DetailID,
      this.unitPrice,
      this.amount});

  SerialView.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    iN02ID = json['iN02ID'];
    whid = json['whid'];
    wCode = json['wCode'];
    itemID = json['itemID'];
    itemName = json['itemName'];
    umid = json['umid'];
    umName = json['umName'];
    length = json['length'];
    width = json['width'];
    height = json['height'];
    quantity = json['quantity'];
    lotNumber = json['lotNumber'];
    serialNumber = json['serialNumber'];
    crackSize = json['crackSize'];
    crackAcreage = json['crackAcreage'];
    actualQty = json['actualQty'];
    remark = json['remark'];
    iN01DetailID = json['iN01DetailID'];
    unitPrice = json['unitPrice'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['iN02ID'] = iN02ID;
    data['whid'] = whid;
    data['wCode'] = wCode;
    data['itemID'] = itemID;
    data['itemName'] = itemName;
    data['umid'] = umid;
    data['umName'] = umName;
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['quantity'] = quantity;
    data['lotNumber'] = lotNumber;
    data['serialNumber'] = serialNumber;
    data['crackSize'] = crackSize;
    data['crackAcreage'] = crackAcreage;
    data['actualQty'] = actualQty;
    data['remark'] = remark;
    data['iN01DetailID'] = iN01DetailID;
    data['unitPrice'] = unitPrice;
    data['amount'] = amount;
    return data;
  }
}

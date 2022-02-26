class SerialViewItem {
  int? length;
  int? width;
  int? height;
  String? lotNumber;
  String? serialNumber;
  String? crackSize;
  double? crackAcreage;
  double? actualQty;

  SerialViewItem({
    this.length,
    this.width,
    this.height,
    this.lotNumber,
    this.serialNumber,
    this.crackSize,
    this.crackAcreage,
    this.actualQty,
  });

  SerialViewItem.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    width = json['width'];
    height = json['height'];
    lotNumber = json['lotNumber'];
    serialNumber = json['serialNumber'];
    crackSize = json['crackSize'];
    crackAcreage = json['crackAcreage'];
    actualQty = json['actualQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['width'] = width;
    data['height'] = height;
    data['lotNumber'] = lotNumber;
    data['serialNumber'] = serialNumber;
    data['crackSize'] = crackSize;
    data['crackAcreage'] = crackAcreage;
    data['actualQty'] = actualQty;
    return data;
  }
}

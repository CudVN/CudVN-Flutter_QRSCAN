class User {
  String? oid;
  String? userName;
  String? password;
  String? fullName;
  int? admin;
  bool? active;
  String? placeName;

  User(
      {this.oid,
      this.userName,
      this.password,
      this.fullName,
      this.admin,
      this.active,
      this.placeName});

  User.fromJson(Map<String, dynamic> json) {
    oid = json['oid'];
    userName = json['userName'];
    password = json['password'];
    fullName = json['fullName'];
    admin = json['admin'];
    active = json['active'];
    placeName = json['placeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['oid'] = oid;
    data['userName'] = userName;
    data['password'] = password;
    data['fullName'] = fullName;
    data['admin'] = admin;
    data['active'] = active;
    data['placeName'] = placeName;
    return data;
  }
}
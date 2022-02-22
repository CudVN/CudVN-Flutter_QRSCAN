import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/object/nhanvien.dart';
import 'package:qr_code/qr_scan_page.dart';
import 'package:http/http.dart' as http;

class AddIN02M extends StatefulWidget {
  const AddIN02M({Key? key}) : super(key: key);

  @override
  _AddIN02MState createState() => _AddIN02MState();
}

class _AddIN02MState extends State<AddIN02M> {
  String? _mySelection;
  late List<User> users;
  Future<List<User>> fetchUser(http.Client client) async {
    final response = await client.get(Uri.parse(base + 'User/'));
    setState(() {
      users = parseUsers(response.body);
    });
    print(users.map((e) => e.oid));
    return users;
  }

  List<User> parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm mới'), actions: [
        IconButton(
            icon: const Icon(
              Icons.qr_code_sharp,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const QRScan()));
            })
      ]),
      body: Center(
          child: FutureBuilder(
        future: fetchUser(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Không có dữ liệu');
          } else if (snapshot.hasData) {
            return DropdownButton(
              items: users.map((item) {
                return DropdownMenuItem(
                  child: Text(item.fullName!),
                  value: item.oid,
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _mySelection = newVal.toString();
                });
              },
              value: _mySelection,
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      )),
    );
  }
}
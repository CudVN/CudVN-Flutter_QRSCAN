import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/home_page.dart';
import 'package:qr_code/object/nhanvien.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final userController = TextEditingController();
  final pwController = TextEditingController();
  final apiController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> _addAPI(String linkAPI) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('api');
    base = (prefs.getString('api') ?? linkAPI);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  User? user;
  bool setting = false;

  fetchUser(http.Client client, String userName, String pw) async {
    final SharedPreferences prefs = await _prefs;
    final result = prefs.getString('api');
    base = result!;
    Map data = {'userName': userName, 'password': pw};
    final response = await client.post(
      Uri.parse(base + 'User/Login/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          data), // jsonEncode(<String, dynamic>{'user': in02m.toJson()}),
    );
    if (response.statusCode < 200 || response.statusCode >= 400) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const MyHomePage(
                      title: 'Xuất kho',
                    )),
            (Route<dynamic> route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: isLoading == true
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: userController,
                        decoration: const InputDecoration(
                          hintText: 'Tài khoản',
                        ),
                      ),
                      TextFormField(
                        controller: pwController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Mật khẩu',
                        ),
                      ),
                      TextButton(
                          onLongPress: () {
                            setting = true;
                            setState(() {});
                          },
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            fetchUser(http.Client(), userController.text,
                                pwController.text);
                          },
                          child: const Text('LOGIN')),
                      setting
                          ? TextButton(
                              onPressed: () async {
                                final preferences =
                                    await SharedPreferences.getInstance();
                                final api = preferences.getString('api');
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                            'Cài đặt API',
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                          content: Column(
                                            children: [
                                              Text('$api'),
                                              TextFormField(
                                                controller: apiController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Nhập link API'),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                primary: Colors.white,
                                                backgroundColor: Colors.teal,
                                                onSurface: Colors.grey,
                                              ),
                                              child: const Text('Xác nhận'),
                                              onPressed: () {
                                                _addAPI(apiController.text);
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ));
                              },
                              child: const Icon(Icons.settings))
                          : Container(),
                    ],
                  ),
                )),
    );
  }
}

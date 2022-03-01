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
  // ignore: unused_field
  late Future<String> _base;

  bool _validateUser = false;
  bool _validatePw = false;

  Future<void> _addAPI(String linkAPI) async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('api');
    base = (prefs.getString('api') ?? linkAPI);
    setState(() {
      _base = prefs.setString('api', linkAPI).then((bool success) {
        return base;
      });
    });
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
    if (result == null) {
      return;
    }
    base = result;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/oryza.png',
              width: size.width * 0.7,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                color: cPrimaryLightColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: TextFormField(
                controller: userController,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.person,
                    color: cPrimaryColor,
                  ),
                  errorText: _validateUser ? 'Không bỏ trống' : null,
                  hintText: 'Tài khoản',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                color: cPrimaryLightColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: TextFormField(
                controller: pwController,
                validator: (value) => value == null ? 'Vui lòng nhập' : null,
                obscureText: true,
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lock,
                    color: cPrimaryColor,
                  ),
                  errorText: _validatePw ? 'Không bỏ trống' : null,
                  hintText: 'Mật khẩu',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: cPrimaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20)),
                    onLongPress: () {
                      setting = true;
                      setState(() {});
                    },
                    onPressed: () {
                      setState(() {
                        userController.text.isEmpty
                            ? _validateUser = true
                            : _validateUser = false;
                        pwController.text.isEmpty
                            ? _validatePw = true
                            : _validatePw = false;
                      });
                      if (_validatePw == false && _validateUser == false) {
                        setState(() {
                          isLoading = true;
                        });
                        fetchUser(http.Client(), userController.text,
                            pwController.text);
                        userName = userController.text;
                      }
                    },
                    child: const Text(
                      'ĐĂNG NHẬP',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            setting
                ? TextButton(
                    onPressed: () async {
                      final preferences = await SharedPreferences.getInstance();
                      final api = preferences.getString('api');
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                  'Cài đặt API',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                                content: Column(
                                  children: [
                                    Text('$api'),
                                    TextFormField(
                                      controller: apiController,
                                      decoration: const InputDecoration(
                                          hintText: 'Nhập link API'),
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
            isLoading == true ? const CircularProgressIndicator() : Container(),
          ],
        ),
      )),
    );
  }
}

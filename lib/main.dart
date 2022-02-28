import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/login_page.dart';
import 'package:qr_code/provider/add_qr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddQRCode(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Qr Code',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginPage() //const MyHomePage(title: 'Xuất Kho',),
          ),
    );
  }
}

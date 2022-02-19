import 'package:flutter/material.dart';
import 'package:qr_code/qr_scan_page.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qr Code',
      theme: ThemeData(        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Qr Code',),
    );
  }
}


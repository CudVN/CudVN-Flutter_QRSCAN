import 'package:flutter/material.dart';
import 'package:qr_code/qr_scan_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.qr_code_sharp,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const QRScan()));
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'QR CODE',
            ),
          ],
        ),
      ),
    );
  }
}

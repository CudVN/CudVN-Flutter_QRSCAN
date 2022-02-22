import 'package:flutter/material.dart';
import 'package:qr_code/object/xuatkho.dart';

class PageDetail extends StatelessWidget {
  const PageDetail({
    Key? key,
    required this.in02m,
  }) : super(key: key);
  final IN02M in02m;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chi Tiết'),
/*         actions: [
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
        ], */
        ),
        body: Column(
          children: [
            Center(
              child: Text('${in02m.oid}'),
            )
          ],
        ));
  }
}

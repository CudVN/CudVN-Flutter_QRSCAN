import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/object/serial.dart';
import 'package:qr_code/object/xuatkho.dart';
import 'package:http/http.dart' as http;

Future<List<SerialView>> fetchSerial(http.Client client, String in02id) async {
  final uri = Uri.parse(base + 'IN02D0/GetByIN02/')
      .replace(queryParameters: {'IN02ID': in02id});
  final response = await client.get(uri);
  return compute(parseIN02Ms, response.body);
}

List<SerialView> parseIN02Ms(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<SerialView>((json) => SerialView.fromJson(json)).toList();
}

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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ItemRichText(
                      title: 'Khách hàng',
                      content: in02m.customerName ?? 'NULL',
                    ),
                  ),
                  ItemRichText(
                    title: 'Số phiếu',
                    content: in02m.voucherNo ?? 'NULL',
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ItemRichText(
                      title: 'Nhân viên',
                      content: in02m.employeeName ?? 'NULL',
                    ),
                  ),
                  ItemRichText(
                    title: 'Ngày xuất',
                    content: in02m.createDate!.isEmpty
                        ? 'null'
                        : DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(in02m.createDate!)),
                  ),
                ],
              ),
              Expanded(
                  child: Center(
                      child: FutureBuilder<List<SerialView>>(
                          future: fetchSerial(http.Client(), in02m.oid!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Không có dữ liệu');
                            } else if (snapshot.hasData) {
                              return IN02D0List(
                                in02D0s: snapshot.data!,
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          })))
            ],
          ),
        ));
  }

  Widget IN02D0List({required List<SerialView> in02D0s}) {
    return ListView.builder(
        itemCount: in02D0s.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            padding: const EdgeInsets.all(4),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text('Serial Number: ${in02D0s[index].serialNumber}',
                      style: const TextStyle(color: Colors.white)),
                ),
                Text('LotNumber: ${in02D0s[index].lotNumber!}',
                    style: const TextStyle(color: Colors.white)),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Length: ${in02D0s[index].length}',
                      style: const TextStyle(color: Colors.white)),
                  Text('Width: ${in02D0s[index].width}',
                      style: const TextStyle(color: Colors.white)),
                  Text('Height: ${in02D0s[index].height}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Crack Size: ${in02D0s[index].crackSize}',
                      style: const TextStyle(color: Colors.white)),
                  Text('Crack Acreage: ${in02D0s[index].crackAcreage}',
                      style: const TextStyle(color: Colors.white)),
                  Text('Actual Qty: ${in02D0s[index].actualQty}',
                      style: const TextStyle(color: Colors.white)),
                ],
              )
            ]),
            color: index % 2 == 0
                ? const Color.fromARGB(255, 71, 117, 160)
                : const Color.fromARGB(255, 104, 123, 185),
          );
        });
  }
}

class ItemRichText extends StatelessWidget {
  const ItemRichText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(style: const TextStyle(fontSize: 20), children: [
      TextSpan(
          text: '$title: ',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black)),
      TextSpan(text: content, style: const TextStyle(color: Colors.green))
    ]));
  }
}

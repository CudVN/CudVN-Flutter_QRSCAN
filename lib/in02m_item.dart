import 'package:flutter/material.dart';
import 'package:qr_code/in02m_detail.dart';
import 'package:qr_code/object/xuatkho.dart';
import 'package:intl/intl.dart';

class IN02MList extends StatelessWidget {
  const IN02MList({
    Key? key,
    required this.in02ms,
  }) : super(key: key);
  final List<IN02M> in02ms;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: in02ms.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.all(4),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text('Số phiếu: ${in02ms[index].voucherNo}',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        Text(
                            'Ngày xuất: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(in02ms[index].createDate!))}',
                            style: const TextStyle(color: Colors.white)),
                      ]),
                      Text('Khách hàng: ${in02ms[index].customerName}',
                          style: const TextStyle(color: Colors.white)),
                    ]),
                color: index % 2 == 0
                    ? const Color.fromARGB(255, 9, 133, 106)
                    : const Color.fromARGB(255, 14, 24, 161),
              ),
              // ignore: avoid_print
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PageDetail(in02m: in02ms[index]))));
        });
  }
}

import 'package:flutter/material.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/in02m_detail.dart';
import 'package:qr_code/object/xuatkho.dart';
import 'package:intl/intl.dart';

class IN02MList extends StatelessWidget {
  const IN02MList({
    Key? key,
    required this.vID,
    required this.in02ms,
  }) : super(key: key);
  final List<IN02M> in02ms;
  final String vID;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: in02ms.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? cPrimaryLightColor2
                        : cPrimaryLightColor,
                    borderRadius: BorderRadius.circular(defaultBorderRadius)),
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                padding: const EdgeInsets.all(4),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                            'Số phiếu: ${in02ms[index].voucherNo}',
                          ),
                        ),
                        Text(
                          'Ngày xuất: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(in02ms[index].createDate!))}',
                        ),
                      ]),
                      vID == vIDXuatBan ? Text(
                        'Khách hàng: ${in02ms[index].customerName}',
                      ) : Text(
                        'Nhân viên: ${in02ms[index].employeeName}'),
                    ]),
              ),
              // ignore: avoid_print
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PageDetail(vID: vID, in02m: in02ms[index]))));
        });
  }
}

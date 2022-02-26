import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/object/qr.dart';
import 'package:qr_code/provider/add_qr.dart';
import 'package:qr_code/widget/noti_bar.dart';

class QrItem extends StatelessWidget {
  final QR qr;
  const QrItem({Key? key, required this.qr}) : super(key: key);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Slidable(
            endActionPane: ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                flex: 1,
                onPressed: (_) => deleteQrCode(context, qr),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ]),
            key: Key(qr.qrCode!),
            child: buildQrItem(context)),
      );

  Widget buildQrItem(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Checkbox(
              activeColor: Colors.lightGreen,
              checkColor: Colors.white,
              value: qr.isDone,
              onChanged: (_) {}),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                qr.qrCode!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}

void deleteQrCode(BuildContext context, QR qr) {
  final provider = Provider.of<AddQRCode>(context, listen: false);
  provider.removeQrCode(qr);
  NotiBar.showSnackBar(context, 'Đã xoá mã QR');
}

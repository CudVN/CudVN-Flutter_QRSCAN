import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/object/qr.dart';
import 'package:qr_code/provider/add_qr.dart';
import 'package:qr_code/widget/noti_bar.dart';

class QrItem extends StatefulWidget {
  final QR qr;
  const QrItem({Key? key, required this.qr}) : super(key: key);

  @override
  State<QrItem> createState() => _QrItemState();
}

class _QrItemState extends State<QrItem> {
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Slidable(
            endActionPane: ActionPane(motion: const ScrollMotion(), children: [
              SlidableAction(
                flex: 1,
                onPressed: (_) => deleteQrCode(context, widget.qr),
                backgroundColor: cErrorColor,
                foregroundColor: bgColor,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ]),
            key: Key(widget.qr.qrCode!),
            child: buildQrItem(context)),
      );

  Widget buildQrItem(BuildContext context) {
    return Container(
      color: widget.qr.isDone == true ? Colors.green : cPrimaryColor,
      margin: const EdgeInsets.symmetric(vertical: 1),
      padding: const EdgeInsets.all(2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.qr.qrCode!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bgColor,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: Checkbox(
                  activeColor: cDoneColor,
                  checkColor: bgColor,
                  value: widget.qr.isDel,
                  onChanged: (value) {
                    widget.qr.isDel = value;
                    setState(() {});
                  }),
            )
          ],
        ),
      ),
    );
  }
}

void deleteQrCode(BuildContext context, QR qr) {
  final provider = Provider.of<AddQRCode>(context, listen: false);
  provider.removeQrCode(qr);
  NotiBar.showSnackBar(context, '???? xo?? m?? QR');
}

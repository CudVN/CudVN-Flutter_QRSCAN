import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:qr_code/constance.dart';
import 'package:qr_code/object/qr.dart';
import 'package:qr_code/provider/add_qr.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScan extends StatefulWidget {
  const QRScan({Key? key}) : super(key: key);

  @override
  _QRScanState createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Future<void> reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddQRCode>(context);
    final qrs = provider.qrs;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Scanner'),
        backgroundColor: cPrimaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    // margin: const EdgeInsets.only(top: 20),
                    child: buildQrView(context)),
                Positioned(child: buildControlButtons(), top: 10),
                Positioned(bottom: 10, child: _buttonDone(context)),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: Colors.white24,
                child: buildResult(qrs),
              )),
        ],
      ),
    );
  }

  buildControlButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white24,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              icon: FutureBuilder<bool?>(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Icon(
                        snapshot.data! ? Icons.flash_on : Icons.flash_off);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.toggleFlash();
                setState(() {});
              }),
          IconButton(
              icon: FutureBuilder(
                future: controller?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return const Icon(Icons.switch_camera);
                  } else {
                    return Container();
                  }
                },
              ),
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              }),
        ],
      ),
    );
  }

  buildResult(List<QR> qrs) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white24,
      child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(2),
          separatorBuilder: (context, index) => Container(
                height: 2,
              ),
          itemCount: qrs.length,
          itemBuilder: (context, index) {
            final qr = qrs[index];
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                '${qr.qrCode}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: cDoneColor),
              ),
            );
          }), /* Text(
          scaned == null
              ? (barcode != null ? 'Code: ${barcode!.code}' : 'Scan a code!')
              : 'Đã quét',
          maxLines: 3,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ) */
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: cErrorColor,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.height * 0.4,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        //controller.pauseCamera();
        if (barcode.code != null) {
          final provider = Provider.of<AddQRCode>(context, listen: false);
          final foundQR =
              provider.qrs.where((element) => element.qrCode == barcode.code);
          if (foundQR.isEmpty) {
            this.barcode = barcode;
            final qr =
                QR(qrCode: this.barcode!.code, isDone: false, isDel: false);
            provider.addQrCode(qr);
            FlutterRingtonePlayer.playNotification();
          }
        }
      });
    });
  }

  _buttonDone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: cDoneColor,
      ),
      child: TextButton.icon(
        icon: const Icon(
          Icons.done,
          color: bgColor,
        ),
        label: const Text(
          'Hoàn Thành',
          style: TextStyle(color: bgColor),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:qr_code/home_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.qr_code_sharp,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {})
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: const Color.fromRGBO(255, 0, 0, 1),
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) {
      setState(() {
        controller.pauseCamera();
        this.barcode = barcode;
        if (this.barcode!.code != null) {
          FlutterRingtonePlayer.playNotification();
          showDialog(
              context: context,
              builder: (context) =>  AlertDialog(                    
                    title: const Text(
                      'Quét mã thành công',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    content: Text(
                      '${barcode.code}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          onSurface: Colors.grey,                          
                        ),
                        child: const Text('Xác nhận'),
                        onPressed: () {
                          this.barcode = null;
                          Navigator.of(context).pop();
                          Future.delayed(const Duration(seconds: 10));
                          controller.resumeCamera();
                        },
                      )
                    ],
                  )); 
        }
      });
    });
  }

}

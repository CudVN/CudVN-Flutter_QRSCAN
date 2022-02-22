import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(child: buildResult(), bottom:10),
          Positioned(child: buildControlButtons(), top:10)
        ],
      ),
    );
  }
  buildControlButtons(){
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
            icon: FutureBuilder<bool?>(future: controller?.getFlashStatus(), builder: (context, snapshot) {
              if (snapshot.data != null) {
                return Icon(
                  snapshot.data! ? Icons.flash_on : Icons.flash_off);
              } else {
                return Container();
              }
            },),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {              
              });
            }),
          IconButton(
           icon: FutureBuilder(future: controller?.getCameraInfo(), builder: (context, snapshot) {
              if (snapshot.data != null) {
                return const Icon( Icons.switch_camera);
              } else {
                return Container();
              }
            },),
            onPressed: () async {
              await controller?.flipCamera();
              setState(() {              
              });
            }),
        ],
      ),
    );
  }
   buildResult() {
     return Container(
       padding: const EdgeInsets.all(12),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(8),
       color: Colors.white24,
     ),child: Text( barcode!=null ? 'Code: ${barcode!.code}' : 'Scan a code!', maxLines: 3,));
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
        //controller.pauseCamera();        
        if (barcode.code != null) {
          var codeTG = this.barcode?.code;
         
          if(codeTG != barcode.code)
          {
             this.barcode = barcode;
             FlutterRingtonePlayer.playNotification();
          }        
          
         
          /* showDialog(
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
                  ));  */
        }
      });
    });
  }

 

}

import 'package:flutter/cupertino.dart';
import 'package:qr_code/object/qr.dart';

class AddQRCode extends ChangeNotifier {
  final List<QR> _qr = [
    
  ];
  List<QR> get qrs => _qr.toList();
  void addQrCode(QR qr) {
    _qr.add(qr);
    notifyListeners();
  }
  void removeQrCode(QR qr) {
    _qr.remove(qr);
    notifyListeners();
  }
}

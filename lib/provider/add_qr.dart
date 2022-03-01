import 'package:flutter/cupertino.dart';
import 'package:qr_code/object/qr.dart';

class AddQRCode extends ChangeNotifier {
  final List<QR> _qr = [];
  List<QR> get qrs => _qr.toList();
  void addQrCode(QR qr) {
    _qr.insert(0, qr);
    notifyListeners();
  }

  void removeQrCode(QR qr) {
    _qr.remove(qr);
    notifyListeners();
  }

  void removeQrCodes() {
    _qr.removeWhere((qr) => qr.isDel == true);
    notifyListeners();
  }

  void removeAllQrCodes() {
    _qr.removeWhere((qr) => qr.qrCode != null);
    notifyListeners();
  }
}

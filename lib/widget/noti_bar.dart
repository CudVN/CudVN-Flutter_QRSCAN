import 'package:flutter/material.dart';
import 'package:qr_code/constance.dart';

class NotiBar {
  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
          SnackBar(backgroundColor: cPrimaryColor, content: Text(text)));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotiBar {
  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
  }
}
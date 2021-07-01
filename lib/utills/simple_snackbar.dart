import 'package:flutter/material.dart';

void simpleSnackbar(BuildContext context, String s) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
}

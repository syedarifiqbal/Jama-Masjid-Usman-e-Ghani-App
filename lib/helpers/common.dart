import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey[600],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

String formatDate({dateString, format = "dd/MM/yyyy"}) {
  // Parse the string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object as "dd/MM/yyyy"
  return DateFormat(format).format(dateTime).toString();
}



import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

bool isValidJSON(String str){
  try {
    var decodedJSON = json.decode(str) as Map<String, dynamic>;
    return true;
  } on FormatException catch (e) {
    return false;
  }
}

void showMsg(String msg){

  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}



void showProgressDialog(BuildContext context) async {
  ProgressDialog pr = ProgressDialog(context);
  pr.style(
    message: 'Downloading...',
    progressWidget: const CircularProgressIndicator(),
  );

  await pr.show();

  // Simulate a download process (you should replace this with your actual download logic)
  await Future.delayed(const Duration(seconds: 3));

  await pr.hide();
}


String getFileSizeKiloBytes(int size) {
  return "${(size / 1024 ).toStringAsFixed(2)} kb";
}


 String getFileSizeMegaBytes(int size) {
  return "${(size / (1024 * 1024)).toStringAsFixed(2)} mb";
}


int toInt(String number){
  if(number.isEmpty) {
    return 0;
  }

  return int.parse(number);
}



  Timestamp convertDateStrToTimestamp(String dateStr){

    List<String> dateParts = dateStr.split('/');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);
    DateTime date = DateTime(year, month, day);

    return Timestamp.fromDate(date);

  }


  String convertTimestampToDateStr(Timestamp date){

    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format( date.toDate());

  }


  String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat('dd/MM/yyyy');
    String formatted = formatter.format(now);
    return formatted;
  }
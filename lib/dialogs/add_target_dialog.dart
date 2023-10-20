

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';

import '../firebase/firebase_methods.dart';
import '../my_entities/utils.dart';



void addTarget(BuildContext context){
  showTargetDialog(context );
}

void editTarget(BuildContext context, String? targetID, Map<String, dynamic>? dataMap ){
  showTargetDialog(context , targetID: targetID, dataMap: dataMap);
}


void showTargetDialog(BuildContext context,  {String? targetID, Map<String, dynamic>? dataMap}) {



  TextEditingController titleController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController dateController = TextEditingController();


  if(dataMap != null && dataMap.isNotEmpty){

    titleController.text = dataMap['title'].toString();
    moneyController.text = dataMap['total_cost'].toString();
    dateController.text = convertTimestampToDateStr( dataMap['date']);
  }
  else{
    dateController.text = getCurrentDate();
  }


  Future<void> saveTarget() async {

    String userID = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> valuesMap = {
      'title': titleController.text,
      'total_cost': double.parse(moneyController.text),
      'remaining_cost': double.parse(moneyController.text),
      'date': convertDateStrToTimestamp(dateController.text),
      'uid': userID,
    };




    if(dataMap != null && dataMap.isNotEmpty){
      updateDocument("Targets" , targetID!, valuesMap);
    }
    else{
      addDocument("Targets", valuesMap);
    }


    Navigator.of(context).pop();







  }


  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Create a custom widget for the dialog content
      return AlertDialog(
        title:  Text(dataMap == null || dataMap.isEmpty ? 'Add Target' : 'Edit Target'),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            getEdittext("Title", titleController),
            getEdittext("Total cost", moneyController , textInputType: TextInputType.number),
            getEdittextDatePicker("Date", dateController , context),


          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              saveTarget();

            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );




}





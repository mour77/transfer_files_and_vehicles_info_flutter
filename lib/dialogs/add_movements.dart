

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';

import '../firebase/firebase_methods.dart';
import '../my_entities/utils.dart';



void addMovement(BuildContext context, String targetID){
  showMovementDialog(context , targetID: targetID);
}

void editMovement(BuildContext context, String? movementID, Map<String, dynamic>? dataMap ){
  showMovementDialog(context , movementID: movementID, dataMap: dataMap);
}


void showMovementDialog(BuildContext context,  {String? targetID , String? movementID, Map<String, dynamic>? dataMap}) {



  TextEditingController titleController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController dateController = TextEditingController();


  if(dataMap != null && dataMap.isNotEmpty){

    titleController.text = dataMap['title'].toString();
    moneyController.text = dataMap['cost'].toString();
    dateController.text = convertTimestampToDateStr( dataMap['date']);
  }
  else{
    dateController.text = getCurrentDate();
  }


  Future<void> saveMovement() async {

    //String userID = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> valuesMap = {
      'title': titleController.text,
      'cost': toInt(moneyController.text),
      'date': convertDateStrToTimestamp(dateController.text),
      'targetID': targetID,
    };




    if(dataMap != null && dataMap.isNotEmpty){
      updateDocument("Movements" , movementID!, valuesMap);
    }
    else{
      addDocument("Movements", valuesMap);
    }


    Navigator.of(context).pop();







  }


  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Create a custom widget for the dialog content
      return AlertDialog(
        title:  Text(dataMap == null || dataMap.isEmpty ? 'Add Movement' : 'Edit Movement'),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            getEdittext("Title", titleController),
            getEdittext("Cost", moneyController , textInputType: TextInputType.number),
            getEdittextDatePicker("Date", dateController , context),


          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              saveMovement();

            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );




}





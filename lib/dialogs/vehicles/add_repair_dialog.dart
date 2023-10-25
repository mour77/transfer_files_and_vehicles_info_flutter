

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';

import '../../firebase/firebase_methods.dart';
import '../../my_entities/utils.dart';





void addRepairHistory(BuildContext context, String? vehicleID){
  showRepairDialog(context , vehicleID: vehicleID);
}

void editRepairHistory(BuildContext context, String? historyID, Map<String, dynamic>? dataMap ){
  showRepairDialog(context , historyID: historyID, dataMap: dataMap);
}



void showRepairDialog(BuildContext context, {String? vehicleID , String? historyID, Map<String, dynamic>? dataMap}) {

  TextEditingController descriptionController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController odometerController = TextEditingController();
  TextEditingController nextOdometerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();





  if(dataMap != null && dataMap.isNotEmpty){

    descriptionController.text = dataMap['description'].toString();
    moneyController.text = dataMap['money'].toString();
    odometerController.text = dataMap['odometer'].toString();
    nextOdometerController.text = dataMap['nextOdometer'].toString();
    dateController.text = convertTimestampToDateStr( dataMap['date']);
    remarksController.text = dataMap['remarks'];
  }
  else{
    dateController.text = getCurrentDate();
  }



  Future<void> saveRepair() async {
    // Initialize Firestore


    String userID = FirebaseAuth.instance.currentUser!.uid;


    Map<String, dynamic> valuesMap = {
      'description': descriptionController.text,
      'categoryID': 2,
      'money': toInt(moneyController.text),
      'odometer': toInt(odometerController.text),
      'nextOdometer': toInt(nextOdometerController.text),
      'date': convertDateStrToTimestamp(dateController.text),
      'remarks': remarksController.text,

      'vehicleID':  dataMap != null && dataMap.isNotEmpty ? dataMap['vehicleID'] : vehicleID,
      'uid': userID,
    };




    if(dataMap != null && dataMap.isNotEmpty){
      updateDocument("History" , historyID!, valuesMap);
    }
    else{
      addDocument("History", valuesMap);
    }

    Navigator.of(context).pop();
  }






  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Create a custom widget for the dialog content
      return AlertDialog(
        title:  Text(dataMap == null || dataMap.isEmpty ? 'Add repair' : 'Edit repair'),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            getEdittext("Description", descriptionController, ),
            getEdittext("Money", moneyController , textInputType: TextInputType.number),
            getEdittext("Odometer", odometerController , textInputType: TextInputType.number),
            getEdittext("Odometer next repair", nextOdometerController , textInputType: TextInputType.number),
            getEdittextDatePicker("Date", dateController , context),
            getEdittext("Remarks", remarksController),


          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              saveRepair();

            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );




}





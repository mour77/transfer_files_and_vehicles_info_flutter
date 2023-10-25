

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';

import '../../firebase/firebase_methods.dart';
import '../../my_entities/utils.dart';



 void addGasHistory(BuildContext context, String? vehicleID){
   showGasDialog(context , vehicleID: vehicleID);
 }

 void editGasHistory(BuildContext context, String? historyID, Map<String, dynamic>? dataMap ){
   showGasDialog(context , historyID: historyID, dataMap: dataMap);
 }


void showGasDialog(BuildContext context,  {String? vehicleID , String? historyID, Map<String, dynamic>? dataMap}) {



  TextEditingController litresController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController dateController = TextEditingController();


  if(dataMap != null && dataMap.isNotEmpty){

    litresController.text = dataMap['litres'].toString();
    moneyController.text = dataMap['money'].toString();
    distanceController.text = dataMap['odometer'].toString();
    dateController.text = convertTimestampToDateStr( dataMap['date']);
  }
  else{
    dateController.text = getCurrentDate();
  }


  Future<void> saveGas() async {
    // Initialize Firestore

    String userID = FirebaseAuth.instance.currentUser!.uid;

    Map<String, dynamic> valuesMap = {
      'description': 'Ανεφοδιασμός',
      'categoryID': 1,
      'litres': toInt(litresController.text),
      'money': toInt(moneyController.text),
      'odometer': toInt(distanceController.text),
      'date': convertDateStrToTimestamp(dateController.text),

      'vehicleID': dataMap != null && dataMap.isNotEmpty ? dataMap['vehicleID'] : vehicleID,
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
        title:  Text(dataMap == null || dataMap.isEmpty ? 'Add gas' : 'Edit gas'),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            getEdittext("Litres", litresController, textInputType: TextInputType.number),
            getEdittext("Money", moneyController , textInputType: TextInputType.number),
            getEdittext("Distance", distanceController , textInputType: TextInputType.number),
            getEdittextDatePicker("Date", dateController , context),


          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              saveGas();

            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );




}





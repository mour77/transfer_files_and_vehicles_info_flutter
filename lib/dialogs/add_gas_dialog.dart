

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';

import '../my_entities/utils.dart';

void showGasDialog(BuildContext context, bool addGas, String vehicleID) {

  TextEditingController litresController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController dateController = TextEditingController();



  Future<void> saveGas() async {
    // Initialize Firestore

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      String userID = FirebaseAuth.instance.currentUser!.uid;


      firestoreInstance.collection('History').add({
        'description': 'Ανεφοδιασμός',
        'categoryID': 1,
        'litres': toInt(litresController.text),
        'money': toInt(moneyController.text),
        'odometer': toInt(distanceController.text),
        'date': convertDateStrToTimestamp(dateController.text),

        'vehicleID': vehicleID,
        'uid': userID,
      });

      print(dateController.text);
      showMsg('Saved');
      Navigator.of(context).pop();

    }

    catch(error) {
      showMsg(error.toString());
    }





  }


  showDialog(
    context: context,
    builder: (BuildContext context) {
      // Create a custom widget for the dialog content
      return AlertDialog(
        title:  Text(addGas ? 'Add gas' : 'Edit gas'),
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





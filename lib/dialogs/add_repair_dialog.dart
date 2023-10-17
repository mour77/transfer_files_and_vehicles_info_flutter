

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';

import '../my_entities/utils.dart';

void showRepairDialog(BuildContext context, bool addRepair, String vehicleID) {

  TextEditingController descriptionController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController odometerController = TextEditingController();
  TextEditingController nextOdometerController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController remarksController = TextEditingController();



  Future<void> saveRepair() async {
    // Initialize Firestore

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      String userID = FirebaseAuth.instance.currentUser!.uid;


      firestoreInstance.collection('History').add({
        'description': descriptionController.text,
        'categoryID': 2,
        'money': toInt(moneyController.text),
        'odometer': toInt(odometerController.text),
        'nextOdometer': toInt(nextOdometerController.text),
        'date': convertDateStrToTimestamp(dateController.text),
        'remarks': remarksController.text,

        'vehicleID': vehicleID,
        'uid': userID,
      });

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
        title:  Text(addRepair ? 'Add repair' : 'Edit repair'),
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





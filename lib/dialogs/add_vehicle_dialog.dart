

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';

import '../my_entities/utils.dart';

void showVehicleDialog(BuildContext context, bool addVehicle) {

  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController kivikaController = TextEditingController();
  TextEditingController hpController = TextEditingController();

  TextEditingController yearController = TextEditingController();
  TextEditingController pinakidaController = TextEditingController();
  TextEditingController tiposKausimouController = TextEditingController();
  TextEditingController xoritikotitaController = TextEditingController();

  TextEditingController arKikloforiasController = TextEditingController();
  TextEditingController arPlaisiouController = TextEditingController();


  Future<void> saveVehicle() async {
    // Initialize Firestore

    try {
      final firestoreInstance = FirebaseFirestore.instance;
      String userID = FirebaseAuth.instance.currentUser!.uid;

      firestoreInstance.collection('Vehicles').add({
        'brand': brandController.text,
        'model': modelController.text,
        'kivika': toInt(kivikaController.text),
        'hp': toInt(hpController.text),
        'year': toInt(yearController.text),
        'plateID': pinakidaController.text,
        'gasTypeID': 1,
        'gasTypeIDStr': tiposKausimouController.text,
        'capacity': toInt(xoritikotitaController.text),
        'arithmos_kikloforias': arKikloforiasController.text,
        'vin': arPlaisiouController.text,
        'userID': userID,
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
        title:  Text(addVehicle ? 'Add vehicle' : 'Edit vehicle'),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            getEdittext("Brand", brandController),
            getEdittext("Model", modelController),
            getEdittext("Kivika", kivikaController, textInputType: TextInputType.number),
            getEdittext("Hp", hpController , textInputType: TextInputType.number),
            getEdittext("Year", yearController, textInputType: TextInputType.number),
            getEdittext("Πινακίδα", pinakidaController),
            getEdittext("Τύπος καυσίμου", tiposKausimouController),
            getEdittext("Χωρητικότητα", xoritikotitaController, textInputType: TextInputType.number),
            getEdittext("Αρ. κυκλοφορίας", arKikloforiasController),
            getEdittext("Αρ. πλαισίου", arPlaisiouController),

          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              saveVehicle();

            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );




}





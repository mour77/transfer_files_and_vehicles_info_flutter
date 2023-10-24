

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/edittext_for_dialogs.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/vehicles.dart';

import '../firebase/firebase_methods.dart';
import '../my_entities/gas_types.dart';
import '../my_entities/utils.dart';




void addVehicle(BuildContext context ,{Future<void> Function()? runMethod}){
  showVehicleDialog(context , runMethod: runMethod );
}

void editVehicle(BuildContext context, String? vehicleID, Map<String, dynamic>? dataMap ,{Future<void> Function()? runMethod} ){
  showVehicleDialog(context , vehicleID: vehicleID, dataMap: dataMap, runMethod: runMethod);
}


void showVehicleDialog(BuildContext context, {String? vehicleID , Map<String, dynamic>? dataMap , Future<void> Function()? runMethod} )  {

  final ValueNotifier<Vehicles?> selectedBrandNotifier = ValueNotifier<Vehicles?> (null) ;
  final ValueNotifier<GasTypes?> selectedGasTypeNotifier = ValueNotifier<GasTypes?>(null)  ;

  TextEditingController modelController = TextEditingController();
  TextEditingController kivikaController = TextEditingController();
  TextEditingController hpController = TextEditingController();

  TextEditingController yearController = TextEditingController();
  TextEditingController pinakidaController = TextEditingController();

  TextEditingController xoritikotitaController = TextEditingController();

  TextEditingController arKikloforiasController = TextEditingController();
  TextEditingController arPlaisiouController = TextEditingController();



  if(dataMap != null && dataMap.isNotEmpty){
    Vehicles v = Vehicles.forDropDown(dataMap['brand'].toString(), dataMap['logoLocalPath'].toString());
    selectedBrandNotifier.value = v;

    int gasTypeID = dataMap['gasTypeID'];
    if (gasTypeID == GasTypes.oil.id){
      selectedGasTypeNotifier.value = GasTypes.oil;
    }
    else if (gasTypeID == GasTypes.diesel.id){
      selectedGasTypeNotifier.value = GasTypes.diesel;
    }


    modelController.text = dataMap['model'].toString();
    kivikaController.text = dataMap['kivika'].toString();
    hpController.text = dataMap['hp'].toString();

    yearController.text = dataMap['year'].toString();
    pinakidaController.text = dataMap['plateID'].toString();
    xoritikotitaController.text = dataMap['capacity'].toString();
    arKikloforiasController.text = dataMap['arithmos_kikloforias'].toString();
    arPlaisiouController.text = dataMap['vin'].toString();

  }


  /*
        'brand': selectedBrandNotifier.value?.data.brand,
        'logoLocalPath': selectedBrandNotifier.value?.data.logoPath,
        'gasTypeID': selectedGasTypeNotifier.value?.id,
        'gasTypeIDStr': selectedGasTypeNotifier.value?.text,
   */





  Future<void> saveVehicle() async {
    // Initialize Firestore

    try {

      if(selectedBrandNotifier.value == null){
        showMsg('Select brand');
        return;
      }
      else if ( selectedGasTypeNotifier.value == null ){
        showMsg('Select gas type');
        return;
      }


      String userID = FirebaseAuth.instance.currentUser!.uid;

      Map<String , dynamic> valuesMap = {
        'brand': selectedBrandNotifier.value?.data.brand,
        'logoLocalPath': selectedBrandNotifier.value?.data.logoPath,
        'model': modelController.text,
        'kivika': toInt(kivikaController.text),
        'hp': toInt(hpController.text),
        'year': toInt(yearController.text),
        'plateID': pinakidaController.text,
        'gasTypeID': selectedGasTypeNotifier.value?.id,
        'gasTypeIDStr': selectedGasTypeNotifier.value?.text,
        'capacity': toInt(xoritikotitaController.text),
        'arithmos_kikloforias': arKikloforiasController.text,
        'vin': arPlaisiouController.text,
        'userID': userID,
      };

      if(dataMap != null && dataMap.isNotEmpty){
        updateDocument("Vehicles" , vehicleID!, valuesMap);
      }
      else{
        addDocument("Vehicles", valuesMap);
      }

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
      return

        AlertDialog(
        title:  Text(dataMap == null || dataMap.isEmpty ? 'Add vehicle' : 'Edit vehicle'),
        content:

        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              // getEdittext("Brand", brandController),
              getBrandDropDownList(selectedBrandNotifier),
              getEdittext("Model", modelController),
              getEdittext("Kivika", kivikaController, textInputType: TextInputType.number),
              getEdittext("Hp", hpController , textInputType: TextInputType.number),
              getEdittext("Year", yearController, textInputType: TextInputType.number),
              getEdittext("Πινακίδα", pinakidaController),
              // getEdittext("Τύπος καυσίμου", tiposKausimouController),
              getGasDropDownList(selectedGasTypeNotifier),
              getEdittext("Χωρητικότητα", xoritikotitaController, textInputType: TextInputType.number),
              getEdittext("Αρ. κυκλοφορίας", arKikloforiasController),
              getEdittext("Αρ. πλαισίου", arPlaisiouController),

            ],
          ),
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
  ).then((value)  {
    if(runMethod != null){
      runMethod();
    }
  });





}






Widget getBrandDropDownList(ValueNotifier<Vehicles?> selectedBrandNotifier)  {




  return
    FutureBuilder<List<Vehicles>>(
      future: getBrands(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // While waiting for data.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final vehicles = snapshot.data;

          if (vehicles != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField2<Vehicles>(
                    decoration: const InputDecoration(
                        labelText: 'select a brand',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                        border: OutlineInputBorder(),
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.black, fontSize: 14.0)),

                    onChanged: (Vehicles? newValue) {

                      selectedBrandNotifier.value = newValue;
                    },
                    items: vehicles.map((Vehicles v) {
                      return

                        DropdownMenuItem<Vehicles>(
                        value: v,
                        child:
                        Row(
                          children: [
                            SizedBox(width:  32, height: 32,
                              child: Image.asset('assets/' + v.data.logoPath),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(v.data.brand , style: const TextStyle( fontSize: 18)),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else {
            return Text('No brands available.');
          }
        }
      },
    );
  


}


Future<List<Vehicles>> getBrands () async {
  List<Vehicles> list = [];
  String jsonData = await loadAssetFile('assets/logos/data.json') ;
  list = (jsonDecode(jsonData) as List)
      .map((data) => Vehicles.forDropDown(data['name'] , data['image']['localThumb'].toString().replaceAll("./", "logos/")))
      .toList();

  return list;


}




Widget getGasDropDownList(ValueNotifier<GasTypes?> selectedGasTypeNotifier){
  GasTypes? selectedGasType;

  return
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField2<GasTypes>(
        value: selectedGasType,
        onChanged: (GasTypes? newValue) {

          selectedGasTypeNotifier.value = newValue;
        },
        items: GasTypes.values.map((GasTypes customObject) {
          return DropdownMenuItem<GasTypes>(
            value: customObject,
            child: Text(customObject.name),
          );
        }).toList(),

        decoration: const InputDecoration(
          labelText: 'Select a gas type',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
          enabledBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.5),
          ),
        ),
      ),
    )

  ;


}


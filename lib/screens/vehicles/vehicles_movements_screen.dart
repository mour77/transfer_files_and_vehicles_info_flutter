import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../my_entities/utils.dart';
import '../../my_entities/vehicles.dart';


class VehiclesMovementsScreen extends StatefulWidget {
  const VehiclesMovementsScreen(BuildContext context, {super.key});


  @override
  State <VehiclesMovementsScreen> createState() =>  VehiclesMovementsScreenState();
}




class VehiclesMovementsScreenState extends State<VehiclesMovementsScreen> {

  Future<List<VehiclesInfo>>? vehiclesListFuture;
  List<VehiclesInfo>? vehiclesList;
  List<DropdownMenuItem<Vehicles>> vehiclesItems = [];

  String vehicleID = "";
  Vehicles? selectedVehicle;

  Stream<QuerySnapshot<VehiclesInfo>>? vehiclesSnapshots;




  @override
  initState() {
    super.initState();

    initialize();
  }


  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Vehicles');

  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //
  //   print(allData);
  // }

  initialize() async {


    downloadVehicles();
  }




  Future<void> downloadVehicles() async {
    QuerySnapshot  snapshot  = await
    FirebaseFirestore.instance.collection('Vehicles').where("userID", isEqualTo: "iN0aECMGBKdbuSSM1tyrYal1tB43")
        .get();

    setState(() {
      vehiclesItems.clear();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        String vehicleId = document.id;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['id'] = vehicleId;

        final Vehicles v = Vehicles.fromJson(data);
        vehiclesItems.add(
          DropdownMenuItem(
            value: v,
            child: Text(v.data.brand),
          ),
        );

        if(vehiclesItems.isNotEmpty){
          selectedVehicle = vehiclesItems[0].value;
          vehicleID = selectedVehicle!.data.id;

        }

        //print(vehiclesItems);
      }
    });





  }





  @override
  Widget build(BuildContext context) {



    return
      Scaffold(


        body:

        Center(
          child: Column(children: [


             Padding(
              padding: const EdgeInsets.all(20.0),
              child: DropdownButtonFormField2<Vehicles>(
                items: vehiclesItems,
                value: selectedVehicle,

                onChanged: (value) {
                  // Handle the selected categoryID
                  setState(() {
                    selectedVehicle = value;
                    vehicleID = value!.data.id;

                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select a vehicle',
                  border: OutlineInputBorder(),

                ),
              ),
            ),
        //  },
     //   ),






        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('History')
                .where('vehicleID', isEqualTo: vehicleID) // Add your where clause here
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                      String title ;
                      int categoryID =  data?['categoryID'];
                      if (data != null && data.containsKey('description')) {
                        // Access the field
                         title = data['description'];
                      } else {
                        title = 'Ανεφοδιασμός';

                      }

                      return ListTile(

                        leading:             (categoryID == 1 ? const Icon(Icons.local_gas_station_outlined , color:  Colors.blue)
                            :  Icon(Icons.build_outlined , color: Colors.red[500] ,)

                        ),
                        title: Row(
                          children: <Widget>[

                            const SizedBox(width: 8), // Add spacing between the icon and text
                            Text(title),
                          ],
                        ),

                        subtitle:
                        getSubtitle(categoryID , data ),
                        // Column(
                        //  // crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     Text('Line 2'),
                        //     Text('Line 3'),
                        //   ],
                        // ),


                        onTap: () {
                          // Handle the selected categoryID
                          print("Selected categoryID: $title");
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),


            ],
          ),
        ),
      );
  }




  Widget getSubtitle(int categoryID, Map<String, dynamic>? historyDataMap ){
    if (categoryID == 1){
      return getGasTile(historyDataMap);
    }
    else if (categoryID == 2){
      return getRepairTile(historyDataMap);

    }

    return Container();
  }





  Widget getGasTile(Map<String, dynamic>? historyDataMap ){


    return

       Column(children: [

        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(historyDataMap!['litres'].toString()) ,
              SizedBox(width: 20), // Adds 20 pixels of space
              Text(convertTimestampToDateStr(historyDataMap['date'])) ,

            ],
          ),
        ),



         Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(children: [
            Text(historyDataMap['distance'].toString()) ,
            SizedBox(width: 20), // Adds 20 pixels of space
            Text(historyDataMap['money'].toString()) ,
          ],),
        ),

      ],
      )
    ;

  }


  Widget getRepairTile(Map<String, dynamic>? historyDataMap ){

    return
      Column(children: [

        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(historyDataMap!['remarks'].toString()) ,
              SizedBox(width: 20), // Adds 20 pixels of space
              Text(convertTimestampToDateStr(historyDataMap['date'])) ,

            ],
          ),
        ),



        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(children: [
            Text(historyDataMap['odometer'].toString()) ,
            SizedBox(width: 20), // Adds 20 pixels of space
            Text(historyDataMap['money'].toString()) ,
          ],),
        ),


        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(children: [
            Text(historyDataMap['nextOdometer'].toString()) ,
          ],),
        ),



      ],
      );

  }



}













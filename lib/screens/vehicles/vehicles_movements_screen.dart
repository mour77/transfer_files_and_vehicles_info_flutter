import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/vehicles/add_repair_dialog.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/vehicles/history_type_dialog.dart';
import 'package:transfer_files_and_vehicles_info_flutter/firebase/firebase_methods.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/gas_types.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/history_types.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/order_types.dart';
import 'package:transfer_files_and_vehicles_info_flutter/shared_preferences.dart';

import '../../dialogs/vehicles/add_gas_dialog.dart';
import '../../dialogs/vehicles/add_vehicle_dialog.dart';
import '../../dialogs/vehicles/order_type_dialog.dart';
import '../../my_entities/utils.dart';
import '../../my_entities/vehicles.dart';


class VehiclesMovementsScreen extends StatefulWidget {
  const VehiclesMovementsScreen(BuildContext context, {super.key});


  @override
  State <VehiclesMovementsScreen> createState() =>  VehiclesMovementsScreenState();
}




class VehiclesMovementsScreenState extends State<VehiclesMovementsScreen> {

  List<DropdownMenuItem<Vehicles>> vehiclesItems = [];

  String vehicleID = "";
  int historyTypeID = 0;
  String orderBy = "date";
  bool isDescending = true;
  Vehicles? selectedVehicle;
  final _key = GlobalKey<ExpandableFabState>();

  final firestoreInstance = FirebaseFirestore.instance;
  String userID = FirebaseAuth.instance.currentUser!.uid;


  @override
  initState() {
    super.initState();
    initialize();
  }


  //CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Vehicles');


  initialize() async {

    downloadVehicles();
  }


  Future<void> downloadVehicles() async {
    print('userid ' + userID);
    QuerySnapshot  snapshot  = await
    FirebaseFirestore.instance.collection('Vehicles').where("userID", isEqualTo: userID).get();

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
            child:
            Row(
              children: [

                SizedBox(width: 32, height: 58,
                  child: Image.asset('assets/' + data['logoLocalPath'],
                  ),
                ),
                //const SizedBox(width: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(v.data.brand + (v.data.model.isNotEmpty ? '   (${v.data.model})' : ''),
                    style: const TextStyle( fontSize: 18),),
                ),
              ],
            ),

          ),
        );

        if(vehiclesItems.isNotEmpty){
          selectedVehicle = vehiclesItems[0].value;
          vehicleID = selectedVehicle!.data.id;
          saveString(selectVehicleID, vehicleID);



        }

        //print(vehiclesItems);
      }
    });





  }


  void setCategory(HistoryTypes type){
    setState(() {
      historyTypeID = type.id;
    });
  }

  void setOrderBy(OrderByTypes type , bool tempIsDescending){
    setState(() {
      orderBy = type.name;
      isDescending = tempIsDescending;
    });
  }

  Stream<QuerySnapshot<Object?>> getMovementsQuery(){
    Query query = FirebaseFirestore.instance.collection('History').where('vehicleID', isEqualTo: vehicleID);
    if (historyTypeID > 0) {
      query = query.where('categoryID', isEqualTo: historyTypeID);
    }
    query = query.orderBy(orderBy, descending: isDescending);// Add your where clause here
    return query.snapshots();

  }


  void closeOrOpenFab(){
    final state = _key.currentState;
    state?.toggle();
  }




  @override
  Widget build(BuildContext context) {



    return
      Scaffold(

        floatingActionButtonLocation: ExpandableFab.location,



        floatingActionButton:


        ExpandableFab(
          key: _key,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.add),
            fabSize: ExpandableFabSize.regular,
            shape: const CircleBorder(),

          ),

          distance: 180,

          overlayStyle: ExpandableFabOverlayStyle(blur: 5, ),
          onOpen: () {
            debugPrint('onOpen');
          },
          afterOpen: () {
            debugPrint('afterOpen');
          },
          onClose: () {
            debugPrint('onClose');

          },
          afterClose: () {
            debugPrint('afterClose');
          },
          children: [
            // extended για να εχει κειμενο
            FloatingActionButton.small(

              tooltip: 'Add vehicle',
              heroTag: null,
              child: const Icon(Icons.add),
              onPressed: () {

                addVehicle(context, runMethod: downloadVehicles);
                closeOrOpenFab();

              },

            ),
            FloatingActionButton.small(
              tooltip: 'Add repair',
              heroTag: null,
              child: const Icon(Icons.build_outlined),
              onPressed: () async {
                String vehicleID = await getSavedString(selectVehicleID);
                setState(() {
                  addRepairHistory(context ,  vehicleID);
                });
                closeOrOpenFab();

              },
            ),
            FloatingActionButton.small(
              tooltip: 'Add gas',
              heroTag: null,
              child: const Icon(Icons.local_gas_station_outlined),
              onPressed: () async {
                String vehicleID = await getSavedString(selectVehicleID);
                setState(() {
                  addGasHistory(context , vehicleID);
                });
                closeOrOpenFab();

              },
            ),

            FloatingActionButton.small(
              tooltip: 'filter ',
              heroTag: null,
              child: const Icon(Icons.filter_alt),
              onPressed: () async {
                HistoryTypes? type = await showHistoryTypesDialog(context);
                if(type != null){
                  setState(() {
                    historyTypeID = type.id;
                  });
                }
                closeOrOpenFab();

              },
            ),


            FloatingActionButton.small(
              tooltip: 'order by',
              heroTag: null,
              child: const Icon(Icons.sort),
              onPressed: () async {
                OrderByTypes? type = await showOrderTypesDialog(context);
                if(type != null){
                  setState(() {
                    orderBy = type.name;
                  });
                  closeOrOpenFab();

                }
              },
            ),



          ],
        ),
        body:

        Center(
          child: Column(children: [


             Padding(
              padding: const EdgeInsets.all(20.0),
              child:

              GestureDetector(
                onLongPress: () {editVehicle(context , vehicleID, selectedVehicle?.data.toJson() , runMethod: downloadVehicles); }
                ,
                child: DropdownButtonFormField2<Vehicles>(
                  items: vehiclesItems,
                  value: selectedVehicle,
                  onChanged: (value) {

                    setState(() {
                      selectedVehicle = value;
                      vehicleID = value!.data.id;
                      saveString(selectVehicleID, vehicleID);
                    });
                  },

                  decoration: const InputDecoration(
                    labelText: 'Select a vehicle',
                    border: OutlineInputBorder(),

                  ),

                ),
              ),

            ),
        //  },
     //   ),






          Expanded(
            child: StreamBuilder<QuerySnapshot>(

              stream: getMovementsQuery(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                return ListView(
                      children: snapshot.data!.docs.map((document) {
                        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                        String historyID = document.id;
                        String title ;
                        int categoryID =  data?['categoryID'];
                        if (data != null && data.containsKey('description')) {
                          // Access the field
                           title = data['description'];
                        } else {
                          title = 'Ανεφοδιασμός';

                        }

                        return

                          Card(
                            margin: const EdgeInsets.only(right: 22, left: 22, top: 18, bottom: 12),
                              color: Colors.grey[200],


                            child:
                              ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                              leading:
                              Container(
                                padding: const EdgeInsets.only(right: 3.0),
                                decoration:  const BoxDecoration(
                                    border:  Border(
                                        right:  BorderSide( color: Colors.white24))),
                                child: (categoryID == 1 ? const Icon(Icons.local_gas_station_outlined , color:  Colors.blue)
                                    :  Icon(Icons.build_outlined , color: Colors.red[500] ,)

                                ),
                              ),

                              title: Row(
                                children: <Widget>[

                                  const SizedBox(width: 8), // Add spacing between the icon and text
                                  Text(title, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                ],
                              ),

                              subtitle:
                              getSubtitle(categoryID , data ),


                              onTap: ()  async {

                                // Handle the selected categoryID
                                print("Selected categoryID: $title");
                              },



                              onLongPress: (){

                                showListTileMenu(context,  historyID, data);
                              },

                                //trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red, size: 30.0)
                            )
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
          padding: const EdgeInsets.only(top: 22.0 ,left: 12 ,right: 12),
          child:

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Row(
                children: [
                  Icon(Icons.gas_meter_outlined , color:  Colors.teal[700]),
                  const SizedBox(width: 20),
                  Text(historyDataMap!['litres'].toString()),
                ],
              ) ,

              // Adds 20 pixels of space
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Icon(Icons.date_range_rounded , color:  Colors.red[900]),
                      const SizedBox(width: 12),
                      Text(convertTimestampToDateStr(historyDataMap['date'])),
                    ],
                  ),
                ),
              ) ,

            ],
          ),
        ),



         Padding(
           padding: const EdgeInsets.only(top: 15.0 ,left: 12 ,right: 12 , bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Row(
                children: [
                  Icon(Icons.speed_rounded ,  color:  Colors.lightBlue[800]),
                  const SizedBox(width: 20),
                  Text(historyDataMap['odometer'].toString()),
                ],
              ) ,



              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.euro ,  color:  Colors.yellow[800]),
                      const SizedBox(width: 12),
                      Text(historyDataMap['money'].toString()) ,
                    ],
                  ),
                ),
              ), // Adds 20 pixels of space
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
          padding: const EdgeInsets.only(top: 22.0 ,left: 12 ,right: 12),
          child:

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [


              Row(

                children: [
                  Icon(Icons.speed_rounded ,  color:  Colors.lightBlue[800]),

                  const SizedBox(width: 12), // Adds 20 pixels of space
                  Text(historyDataMap!['odometer'].toString()) ,
                ],
              ), // Adds 20 pixels of space



              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: SizedBox(
                  width: 120,
                  child:
                  Row(
                    children: [
                      Icon(Icons.date_range_rounded , color:  Colors.red[900]),
                      const SizedBox(width: 12),
                      Expanded(child: Text(convertTimestampToDateStr(historyDataMap['date'])) ,
                      )
                    ],
                  ),
                ),
              ), // Adds 20 pixels of space

              //SizedBox(width: 1,)
            ],
          ),
        ),



        Padding(
          padding: const EdgeInsets.only(top: 15.0 ,left: 12 ,right: 12),
          child: Container(
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.next_week_outlined ,  color:  Colors.lightBlue[800]),
                      const SizedBox(width: 12),

                      Expanded(child: Text(historyDataMap['nextOdometer'].toString())) ,
                    ],
                  ),
                ),

              const SizedBox(width: 32), // Adds 20 pixels of space


              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child:

                SizedBox(
                  width: 120,
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.euro ,  color:  Colors.yellow[800]),
                        const SizedBox(width: 12),
                        Text(historyDataMap['money'].toString()) ,
                      ],
                    ),
                  ),
                ),
              ), // Adds 20 pixels of space
            ],),
          ),
        ),


        Padding(
          padding: const EdgeInsets.only(top: 15.0 ,left: 12 ,right: 12 ,bottom: 12),
          child: Row(children: [
            const Icon(Icons.comment , color:  Colors.black87),
            const SizedBox(width: 20),
            Text(historyDataMap!['remarks'].toString()) ,


          ],
          ),
        ),



      ],
      );

  }










  void showListTileMenu(BuildContext context, String documentID, Map<String, dynamic>? data) {

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero, ancestor: overlay);
    final int categoryID =  data?['categoryID'];


    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + renderBox.size.height,
        position.dx + renderBox.size.width,
        position.dy + renderBox.size.height * 2,
      ),
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
          ),
        ),
      ],
    ).then((dynamic selected) async {
      if (selected != null) {
        if (selected == 'edit') {

          if(categoryID == 1){
            editGasHistory(context,  documentID,  data);
          }
          else if (categoryID == 2){
            editRepairHistory(context,  documentID,  data);
          }

        }


        else if (selected == 'delete') {
          deleteDocument("History", documentID);

        }
      }
    });
  }


}












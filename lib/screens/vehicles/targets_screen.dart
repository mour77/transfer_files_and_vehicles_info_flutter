import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:transfer_files_and_vehicles_info_flutter/dialogs/vehicles/add_movements.dart';
import 'package:transfer_files_and_vehicles_info_flutter/firebase/firebase_methods.dart';

import '../../dialogs/vehicles/add_gas_dialog.dart';
import '../../dialogs/vehicles/add_target_dialog.dart';
import '../../my_entities/utils.dart';
import '../../my_entities/Targets.dart';
import '../../shared_preferences.dart';


class TargetsScreen extends StatefulWidget {
  const TargetsScreen(BuildContext context, {super.key});


  @override
  State <TargetsScreen> createState() =>  TargetsScreenState();
}




class TargetsScreenState extends State<TargetsScreen> {

  List<DropdownMenuItem<Targets>> targetItems = [];
  //
  String targetID = "";
  Targets? selectedTarget;

  late Future _someDataLoadingFuture;

  final firestoreInstance = FirebaseFirestore.instance;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  bool isEditPressed = false;
  bool isDeletePressed = false;

  final TextEditingController  _remainingCostController = TextEditingController(text: '');
  double totalCostOfSelectedTarget = 0;




  @override
  initState() {
    super.initState();

    initialize();
  }




  initialize() async {

    print('usrid ' + userID);
    _someDataLoadingFuture = downloadTargets();


   // downloadTargets().then((value) => setRemainingCost());
  }






  Future<void> downloadTargets() async {

    print('mpika download');

    QuerySnapshot  snapshot  = await
    FirebaseFirestore.instance.collection('Targets').where("uid", isEqualTo: userID).get();


      targetItems.clear();
      // print('megethos ${snapshot.size}');

      for (QueryDocumentSnapshot document in snapshot.docs) {
        String targetID = document.id;
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['id'] = targetID;

        final Targets v = Targets.fromJson(data);
        targetItems.add(
          DropdownMenuItem(
            value: v,
            child:
            Row(
              children: [
                Text('${v.data.title}      (${v.data.totalCost})'),
              ],
            ),
          ),
        );



        //print(targetItems);
      }

      setState(() {
        if(targetItems.isNotEmpty){
          selectedTarget = targetItems[0].value;
          totalCostOfSelectedTarget = double.parse(targetItems[0].value!.data.totalCost);
          targetID = selectedTarget!.data.id;
          saveString(selectTargetID, targetID);

          getRemainingCost();
        }
      });




   // await getRemainingCost();


  }



  Future<void> getRemainingCost () async {

    await FirebaseFirestore.instance.collection('Targets').where(FieldPath.documentId, isEqualTo: targetID).get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        var remCost = value.docs.first['remaining_cost'];
        if(remCost is int){
          _remainingCostController.text =  double.parse(remCost.toString()).toString();
        }
        else{
          _remainingCostController.text = remCost.toString();
        }

        if (targetItems.isNotEmpty){
          for (var element in targetItems) {
            if (element.value!.data.id == targetID){
                element.value!.data.remainingCost = _remainingCostController.text;
                return;
            }
          }
        }
      }

    });



  }




  Future<void> updateRemainingCost() async {
    QuerySnapshot  snapshot  = await
    FirebaseFirestore.instance.collection('Movements').where("targetID", isEqualTo: targetID).get();

    setState(() {
      // print('megethos ${snapshot.size}');
      double tempTotalCost = 0;
      for (QueryDocumentSnapshot document in snapshot.docs) {
        var cost = document['cost'];
        if(cost is int){
          tempTotalCost = tempTotalCost + double.parse(cost.toString());
        }
        else{
          tempTotalCost = tempTotalCost + cost;
        }

        //print(targetItems);
      }


     // print(tempTotalCost);
     // print(totalCostOfSelectedTarget);
     // _remainingCostController.text = (totalCostOfSelectedTarget - tempTotalCost).toString();

      if(snapshot.docs.isNotEmpty){
        Map<String, dynamic> map = {
          "remaining_cost" : totalCostOfSelectedTarget - tempTotalCost
        };
        print(targetID);

        updateDocument("Targets", targetID, map , showToastMsg: false).then((value) => getRemainingCost());
      }


    });





  }



  Future<void> DownloadTargetsAndUpdateRemainingCost() async {
    downloadTargets().then((value) => updateRemainingCost());
  }

  @override
  Widget build(BuildContext context) {



    return
      Scaffold(

        floatingActionButtonLocation: ExpandableFab.location,

        floatingActionButton: ExpandableFab(

          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: const Icon(Icons.add),
            fabSize: ExpandableFabSize.regular,
            shape: const CircleBorder(),
          ),


          overlayStyle: ExpandableFabOverlayStyle(blur: 5, ),

          children: [
            // extended για να εχει κειμενο
            FloatingActionButton.small(

              tooltip: 'Add target',
              heroTag: null,
              child: const Icon(Icons.playlist_add),
              onPressed: () {
                addTarget(context);
              },

            ),


            FloatingActionButton.small(

              tooltip: 'Add movement',
              heroTag: null,
              child: const Icon(Icons.app_registration_rounded),
              onPressed: () {
                addMovement(context, targetID, updateRemainingCost);
              },

            ),

          ],
        ),








        body:

        Center(
          child:
          Column(children: [


            Row(
              children: [

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child:
                    GestureDetector(

                      onLongPress: (){
                        editTarget(context, targetID, selectedTarget!.data.toJson(), runMethod: DownloadTargetsAndUpdateRemainingCost );
                      },

                      child: DropdownButtonFormField2<Targets>(
                        items: targetItems,
                        value: selectedTarget,


                        onChanged: (value) {
                          // Handle the selected categoryID
                          setState(() {

                            _remainingCostController.text = value!.data.remainingCost.toString();
                            totalCostOfSelectedTarget = double.parse(value.data.totalCost);
                            print("totalCostOfSelectedTarget $totalCostOfSelectedTarget");

                            selectedTarget = value;
                            targetID = value.data.id;
                            print(targetID);

                            saveString(selectTargetID, targetID);

                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select target',
                          border: OutlineInputBorder(),

                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns children to the space between the start and end
              children: [
                const Spacer(), // This widget takes up any remaining space
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 22),
                  child: SizedBox(
                    width: 120,
                    height: 32,
                    child: TextField(
                      textAlign: TextAlign.center, // Center-align the text
                      controller: _remainingCostController,
                      readOnly: true,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          labelText: 'Remaining cost',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.black, fontSize: 12.0)),
                    ),
                  ),
                ),
              ],
            ),





            Expanded(
              child:


              FutureBuilder(
                future: _someDataLoadingFuture,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {


                    return
                      StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Movements')
                          .where('targetID', isEqualTo: targetID) 
                          .orderBy("date", descending: true)// Add your where clause here
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {

                          return const CircularProgressIndicator();
                        }

                        return ListView(
                          children: snapshot.data!.docs.map((document) {
                            Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
                            String movementID = document.id;
                            String title = data?['title'];


                            return

                              Card(
                                  margin: const EdgeInsets.only(right: 22, left: 22, top: 18, bottom: 12),
                                  color: Colors.grey[200],


                                  child:

                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                                    // leading:
                                    // Container(
                                    //   padding: const EdgeInsets.only(right: 3.0),
                                    //   decoration:  const BoxDecoration(
                                    //       border:  Border(
                                    //           right:  BorderSide( color: Colors.white24))),
                                    //     child:  Icon(Icons.arrow_upward_outlined , color: Colors.green[500] ,)
                                    //
                                    //
                                    // ),

                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: <Widget>[

                                        const Padding(
                                          padding: EdgeInsets.only(left: 12.0),
                                          child: Icon(Icons.text_snippet , color: Colors.blue ,),
                                        ),
                                        Expanded(child:

                                        Padding(
                                          padding: const EdgeInsets.only(left:20.0 ),
                                          child: Text(
                                            title, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                        )
                                        ),


                                        Row(
                                          children: [

                                            IconButton(
                                              icon: const Icon(Icons.edit) ,
                                              color:  Colors.lightBlue,
                                              onPressed: () {
                                                setState(() {
                                                  isEditPressed = !isEditPressed;
                                                  editMovement(context, movementID, data , updateRemainingCost);

                                                });

                                              },
                                            ),

                                            IconButton(icon:  const Icon(Icons.clear) ,  color:  Colors.red[800],

                                              onPressed: () {
                                                setState(() {
                                                  isDeletePressed = !isDeletePressed;
                                                });
                                                deleteDocument("Movements", movementID, runMethod: updateRemainingCost );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),




                                    subtitle:
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [

                                          Row(
                                            children: [
                                              Icon(Icons.euro ,  color:  Colors.yellow[800]),
                                              const SizedBox(width: 20,),
                                              Text(data!['cost'].toString(), style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                            ],
                                          ),


                                          Row(
                                          children: [
                                            Icon(Icons.date_range_outlined ,  color:  Colors.lightBlue[800]),
                                            const SizedBox(width: 20,),
                                            Text(convertTimestampToDateStr(data!['date']),
                                              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),),
                                          ],
                                        ),



                                      ],

                                      ),
                                    ),


                                    onTap: ()  async {

                                      print("Selected categoryID: $title");
                                    },



                                    //trailing: Icon(Icons.keyboard_arrow_right, color: Colors.red, size: 30.0)
                                  )
                              );
                          }).toList(),
                        );
                      },
                    );




                  }
                  else{
                    return const CircularProgressIndicator();
                  }
                  return const CircularProgressIndicator();
                }





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

                  const SizedBox(width: 20), // Adds 20 pixels of space
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

                Row(
                  children: [
                    Icon(Icons.edit_calendar_rounded ,  color:  Colors.lightBlue[800]),
                    const SizedBox(width: 20),
                    Text(historyDataMap['nextOdometer'].toString()) ,
                  ],
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













}












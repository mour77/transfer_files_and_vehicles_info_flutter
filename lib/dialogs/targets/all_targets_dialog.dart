

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/history_types.dart';

//showSelectedTargetsTotalCostDialog

class ShowSelectedTargetsTotalCostDialog extends StatefulWidget {

  @override
  _ShowSelectedTargetsTotalCostDialogState createState() => _ShowSelectedTargetsTotalCostDialogState();
}

class _ShowSelectedTargetsTotalCostDialogState extends State<ShowSelectedTargetsTotalCostDialog> {
  // Firestore collection reference
  String userID = FirebaseAuth.instance.currentUser!.uid;

  // List of items retrieved from Firestore
  List<DocumentSnapshot> items = [];
  Map<String, bool> itemCheckedState = {};
  TextEditingController totalCostController = TextEditingController();
  double totalCost = 0;
  double totalRemainingCost = 0;

  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore
    fetchData();
  }

  Future<void> fetchData() async {
  final CollectionReference myCollection = FirebaseFirestore.instance.collection('Targets');
  QuerySnapshot querySnapshot = await myCollection.where("uid", isEqualTo: userID).get();
    setState(() {
      items = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        title: const Text('Select targets'),
        content:

        SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [

              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                textAlign: TextAlign.center, // Center-align the text
                controller: totalCostController,
                readOnly: true,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 22, horizontal: 10),
                    labelText: 'Total and remaining costs',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.black, fontSize: 12.0)),
              ),

              ListView.builder(
                shrinkWrap: true,


                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  String itemId = item.id; // Assuming the Firestore document has an ID field

                  // Initialize the checked state for each item
                  itemCheckedState.putIfAbsent(itemId, () => false);

                  return
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ListTile(
                      title: Text(item['title']), // Adjust the field name as per your Firestore document
                      trailing:

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.euro ,  color:  Colors.yellow[800]),
                          const SizedBox(width: 12,),
                          Text(item["total_cost"].toString()),
                          Checkbox(
                            value: itemCheckedState[itemId]!,
                            onChanged: (value) {
                              setState(() {
                                itemCheckedState[itemId] = value!;
                                if (value) {
                                  totalCost = totalCost + item['total_cost'];
                                  totalRemainingCost = totalRemainingCost + item['remaining_cost'];
                                }
                                else{
                                  totalCost = totalCost - item['total_cost'];
                                  totalRemainingCost = totalRemainingCost - item['remaining_cost'];
                                }

                                totalCostController.text =
                                    'Total: $totalCost\n\nRemaining: $totalRemainingCost';
                              });
                            },
                          ),

                        ],
                      ),


                  //  leading:

                  ),
                    );
                },
              ),
            ],
          ),
        ),
      );  }
}
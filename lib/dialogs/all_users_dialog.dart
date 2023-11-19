import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowAllUsersDialog extends StatefulWidget {

  @override
  _ShowAllUsersDialogDialogState createState() => _ShowAllUsersDialogDialogState();
}

class _ShowAllUsersDialogDialogState extends State<ShowAllUsersDialog> {
  // Firestore collection reference
  String userID = FirebaseAuth.instance.currentUser!.uid;

  // List of items retrieved from Firestore
  List<DocumentSnapshot> items = [];
  Map<String, bool> itemCheckedState = {};


  @override
  void initState() {
    super.initState();
    // Fetch data from Firestore
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      items = usersSnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        title: const Text('Select users'),
        content:

        SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [

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
                        title: Text(item['displayName']),
                        subtitle: Text(item['givenName']),
                        trailing:

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Checkbox(
                              value: itemCheckedState[itemId]!,
                              onChanged: (value) {
                                setState(() {

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


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/utils.dart';



Future<void> updateDocument(String collectionName, String documentId , Map<String, dynamic> map ,{bool showToastMsg = true} ) async {
  try{
    final CollectionReference collection =
    FirebaseFirestore.instance.collection(collectionName);

    // Update the field 'field_to_update' to a new value
    await collection.doc(documentId).update(map);

    if (showToastMsg){
      showMsg("updated");
    }


  }
  catch(error){
    showMsg(error.toString());

  }
}



Future<void> addDocument(String collectionName,  Map<String, dynamic> map ) async {
  try{

    // Update the field 'field_to_update' to a new value

    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance.collection(collectionName).add(map);
    showMsg("saved");

  }
  catch(error){
    showMsg(error.toString());

  }
}





Future<void> deleteDocument(String collectionName, String documentId , {bool showToastMsg = true , Future<void> Function()? runMethod}) async {
  try{
    final CollectionReference collection =
    FirebaseFirestore.instance.collection(collectionName);

    // Delete the document with the specified document ID
    await collection.doc(documentId).delete();
    if(showToastMsg) {
      showMsg("Deleted");
    }

    if (runMethod != null){
      runMethod();
    }

  }
  catch(error){
    showMsg(error.toString());

  }

}


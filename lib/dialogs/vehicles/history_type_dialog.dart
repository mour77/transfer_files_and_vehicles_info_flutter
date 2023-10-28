

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/history_types.dart';

Future<HistoryTypes?>  showHistoryTypesDialog(BuildContext context) async {

  Completer<HistoryTypes?> completer = Completer<HistoryTypes?>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text("Επιλέξτε κατηγορία"),
        children: <Widget>[

          SimpleDialogOption(
            onPressed: () {

              Navigator.of(context).pop();
              completer.complete(HistoryTypes.none);

            },
            child: const Text("Κανένα"),
          ),

          SimpleDialogOption(
            onPressed: () {

              Navigator.of(context).pop();
              completer.complete(HistoryTypes.refuel);

            },
            child: const Text("Ανεφοδιασμός"),
          ),

          SimpleDialogOption(
            onPressed: () {

              Navigator.of(context).pop();
              completer.complete(HistoryTypes.repair);

            },
            child: const Text("Επισκευή"),
          ),

        ],
      );
    },
  );

  return completer.future;
}
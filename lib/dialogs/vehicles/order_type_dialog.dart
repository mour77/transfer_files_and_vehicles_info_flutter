

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/order_types.dart';

Future<OrderByTypes?> showOrderTypesDialog(BuildContext context) async {

  Completer<OrderByTypes?> completer = Completer<OrderByTypes?>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return
        SimpleDialog(
        title: const Text("Με σειρά"),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(OrderByTypes.date);

            },
            child: const Text("Ημερομηνία"),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(OrderByTypes.odometer);

            },
            child: const Text("Οδόμετρο"),
          ),

          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(OrderByTypes.money);

            },
            child: const Text("Κόστος"),
          ),

        ],

      );

    },

  );
  return completer.future;
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/select_first_screen.dart';


import '../../shared_preferences.dart';


class VehiclesMovementsScreen extends StatefulWidget {
  const VehiclesMovementsScreen(BuildContext context, {super.key});


  @override
  State <VehiclesMovementsScreen> createState() =>  VehiclesMovementsScreenState();
}




class VehiclesMovementsScreenState extends State<VehiclesMovementsScreen> {



  @override
  initState() {
    super.initState();

    initialize();
  }


  initialize() async {



  }


  @override
  Widget build(BuildContext context) {



    return
      Scaffold(


        body: Text('xaxaxaxa'),
      );
  }


}













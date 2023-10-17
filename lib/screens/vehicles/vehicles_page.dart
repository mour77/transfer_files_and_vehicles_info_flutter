import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/utils.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/transferScreens/settings_transfer_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/vehicles/vehicles_movements_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/vehicles/vehicles_settings_screen.dart';
import 'package:flutter/material.dart';

import '../../dialogs/add_gas_dialog.dart';
import '../../dialogs/add_repair_dialog.dart';
import '../../dialogs/add_vehicle_dialog.dart';
import '../../dialogs/edittext_for_dialogs.dart';




class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key, required this.title});


  final String title;

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  int currentIndex = 0;
  String title = "";
  List<Widget> _screens = [];



  @override
  Widget build(BuildContext context) {
    _screens = [
      VehiclesMovementsScreen(context),
      SettingsVehiclesScreen(context),

    ];


    return

      Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          overlayStyle: ExpandableFabOverlayStyle(blur: 5,),
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
                showVehicleDialog(context, true);
              },

            ),
            FloatingActionButton.small(
              tooltip: 'Add repair',
              heroTag: null,
              child: const Icon(Icons.build_outlined),
              onPressed: () {
                showRepairDialog(context , true, 'IFUdPOun9zqHqfN39s6Z');
              },
            ),
            FloatingActionButton.small(
              tooltip: 'Add gas',
              heroTag: null,
              child: const Icon(Icons.local_gas_station_outlined),
              onPressed: () {
                showGasDialog(context , true, 'IFUdPOun9zqHqfN39s6Z');

              },
            ),
          ],
        ),


        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child:
                IndexedStack(
                  index: currentIndex,
                  children: _screens,
                ),


              ),
            ],
          ),
        ),


        bottomNavigationBar:   BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: Colors.indigoAccent, size: MediaQuery.of(context).size.height * 0.022),
          selectedItemColor: Colors.indigoAccent,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          currentIndex: currentIndex,
          onTap: onTabTapped,

          type: BottomNavigationBarType.fixed,

          items: getBottomNavItems(),
        ),// This trailing comma makes auto-formatting nicer for build methods.
      );
  }


  List<BottomNavigationBarItem> getBottomNavItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_repair_service_outlined),
        label:  'Movements',
      ),


      const BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        label: 'Settings',
      ),


    ];
  }


  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;


      switch(index){
        case 0: {title =  'Movements';}
        break;
        case 1: {title ='Settings';}
        break;

      }
    });
  }


}







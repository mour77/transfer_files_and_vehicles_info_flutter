import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/vehicles/targets_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/vehicles/vehicles_movements_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/vehicles/vehicles_settings_screen.dart';




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
      TargetsScreen(context),
      SettingsVehiclesScreen(context),

    ];


    return

      Scaffold(



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
        label:  'History',
      ),


      const BottomNavigationBarItem(
        icon: Icon(Icons.track_changes_sharp),
        label: 'Targets',


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
        case 0: {title =  'History';}
        break;
        case 1: {title = 'Targets';}
        break;
        case 2: {title = 'Settings';}
        break;

      }
    });
  }


}







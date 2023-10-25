import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/select_first_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/login_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/transferScreens/settings_transfer_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/transferScreens/transfer_page.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/vehicles/vehicles_movements_screen.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/vehicles/vehicles_page.dart';

import '../firebase_options.dart';
import 'transferScreens/upload_photo_screen.dart';
import 'transferScreens/download_screen.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});




  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String title = "";
  List<Widget> _screens = [];
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[

    TransferPage(title: ''),
    VehiclesPage(title: ''),


  ];


  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async{
    int id = await getSelectedFirstScreen();

    setState(() {
      if(id == SelectFirstScreen.transferFiles.id) {
        _selectedIndex = 0;
      } else {
        _selectedIndex = 1;
      }
    });



    await Firebase.initializeApp(

      options: DefaultFirebaseOptions.currentPlatform,

    );




  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _manageTitle(_selectedIndex);
    });
  }

  void _manageTitle(int index){
    if(_selectedIndex == 0){
      title = 'Transfer Files';
    }
    else{
      title = 'Vehicles';
    }

  }


  @override
  Widget build(BuildContext context) {
    // _screens = [
    //   DownloadScreen(context),
    //   CameraScreen(context),
    //   UploadScreen(context),
    //
    // ];


    return

      Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [

            IconButton(
              icon:  const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ));
              },
            ),
          ],
        ),
        body:
        Center(
          child: _widgetOptions[_selectedIndex],
        ),



        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),


              ListTile(
                title: const Text('Transfer files'),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);

                  Navigator.pop(context);

                },
              ),
              ListTile(
                title: const Text('Vehicles'),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);


                  Navigator.pop(context);
                },
              ),

            ],
          ),
        ),

      );
  }




}


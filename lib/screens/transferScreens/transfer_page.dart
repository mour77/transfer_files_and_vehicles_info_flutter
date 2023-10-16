import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/transferScreens/settings_transfer_screen.dart';

import 'upload_photo_screen.dart';
import 'download_screen.dart';



class TransferPage extends StatefulWidget {
  const TransferPage({super.key, required this.title});



  final String title;

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  int currentIndex = 0;
  String title = "";
  List<Widget> _screens = [];



  @override
  Widget build(BuildContext context) {
    _screens = [
      DownloadScreen(context),
      CameraScreen(context),
      SettingsTransferScreen(context),

    ];


    return

      Scaffold(

        // appBar: AppBar(
        //   title: Text(title),
        //   actions: [
        //     (currentIndex == 0 ?
        //
        //   IconButton(
        //       icon:  const Icon(Icons.refresh_outlined),
        //       onPressed: () async {
        //
        //       },
        //     ) : Container()
        //
        //     ),
        //     IconButton(
        //       icon:  const Icon(Icons.logout),
        //       onPressed: () async {
        //
        //       },
        //     ),
        //   ],
        // ),
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
          icon: Icon(Icons.file_download_outlined),
          label:  'Download',
        ),

      const BottomNavigationBarItem(
          icon: Icon(Icons.add_a_photo_outlined),
          label: 'Photo Upload',
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
          case 0: {title =  'Transfer files';}
          break;
          case 1: {title ='Photo upload';}
          break;
          case 2: {title ='Settings';}
          break;

        }
      });
    }


}







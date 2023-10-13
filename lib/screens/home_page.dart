import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/upload_screen.dart';

import 'camera_screen.dart';
import 'download_screen.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  String title = "";
  List<Widget> _screens = [];


  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });


    @override
    initState(){
      super.initState();
      //currentIndex = 2;

    //  title = Language.lit(Settings.getLang(), 'Patients|Ασθενείς');

    }
  }

  @override
  Widget build(BuildContext context) {
    _screens = [
      DownloadScreen(context),
      UploadScreen(context),
      CameraScreen(context),

    ];


    return

      Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
          icon:  const Icon(Icons.logout),
          onPressed: () async {

           // String response = await logout();
          //  print('logoutResponse   ' + response);

           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyLogin()));


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
          icon: Icon(Icons.file_download_outlined),
          label:  'Download',
        ),

      const BottomNavigationBarItem(
          icon: Icon(Icons.file_upload_outlined),
          label: 'Upload',
        ),

      const BottomNavigationBarItem(
          icon: Icon(Icons.add_a_photo_outlined),
          label: 'Camera Upload',
        ),


      ];
    }


    void onTabTapped(int index) {
    setState(() {
      currentIndex = index;


        switch(index){
          case 0: {title =  'Ασθενείς';}
          break;
          case 1: {title ='Appointments';}
          break;
          case 2: {title ='test';}
          break;

        }
      });
    }


}







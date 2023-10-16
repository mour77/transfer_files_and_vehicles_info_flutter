import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/screens/home_page.dart';

import '../firebase_options.dart';
import 'login_screen.dart';
import 'transferScreens/transfer_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});




  Future<void> initApp() async {


  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      // routes: {
      //   'login': (context) => MyLogin(),
      //   'splash': (context) => SplashScreen(),
      //   'settings': (context) => Settings(),
      //   'home': (context) => HomePage(),
      //   'patientMain': (context) => PatientMain(0,"", "", 0, "", ""),
      // },

    );
  }
}



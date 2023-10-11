import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen(BuildContext context);


  @override
  State <UploadScreen> createState() =>  UploadScreenState();
}





class UploadScreenState extends State<UploadScreen> {
  int currentIndex = 0;
  String title = "";



  @override
  initState(){
    super.initState();


  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('titlos'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'test',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () {  },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
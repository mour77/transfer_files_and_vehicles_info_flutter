import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/File.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/http_methods.dart';

class DownloadScreen extends StatefulWidget {
  DownloadScreen(BuildContext context);


  @override
  State <DownloadScreen> createState() =>  DownloadScreenState();
}


class DownloadScreenState extends State<DownloadScreen> {
  int currentIndex = 0;
  String title = "";

  List<MyFiles> lista = [];
  Future<List<MyFiles>>? listaFuture ;


  @override
  initState(){
    super.initState();

   // lista = ;

    initList();

  }


  Future<void> initList() async {
    List<Map<String, dynamic>> disksList = await apiGetRequest('/displayHardDisks');
    lista = disksList.map((map) => MyFiles.fromJsonDisks(map)).toList();

  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(


      body:
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery
                    .of(context)
                    .size
                    .width * 0.01),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  //searchString = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                 // labelText: Language.lit(Settings.getLang(), 'Search|Αναζήτηση'),
                  suffixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * 0.01),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final obj = lista[index];
                return ListTile(
                  title: Text(obj.name),
                  subtitle: Text('Name: ${obj.name.toString()}'),
                );
              },
            ),
          ),
        ],
      )


 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
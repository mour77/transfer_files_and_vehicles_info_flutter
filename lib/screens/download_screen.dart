import 'package:flutter/material.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/File.dart';

class DownloadScreen extends StatefulWidget {
  DownloadScreen(BuildContext context);


  @override
  State <DownloadScreen> createState() =>  DownloadScreenState();
}


class DownloadScreenState extends State<DownloadScreen> {
  int currentIndex = 0;
  String title = "";

  List<MyFiles> lista = [];


  @override
  initState(){
    super.initState();

   // lista = ;

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
            child: FutureBuilder(
              builder: (context, AsyncSnapshot<List<MyFiles>> snapshot) {
                if (snapshot.hasData) {
                  return
                    Center(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return
                            snapshot.data![index].name.isNotEmpty
                              ? ListTile(
                            title: Text('${snapshot.data?[index].name}'),
                            //.title
                            subtitle: RichText(
                              text: const TextSpan(children: [

                                TextSpan(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),

                                TextSpan(
                                    style: TextStyle(color: Colors.grey)),

                              ]),

                            ),
                            onTap: () {

                            },
                          )
                              : Container();
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return
                            snapshot.data![index].name //.title
                              .isNotEmpty
                              ? Divider()
                              : Container();
                        },
                      ),
                    );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }
                return CircularProgressIndicator();
              },
              // future: shows,
              future: lista,
            ),
          ),
        ],
      )


 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
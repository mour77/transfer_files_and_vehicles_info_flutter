import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/File.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/http_methods.dart';

import '../file_manager.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen(BuildContext context, {super.key});


  @override
  State <DownloadScreen> createState() =>  DownloadScreenState();
}


class DownloadScreenState extends State<DownloadScreen> {
  int currentIndex = 0;
  String title = "";

  List<MyFiles> lista = [];
  final TextEditingController pathController = TextEditingController();



  @override
  initState(){
    super.initState();

    pathController.text = "";
    initListDisks();

  }


  void initListDisks()  async {

    List<Map<String, dynamic>> disksList = await apiGetRequest('/displayHardDisks');
    setState(() {
      lista = disksList.map((map) => MyFiles.fromJsonDisks(map)).toList();
      print(lista);
    });

    //lista;

  }


  void _getFiles  () async {
    List<Map<String, dynamic>> disksList = await apiGetRequest('/displayFiles?path=${pathController.text}');
    setState(() {
      lista = disksList.map((map) => MyFiles.fromJson(map)).toList();

      print(lista);
    });

  }




  @override
  Widget build(BuildContext context) {



    return

      Scaffold(

          floatingActionButton: FloatingActionButton(
            onPressed: pickFile,
            tooltip: 'upload',
            child: const Icon(Icons.upload),
          ),
      body:
      Column(

        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
           padding: const EdgeInsets.all(12),

            child: Row(
              children: [
                Expanded(
                //  padding: EdgeInsets.symmetric(
                //       horizontal: MediaQuery
                //           .of(context)
                //           .size
                //           .width * 0.01),
                  child: TextField(
                    controller: pathController,

                    readOnly: true,
                    decoration: const InputDecoration(
                        labelText: 'Path',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                        border: OutlineInputBorder(),
                        counterText: '',
                        hintStyle: TextStyle(color: Colors.black, fontSize: 14.0)),
                  ),


                ),


                IconButton(
                  icon: const Icon(Icons.backspace_outlined),
                  onPressed: () {
                    setState(() {

                      String fullPath = pathController.text;
                      if (fullPath.endsWith("://")){
                        pathController.text = '';
                        initListDisks();

                        return;
                      }

                      int  pos = fullPath.lastIndexOf("//");
                      String substring = fullPath.substring(0, pos);


                      //gia tous diskous einai auto
                      if(substring.endsWith(":")) {
                        substring = "$substring//";
                      }

                      pathController.text = substring;


                      _getFiles();
                    });
                  },
                ),

            ],
            ),
          )
          ,





          SizedBox(height: MediaQuery
              .of(context)
              .size
              .height * 0.01),
          Expanded(

            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 22),
              child: ListView.builder(
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  final file = lista[index];
                  return
                    ListTile(
                      title: Text(file.name + (file.ext.isNotEmpty ? ".${file.ext}" : "")),
                      trailing: getIconForFile(file.ext),

                      onTap: (){
                      if(file.ext.isNotEmpty) {
                        openSelectedFile(file.name, file.ext, file.path);

                        return;
                      }

                      if(file.path.isEmpty) {
                        pathController.text = pathController.text + file.name.replaceAll("\\", "//");
                      }
                      else{
                        pathController.text =  file.path.replaceAll("\\", "//");
                        print('path ' +file.path );

                      }

                        _getFiles();
                      },
                  );
                },
              ),
            ),
          ),
        ],
      )


 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }




  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      // Handle the selected file, for example, display its path:
      print('File path: ${file.path}');
      sendFile(file.path!);


    } else {
      // User canceled the file selection.
      print('File selection canceled.');
    }
  }

}
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../file_manager.dart';
import '../my_entities/File.dart';
import 'package:path/path.dart' ;

import '../my_entities/http_methods.dart';


class UploadScreen extends StatefulWidget {
  const UploadScreen(BuildContext context, {super.key});


  @override
  State <UploadScreen> createState() =>  UploadScreenState();
}




class UploadScreenState extends State<UploadScreen> {

  int currentIndex = 0;
  String title = "";

  List<FileSystemEntity> listaSystem = [];
  List<MyFiles> lista = [];
  final TextEditingController pathController = TextEditingController();




  @override
  initState(){
    super.initState();

    initList();
  }


  initList() async {
    listaSystem =  await listFilesAndDirectoriesInInternalStorage();

    for (var entity in listaSystem) {


      if (entity is File) {
        print('File: ${entity.path}');

        File file = entity;
        int size = await file.length();
        MyFiles myFile  = MyFiles(
            name: basenameWithoutExtension(file.path),
            ext: extension(file.path),
            path: file.path,
            fileSize: size,
            isFolder: false,
            isDisk: false);

        lista.add(myFile);


      } else if (entity is Directory) {
        Directory dir = entity;
        MyFiles myFile  = MyFiles(
            name: basenameWithoutExtension(dir.path),
            ext: '',
            path: dir.path,
            fileSize: 0,
            isFolder: true,
            isDisk: false);
        lista.add(myFile);

        print('Directory: ${entity.path}');
      }
    }

  }



  void _getFiles  () async {

    print('selected path ' + pathController.text);
    List<FileSystemEntity>  fileSystemList = await  listFilesInExternalDirectory(pathController.text);
    setState(() {

      lista.clear();

      for (FileSystemEntity entity in fileSystemList) {
        print(basenameWithoutExtension(entity.path));
        if (entity is File) {
          print('File: ${entity.path}');

          File file = entity;
          int size = file.lengthSync();
          MyFiles myFile  = MyFiles(
              name: basenameWithoutExtension(file.path),
              ext: extension(file.path),
              path: file.path,
              fileSize: size,
              isFolder: false,
              isDisk: false);

          lista.add(myFile);


        } else if (entity is Directory) {
          Directory dir = entity;
          MyFiles myFile  = MyFiles(
              name: basenameWithoutExtension(dir.path),
              ext: '',
              path: dir.path,
              fileSize: 0,
              isFolder: true,
              isDisk: false);
          lista.add(myFile);

          print('Directory: ${entity.path}');
        }

      }






      //lista = disksList.map((map) => MyFiles.fromJson(map)).toList();

    });

  }

  @override
  Widget build(BuildContext context) {



    return


      Scaffold(


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
                      onPressed: () async {

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


                        setState(() {

                          // String fullPath = pathController.text;
                          //
                          // int  pos = fullPath.lastIndexOf("/");
                          // String substring = fullPath.substring(0, pos);
                          //
                          // pathController.text = substring;
                          //
                          //
                          // _getFiles();
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





  Future<List<FileSystemEntity>> listFilesAndDirectoriesInInternalStorage() async {
    try {
      Directory d = await getApplicationDocumentsDirectory();
      print('monopati   ' + d.path);

     // Directory? directory = await getDownloadsDirectory(); mono macos

      // String path = await ExtStorage.getExternalStoragePublicDirectory(
      //     ExtStorage.DIRECTORY_DOWNLOADS);


      final internalStorageDir = await getApplicationDocumentsDirectory();
      pathController.text = internalStorageDir.path;
      if (internalStorageDir == null) {
        throw FileSystemException('Internal storage directory not found');
      }

      List<FileSystemEntity> filesAndDirs = await internalStorageDir.list().toList();
      return filesAndDirs;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }


  Future<List<FileSystemEntity>> listFilesInExternalDirectory(String directoryPath) async {
    try {
      Directory externalDir = Directory(directoryPath);

      if (await externalDir.exists()) {
        List<FileSystemEntity> filesAndDirs = await externalDir.list().toList();
        return filesAndDirs;

      } else {
        throw FileSystemException('Directory does not exist');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }



}
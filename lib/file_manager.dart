

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'my_entities/fileDataJSON.dart';

void openSelectedFile(String? fileName, String? fileExt ,String filePath) async {



  List<FileData> lista = await readFileByteNew(filePath);


  print('xaxaxaxaxa ' + lista[0].fileData);


  Uint8List bytes = base64.decode(lista[0].fileData);

  //EDW
  var androidInfo = await DeviceInfoPlugin().androidInfo;
  var sdkInt = androidInfo.version.sdkInt;
  var status;

  final dir;
  if(Platform.isAndroid){
    if(sdkInt! <= 29) { // android versions till 10
      dir = await getExternalStorageDirectory();
    }else{ //newer android versions like 11, 12
      dir = await FilePicker.platform.getDirectoryPath(); // Choose directory Dialog

    }
  }else{ //iOS
    dir = await getApplicationSupportDirectory();
  }


  status = await Permission.storage.request().isGranted;


  if(status) {
    File temp;
    if(sdkInt! <= 29){
      temp = File('${dir!.path}/$fileName.$fileExt');
      File('$dir/$fileName.$fileExt').writeAsBytes(bytes);
      await temp.writeAsBytes(bytes);

      await OpenFile.open(temp.path);
    }else {

   //   temp = File('${dir!}/$fileName.$fileExt');

      temp = File('${dir!}/$fileName.$fileExt');

      temp = await File('$dir/$fileName.$fileExt').writeAsBytes(bytes);

     // await temp.writeAsBytes(bytes);

      FilePickerResult? result = await FilePicker.platform.pickFiles();
      String? pathFile = temp.path;
      if (result != null) {
        pathFile = result.files.single.path;
      }
      final _result = await OpenFile.open(pathFile);
    }



  }


}



Icon getIconForFile(String ext) {

  switch (ext.toLowerCase()) {
    case '':
      return  Icon(Icons.folder_copy_rounded, color: Colors.yellow[500], );

    case 'pdf':
      return Icon(Icons.picture_as_pdf, color: Colors.red[500]);

    case 'doc':
    case 'docx':
      return Icon(Icons.file_open, color: Colors.blue[500]);

    default:
      return const Icon(Icons.file_copy_outlined);

  }


}

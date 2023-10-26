

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'my_entities/fileDataJSON.dart';

void downloadAndOpenSelectedFile(String? fileName, String? fileExt ,String filePath, BuildContext context) async {

  ProgressDialog pr =  ProgressDialog(context,type: ProgressDialogType.download, isDismissible: true, showLogs: true);
  pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: const CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      textAlign: TextAlign.center,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
  );



  await pr.show();

  List<FileData> lista = await readFileByteNew(filePath);

  await pr.hide();





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
      print('skata     ' + temp.path.toString());

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

    case 'xls':
    case 'xlsx':
      return Icon(Icons.document_scanner, color: Colors.green[500]);

      //'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'bmp':
    case 'webp':
      return const Icon(Icons.image_outlined, color: Colors.blue);

    case 'avi':
    case 'mkv':
    case 'mov':
      return Icon(Icons.video_file_outlined, color: Colors.red[300]);


    case 'mp3':
    case 'wav':
    case 'flac':
    case 'ogg':
    return Icon(Icons.music_note, color: Colors.orange[500]);


    default:
      return const Icon(Icons.file_copy_outlined);

  }


}


playMusic(String fileName) async {
  print(fileName);
  AudioPlayer audioPlayer = AudioPlayer();
  String audioPath = '';
  try {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      //audioPath = '${directory.path}/Music/soundtest.wav'; // Replace with the correct file name and extension
      audioPath = 'storage/emulated/0/Music/$fileName'; // Replace with the correct file name and extension
      //storage/emulated/0/Music/soundtest.wav
    }
  } catch (e) {
    print('Error getting the storage directory: $e');
  }

  await audioPlayer.play(UrlSource(audioPath));

}

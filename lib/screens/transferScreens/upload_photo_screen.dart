

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/utils.dart';

import '../../my_entities/http_methods.dart';



class CameraScreen extends StatefulWidget {
  CameraScreen(BuildContext context);


  @override
  State <CameraScreen> createState() =>  CameraScreenState();
}



class CameraScreenState extends State<CameraScreen> {
  int currentIndex = 0;
  String title = "";
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  File? imageFile;



    @override
    initState(){
      super.initState();



    }


  @override
  Widget build(BuildContext context) {



    return Scaffold(

      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            displayCapturedPhoto()

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'uploadTag',
        tooltip: 'camera',
        onPressed: () {  initializeCamera(); },
        child: const Icon(Icons.camera_alt_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }







  void initializeCamera() async {

    final status = await Permission.camera.request();
    if (status.isGranted) {
      print('mpike');
    } else {
      print('den mpike');
    }

    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    // Initialize the camera with the first available camera
    final firstCamera = cameras?.first;
    cameraController = CameraController(firstCamera!, ResolutionPreset.medium);
    await cameraController?.initialize();

    takePhoto();
  }


  Future<void> takePhoto() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      // User canceled photo capture
      return;
    }
    else{
      setState(() {
        imageFile = File(image.path);
      });
      saveImageToTheDeviceAndSendItToServer();


    }


  }


  Widget displayCapturedPhoto() {
    return imageFile != null
        ? Image.file(
      imageFile!,
      width: 532,
      height: 480,
    )
        : Container();
  }







  Future<void> saveImageToTheDeviceAndSendItToServer() async {
    if (await Permission.photos.request().isGranted) {
    // Request permission to access the photo gallery if not already granted.

    final result = await ImageGallerySaver.saveFile(imageFile!.path);

    if (result != null) {
      sendFile(imageFile!.path,"C://transferPhotoFolder");

    // The image was successfully saved to the gallery.
      showMsg('Η φωτογραφία αποθηκεύτηκε');
    }
    else {
      showMsg('Failed to save the image to the gallery.');
    }
    }
    else {
      showMsg('Permission to access the photo gallery is denied.');
    }

  }
}






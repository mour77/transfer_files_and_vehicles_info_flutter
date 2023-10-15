import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../file_manager.dart';
import '../my_entities/File.dart';
import 'package:path/path.dart' ;

import '../my_entities/http_methods.dart';
import '../shared_thumbnail.dart';


class UploadScreen extends StatefulWidget {
  const UploadScreen(BuildContext context, {super.key});


  @override
  State <UploadScreen> createState() =>  UploadScreenState();
}




class UploadScreenState extends State<UploadScreen> {

  bool showThumbnail = false;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  initState() {
    super.initState();

    initialize();
  }


  initialize() async {

    showThumbnail = await isThumbnailOn();
    _urlController.text = await getSavedString(urlSP);
    _portController.text = await getSavedString(portSP);
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

      body:

      SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Γενικά'),
            tiles: <SettingsTile>[
              // SettingsTile.navigation(
              //   leading: const Icon(Icons.language),
              //   title: const Text('Language'),
              //   value: const Text('English'),
              // ),

              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    showThumbnail = value;
                    setThumbnail(showThumbnail);

                  });
                },
                initialValue: showThumbnail,
                leading: const Icon(Icons.image_outlined),
                title: const Text('Show thumbnail'),
              ),


              SettingsTile(title: Container(),
                value:  TextField(
                    controller: _urlController,

                    decoration: const InputDecoration(
                    labelText: 'url',
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5),
                    ),
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(color: Colors.black, fontSize: 14.0)),
                    onChanged:  (text) {
                      saveString( urlSP,text);
                    },
                ),
              ),

              SettingsTile(title: const Text(''),
              value:  TextField(
                  controller: _portController,
                  decoration: const InputDecoration(
                  labelText: 'port',


                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 0.5),
                  ),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.black, fontSize: 14.0)),
                  keyboardType: TextInputType.number,

                onChanged:  (text) {
                    saveString( portSP,text);
                  },

                ),
              ),

            ],

          ),
        ],
      ),
    );
  }


}













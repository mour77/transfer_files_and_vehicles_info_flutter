import 'dart:io';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/select_first_screen.dart';


import '../../shared_preferences.dart';


class SettingsVehiclesScreen extends StatefulWidget {
  const SettingsVehiclesScreen(BuildContext context, {super.key});


  @override
  State <SettingsVehiclesScreen> createState() =>  SettingsVehiclesScreenState();
}




class SettingsVehiclesScreenState extends State<SettingsVehiclesScreen> {

  bool showThumbnail = false;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  SelectFirstScreen? _selectedFirstScreen;

  @override
  initState() {
    super.initState();

    initialize();
  }


  initialize() async {

    showThumbnail = await isThumbnailOn();
    _urlController.text = await getSavedString(urlSP);
    _portController.text = await getSavedString(portSP);

    int id = await getSelectedFirstScreen();
    if(id == SelectFirstScreen.transferFiles.id) {
      _selectedFirstScreen = SelectFirstScreen.transferFiles;
    } else {
      _selectedFirstScreen = SelectFirstScreen.vehicles;
    }

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





                SettingsTile(title: const Text('Select starting screen'),
                  value:
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Transfer files'),
                        leading: Radio<SelectFirstScreen>(
                          value: SelectFirstScreen.transferFiles,
                          groupValue: _selectedFirstScreen,
                          onChanged: (SelectFirstScreen? value) {
                            setState(() {
                              _selectedFirstScreen = value;
                              setFirstScreen(_selectedFirstScreen!);
                            });
                          },
                        ),
                      ),

                      ListTile(
                        title: const Text('Vehicles'),
                        leading: Radio<SelectFirstScreen>(
                          value: SelectFirstScreen.vehicles,
                          groupValue: _selectedFirstScreen,
                          onChanged: (SelectFirstScreen? value) {
                            setState(() {
                              _selectedFirstScreen = value;
                              setFirstScreen(_selectedFirstScreen!);

                            });

                          },
                        ),
                      ),
                    ],
                  ),


                )

              ],

            ),
          ],
        ),
      );
  }


}













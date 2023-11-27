import 'dart:io';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/select_first_screen.dart';


import '../../dialogs/all_users_dialog.dart';
import '../../my_entities/targets_order_by.dart';
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
  TargetsOrderBy? selectedOrderBy;

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


    String orderByColName = await getSavedString(targetsListOrderBy);
    selectedOrderBy = TargetsOrderBy.values.where((element) => element.colName == orderByColName).single;
    selectedOrderBy ??= TargetsOrderBy.title;

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
                ),



                SettingsTile(title: const Text('Targets list order by'),
                  value:
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        SegmentedButton<TargetsOrderBy>(
                          segments: const <ButtonSegment<TargetsOrderBy>>[
                            ButtonSegment<TargetsOrderBy>(
                                value: TargetsOrderBy.title,
                                label: Text('Title'),
                                icon: Icon(Icons.text_format_rounded)),
                            ButtonSegment<TargetsOrderBy>(
                                value: TargetsOrderBy.totalCost,
                                label: Text('Total cost'),
                                icon: Icon(Icons.monetization_on_outlined),

                            ),
                            ButtonSegment<TargetsOrderBy>(
                                value: TargetsOrderBy.remainingCost,
                                label: Text('Remaining cost'),
                                icon: Icon(Icons.money_off)),

                            // ButtonSegment<TargetsOrderBy>(
                            //     value: TargetsOrderBy.date,
                            //     label: Text('Date'),
                            //     icon: Icon(Icons.calendar_today)
                            // ),
                          ],

                          selected: <TargetsOrderBy>{selectedOrderBy??= TargetsOrderBy.title},
                          onSelectionChanged: (Set<TargetsOrderBy> newSelection) {
                            setState(() {

                              selectedOrderBy = newSelection.first;
                              saveString(targetsListOrderBy, selectedOrderBy?.colName ?? TargetsOrderBy.title.colName);
                            });
                          },
                        ),

                      ],
                    ),
                  ),
                ),

                SettingsTile(title: const Text('Manage'),
                  value:  ListTile(
                      onTap: () => showDialog(context: context, builder: (context) => const ShowAllUsersDialog(targetID: '')),

                    leading: const Icon(Icons.track_changes_sharp),
                    title: const Text('Share target'),
                    trailing: const Icon(Icons.arrow_forward_rounded)

                  ),

                  )
                ,


                  ],

            ),

          ],
        ),
      );
  }


}













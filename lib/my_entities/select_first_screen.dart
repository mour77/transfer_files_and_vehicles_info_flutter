

import 'package:transfer_files_and_vehicles_info_flutter/shared_preferences.dart';

enum SelectFirstScreen {
  transferFiles(1),
  vehicles(2);

  const SelectFirstScreen(this.id);
  final int id;
}

void setFirstScreen(SelectFirstScreen screen){
  saveInt(selectFirstScreen, screen.id);
}

Future<int> getSelectedFirstScreen() async {
  return getSavedInt(selectFirstScreen);
}
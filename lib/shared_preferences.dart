

import 'package:shared_preferences/shared_preferences.dart';

const String _showThumbnail = "showThumbnail";
const String _getInfoFromMyServer = "getInfoFromMyServer";
const String urlSP = "url";
const String portSP = "port";
const String imageServerPath = "imageServerPath";

const String selectFirstScreen = "selectFirstScreen";

const String selectVehicleID = "selectVehicledID";
const String selectTargetID = "selectTargetID";

const String targetsListOrderBy = "targetsListOrderBy";
const String movementsListOrderBy = "movementsListOrderBy";


void  saveString(String settings, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(settings, value);
}


Future<String> getSavedString(String settings) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(settings) ?? '';
}



void  saveInt(String settings, int value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt(settings, value);
}


Future<int> getSavedInt(String settings) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt(settings) ?? 0;
}




void  setThumbnail(bool thumbnail) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_showThumbnail, thumbnail);
}


Future<bool> isThumbnailOn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_showThumbnail) ?? false;
}



void  setMyServerInfo(bool isMyServerOn) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_getInfoFromMyServer, isMyServerOn);
}



Future<bool> isMyServerInfoOn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_getInfoFromMyServer) ?? false;
}


import 'package:shared_preferences/shared_preferences.dart';

const String _showThumbnail = "showThumbnail";
const String urlSP = "url";
const String portSP = "port";
const String imageServerPath = "imageServerPath";


void  saveString(String settings, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(settings, value);
}


Future<String> getSavedString(String settings) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(settings) ?? '';
}



void  setThumbnail(bool thumbnail) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_showThumbnail, thumbnail);
}


Future<bool> isThumbnailOn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_showThumbnail) ?? false;
}


import 'dart:convert';

bool isValidJSON(String str){
  try {
    var decodedJSON = json.decode(str) as Map<String, dynamic>;
    return true;
  } on FormatException catch (e) {
    return false;
  }
}

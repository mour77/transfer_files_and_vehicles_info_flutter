

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:transfer_files_and_vehicles_info_flutter/my_entities/utils.dart';




Future<List<Map<String, dynamic>>> apiGetRequest(String endpoint ,{Map<String, String> headers = const{}}) async {

  // String url = "http://" + ipAddress + ":" + port + "/api/v2/" + endpoint;
 // String url = await getURL(endpoint);
 // String token = await getToken();

  String url = "http://192.168.254.51:32008"   + endpoint;
  String token = "32008";

  print( "url " + url);

  Map<String, String>  headersMap =
  <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept-Charset': 'utf-8',
  };

  if(headers.isNotEmpty) {
    headersMap.addAll(headers);
  }


  final  response = await
  get(
    Uri.parse(url),
    headers: headersMap,
  );

  String responseBody = utf8.decode(response.bodyBytes);

  if (response.statusCode == 200) {

    List<dynamic> jsonData = [];
    dynamic parsedJSON = json.decode(responseBody);
    if (parsedJSON is List)
      jsonData = parsedJSON;
    else{
      jsonData.add(parsedJSON);
    }

    // List<dynamic> jsonData = json.decode(responseBody);
    List<Map<String, dynamic>> dataList = jsonData.map((item) => item as Map<String, dynamic>).toList();

    // If the server returns a 200 OK response, parse the JSON
    return dataList;

  } else {

    List<Map<String, dynamic>> errorListMap = [];
    bool isJSON = isValidJSON(responseBody);

    if(isJSON){
      Map<String, dynamic> errorMap = json.decode(responseBody);
      errorListMap.add(errorMap);
      return errorListMap;

    }
    else{
      String errorMsg = responseBody.substring(responseBody.indexOf("error=" ), responseBody.length -1);
      Map<String, dynamic> errorMap = {"error" : errorMsg};
      errorListMap.add(errorMap);
    }
    // If the server did not return a 200 OK response, throw an exception.

    return errorListMap;

  }


}





Future<void> sendFile(String filePath) async {
  try {
    // Replace with the URL of the server to which you want to send the file
    final url = Uri.parse('http://192.168.254.51:32008/uploadFile?filePath=D://');

    // Create a MultipartRequest to send the file
    final request = MultipartRequest('POST', url);

    // Create a File object from the file you want to upload
    File file = File(filePath); // Replace with the actual file path

    // Attach the file to the request
    request.files.add(await MultipartFile.fromPath('file', file.path));

    // Send the request
    final response = await request.send();

    // Check the response status
    if (response.statusCode == 200) {
      print('File uploaded successfully.');
    } else {
      print('Failed to upload file. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

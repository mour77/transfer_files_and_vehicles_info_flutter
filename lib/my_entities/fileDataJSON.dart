
import 'http_methods.dart';

class FileData {
  final String fileData;


  const FileData({
    required this.fileData,
  });

  factory FileData.fromJson(Map<String, dynamic> json) {

    // json["results"];
    return FileData(
      fileData: json['dataStr'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileData'] = fileData;

    return data;
  }



}








  Future<List<FileData>> readFileByteNew(String filePath) async {

    Future<List<Map<String, dynamic>>> list =  apiGetRequest('/downloadFile?filePath=$filePath'.replaceAll("\\", "//"));
    List<FileData>  fileList =  await convertListToFileDataList(list);

    return fileList;

  }


  Future<List<FileData>> convertListToFileDataList(Future<List<Map<String, dynamic>>> mapListFuture ) async {
    final List<Map<String, dynamic>> mapList = await mapListFuture;

    final List<FileData> fileDataList = [];

    for (final Map<String, dynamic> map in mapList) {
      final FileData fileDataItem;

      fileDataItem = FileData.fromJson(map); // Replace with actual parsing logic.
      fileDataList.add(fileDataItem);
    }
    return fileDataList;

  }


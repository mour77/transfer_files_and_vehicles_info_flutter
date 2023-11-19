import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

Future<void> createExcel(List<String> args) async {
  //var file = "/Users/kawal/Desktop/excel/test/test_resources/example.xlsx";
  //var bytes = File(file).readAsBytesSync();
  var excel = Excel.createExcel();
  // or
  //var excel = Excel.decodeBytes(bytes);
  Sheet sheetObject = excel['SheetName'];

  CellStyle cellStyle = CellStyle(backgroundColorHex: '#1AFF1A', fontFamily :getFontFamily(FontFamily.Calibri));

  cellStyle.underline = Underline.Single; // or Underline.Double


  var cell = sheetObject.cell(CellIndex.indexByString('A1'));
  cell.value = 8; // dynamic values support provided;
  cell.cellStyle = cellStyle;

// printing cell-type
  print('CellType: '+ cell.cellType.toString());

  ///
  /// Inserting and removing column and rows

// insert column at index = 8
  sheetObject.insertColumn(8);

// remove column at index = 18
  sheetObject.removeColumn(18);

// insert row at index = 82
  sheetObject.insertRow(82);

// remove row at index = 80
  sheetObject.removeRow(80);


  List<int>? fileBytes = excel.save();
  //print('saving executed in ${stopwatch.elapsed}');
  if (fileBytes != null) {
    Directory directory = await getApplicationDocumentsDirectory();
    if (!directory.existsSync()){
      directory.createSync();
    }
    final excelFilePath = '${directory.path}/example.xlsx';


    List<int>? nullableList = excel.encode(); // Your nullable list
    List<int> nonNullableList = nullableList ?? []; // Pr

    print('xaxaxaax');
    print(directory);
    print(excelFilePath);
    print(nonNullableList);

    File(excelFilePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(nonNullableList);

    print(File(excelFilePath).existsSync());
    print(File(excelFilePath).path);
    print(File(excelFilePath).absolute.path);

    //final result = await OpenFile.open(excelFilePath);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
  }
}


class MyFiles {

  final String name, ext, path;
  final int fileSize;
  final bool isFolder;
  final bool isDisk ;

  MyFiles({
    required this.name,
    required this.ext,
    required this.path,
    required this.fileSize,
    required this.isFolder,
    required this.isDisk,
  });


  factory MyFiles.fromJson(Map<String, dynamic> json) {

    // json["results"];
    return MyFiles(
      name: json['name'] as String,
      ext: json['ext'] as String,
      path: json['path'] as String,
      fileSize: json['fileSize'] as int,
      isFolder: json['folder'] as bool,
      isDisk: false,

    );
  }

  factory MyFiles.fromJsonDisks(Map<String, dynamic> json) {

    // json["results"];
    return MyFiles(
      name: json['name'] as String,
        ext: '' , path: '',
        fileSize: 0, isFolder: false,
        isDisk : true);


  }
}






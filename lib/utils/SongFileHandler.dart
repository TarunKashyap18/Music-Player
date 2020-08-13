import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';

class SongsFileHandler{
  //  for getting every single song path list from given path
  Future<List<String>> getSongsPathListFromStorage(String path)async{
    var root=new Directory(path) ;
    List<String> songsPathList = [];
    var songFiles = await FileManager(root: root)
        .filesTree(extensions: ["mp3"]);
    for(int i=0;i<songFiles.length;i++)
      songsPathList.add(songFiles[i].path);
    return songsPathList;
  }
  //getting files names form their path
  String getFilesName(String filePath){
    File file= new File(filePath);
    return file.path.split('/').last;
  }
  loadThumbnailImage(String filePath) {
    File file = new File(filePath);
    ImageProvider image=FileImage(File(filePath));
    print(image.runtimeType);
    return image;
//    print(_albumArtImage.runtimeType);
//    return _albumArtImage;
  }

}
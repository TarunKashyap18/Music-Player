import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';

class QueueHandler{
  List<String> _queueList;
  List<Audio> _queuePlaylist;
  int index;
  var currentSong;

  QueueHandler(){
    _queueList=[];
    index=0;
    currentSong=null;
  }


  set queueList(List<String> value) {
    _queueList = value;
  }

  addToQueue(String item){
    if(_queueList.isEmpty) {
      _queueList.add(item);
      Audio audio =Audio(item);
      _queuePlaylist.add(audio);
    }
    else if(!_queueList.contains(item) ) {
      _queueList.add(item);
    }
  }
  getCurrentSong(){
    currentSong=_queueList[index];
  return  _queueList[index];
  }
  getNextSong(){
    if(index < _queueList.length-1)
      index+=1;
    else
      return ;
    print("Next song index : $index");
//    nextSong=_queueList[index];
    return _queueList[index];
  }
  getPreviousSong(){
    if(index== 0)
      return ;
    else
      index-=1;
//    previousSong=_queueList[index];
    print("Previous song index : $index");
    return _queueList[index];
  }
  getQueueList(){
//    return _queueList;
  return _queuePlaylist;
  }
  getSongName(){
    var currSong=_queueList[index];
    File file= new File(currSong);
    return file.path.split('/').last;
  }
  queueEmpty(){
    return _queueList.isEmpty;
  }
}
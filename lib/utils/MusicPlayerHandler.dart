import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/animation.dart';
import 'package:my_music/utils/QueueHandler.dart';
class MusicPlayerHandler{

  final audioPlayer= AssetsAudioPlayer();
  QueueHandler queueHandler;
  bool isSongPlaying;
  bool isPlayerStarted;

  MusicPlayerHandler(){
   isSongPlaying=false;
   isPlayerStarted=false;
   queueHandler=new QueueHandler();
  }
  playSong(String path){
    if(isSongPlaying){
      audioPlayer.playOrPause();
    }
    else{
      if(isPlayerStarted){
        audioPlayer.playOrPause();
      }
      else {
        audioPlayer.open(
          Audio.file(path),
          autoStart: true,
          showNotification: true,
        );
        isPlayerStarted=!isPlayerStarted;
      }
    }
    isSongPlaying=!isSongPlaying;
  }
  playNextOrPrevious(String path){
    audioPlayer.open(
      Audio.file(path),
      autoStart: true,
      showNotification: true,
    );
//    isSongPlaying=!isSongPlaying;
    isPlayerStarted=!isPlayerStarted;
  }
  disposeMusicPlayer(){
    audioPlayer.dispose();
  }

}
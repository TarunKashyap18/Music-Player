import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_music/utils/MusicPlayerHandler.dart';
import 'package:my_music/utils/SongFileHandler.dart';
import 'package:my_music/utils/PermissionHandler.dart';
import 'package:my_music/utils/QueueHandler.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';

List<String>_data=[];
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'MyMusic'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  List<StorageInfo> _storageInfo = [];
  String songName="";
  var internalStoragePath ;
  var externalStoragePath;
  var playerSize=2;
  var listSize=8;
  var playOrPauseIcon=Icons.play_arrow;
  bool playerVisibility=false;
  bool listVisibility =true;
  var currentSong;
//  AnimationController playPauseController;

  MyPermissionStorage permissionStorage =new MyPermissionStorage();
  SongsFileHandler _songsFileHandler=new SongsFileHandler();
  MusicPlayerHandler _musicPlayerHandler=new MusicPlayerHandler();
  QueueHandler _queueHandler = new QueueHandler() ;
  @override

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission(Permission.storage);
    initPlatformState();
//    playPauseController = AnimationController(vsync: this,duration: Duration(milliseconds: 200));
  }
  void getPermission(Permission permission){
    permissionStorage.getStoragePermission(permission);
  }

//  Getting storage information like internal storage and external storage and their paths

  Future<void> initPlatformState() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}
    if (!mounted)
      return;
    setState(() {
      _storageInfo = storageInfo;
    });
    if(storageInfo.length>0)
      setState(() {
        internalStoragePath = _storageInfo[0].rootDir;
      });
    if(storageInfo.length > 1)
      setState(() {
        externalStoragePath = _storageInfo[1].rootDir;
      });
  }
  _getVisibilityOfMusicPlayer(){
    if(_queueHandler.queueEmpty())
      setState(() {
        playerVisibility=false;
      });
    else
      setState(() {
        playerVisibility=true;
      });
  }
  updateName(String name) {
    setState(() {
      songName=name;
    });
  }
  playerContainer(){
   return Visibility(
        visible: playerVisibility,
        child: Expanded(
          flex: playerSize,
          child: Container(
            child:Column(
              children: <Widget>[
                Center(
                    child:InkWell(
                      child:  Icon(Icons.keyboard_arrow_up,color:Colors.white,size:20 ,),
//                        onTap: (){
//                          setState(() {
//                            listVisibility!=listVisibility;
//                            playerSize=9;
//                          });
//                        },
                    )
                ),
                Text("Now Playing",style:TextStyle(
                    color:Colors.white
                ),),
                Text("$songName",style:TextStyle(
                    color:Colors.white
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.skip_previous,size: 40,color:Colors.white), onPressed:(){
//                      songManger(_queueHandler.getPreviousSong());
                    _musicPlayerHandler.playNextOrPrevious(_queueHandler.getPreviousSong());
                    updateName(_queueHandler.getSongName());

                    }),
                    IconButton(icon: Icon(playOrPauseIcon,size:40,color:Colors.white,), onPressed:(){
                        songManger(_queueHandler.getCurrentSong());
                        updateName(_queueHandler.getSongName());
                    }),
                    IconButton(icon: Icon(Icons.skip_next,size: 40,color:Colors.white,), onPressed:(){
//                      songManger(_queueHandler.getNextSong());
                    _musicPlayerHandler.playNextOrPrevious(_queueHandler.getNextSong());
                    updateName(_queueHandler.getSongName());
                    }),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  void songManger(var song) {
    if(!_musicPlayerHandler.isSongPlaying)
      setState(() {
        playOrPauseIcon=Icons.pause;
      });
    else
      setState(() {
        playOrPauseIcon=Icons.play_arrow;
      });
    _musicPlayerHandler.playSong(song);
  }

  listContainer(){
    return Visibility(
        visible: listVisibility,
        child: Expanded(
          flex: listSize,
          child: Container(
            child:FutureBuilder<List>(
                future: _songsFileHandler.getSongsPathListFromStorage(internalStoragePath),
                builder: (context , snapshot) {
                  if (snapshot.hasData) {
                    _data = snapshot.data;
                    return ListView.builder(
                        itemCount: _data.length ,
                        padding: const EdgeInsets.all(5.0),
                        itemBuilder:(BuildContext context,int index){
                          return Column(
                            children: <Widget>[
                              Divider(height: 6.0,),
                              ListTile(
                                title: Text(_songsFileHandler.getFilesName(_data[index])),
                                leading: CircleAvatar(
//                                        backgroundImage: _songsFileHandler.loadThumbnailImage(_data[index]),
                                  radius: 30,
                                ),
                                trailing:IconButton(
                                    icon: Icon(Icons.play_arrow,size: 30,color: Colors.white,),
                                    onPressed:(){
                                      _queueHandler.addToQueue(_data[index]);
                                      _getVisibilityOfMusicPlayer();
                                    }
                                ),
                                onLongPress: (){
                                  final snackBar= SnackBar(content: Text(_songsFileHandler.getFilesName(_data[index])));
                                  Scaffold.of(context).showSnackBar(snackBar);
                                },

                              ),
                            ],
                          ) ;
                        });
                  }
                  else if(snapshot.hasError)
                    return Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Cant load the music files"),
                        CircularProgressIndicator(),
                      ],
                    ));
                  else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("Loading Music files form device")
                        ],
                      ),
                    );
                  }
                }),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body:SafeArea(
        child:Column(
          children: <Widget>[
//            ********* List Container **********
            listContainer(),
//              player Container
            playerContainer(),
          ],
        ),
      ),
    );
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _musicPlayerHandler.disposeMusicPlayer();
  }

}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:amap_base_location/amap_base_location.dart';
import 'dart:io';
class UploadPage extends StatefulWidget {
  UploadPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UploadPage createState() => _UploadPage();
}

class _UploadPage extends State<UploadPage> {
  String _words;
  String _location;
  bool _privateStatus;
  List<File> _mediaFiles;
  VoidCallback listener;

  final int _maxFilesNumber = 9;

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    this._mediaFiles = [];
    super.initState();
  }

  void _scanVideo(ImageSource source) async {
    File video = await ImagePicker.pickVideo(source: source);
    if(video != null){
      bool different = true;
      for(File item in this._mediaFiles){
        if(item.path == video.path || this._mediaFiles.length == this._maxFilesNumber){
          different = false;
        }
      }
      if(different){
        setState(() {
          this._mediaFiles.add(video);
        });
      }
    }
  }

  void _scanImaage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    if(image != null){
      bool different = true;
      for(File item in this._mediaFiles){
        if(item.path == image.path || this._mediaFiles.length == this._maxFilesNumber){
          different = false;
        }
      }
      if(different){
        setState(() {
          this._mediaFiles.add(image);
        });
      }
    }
  }

  Widget _previewVideo(File file) {
    if (file != null) {
      String unixTime = DateTime.now().millisecondsSinceEpoch.toString();
      return VideoApp(Key(unixTime), file);
    }
    return Container();
  }

  Widget _previewImage(File file) {
    if (file != null) {
      return Image.file(file);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "發表",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            onPressed: () {
              //TODO:
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              _buildTextField(),
              Divider(),
              _buildFileListView(),
              Divider(),
              _buildLocationInfo(),
              Divider(),
            ],
          ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      autocorrect: false, // 是否自动校正
      autofocus: false, //自动获取焦点
      enabled: true, // 是否启用
      inputFormatters: [], //对输入的文字进行限制和校验
      keyboardType: TextInputType.text, //获取焦点时,启用的键盘类型
      maxLines: null, // 输入框最大的显示行数
      maxLength: 50, //允许输入的字符长度/
      maxLengthEnforced: true, //是否允许输入的字符长度超过限定的字符长度,不允许
      obscureText: false, // 是否隐藏输入的内容
      onChanged: (String value) {
        this._words = value;
      },
      onSubmitted: (String value) {
        this._words = value;
      },
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        labelText: "心情描述",
        border: OutlineInputBorder(), // 边框样式
        hintText: '不超過30字，言簡意賅......',
      ),
    );
  }

  Widget _buildFileListView() {
    List<Map<String, dynamic>> addButton = [
      {"ico": Icons.photo_library,"func": () {_scanImaage(ImageSource.gallery);}},
      {"ico": Icons.camera_alt,"func": () { _scanImaage(ImageSource.camera);}},
      {"ico": Icons.video_library,"func": () { _scanVideo(ImageSource.gallery); }},
      {"ico": Icons.videocam,"func": () { _scanVideo(ImageSource.camera);}},
    ];

    var buttons = addButton.map((item){
      MaterialColor color = Colors.deepPurple;
      if(addButton.indexOf(item) ~/ 2 > 0){
        color = Colors.red;
      }
      return Container(
        width: 45.0,
        child: FlatButton(
          onPressed: item["func"],
          child: CircleAvatar(
            radius: 15.0,
            backgroundColor: color,
            child: Icon(
              item["ico"],
              size: 20.0,
            ),
          ),
          padding: EdgeInsets.all(5.0),
        ),
      );
    }).toList();

    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Row(
                children: buttons,
              ),
              Expanded(
                child: Text(
                  "已選擇文件: " + this._mediaFiles.length.toString() + "/9",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.purple,
                      //fontWeight: FontWeight.bold,
                    ),
                ),
              ),
            ],
          ),
          _buildFileList(),
        ],
      ),
    );
  }

  Widget _buildFileList(){
    if(this._mediaFiles == null){
      return Container();
    }
    List<Widget> filesScan = this._mediaFiles.map((item){
      return _verifyFileType(item);
    }).toList();
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), //disable scroll
      crossAxisCount: 3,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: filesScan,
    );
  }

  Widget _verifyFileType(File file){
    List<String> imageType = ["bmp", "gif", "jpeg", "png", "tiff", "jpg", "ico"];
    List<String> videoType = ["mp4", "m4a", "fmp4", "webm", "matroska", "mp3", "ogg", "wav", "flv", "flac", "amr"];

    String newString = file.path.toLowerCase();
    int index = newString.lastIndexOf('.');
    String suffix = file.path.substring(index + 1);
    for(var item in imageType){
      if(suffix == item){
        return AspectRatio(
          aspectRatio: 1.0,
          child: Image.file(file, fit: BoxFit.cover,),
        );
      }
    }
    String unixTime = DateTime.now().millisecondsSinceEpoch.toString();
    for(var item in videoType){
      if(suffix == item){
        return  VideoApp(Key(unixTime), file);
      }
    }
  }

  Widget _buildLocationInfo(){
    return Container();
  }

  Widget _buildPrivateStatus(){
    return null;
  }
}



class VideoApp extends StatefulWidget {

  File file;

  VideoApp(Key key,this.file):super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: _controller.value.initialized? Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.0, // _controller.value.aspectRatio
                  child: VideoPlayer(_controller..setVolume(1.0)), //..setLooping(true)
                ),
            Center(
                child: GestureDetector(
                  onTap: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause(): _controller.play();
                  });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    foregroundDecoration: BoxDecoration(
                      color: Color.fromARGB(0, 0, 0, 0),
                    ),
                    child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 25, color: Colors.white,),
              ),
            ),
            ),
              ],
          ): Container(),
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
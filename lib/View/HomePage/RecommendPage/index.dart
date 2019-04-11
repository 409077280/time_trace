import 'package:flutter/material.dart';
import './searchPage.dart';
import '../../CameraPage/camera.dart';
import '../../UploadPage/imagePiker.dart';

class RecommendPage extends StatefulWidget {
  RecommendPage({Key key}) : super(key: key);
  @override
  createState() {
    return _RecommendPage();
  }
}

class _RecommendPage extends State<RecommendPage> {
  List<Map<String, dynamic>> _userRecords;
  ScrollController _scrollController;

  @override
  void initState() {
    this._scrollController = ScrollController();
    this._scrollController.addListener(_upPullToRefresh);
    //this._userRecords = null;
    this._userRecords = [
      {
        "id": 4654,
        "userImg": "http://www.didiao.co/uc_server/images/noavatar_middle.gif",
        "userName": "小盆友",
        "release_time": "2019-03-13 18:20:25",
        "words": "今天很开心又去玩耍了",
        "media": [
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009vtxtcfc06traaz5o.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009likk6ezxt55o1i8k.jpg",
        ],
        "locationInfo": "深圳市·南山区·滨海大道",
        "likeNumber": 98656,
        "commentNumber": 23,
      },
      {
        "id": 4654,
        "userImg":
            "http://www.huaclub.cc/uc_server/data/avatar/000/23/03/81_avatar_middle.jpg",
        "userName": "老钓友",
        "release_time": "2019-03-13 18:20:25",
        "words": "今天鱼多多，哈哈",
        "media": [
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009vtxtcfc06traaz5o.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009likk6ezxt55o1i8k.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009vtxtcfc06traaz5o.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009likk6ezxt55o1i8k.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009vtxtcfc06traaz5o.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009likk6ezxt55o1i8k.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009vtxtcfc06traaz5o.jpg",
          "http://www.huaclub.cc/data/attachment/forum/201903/13/070009likk6ezxt55o1i8k.jpg",
        ],
        "locationInfo": "深圳市·南山区·滨海大道",
        "likeNumber": 12,
        "commentNumber": 5,
      },
      {
        "id": 4654,
        "userImg":
            "http://www.huaclub.cc/uc_server/data/avatar/000/23/03/81_avatar_middle.jpg",
        "userName": "老钓友",
        "release_time": "2019-03-13 18:20:25",
        "words": "今天鱼多多，哈哈",
        "media": [],
        "locationInfo": "深圳市·南山区·滨海大道",
        "likeNumber": 12,
        "commentNumber": 5,
      },
    ];
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    this._scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.camera_enhance),
          iconSize: 30.0,
          onPressed: () {
            _jumpToNewPage(CameraPage());
          },
          color: Colors.white70,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              child: FlatButton.icon(
                onPressed: () {
                  _jumpToNewPage(SearchPage());
                },
                icon: Icon(Icons.search),
                label: Text("搜索暱稱或用戶名"),
                color: Colors.white30,
                textColor: Colors.white,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.file_upload),
          iconSize: 30.0,
          onPressed: () {
            _jumpToNewPage(UploadPage());
          },
          color: Colors.white70,
        )
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      child: RefreshIndicator(
        child: ListView(
          children: _buildUserRecords(),
          physics: const AlwaysScrollableScrollPhysics(),
          controller: this._scrollController,
        ),
        onRefresh: _downPullToRefresh,
      ),
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
    );
  }

  List<Widget> _buildUserRecords() {
    return this._userRecords.map((item) {
      return Container(
        child: Column(
          children: <Widget>[
            _buildUserImgAndName(item),
            _buildUserWords(item),
            _buildMediaGridView(item["media"]),
            _buildMapLocation(item),
            _buildLikeAndComment(item),
          ],
        ),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white70,
        ),
      );
    }).toList();
  }

  Widget _buildUserImgAndName(Map<String, dynamic> recordInfo) {
    return Container(
      height: MediaQuery.of(context).size.width / 8,
      child: Row(
        children: <Widget>[
          Container(
            child: FlatButton(
              onPressed: null,
              child: CircleAvatar(
                //radius: MediaQuery.of(context).size.width / 16,
                backgroundImage: NetworkImage(recordInfo["userImg"]),
              ),
              padding: EdgeInsets.all(0),
            ),
            width: MediaQuery.of(context).size.width / 8,
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Align(
                      child: Text(
                        recordInfo["userName"],
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      child: Text(
                        recordInfo["release_time"],
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black54,
                            fontStyle: FontStyle.italic),
                      ),
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserWords(Map<String, dynamic> recordInfo) {
    return Container(
      child: Align(
        child: Text(
          recordInfo["words"],
          style: TextStyle(
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.centerLeft,
      ),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
    );
  }

  Widget _buildMediaGridView(List<dynamic> media) {
    var _gridview = null;
    if (media != null && media.length != 0) {
      _gridview = GridView.count(
        shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(), //disable scroll
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: _buildmediaView(media),
      );
    }
    return Container(
      child: _gridview,
    );
  }

  //TODO: Assert media files's type, if ".mp4" should build video player. And restrict Image numbers
  List<Widget> _buildmediaView(List<dynamic> media) {
    return media.map((item) {
      return InkWell(
        onTap: () {
          //TODO: Turn photos to scan page. args is  List<dynamic> photos
        },
        child: Image.network(
          item,
          fit: BoxFit.cover,
        ),
      );
    }).toList();
  }

  Widget _buildMapLocation(Map<String, dynamic> recordInfo) {
    Widget location = null;
    if (recordInfo["locationInfo"] != null &&
        recordInfo["locationInfo"] != "") {
      location = Row(
        children: <Widget>[
          Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 18.0,
          ),
          Text(
            recordInfo["locationInfo"],
            style: TextStyle(color: Colors.black54),
          ),
        ],
      );
    }
    return Container(
      child: location,
      height: 20.0,
      margin: EdgeInsets.only(top: 8.0),
    );
  }

  Widget _buildLikeAndComment(Map<String, dynamic> recordInfo) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            child: FlatButton(
              onPressed: () {
                //TODO: Request service, changed like-status to true or false.
                setState(() {
                  var index = this._userRecords.indexOf(recordInfo);
                  this._userRecords[index]["likeNumber"] += 1;
                });
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.favorite),
                  Text(recordInfo["likeNumber"].toString()),
                ],
              ),
              padding: EdgeInsets.all(0),
              textColor: Colors.black87,
            ),
            width: 70.0,
          ),
          Container(
            child: FlatButton(
                onPressed: () {
                  //TODO: Turn to detail page.
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.chat),
                    Text(recordInfo["commentNumber"].toString()),
                  ],
                ),
                padding: EdgeInsets.all(0),
                textColor: Colors.black87),
            width: 70.0,
            margin: EdgeInsets.only(left: 10.0),
          ),
        ],
      ),
      height: 30,
      margin: EdgeInsets.only(top: 8.0),
    );
  }

  Future<Null> _upPullToRefresh() async {
    var maxScroll = this._scrollController.position.maxScrollExtent;
    var pixels = this._scrollController.position.pixels;

    if (maxScroll == pixels && this._userRecords.length < 100) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("正在加載更多內容", textAlign: TextAlign.center),
        backgroundColor: Colors.grey,
        duration: Duration(milliseconds: 300),
      ));
      setState(() {
        this._userRecords.add({
          "id": 4654,
          "userImg":
              "http://www.didiao.co/uc_server/images/noavatar_middle.gif",
          "userName": "灰太狼",
          "release_time": "2019-03-13 18:20:25",
          "words": "今天很开心又去玩耍了",
          "media": [
            "http://www.huaclub.cc/data/attachment/forum/201903/13/070009vtxtcfc06traaz5o.jpg",
          ],
          "locationInfo": "深圳市·南山区·滨海大道",
          "likeNumber": 9856,
          "commentNumber": 83,
        });
      });
    }
    return null;
  }

  Future<Null> _downPullToRefresh() async {
    setState(() {
      this._userRecords[0]["userName"] = "大朋友";
    });
    return null;
  }

  void _jumpToNewPage(StatefulWidget state) {
    var _newRoute = MaterialPageRoute(builder: (context) => state);
    Navigator.of(context).push(_newRoute);
  }
}

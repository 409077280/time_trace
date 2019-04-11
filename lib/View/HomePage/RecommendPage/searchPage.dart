import 'package:flutter/material.dart';
import '../../../Network/http.dart';

import '../index.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  State createState() {
    return _searchState();
  }
}

class _searchState extends State<SearchPage> {
  TextEditingController _inputController;
  List<Map<String, dynamic>> _listviews;

  @override
  void initState() {
    _inputController = new TextEditingController();
    //this._listviews = null;
    this._listviews = [
      {
        "id": 123,
        "userImg":
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552476366669&di=522a3e7c8e59a9e9b1e84e296d37e6be&imgtype=0&src=http%3A%2F%2Fwww.haiko.com.cn%2Fuploads%2Fallimg%2F180315%2F2_180315112833_1.jpg",
        "userName": "老王",
        "introduce": "欢迎来到德莱联盟",
      },
      {
        "id": 124,
        "userImg":
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1552476367112&di=e49cbc619c7527f1f08fbad3f261f68f&imgtype=0&src=http%3A%2F%2Fen.pimg.jp%2F004%2F042%2F800%2F1%2F4042800.jpg",
        "userName": "老李",
        "introduce": "里面有很多皂片，你懂的！",
      },
    ];
    super.initState();
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
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () {
          Navigator.pop(context);
        },
        iconSize: 35.0,
      ),
      title: Container(
        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        decoration: new BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
            color: Colors.white70),
        child: new Row(
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.brown,
                ),
                onPressed: null,
                padding: EdgeInsets.all(0),
              ),
              width: 24,
            ),
            Expanded(
              child: TextField(
                controller: _inputController,
                autofocus: true,
                decoration: InputDecoration.collapsed(
                  hintText: "輸入用戶名稱",
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  fillColor: Colors.purpleAccent,
                ),
                onSubmitted: _textFieldSubmit,
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.brown,
                ),
                onPressed: () {
                  setState(() {
                    _inputController.clear();
                  });
                },
                padding: EdgeInsets.all(0),
              ),
              width: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _textFieldSubmit(String str) async {
    print(str);
    SearchUserList searchRquest = new SearchUserList();
    Map result = await searchRquest.getUserList(str);

    if (result["result"] == true) {
      if (result["body"]["code"] == 0) {
        setState(() {
          this._listviews = result["body"]["data"];
        });
      } else {
        //TODO:做服务端返回的错误提示，layout方式
      }
    } else {
      //TODO:做服务访问失败的提示，layout范式
    }
  }

  Widget _buildBody() {
    if (this._listviews == null) {
      return null;
    }
    var _userListView = this._listviews.map((item) {
      return FlatButton(
        onPressed: () {
          var _newRoute = MaterialPageRoute(builder: (context) => HomePage());
          Navigator.of(context).pushReplacement(_newRoute);
        },
        child: Card(
          child: new ListTile(
            leading: Image.network(item["userImg"], width: MediaQuery.of(context).size.width / 6, height: MediaQuery.of(context).size.width / 6,),
            title: Text(item["userName"]),
            subtitle: Text(item["introduce"]),
            trailing: null,
          ),
        ),
      );
    }).toList();

    return Center(
      child: ListView(
        children: _userListView,
      ),
    );
  }
}

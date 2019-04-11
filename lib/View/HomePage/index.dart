import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'RecommendPage/index.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  List<IconData> _bottomIcons;
  List<IconButton> _icoButtons;
  List<Widget> _itemBodys;
  int _index;

  @override
  void initState() {
    this._bottomIcons = [
      Icons.apps,
      Icons.picture_in_picture,
      Icons.message,
      Icons.person,
    ];
    this._itemBodys = [
      RecommendPage(),
      RecommendPage(),
      RecommendPage(),
      RecommendPage(),
    ];
    this._index = 0;

    this._icoButtons = _buildIconButton();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return RecommendPage();
              }));
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: _itemBodys[_index],
          bottomNavigationBar: BottomAppBar(
            color: Colors.deepPurple,
            shape: CircularNotchedRectangle(),
            child: tabs(),
          ),
        ),
        onWillPop:(){
          return _dialogExitApp(context);
        }
    );
  }

  Future _dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              content: new Text("是否退出"),
              actions: [
                new FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop(false);
                      //TODO:Move to back-stage.
                    },
                    child: new Text("取消")),
                new FlatButton(
                    onPressed: _exitApp,
                    child: new Text("确定"))
              ],
            ));
  }

  Future<void> _exitApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Widget tabs() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _icoButtons,
    );
  }

  List<IconButton> _buildIconButton() {
    return this._bottomIcons.map((item) {
      int _currentIndex = this._bottomIcons.indexOf(item);
      return IconButton(
        icon: Icon(item),
        iconSize: _currentIndex == this._index ? 26.0 : 20.0,
        color: _currentIndex == this._index ? Colors.orange : Colors.white,
        onPressed: () {
          _onPress(_currentIndex);
        },
      );
    }).toList();
  }

  void _onPress(int index) {
    print(index);
    if (this._index != index) {
      setState(() {
        this._index = index;
        this._icoButtons = _buildIconButton();
      });
    }
  }
}

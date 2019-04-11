import 'dart:async';
import 'package:flutter/material.dart';
import '../../Config/globalValue.dart' as GlobalValue;
import '../HomePage/index.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ///通过state判断App前后台切换
    if (state == AppLifecycleState.resumed) {
      //TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(GlobalValue.GlobalValue.SplashImage,fit: BoxFit.fill,);
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

// 倒计时
  void countDown() {
    var _duration = new Duration(seconds: 2);
    new Future.delayed(_duration, goToHomePage);
  }

  void goToHomePage() {
    var _newRoute = MaterialPageRoute(builder: (context) => HomePage());
    Navigator.of(context).pushReplacement(_newRoute);
  }
}
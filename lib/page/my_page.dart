import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/api/Api.dart';
import 'package:flutter_practice/entity/banner_entity.dart';
import 'package:flutter_practice/page/homewidget/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _myPage();
}

class _myPage extends State<MyPage> {
  String name = "";
  String email = "";
  List<Data> picList = <Data>[];

  String sps = "默认";

  _saveV(String v) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('value', v);
  }

  _getV() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sps = prefs.getString('value');
    });
  }

  static const String MY_URL="https://m.ctrip.com/webapp/myctrip/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        url: MY_URL,
        hideAppBar: true,
        backForbid: true,
        staturBarColor: "4C5BCA",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_practice/page/My_Page.dart';
import 'package:flutter_practice/page/home_page.dart';
import 'package:flutter_practice/page/search_page.dart';
import 'package:flutter_practice/page/travel_page.dart';

import 'widget/tabs_navigator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var pages = [HomePage(), SearchPage(),TravelPage(), MyPage()];
  var tabs = ["首页", "搜索","旅拍", "我的"];
  var tabIcons = [Icons.home, Icons.search,Icons.camera_enhance, Icons.account_circle];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        platform: TargetPlatform.iOS,//向右边滑动返回上一页
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(Colors.blue, pages, tabs, tabIcons),
    );
  }
}

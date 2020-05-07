import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/entity/home_entity.dart';
import 'package:flutter_practice/page/homewidget/webview.dart';

class SubNav extends StatelessWidget {
  final List<LocalNavList> subNavList;

  SubNav(this.subNavList);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((item) {
      items.add(_createItem(context, item));
    });
    //计算每一行显示的数量
    int separate = (subNavList.length / 2).toInt();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate, items.length),
          ),
        ),
      ],
    );
  }

  Widget _createItem(BuildContext context, LocalNavList navList) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              WebView(url: navList.url,
                staturBarColor: navList.statusBarColor,
                hideAppBar: navList.hideAppBar,)));
        },
        child: Column(
          children: <Widget>[
            Image.network(
              navList.icon,
              width: 18,
              height: 18,
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                navList.title,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

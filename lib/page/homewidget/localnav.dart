import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/entity/home_entity.dart';
import 'package:flutter_practice/page/homewidget/webview.dart';

class LocalNav extends StatelessWidget {
  final List<LocalNavList> localList;

  LocalNav(this.localList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localList == null) return null;
    List<Widget> items = [];
    localList.forEach((item) {
      items.add(_createItem(context, item));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _createItem(BuildContext context, LocalNavList navList) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,MaterialPageRoute(builder: (context)=>WebView(url: navList.url,staturBarColor: navList.statusBarColor,hideAppBar: navList.hideAppBar,)));
      },
      child: Column(
        children: <Widget>[
          Image.network(
            navList.icon,
            width: 32,
            height: 32,
          ),
          Text(
            navList.title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

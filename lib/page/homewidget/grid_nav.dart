import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/entity/home_entity.dart';
import 'package:flutter_practice/page/homewidget/webview.dart';

class Grid_Nav_widget extends StatelessWidget {
  GridNav gridNav;

  Grid_Nav_widget(this.gridNav);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: Container(
        child: Column(
          children: _gridNavItems(context),
        ),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNav == null) return items;
    if (gridNav.hotel != null) {
      items.add(_gridNavItem(context, gridNav.hotel, true));
    }
    if (gridNav.flight != null) {
      items.add(_gridNavItem(context, gridNav.flight, false));
    }
    if (gridNav.travel != null) {
      items.add(_gridNavItem(context, gridNav.travel, false));
    }
    return items;
  }

  _gridNavItem(BuildContext context, Hotel gridHotelItem, bool first) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridHotelItem.mainItem));
    items.add(_doubleItem(context, gridHotelItem.item1, gridHotelItem.item2));
    items.add(_doubleItem(context, gridHotelItem.item3, gridHotelItem.item4));

    List<Widget> expandItems = [];
    items.forEach((item) {
      expandItems.add(Expanded(child: item, flex: 1));
    });
    Color startColor = Color(int.parse("0xff" + gridHotelItem.startColor));
    Color endColor = Color(int.parse("0xff" + gridHotelItem.endColor));
    return Container(
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        //线性渐变
        gradient: LinearGradient(colors: [startColor, endColor]),
      ),
      child: Row(
        children: expandItems,
      ),
    );
  }

  //左边那个
  _mainItem(BuildContext context, LocalNavList navList) {
    return _warpGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Image.network(
              navList.icon,
              fit: BoxFit.contain,
              width: 121,
              height: 88,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                navList.title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        navList);
  }

  //中间的
  _doubleItem(BuildContext context, LocalNavList top, LocalNavList bottom) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _doubleItemContent(context, top, true),
        ),
        Expanded(
          child: _doubleItemContent(context, bottom, false),
        ),
      ],
    );
  }

  //中间item具体实现
  _doubleItemContent(BuildContext context, LocalNavList navList, bool first) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          left: borderSide,
          bottom: first ? borderSide : BorderSide.none,
        )),
        child: _warpGesture(
            context,
            Center(
              child: Text(
                navList.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            navList),
      ),
    );
  }

  _warpGesture(BuildContext context, Widget widget, LocalNavList navList) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: navList.url,
                      staturBarColor: navList.statusBarColor,
                      hideAppBar: navList.hideAppBar,
                    )));
      },
      child: widget,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabNavigator extends StatefulWidget {
 final Color selectColor;
 final List<Widget> pages;
 final List<String> tabs;
 final List<IconData> tabsIcons;

 TabNavigator(this.selectColor, this.pages, this.tabs, this.tabsIcons);

  @override
  State<StatefulWidget> createState() =>
      _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentIndex = 0;

  void _onItemTapped(int value) {
    _pageController.jumpToPage(value);
    setState(() {
      _currentIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),//禁止滑动
        onPageChanged: _onItemTapped,
        controller: _pageController,
        children: widget.pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
//        selectedFontSize: 13,
//        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        // BottomNavigationBarType 中定义的类型，有 fixed 和 shifting 两种类型
        iconSize: 24.0,
        // BottomNavigationBarItem 中 icon 的大小
        currentIndex: _currentIndex,
        // 当前所高亮的按钮index
        onTap: _onItemTapped,
        // 点击里面的按钮的回调函数，参数为当前点击的按钮 index
        fixedColor: Colors.deepPurple,
        // 如果 type 类型为 fixed，则通过 fixedColor 设置选中 item 的颜色
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text(widget.tabs[0]), icon: Icon(widget.tabsIcons[0])),
          BottomNavigationBarItem(
              title: Text(widget.tabs[1]), icon: Icon(widget.tabsIcons[1])),
          BottomNavigationBarItem(
              title: Text(widget.tabs[2]), icon: Icon(widget.tabsIcons[2])),
          BottomNavigationBarItem(
              title: Text(widget.tabs[3]), icon: Icon(widget.tabsIcons[3])),
        ],
      ),
    );
  }
}

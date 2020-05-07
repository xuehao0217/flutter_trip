import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/api/api.dart';
import 'package:flutter_practice/entity/home_entity.dart';
import 'package:flutter_practice/net/dio_manager.dart';
import 'package:flutter_practice/page/homewidget/loading_container.dart';
import 'package:flutter_practice/page/search_page.dart';
import 'package:flutter_practice/page/speak_page.dart';
import 'package:flutter_practice/utils/navigator_utils.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'homewidget/grid_nav.dart';
import 'homewidget/localnav.dart';
import 'homewidget/sales_box.dart';
import 'homewidget/search_bar.dart';
import 'homewidget/subnav.dart';
import 'homewidget/webview.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _homePage();
}

class _homePage extends State<HomePage> {
  HomeEntity _homeEntity = HomeEntity();
  bool _loading = true;
  double appBarAlpha = 0;

  _listViewScroll(offset) {
    double alpha = offset / 44;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  //下拉刷新组件方法必须返回 Future<void>  同时必须是async修饰
  Future<void> _homeRefresh() async {
    getContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _loading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              removeTop: true, //移除状态栏
              context: context,
              child: RefreshIndicator(
                onRefresh: _homeRefresh,
                child: NotificationListener(
                    onNotification: (scroll) {
                      if (scroll is ScrollUpdateNotification &&
                          scroll.depth == 0) {
                        //NotificationListener是第0个元素滚动才触发
                        _listViewScroll(scroll.metrics.pixels); //获取滚动距离
                      }
                    },
                    child: ListView(
                      children: <Widget>[
                        _banner,
                        Padding(
                          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                          child: LocalNav(_homeEntity.localNavList),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                          child: Grid_Nav_widget(_homeEntity.gridNav),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                          child: SubNav(_homeEntity.subNavList),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                          child: SalesBoxWidget(_homeEntity.salesBox),
                        ),
                      ],
                    )),
              ),
            ),
            _appBar,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getContent();
  }

  getContent() {
    DioManager.getInstance().get(Api.HOME_PAGE, null, (data) {
      setState(() {
        _homeEntity = HomeEntity.fromJson(data);
        _loading = false;
      });
    });
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0x66000000), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 70,
            decoration: BoxDecoration(
                color:
                    Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              serchBarType: appBarAlpha > 0.2
                  ? SerchBarType.homeLight
                  : SerchBarType.home,
              inputBoxClick: _jump2Search,
              speakClick: _jump2Speck,
              defText: "景点 酒店 美食",
              leftBtClick: () {

              },
            ),
          ),
        ),
        Container(
          height: appBarAlpha>0.2?0.5:0,
          decoration:BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 0.5)],
          ) ,
        ),
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 150,
      child: Swiper(
        autoplay: true,
        autoplayDelay: 1500,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WebView(url: _homeEntity.bannerList[index].url)));
            },
            child: Image.network(
              _homeEntity.bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        itemCount: _homeEntity.bannerList?.length ?? 0,
        pagination: SwiperPagination(),
      ),
    );
  }

  void _jump2Search() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(hind: "景点 酒店 美食",)));
  }

  void _jump2Speck() {
    NavigatorUtils.push(context,SpeakPage());
  }
}

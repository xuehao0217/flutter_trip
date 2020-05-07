import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_practice/api/api.dart';
import 'package:flutter_practice/entity/travel_tab_entity.dart';
import 'package:flutter_practice/net/dio_manager.dart';
import 'package:flutter_practice/page/homewidget/loading_container.dart';
import 'package:flutter_practice/page/travel_tab_page.dart';
///旅拍页面
class TravelPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_StateTravel();
}
class _StateTravel extends State<TravelPage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  List<Tabs> _tabs=[];
  bool _isLoading=true;
  TravelEntity _travelEntity;
  @override
  void initState() {
    super.initState();
    DioManager.getInstance().get(Api.TRAVEL_PAGE, null, (data) {
      setState(() {
        var travelEntity = TravelEntity.fromJson(data);
        //这里要挨个赋值
        _travelEntity=travelEntity;
        _tabs=travelEntity.tabs;
        //等数据加载完成再去创建
        _tabController=TabController(length: _tabs.length,vsync: this);
        _isLoading=false;
      });
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 30),
              child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.black,//指示器字体的颜色
                  labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                  indicator: UnderlineTabIndicator(
                    //指示器
                    borderSide:BorderSide(color: Color(0xff2fcfbb),width: 3),
                    insets: EdgeInsets.only(bottom: 10),
                  ),
                  tabs:_tabs.map<Tab>((tab){return Tab(text: tab.labelName);}).toList()
              ),
            ),
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((tab){
                  return TravelTabPage(groupChannelCode: tab.groupChannelCode,travelUrl: _travelEntity.url,);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
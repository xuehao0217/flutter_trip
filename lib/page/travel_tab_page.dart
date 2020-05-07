
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/entity/travel_item_entity.dart';
import 'package:flutter_practice/entity/travel_tab_entity.dart';
import 'package:flutter_practice/net/dio_manager.dart';
import 'package:flutter_practice/page/homewidget/webview.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'homewidget/loading_container.dart';




class TravelTabPage extends StatefulWidget{
  const TravelTabPage({Key key, this.travelEntity, this.travelUrl, this.groupChannelCode}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_StateTravelTabPage();
 final TravelEntity travelEntity;
  final String  travelUrl;
  final String  groupChannelCode;


}

class _StateTravelTabPage extends State<TravelTabPage> with AutomaticKeepAliveClientMixin{
  List<ResultList> travelItems;
  int pageIndex=1;
  bool _isLoading=true;

  ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener((){
          //当当前像素是最大滑动距离证明到底部
        if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
            _loadData(loadMore: true);
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:LoadingContainer(
          isLoading:_isLoading,
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: MediaQuery.removePadding(
                removeTop: true,
                context: context, child:  StaggeredGridView.countBuilder(
                controller: _scrollController,
              crossAxisCount: 2,//几列
              itemCount: travelItems?.length??0,
              itemBuilder: (BuildContext context, int index) => _TravelItem(index: index,item: travelItems[index],),
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.fit(1),//一个item 占用几列的空间   2/1
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )
            ),
          ),
      ),
    );
  }


  void _loadData({loadMore =false}) {
    if(loadMore){
      pageIndex++;
    }else{
      pageIndex=1;
    }
    Map paramsMap=Params["pagePara"];
    paramsMap["pageIndex"]=pageIndex;
    paramsMap["pageSize"]=10;
    Params["groupChannelCode"]=widget.groupChannelCode;
      DioManager.getInstance().post(widget.travelUrl??url, Params, (data){
      setState(() {
        _isLoading=false;
        List<ResultList> items=  _filterItems(TravelItemEntity.fromJson(data).resultList);
        print(items.toString());
        if(travelItems!=null){
          travelItems.addAll(items);
        }else{
          travelItems=items;
        }
      });
      });
  }
  //过滤数据
  List<ResultList> _filterItems(List<ResultList> resultList) {
      if(resultList==null){
        return[];
      }
        List<ResultList> filterItems=[];
      resultList.forEach((item){
        if(item.article!=null){
          filterItems.add(item);
        }
      });
      return filterItems;
  }

  @override
  //当前页面保存
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    _loadData();
  }
}
//瀑布流具体页面
class _TravelItem  extends StatelessWidget{
  final ResultList item;
  final int index;
  const _TravelItem({Key key, this.item, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(item.article.urls!=null&&item.article.urls.length>0){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>WebView(url: item.article.urls[0].h5Url,title: "详情",)));
        }
      },
        child: Card(
          //裁切圆角
          child: PhysicalModel(
          color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  _itemImg(),
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Text(item.article.articleTitle,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.black),),
                  ),
                  infoText(),
              ],
            ),
          ),
        ),
    );
  }
  //卡牌上半部分
  _itemImg() {
    return Stack(
      children: <Widget>[
        Image.network(item.article?.images[0]?.dynamicUrl??""),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(right: 3),child: Icon(Icons.location_on,color: Colors.white,size: 12,)),
                //控制组件的最大高度和宽度
                LimitedBox(
                  maxWidth: 130,
                  child: Text(_itemName(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  String _itemName() {
    return item.article.pois==null||item.article.pois.length==0?"未知":item.article.pois[0]?.poiName??"未知";
  }

  //卡片下半部分
  infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6,0,6,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.article.author?.coverImage?.dynamicUrl,width: 24,height: 24,),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(item.article.author?.nickName,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),),

              ),
            ],
          ),
            Row(
             children: <Widget>[
               Icon(Icons.thumb_up,size: 14,color: Colors.grey,),
               Padding(
                 padding: EdgeInsets.only(left: 3),
                   child: LimitedBox(
                      maxWidth: 25,
                           child: Text(item.article.readCount.toString(),style:TextStyle(fontSize: 10),maxLines: 1,overflow: TextOverflow.clip,),
                   ),
                  ),
               ],
             ),
        ],
      ),
    );
  }
}



//请求参数
var url="https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5";
var Params= {
  "districtId": -1,
  "groupChannelCode": "tourphoto_global1",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 2,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "contentType": "json"
};



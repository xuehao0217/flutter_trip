import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/api/api.dart';
import 'package:flutter_practice/entity/search_entity.dart';
import 'package:flutter_practice/net/dio_manager.dart';
import 'package:flutter_practice/page/homewidget/webview.dart';
import 'package:flutter_practice/page/speak_page.dart';

import 'homewidget/search_bar.dart';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String hind;
  final String keyWord;

  const SearchPage(
      {Key key, this.hideLeft, this.searchUrl, this.keyWord, this.hind})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _searchPage();
}

class _searchPage extends State<SearchPage> {
  String keyWord;
  List<Data> searchs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                flex: 1,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return _item(index);
                  },
                  itemCount: searchs?.length ?? 0,
                ),
              )),
        ],
      ),
    );
  }

  @override
  void initState() {
    if(widget.keyWord!=null){
      _onTextChange(widget.keyWord);
    }
    super.initState();
  }

  void _onTextChange(String text) {
    keyWord = text;
    if (text.length == 0) {
      setState(() {
        searchs = null;
      });
      return;
    }
    var params = {
      "keyword": text,
    };
    DioManager.getInstance(baseUrl: "").get(Api.SEARCH, params, (data) {
      if (keyWord == params["keyword"]) {
        setState(() {
          searchs = SearchEntity.fromJson(data).data;
        });
      }
    });
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.only(top: 30),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideleft: widget.hideLeft,
              defText: widget.keyWord,
              hint: widget.hind,
              speakClick: () {
                //jump to speak
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SpeakPage()));
              },
              leftBtClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  Widget _item(int pos) {
    if (searchs == null) {
      return null;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: searchs[pos].url,
                      title: "详情",
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Icon(
                _icon(searchs[pos].type),
                size: 26,
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(pos),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(pos),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon(String type) {
    if (type == null) {
      return Icons.ac_unit;
    }
    if (type.contains("district")) {
      return Icons.comment;
    } else if (type.contains("ticket")) {
      return Icons.table_chart;
    } else if (type.contains("sight")) {
      return Icons.scanner;
    } else if (type.contains("airport")) {
      return Icons.archive;
    } else {
      return Icons.not_listed_location;
    }
  }

  _title(int pos) {
    var data = searchs[pos];
    if (data == null) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keyWordTextSpan(data.word, keyWord));
    spans.add(TextSpan(
        text: " " + (data.districtname ?? "" + " "),
        style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  _subTitle(int pos) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: searchs[pos].price ?? "",
            style: TextStyle(fontSize: 16, color: Colors.orange)),
        TextSpan(
            text: searchs[pos].type ?? "",
            style: TextStyle(fontSize: 12, color: Colors.grey))
      ]),
    );
  }

  Iterable<TextSpan> _keyWordTextSpan(String word, String keyWord) {
    List<TextSpan> spans = [];
    if (word == null) return spans;
    List<String> arr = word.split(keyWord);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keyWordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    //"wordwoc".split("w"); -> [, ord,oc]
    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyWord, style: keyWordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }
}

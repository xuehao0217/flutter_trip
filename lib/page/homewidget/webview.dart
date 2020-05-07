import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/api/api.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  final String url;
  final String staturBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid; //禁止返回

  WebView(
      {this.url,
      this.staturBarColor = "ffffff",
      this.title = "",
      this.hideAppBar,
      this.backForbid = false});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChangedListen;
  StreamSubscription<WebViewHttpError> _onHttpErrorListen;

  bool exiting = false; //是否返回

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {});
    _onStateChangedListen =
        flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      switch (viewState.type) {
        case WebViewState.finishLoad:
          break;
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:
          print("WebView_startLoad:" + widget.url);
          //是否返回首页 没有返回
          if (_isToMian(viewState.url) && !exiting) {
            if (widget.backForbid) {
              flutterWebviewPlugin.launch(widget.url);
            } else {
              //返回上一页
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        case WebViewState.abortLoad:
          break;
      }
    });

    _onHttpErrorListen = flutterWebviewPlugin.onHttpError.listen((error) {
      print("webview_onHttpError $error");
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChangedListen.cancel();
    _onHttpErrorListen.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColor = widget.staturBarColor ?? "ffffff";
    Color backBtColor;
    if (statusBarColor == "ffffff") {
      backBtColor = Colors.black;
    } else {
      backBtColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse("0xff" + statusBarColor)), backBtColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text("加载中..."),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _isToMian(String url) {
    bool contain = false;
    for (final v in Api.CATCH_URL) {
      if (url?.endsWith(v) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  _appBar(Color bgColor, Color backBtColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: bgColor,
        height: 30,
      );
    }
    return Container(
      color: bgColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      //充满整个屏幕宽度
      child: FractionallySizedBox(
        widthFactor: 1, //宽度撑满
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backBtColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? "",
                  style: TextStyle(color: backBtColor, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

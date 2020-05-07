import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover; //是否覆盖整个页面

  const LoadingContainer(
      {Key key,
      @required this.isLoading,
      this.cover = false,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !cover
        ? !isLoading ? child : _loadingView
        : Stack(
            children: <Widget>[child, isLoading ? _loadingView : null],
          );
  }

//  Widget _loadingView() {
//    return Center(
//      child: CircularProgressIndicator(),
//    );
//  }
  //get 直接调用方法
  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

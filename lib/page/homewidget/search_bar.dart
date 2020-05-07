import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/utils/common_utils.dart';

enum SerchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideleft;
  final SerchBarType serchBarType;
  final String hint;
  final String defText;
  final void Function() leftBtClick;
  final void Function() rightBtClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideleft,
      this.serchBarType = SerchBarType.normal,
      this.hint,
      this.defText,
      this.leftBtClick,
      this.rightBtClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _searchBar();
}

class _searchBar extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.defText != null) {
      setState(() {
        _controller.text = widget.defText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.serchBarType == SerchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  _genNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
                  child: widget.hideleft ?? false
                      ? null
                      : Icon(
                          Icons.arrow_back_ios,
                          color: Colors.grey,
                          size: 26,
                        )),
              widget.leftBtClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  "搜索",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              widget.rightBtClick),
        ],
      ),
    );
  }

  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "北京",
                        style: TextStyle(color: _homeFontColor(), fontSize: 14),
                      ),
                      Icon(
                        Icons.expand_more,
                        color: _homeFontColor(),
                        size: 22,
                      ),
                    ],
                  )),
              widget.leftBtClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor(),
                  size: 26,
                ),
              ),
              widget.rightBtClick),
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: child,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.serchBarType == SerchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = CommonUtils.getColor("ededed");
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(
            widget.serchBarType == SerchBarType.normal ? 5 : 15),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.serchBarType == SerchBarType.normal
                ? Color(0xffa9a9a9)
                : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.serchBarType == SerchBarType.normal
                ? TextField(
                    controller: _controller,
                    onChanged: _onTextChanged,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hint ?? "",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  )
                : _wrapTap(
                    Container(
                      child: Text(
                        widget.defText,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    widget.inputBoxClick),
          ),
          !showClear
              ? _wrapTap(
                  Icon(Icons.mic,
                      size: 22,
                      color: widget.serchBarType == SerchBarType.normal
                          ? Colors.blue
                          : Colors.grey),
                  widget.speakClick)
              : _wrapTap(
                  Icon(Icons.clear,
                      size: 22,
                      color: widget.serchBarType == SerchBarType.normal
                          ? Colors.blue
                          : Colors.grey), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onTextChanged("");
                }),
        ],
      ),
    );
  }

  _onTextChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeFontColor() {
    return widget.serchBarType == SerchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}

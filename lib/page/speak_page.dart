import 'package:flutter/material.dart';
import 'package:flutter_practice/page/search_page.dart';

class SpeakPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateSpeak();
}
 String speakTips="长按说话";

class StateSpeak extends State<SpeakPage> with SingleTickerProviderStateMixin{
  Animation<double>  animation;
  AnimationController controller;
  @override
  void initState() {
    controller=AnimationController(vsync: this,duration: Duration(milliseconds: 1000) );
    animation=CurvedAnimation(parent: controller,curve:Curves.easeIn )..addStatusListener((status){
        if(status==AnimationStatus.completed){
          controller.reverse();
        }else if(status==AnimationStatus.dismissed){
          controller.forward();
        }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
                _topItem(),
                  _bottomItem()
            ],
          ),
        ),
      ),
    );
  }

  _bottomItem() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onPanCancel: () {
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.all(10) ,
                    child: Text(speakTips,style: TextStyle(color: Colors.blue,fontSize: 12),),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                          height: MIC_SIZE,
                        width: MIC_SIZE,
                      ),
                      Center(
                        child:AnimateMic(animation: animation,) ,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
          right: 0,
          bottom: 20,
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
             child: Icon(Icons.close,size: 30,color: Colors.grey,),
            ),
          ),
        ],
      ),
    );
  }

  _speakStart() {
    controller.forward();
    setState(() {
      speakTips="---识别中---";
    });
    Future.delayed(new Duration(seconds: 3),(){
    return"识别结果";
    }).then((data){
      //执行成功会走到这里
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage(keyWord: data,)));
    });
  }

  _speakStop() {
    setState(() {
      speakTips="长按说话";
    });
    controller.reset();
    controller.stop();
  }

}

_topItem() {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
        child: Text("你可以这样说",style: TextStyle(fontSize: 16,color: Colors.black54),),
      ),
    Text("故宫门票\n北京一日游\n迪士尼",textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.grey),),
      Padding(
        padding: EdgeInsets.all(20),
        child: Text("语音识别结果"),
      ),
    ],

  );
}

const double MIC_SIZE = 80;

class AnimateMic extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE - 20);

  AnimateMic({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MIC_SIZE / 2),
        ),
        child: Icon(Icons.mic, color: Colors.white, size: 30,),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../animalItem.dart';

class CupertinoSecondPage extends StatefulWidget {
  final List<Animal> animalList;
  const CupertinoSecondPage({Key key, this.animalList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CupertinoSecondPage();
  }
}

class _CupertinoSecondPage extends State<CupertinoSecondPage> {
  TextEditingController _textController;  // 동물 이름
  int _kindChoice = 0;                    // 동물 종류
  bool _flyExist = false;                 // 날개 유무
  String _imagePath;                      // 동물 이미지
  Map<int, Widget> segmentWidget = {
    0: SizedBox(
      child: Text('곤충', textAlign: TextAlign.center,),
      width: 80,
    ),
    1: SizedBox(
      child: Text('포유류', textAlign: TextAlign.center,),
      width: 80,
    ),
    2: SizedBox(
      child: Text('영장류', textAlign: TextAlign.center,),
      width: 80,
    ),
  };

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('동물 추가'),
      ),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: CupertinoTextField(
                  controller: _textController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              CupertinoSegmentedControl(
                padding: EdgeInsets.only(bottom: 20, top: 20),
                groupValue: _kindChoice,
                children: segmentWidget,
                onValueChanged: (value) {
                  setState(() {
                    _kindChoice = value;
                  });
                }
              ),
              Row(
                children: <Widget>[
                  Text('날개가 존재합니까?'),
                  CupertinoSwitch(value: _flyExist, onChanged: (value){
                    setState(() {
                      _flyExist = value;
                    });
                  })
                ], mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      child: Image.asset('repo/images/cow.png', width: 80,),
                      onTap: (){
                        _imagePath = 'repo/images/cow.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/pig.png', width: 80,),
                      onTap: (){
                        _imagePath = 'repo/images/pig.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/bee.png', width: 80,),
                      onTap: (){
                        _imagePath = 'repo/images/bee.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/cat.png', width: 80,),
                      onTap: (){
                        _imagePath = 'repo/images/cat.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/fox.png', width: 80,),
                      onTap: (){
                        _imagePath = 'repo/images/fox.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/monkey.png', width: 80,),
                      onTap: (){
                        _imagePath = 'repo/images/monkey.png';
                      },
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                  child: Text('동물 추가하기'),
                  color: Colors.black,
                  onPressed: (){
                    var animal = Animal(
                        animalName: _textController.value.text,
                        kind: getKind(_kindChoice),
                        imagePath: _imagePath,
                        flyExist: _flyExist);
                    showCupertinoDialog(
                        context: context,
                        builder: (context){
                          return CupertinoAlertDialog(
                            title: Text('동물 추가하기'),
                            content: Text('이 동물은 ${animal.animalName}입니다.'
                                '\n그리고 동물의 종류는 ${animal.kind}입니다.'
                                '\n이 동물을 추가하시겠습니까?'),
                            actions: [
                              CupertinoButton(
                                  child: Text('예'),
                                  onPressed: () {
                                    widget.animalList.add(animal);
                                    Navigator.of(context).pop();
                                  }),
                              CupertinoButton(
                                  child: Text('아니요'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          );
                        });
                  })
            ], mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  getKind(int segmentValue) {
    switch (segmentValue) {
      case 0:
        return "곤충";
      case 1:
        return "포유류";
      case 2:
        return "영장류";
    }
  }
}
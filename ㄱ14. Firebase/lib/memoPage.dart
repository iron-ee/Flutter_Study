import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_admob/firebase_admob.dart';

class MemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  FirebaseDatabase _database;
  DatabaseReference reference;
  String _databaseURL = 'https://flutterexample-7284d-default-rtdb.firebaseio.com/';      // 데이터베이스 주소
  List<Memo> memos = List();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  BannerAd bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,    // 실전에서는 발급받은 광고 단위 ID를 넣어야 함
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print('$event');
      });

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database.reference().child('memo');
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-5633401770878764~2449389895');   // 애드몹 앱 ID 넣는 곳

    reference.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });

    _firebaseMessaging.getToken().then((value) {
      print(value);   // 토큰을 가져와 출력
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          )
        );
      },
      onLaunch: (Map<String, dynamic> message) async{},
      onResume: (Map<String, dynamic> message) async{}
      );

    bannerAd
      ..load()
      ..show(
        anchorOffset: 0,
        anchorType: AnchorType.bottom,
      );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모 앱'),
      ),
      body: Container(
        child: Center(
          child: memos.length == 0
          ? CircularProgressIndicator()
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Card(
                  child: GridTile(
                    child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: SizedBox(
                        child: GestureDetector(
                          onTap: () async{
                            // 여기에 메모 상세보기 화면으로 이동 추가
                            Memo memo = await Navigator.of(context).push(
                             MaterialPageRoute<Memo>(
                                 builder: (BuildContext context) =>
                                  MemoDetailPage(reference, memos[index]))
                            );
                            if (memo != null) {
                              setState(() {
                                memos[index].title = memo.title;
                                memos[index].content = memo.content;
                              });
                            }
                          },
                          onLongPress: () {
                            // 여기에 길게 클릭 시 메모 삭제 기능 추가
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(memos[index].title),
                                    content: Text('삭제하시겠습니까?'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            reference
                                              .child(memos[index].key)
                                                .remove()
                                                .then((_){
                                               setState(() {
                                                 memos.removeAt(index);
                                                 Navigator.of(context).pop();
                                               });
                                            });
                                          },
                                          child: Text('예')),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('아니요')),
                                    ],
                                  );
                                });
                          },
                          child: Text(memos[index].content),
                        ),
                      ),
                    ),
                    header: Text(memos[index].title),
                    footer: Text(memos[index].createTime.substring(0, 10)),
                  ),
                );
              }, itemCount: memos.length,),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MemoAddPage(reference))
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
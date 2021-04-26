import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;    // http 패키지 불러오기
import 'dart:convert';    // json 데이터

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result ='';
  List data;
  TextEditingController _editingController;
  ScrollController _scrollController;
  int page = 1;

  @override
  void initState() {
    super.initState();
    data = List();
    _editingController = TextEditingController();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        print('bottom');  // 리스트의 마지막일 때 실행
        page++;
        getJsonData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요'),
        ),
      ),
      body: Container(
        child: Center(
          child: data.length == 0
              ? Text('데이터가 없습니다.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          )
           : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Image.network(
                          data[index]['thumbnail'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width -150,
                              child: Text(
                                data[index]['title'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text('저자 : ${data[index]['authors'].toString()}'),
                            Text('가격 : ${data[index]['sale_price'].toString()} 원'),
                            Text('판매중 : ${data[index]['status'].toString()}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }, itemCount: data.length, controller: _scrollController,),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page = 1;
          data.clear();
          getJsonData();
          },
        child: Icon(Icons.file_download),
      ),// 내려받기 모양의 아이콘
    );
  }

  Future<String> getJsonData() async {
    var url = Uri.parse(
        'https://dapi.kakao.com/v3/search/book?'
        'target=title&page=$page&query=${_editingController.value.text}');
    var response = await http.get(url,
        headers: {"Authorization": "KakaoAK de2d1a6b581f4326574b8bef2aa50358"});
    setState(() {
      var dataConvertedToJson = json.decode(response.body);
      List result = dataConvertedToJson['documents'];
      data.addAll(result);
    });
    return response.body;
  }
}


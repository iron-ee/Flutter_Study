import 'package:flutter/material.dart';
import '../animalItem.dart';    // Animal 클래스 사용을 위한 import

class FirstApp extends StatelessWidget {
  final List<Animal> list;  // Animal List 선언
  FirstApp({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ListView.builder(itemBuilder: (context, position) {
            return GestureDetector(
              child: Card(  // 이 부분에 위젯을 이용해 데이터를 표시
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      list[position].imagePath,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    Text(list[position].animalName)
                  ],
                ),
              ),
              onTap: (){
                AlertDialog dialog = AlertDialog(
                  content: Text(
                    '이 동물은 ${list[position].kind}입니다.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
                showDialog(context: context, builder: (BuildContext context) => dialog);
              },
            );
          },itemCount: list.length), // 아이템 개수만큼만 스크롤 할 수 있게 제한
        ),
      ),
    );
  }
}

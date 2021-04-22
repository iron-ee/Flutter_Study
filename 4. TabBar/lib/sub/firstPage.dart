import 'package:flutter/material.dart';

class FirstApp extends StatelessWidget {
  static const String _title = 'Widget Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: ImageWidgetApp(),
    );
  }
}

class ImageWidgetApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageWidgetApp();
  }
}

class _ImageWidgetApp extends State<ImageWidgetApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('image/flutter.png', width: 200, height: 100, fit: BoxFit.fill,), // 이미지를 불러오는 코드
              Text('Hello Flutter', style: TextStyle(fontFamily: 'Pacifico',  fontSize: 30, color: Colors.blue),) // Pacifico 폰트로 텍스트를 표시하는 코드
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';


class SecondApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    print('createState() !');
    return _SecondApp();
  }
}

class _SecondApp extends State<SecondApp> {
  var switchValue = false;
  String test = 'hello'; // 버튼에 들어갈 텍스트 입력
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    print('build() !');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.light(),
      home: Scaffold(
        body: Center(
            child: RaisedButton(
                child: Text('$test'),
                color: _color,
                onPressed: () {
                  if (test == 'hello') {
                    setState(() {
                      test = 'flutter';
                      _color = Colors.amber;
                    });
                  } else {
                    setState(() {
                      test = 'hello';
                      _color = Colors.blue;
                    });
                  }
                })
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'login.dart';
import 'signPage.dart';
import 'mainPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tour_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE place(id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title TEXT, tel TEXT, zipcode TEXT, address TEXT, mapx Number,"
              "mapy Number, imagePath TEXT)",
        );
      },
      version: 1,
    );
  }


  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-5633401770878764~7028683172');
    Future<Database> database = initDatabase();   // initDatabase() 함수 호출

    return MaterialApp(
      title: '모두의 여행',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/sign': (context) => SignPage(),
        '/main': (context) => MainPage(database),
      },
    );
  }
}



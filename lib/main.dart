import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mask_stock/model/store.dart';

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
      ),
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future fetch() async {
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?';

    // get 은 Future 를 Return 함
    // await 가 없으면 다음 코드가 수행될 보장이 없음
    // 그래서 await 키워드로 해당 get 이 끝날 때 까지 기다린 후 다음 코드를 진행 함 (결론은 await 함수는 Future 안에서만 사용 가능)
    var response = await http.get(url);
    // 매우 중요함
    // utf8.decode 사용하는 이유 => 한글 깨짐 처리하기 위해, 하지만 전체 데이터가 String 덩어리로 들어옴
    // 이를 해결하기위해 jsonDecode 메서드 사용 => json형태로 Decode 해줘야 Model 클래스에 담을 수 있
     logger.d('response.body: ${jsonDecode(utf8.decode(response.bodyBytes))}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock')),
      body: Center(
        child: RaisedButton(
          onPressed: fetch,
          child: Text('TEST'),
        ),
      ),
    );
  }
}

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
  final stores = List<Store>();
  var isLoading = true;

  Future fetch() async {
    setState(() {
      isLoading = true;
    });
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json?';

    // get 은 Future 를 Return 함
    // await 가 없으면 다음 코드가 수행될 보장이 없음
    // 그래서 await 키워드로 해당 get 이 끝날 때 까지 기다린 후 다음 코드를 진행 함 (결론은 await 함수는 Future 안에서만 사용 가능)
    var response = await http.get(url);
    final jsonResult = jsonDecode(utf8.decode(response.bodyBytes));
    // 매우 중요함
    // utf8.decode 사용하는 이유 => 한글 깨짐 처리하기 위해, 하지만 전체 데이터가 String 덩어리로 들어옴
    // 이를 해결하기위해 jsonDecode 메서드 사용 => json 형태로 Decode 해줘야 Model 클래스에 담을 수 있다

    final jsonStores = jsonResult['stores'];

    // 상태가 변경되었을때 화면을 다시 그려주는 역할 => setState()
    setState(() {
      //값이 담겨있으면 초기화 (새로고침 기능을 만들기 위해)
      stores.clear();
      jsonStores.forEach((e) {
        stores.add(Store.fromJson(e));
      });
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는 곳 : ${stores.where((e) {
          return e.remainStat == 'plenty' ||
              e.remainStat == 'some' ||
              e.remainStat == 'few';
        }).length}곳'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                fetch();
              })
        ],
      ),
      body: isLoading
          ? loadingWidget()
          : ListView(
              children: stores.where((e) {
                return e.remainStat == 'plenty' ||
                    e.remainStat == 'some' ||
                    e.remainStat == 'few';
              }).map((e) {
                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.addr),
//            trailing: Text(e.remainStat ?? '매진'), // [elements ?? ''] => elements 의 값이 Null 일 때 ''로 교체,
                  trailing: _buildRemainStatWidget(e),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildRemainStatWidget(Store store) {
    var remainStat = '판매중지';
    var description = '판매중지';
    var color = Colors.black;

//    if (store.remainStat == 'plenty') {
//      remainStat = '충분';
//      description = '100개 이상';
//      color = Colors.green;
//    }
    switch (store.remainStat) {
      case 'plenty':
        remainStat = '충분';
        description = '100개 이상';
        color = Colors.green;
        break;
      case 'some':
        remainStat = '보통';
        description = '30 ~ 100개';
        color = Colors.yellow;
        break;
      case 'few':
        remainStat = '부족';
        description = '2 ~ 30개';
        color = Colors.red;
        break;
      case 'empty':
        remainStat = '소진임박';
        description = '1개 이하';
        color = Colors.grey;
        break;
      default:
    }

    return Column(
      children: [
        Text(
          remainStat,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        Text(description),
      ],
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('정보를 가져오는 중...'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

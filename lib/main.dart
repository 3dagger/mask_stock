import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mask_stock/model/store.dart';
import 'package:mask_stock/ui/view/main_page.dart';
import 'package:mask_stock/viewmodel/store_model.dart';
import 'package:provider/provider.dart';

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

// Provider 는 최상위 위젯에 위치시키는게 효율적임
void main() {
  runApp(
    ChangeNotifierProvider.value(
      value: StoreModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
    );
  }
}



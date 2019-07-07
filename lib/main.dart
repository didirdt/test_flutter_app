import 'package:flutter/material.dart';
import 'package:testapp/homepage/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Didi Test Flutter';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
          primaryColor: Colors.indigo,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: HomePage());
  }
}

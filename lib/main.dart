import 'package:flutter/material.dart';
import 'package:hacker_news/homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: "Hacker News",
        home: HomePage()
    );

  }

}
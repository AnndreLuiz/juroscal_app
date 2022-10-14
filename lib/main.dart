import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:juroscal_app/views/secondpage.dart';
import 'views/homepage.dart';
import 'views/secondpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        shadowColor: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/item': (context) => const Secondpage(),
      },
    );
  }
}

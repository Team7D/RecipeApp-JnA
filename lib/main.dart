import 'package:flutter/material.dart';

import 'Frontend/Pages/home_page.dart';
import 'Frontend/Pages/login_page.dart';
import 'Frontend/Pages/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}


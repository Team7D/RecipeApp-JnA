import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_app/Backend/Core/Recipe/ingredient.dart';
import 'package:recipe_app/Backend/Core/Recipe/recipeTesting.dart';
import 'Backend/Services/Firebase/firebase_options.dart';
import 'Frontend/Pages/home_page.dart';
import 'Frontend/Pages/login_page.dart';
import 'Frontend/Pages/search_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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


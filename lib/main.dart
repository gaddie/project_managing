import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_manager/Screens/HomePage.dart';
import 'package:project_manager/Screens/LoginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/homePage': (context) => HomePage(),
      },
    );
  }
}

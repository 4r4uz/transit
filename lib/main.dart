import 'package:app_waa/web/home.dart';
import 'package:app_waa/web/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app',
      initialRoute: '/',
      routes: {
        '':(context) => const Home(),
        'profile':(context) => const Profile()
      },
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}

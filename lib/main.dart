import 'package:app_waa/web/screens/buses.dart';
import 'package:app_waa/web/screens/companies.dart';
import 'package:app_waa/web/screens/drivers.dart';
import 'package:app_waa/web/screens/home.dart';
import 'package:app_waa/web/screens/login.dart';
import 'package:app_waa/web/screens/monitoring.dart';
import 'package:app_waa/web/screens/reports.dart';
import 'package:app_waa/web/screens/routes.dart';
import 'package:app_waa/web/screens/schedules.dart';
import 'package:app_waa/web/screens/settings.dart';
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
        'login':(context) => const Login(),
        'buses':(context) => const Buses(),
        'companies':(context) => const Companies(),
        'drivers':(context) => const Drivers(),
        'monitoring':(context) => const Monitoring(),
        'reports':(context) => const Reports(),
        'routes':(context) => const Routes(),
        'schedules':(context) => const Schedules(),
        'settings':(context) => const Settings(),
      },
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}

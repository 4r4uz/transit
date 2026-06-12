import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      backgroundColor: Colors.yellow,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: null
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: null,
            ),
          ),
        ],
      ),
    );
  }
}

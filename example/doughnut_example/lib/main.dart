import 'package:flutter/material.dart';
import 'package:flutter_doughnut/flutter_doughnut.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 500,
          child: Doughnut(
            data: [
              Sector(value: 60),
            ],
            selectedKey: "",
          ),
        ),
      ),
    );
  }
}

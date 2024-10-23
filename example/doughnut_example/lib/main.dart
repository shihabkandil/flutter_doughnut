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
          width: 500,
          height: 500,
          child: Doughnut(
            data: [
              Sector(value: 50,color: Colors.red),
              Sector(value: 10,color: Colors.orange),
              Sector(value: 23,color: Colors.blue),
              Sector(value: 5,color: Colors.green),
            ],
            selectedKey: "",
          ),
        ),
      ),
    );
  }
}

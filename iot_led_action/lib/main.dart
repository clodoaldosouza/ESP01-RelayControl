import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(MaterialApp(
    title: 'IOT LED Action',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Home(),
  ));
}

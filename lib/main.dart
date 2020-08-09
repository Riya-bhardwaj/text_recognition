import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:ml/QRcode.dart';
import 'package:ml/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:fyp_app/wrapper.dart';
import 'package:fyp_app/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: Wrapper(),
    );
  }
}


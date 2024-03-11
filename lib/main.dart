import 'package:flutter/material.dart';
import 'package:pep/constants.dart';
import 'package:pep/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПЭП',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(elevation: 0, backgroundColor: Colors.white),
        fontFamily: 'ProximaNova',
        textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 39,
              height: 41 / 39,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.02),
          bodyText1: TextStyle(
              fontSize: 24,
              height: 29 / 24,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.02),
          bodyText2: TextStyle(
              fontSize: 14,
              height: 17 / 14,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.02),
          button: TextStyle(
              fontSize: 24,
              height: 29 / 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.02),
        ),
      ),
      home: LoginPage(),
    );
  }
}

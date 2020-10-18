import 'package:flutter/material.dart';
import 'utils/constants/theme.dart';
import 'auth/screens/splash_screen.dart';
import 'dart:async';

void mainCommon() async {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object error, StackTrace stackTrace) {
    try {
      print("Error : $error");
    } catch (e) {
      print("Sending report failed: $e");
      print('Original error: $error');
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: SplashScreen(),
    );
  }
}

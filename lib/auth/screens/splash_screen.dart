import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:project_boilerplate/auth/screens/home_screen.dart';
import 'login_screen.dart';
import '../../utils/widgets/widget_models.dart';
import '../../utils/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer timer;

  _SplashScreenState() {
    timer = new Timer(const Duration(seconds: 3), () async {
      var token = await getPreferences('token', kType: 'string') ?? "";
      log('TOKEN PW: $token');
      if (token != "") {
        navigationManager(context, HomeScreen(), isPushReplaced: true);
      } else {
        navigationManager(context, LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwatchColor.kDarkBlue,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(80),
          child: Image.asset('assets/icons/icon_logo.png'),
        ),
      ),
    );
  }
}

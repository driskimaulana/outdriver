import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:outdriver/model/user.dart';
import 'package:outdriver/pages/Driver/home.dart';
import 'package:outdriver/pages/User/home.dart';

import 'login.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  _SplashScreenState() {
    // ignore: unnecessary_new
    new Timer(const Duration(milliseconds: 2000), () async {
      StatefulWidget redirect = Login();
      var isLogin = await SessionManager().containsKey("token");
      if (isLogin) {
        var user = await SessionManager().get("curr_user");
        if (user['role'] == "Customer") {
          redirect = HomeScreen();
        } else {
          redirect = driverHome();
        }
      }
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => redirect),
            (route) => false);
      });
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(28, 180, 54, 1),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Image.asset(
            "assets/images/outdriver.png",
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outdriver/app_utils.dart';
import 'package:outdriver/model/user.dart';
import 'package:outdriver/pages/Driver/home.dart';
import 'package:outdriver/pages/User/home.dart';
import 'package:outdriver/pages/choose_role.dart';
import 'package:outdriver/pages/registration_page.dart';

class Login extends StatefulWidget {
  static const nameRoute = '/homepage';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final mainColor = const Color.fromRGBO(28, 180, 54, 1);

  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();

  bool isLoading = false;

  bool isInputValid = true;
  String? errorEmailText = null;
  String? errorPasswordText = null;

  String _email = "", _password = "";
  String _errMessage = "";
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();

  Future<Map<String, dynamic>?> signIn() async {
    Dio dio = new Dio();
    var body = {'email': _email, 'password': _password};
    var url = "${Utils.BASE_API_URL}/user/signin";
    var res = await dio.post(url, data: body);
    // var res = await http.post(url, body: body);
    if (res.statusCode == 200) {
      return res.data;
    } else if (res.statusCode == 404 || res.statusCode == 400) {
      setState(() {
        _errMessage = res.data['message'];
      });
      return null;
    } else {
      print(res.headers['location']);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 300,
                        padding: EdgeInsets.only(top: 30),
                        child: Image(
                          image: AssetImage(
                            'assets/images/outdriver_transparent.png',
                          ),
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: ((context, index) => Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text(
                                      "Login to start your exploration.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: TextField(
                                    autofocus: true,
                                    controller: emailCtr,
                                    cursorColor: Colors.amber,
                                    showCursor: true,
                                    autocorrect: false,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    // textCapitalization:
                                    //     TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff02929A))),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 25,
                                      ),
                                      errorText:
                                          !isInputValid ? errorEmailText : null,
                                      hintText: "Your Email Address",
                                      labelText: "Email",
                                      // labelStyle: TextStyle(color: Color(0xff02929A)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: TextField(
                                    // autofocus: true,
                                    cursorColor: Colors.amber,
                                    controller: passwordCtr,
                                    showCursor: true,
                                    autocorrect: false,
                                    obscureText: true,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    // textCapitalization:
                                    //     TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      errorText: !isInputValid
                                          ? errorPasswordText
                                          : null,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff02929A))),
                                      prefixIcon: Icon(
                                        Icons.remove_red_eye,
                                        size: 25,
                                      ),
                                      hintText: "Password",
                                      labelText: "Password",
                                      // labelStyle: TextStyle(color: Color(0xff02929A)),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: mainColor,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(top: 15),
                                  width: MediaQuery.of(context).size.width,
                                  child: TextButton(
                                    child: const Text('Login'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      _email = emailCtr.text;
                                      _password = passwordCtr.text;
                                      if (_email != "" && _password != "") {
                                        Map<String, dynamic>? res =
                                            await signIn();
                                        if (res != null) {
                                          User user =
                                              User.fromJson(res['result']);
                                          await SessionManager()
                                              .set("curr_user", user);
                                          await SessionManager()
                                              .set("token", res['token']);
                                          if (user.role == "Customer") {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()),
                                                    (route) => false);
                                          } else {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            driverHome()),
                                                    (route) => false);
                                          }
                                        }
                                      } else {
                                        setState(() {
                                          isInputValid = false;
                                          errorEmailText = "Fix email field";
                                          errorPasswordText =
                                              "Fix password field";
                                          _errMessage =
                                              "Please enter your email and password";
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text(
                                      "Don't have any account in outDriver?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xff02929A),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChososeRole(),
                                        ),
                                      );
                                    },
                                    child: const Text('Register'),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
            isLoading
                ? const SpinKitChasingDots(
                    size: 20,
                    color: Color.fromRGBO(28, 180, 54, 1),
                  )
                : SizedBox(),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: mainColor),
    );
  }

  bool validateInput() {
    bool isvalid = true;
    if (emailCtr.value.text.isEmpty) {
      setState(() {
        errorEmailText = "Email should not be empty.";
        isInputValid = false;
      });
      isvalid = false;
    }

    if (passwordCtr.value.text.isEmpty) {
      setState(() {
        errorPasswordText = "Password should not be empty.";
        isInputValid = false;
      });
      return false;
    }

    if (passwordCtr.value.text.length < 8) {
      setState(() {
        errorPasswordText = "Password should contain 8 or more characters.";
        isInputValid = false;
      });
      return false;
    }

    return true;
  }

  // Future<void> _handleLogin() async {
  //   if (!validateInput()) {
  //     return;
  //   }
  //   setState(() {
  //     isLoading = true;
  //   });

  //   final loggedinUser =
  //       await AuthenticationViewModel().login(emailCtr.text, passwordCtr.text);
  //   if (loggedinUser != null) {
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setString("token", loggedinUser.token);
  //     // await UserViewModel().whoAmI(loggedinUser.token);
  //     // Restart.restartApp(webOrigin: "/");
  //     // UserViewModel().setLoggedinUser(loggedinUser);
  //     Navigator.of(context, rootNavigator: true)
  //         .pushNamedAndRemoveUntil("/", (route) => false);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Login Failed. Try again later!",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.cyan);
  //     log("LOGIN FAILED");
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  //   // log("loggedinUser: " + loggedinUser.email);
  // }
}

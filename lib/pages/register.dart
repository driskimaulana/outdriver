import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outdriver/app_utils.dart';
import 'package:outdriver/model/user.dart';
import 'package:outdriver/pages/Driver/home.dart';
import 'package:outdriver/pages/User/home.dart';

class Register extends StatefulWidget {
  String role;

  Register({super.key, required this.role});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final mainColor = const Color.fromRGBO(28, 180, 54, 1);

  var isLoading = false;

  bool isInputValid = true;
  String? errorNameText = null;
  String? errorEmailText = null;
  String? errorPasswordText = null;

  final fullNameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();

  String _role = "Customer";
  String _nama = '', _email = '', _password = '';
  String _message = '';
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  doRegis() async {
    _nama = fullNameCtr.text;
    _email = emailCtr.text;
    _password = passwordCtr.text;
    _role = widget.role;
    var body = {
      "name": _nama,
      "email": _email,
      "password": _password,
      "role": _role,
    };
    print(body);
    Dio dio = new Dio();
    var url = "${Utils.BASE_API_URL}/user/signup";
    var response = await dio.post(url, data: body);
    // var response = await http.post(url, body: body);
    if (response.statusCode == 201) {
      var body = response.data;
      SessionManager().set("token", body['token']);

      User user = User(
          id: body['result']['_id'], name: _nama, email: _email, role: _role);
      await SessionManager().set("curr_user", user);
      if (_role == "Customer") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => driverHome()),
            (route) => false);
      }
    } else if (response.statusCode == 400) {
      setState(() {
        _message = "Email already registered";
      });
    } else {
      print(response.statusCode);
      throw Exception('Failed to load post');
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
                          height: 250,
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
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text(
                                      "Create acccount to start your exploration.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: TextField(
                                    autofocus: true,
                                    controller: fullNameCtr,
                                    cursorColor: Colors.amber,
                                    showCursor: true,
                                    autocorrect: false,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    // textCapitalization:
                                    //     TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      errorText:
                                          !isInputValid ? errorNameText : null,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff02929A))),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 25,
                                      ),
                                      hintText: "Fullname",
                                      labelText: "Fullname",
                                      // labelStyle: TextStyle(color: Color(0xff02929A)),
                                    ),
                                  ),
                                ),
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
                                      errorText:
                                          !isInputValid ? errorEmailText : null,
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff02929A))),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 25,
                                      ),
                                      hintText: "Your Email Address",
                                      labelText: "Email",
                                      // labelStyle: TextStyle(color: Color(0xff02929A)),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: TextField(
                                    autofocus: true,
                                    controller: passwordCtr,
                                    cursorColor: Colors.amber,
                                    showCursor: true,
                                    autocorrect: false,
                                    textAlignVertical: TextAlignVertical.bottom,
                                    // textCapitalization:
                                    //     TextCapitalization.characters,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
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
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: _handleRegister,
                                    child: const Text('Register'),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const Text(
                                      "Already have an acoount in Flyket?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400),
                                    )),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 2),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xff02929A),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pushNamed("/login");
                                    },
                                    child: const Text('Login'),
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
    if (fullNameCtr.value.text.isEmpty) {
      setState(() {
        errorNameText = "Fullname should not be empty.";
        isInputValid = false;
      });
      return false;
    }
    if (emailCtr.value.text.isEmpty) {
      setState(() {
        errorEmailText = "Email should not be empty.";
        isInputValid = false;
      });
      return false;
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

  Future<void> _handleRegister() async {
    if (!validateInput()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    await doRegis();

    setState(() {
      isLoading = false;
    });
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outdriver/app_utils.dart';
import 'package:outdriver/pages/Driver/screens.dart/getOrder_screen.dart';
import 'package:outdriver/pages/Driver/screens.dart/myreview.dart';
import 'package:outdriver/pages/profile_page.dart';
import 'package:outdriver/view/order_confirmed.dart';

class driverHome extends StatefulWidget {
  const driverHome({super.key});
  @override
  State<driverHome> createState() => _driverhomestate();
}

class _driverhomestate extends State<driverHome> {
  changeOrderState() async {
    Dio dio = new Dio();
    var url = "${Utils.BASE_API_URL}/user/changeAcceptOrder";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    // var response = await http.get(url, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    var response = await dio.get(url);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load post');
    }
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const getOrder(isGetOrder: true),
        ),
      );
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 180, 54, 1),
        elevation: 0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/only_logo.png",
                    height: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "outDriver",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.grey[500],
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(28, 180, 54, 1),
                  ),
                ),
                onPressed: () {
                  changeOrderState();
                },
                child: const Text("Get Order"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(28, 180, 54, 1),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const getOrder(isGetOrder: false),
                    ),
                  );
                },
                child: const Text("Order History"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(28, 180, 54, 1),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyReviews(),
                    ),
                  );
                },
                child: const Text("My Reviews"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

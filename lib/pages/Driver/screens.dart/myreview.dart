import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:outdriver/model/myreview.dart';
import 'package:outdriver/model/webservices.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  bool isLoading = false;

  List<MyReview> myreviews = <MyReview>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMyReview();
  }

  getMyReview() async {
    setState(() {
      isLoading = true;
    });
    var token = await SessionManager().get("token");

    myreviews = await WebServices().fetchMyReviews(token);

    log(myreviews[0].comment);
    setState(() {
      isLoading = false;
    });
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
      ),
      body: Column(
        children: [
          Text(
            "My Reviews",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SingleChildScrollView(
            child: isLoading
                ? const SpinKitChasingDots(
                    size: 20,
                    color: Color.fromRGBO(28, 180, 54, 1),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: myreviews.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myreviews[index].customerName,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    myreviews[index].customerEmail,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 10,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Color.fromARGB(255, 178, 161, 6),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(myreviews[index].ratings.toString())
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "\"${myreviews[index].comment}\"",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

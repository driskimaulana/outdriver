import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outdriver/app_utils.dart';
import 'package:outdriver/model/listOrder.dart';
import 'package:outdriver/model/order.dart';

import 'package:outdriver/pages/User/screens/reviewform_screen.dart';
import 'package:outdriver/pages/User/screens/reviewform_screen_reviewed.dart';

class userOrder extends StatefulWidget {
  const userOrder({super.key});
  @override
  State<userOrder> createState() => _userorderstate();
}

class _userorderstate extends State<userOrder> {
  late listOrder order;
  StreamController _postsController = StreamController();
  bool isLoading = false;

  cancelOrder(String id) async {
    var body = {
      'transactionId': id,
    };
    Dio dio = new Dio();
    var url = "${Utils.BASE_API_URL}/transaction/getTransactions";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    if (response.statusCode == 200) {
      var data = response.data;
      if (data['data'] != null) {
        if (data['data']['status'] == "Accepted") {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Can't cancel Accepted order")));
        } else {
          url = "${Utils.BASE_API_URL}/transaction/deleteTransaction";
          response = await dio.post(url, data: body);
          // response = await http.post(url, body: body, headers: {
          //   'Authorization': 'Bearer $token',
          // });
          if (response.statusCode == 200) {
          } else {
            throw Exception('Failed to load post');
          }
        }
        loadPosts();
      }
    } else {
      throw Exception('Failed to load post');
    }
    setState(() {
      isLoading = false;
    });
  }

  loadPosts() async {
    setState(() {
      isLoading = true;
    });
    fetchPost().then((res) async {
      _postsController.add(res);
      setState(() {
        isLoading = false;
      });
      return res;
    });
  }

  @override
  void initState() {
    loadPosts();
    super.initState();
  }

  Future fetchPost() async {
    Dio dio = new Dio();
    var url = "${Utils.BASE_API_URL}/transaction/getTransactionByCustomerId";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.get(url);
    // var response = await http.get(url, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    if (response.statusCode == 200) {
      if (response.data['data'] != null) {
        order = listOrder.fromJson(response.data);
        return order.order;
      } else {
        return {'message': "empty"};
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  Widget getButton(String status, String id, Order data) {
    if (status == "Waiting") {
      return TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.redAccent,
        ),
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          cancelOrder(id);
        },
        child: Text("Batal"),
      );
    } else if (status == "Accepted") {
      return Text("On Going");
    } else if (status == "Rejected") {
      return Text("Rejected");
    }
    print("ini sebelum return get buttonn");
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.blue,
      ),
      onPressed: () async {
        var review = await isReview(data.id);
        var isReviewed = true;
        if (await review.data['data'].isEmpty) {
          isReviewed = false;
        }

        if (isReviewed) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => reviewFormAlreadyReviewed(
                      data,
                      review.data['data'][0]['rating'],
                      review.data['data'][0]['comment'])));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => reviewForm(data)));
        }
        // if (isReviewed) {
        //     print("Masuk Sini");
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => reviewForm(data)));
        // }
        // isReview(data.id).then((val) async {
        //   print("MASUK KEDALEM SINI");
        //   print("ini DATANYA" + val);
        // });
      },
      child: Text("Detail"),
    );
  }

  isReview(String id) async {
    print("MASUK SINI KAN");
    var body = {
      'transactionId': id,
    };
    Dio dio = new Dio();
    var url = "${Utils.BASE_API_URL}/review/checkCustomerReview";
    var token = await SessionManager().get("token");
    // print("TOKEEN :" + token);
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    // try {
    //   return await dio.post(url, data: body);
    // } on DioError catch (e) {
    //   print("ERRROR");
    //   print(e);
    // }
    // print("RESPONSEE: " + response.data['data']);
    var response = await dio.post(url, data: body);
    if (response.statusCode == 200) {
      return response;
      // print(response.data['data']);
      // if (response.data['data'].isEmpty) {
      //   //order = listOrder.fromJson(response.data);
      //   return false;
      // } else {
      //   // return Future.delayed(const Duration(seconds: 1), () => false);
      //   return true;
      // }
    } else {
      throw Exception('Failed to load post');
    }
  }

  String formatToLocalDate(DateTime dt) {
    String formatted = DateFormat.yMMMMd().add_jm().format(dt);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(28, 180, 54, 1),
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
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh),
            onPressed: () {
              print("asd");
              loadPosts();
            },
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            minimum: const EdgeInsets.all(10),
            child: Container(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                    stream: _postsController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            padding: EdgeInsets.only(bottom: 70),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, int index) {
                              //  print(snapshot.data[index]);
                              return Card(
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot
                                                    .data[index].from['name'],
                                              ),
                                              Text(snapshot
                                                  .data[index].to['name']),
                                              Text(
                                                  "Driver: ${snapshot.data[index].driver['name']}"),
                                              Text(formatToLocalDate(
                                                  snapshot.data[index].date)),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          getButton(
                                            snapshot.data[index].status,
                                            snapshot.data[index].id,
                                            snapshot.data[index],
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            });
                      }
                      return Text("Loading");
                    })),
          ),
          isLoading
              ? Stack(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Opacity(
                      opacity: 0.8,
                      child:
                          ModalBarrier(dismissible: false, color: Colors.black),
                    ),
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}

class order {
  String id;
  String nama;
  int status;

  order({required this.id, required this.nama, required this.status});
}

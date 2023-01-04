import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:google_place/src/details/details_result.dart';
import 'package:outdriver/app_utils.dart';
import 'package:outdriver/model/driver.dart';
import 'package:outdriver/model/listDriver.dart';
import 'package:outdriver/pages/User/home.dart';
import 'package:outdriver/pages/User/userOrder.dart';

class foundDriver extends StatefulWidget {
  final DetailsResult? startPosition;
  final DetailsResult? endPosition;
  final distance;
  final total;

  const foundDriver(
      this.startPosition, this.endPosition, this.distance, this.total,
      {super.key});
  @override
  State<foundDriver> createState() => _founddriverstate();
}

class _founddriverstate extends State<foundDriver> {
  bool isOrder = false;
  late StreamController _postController;
  late Driver driver;

  Future fetchPost() async {
    Dio dio = new Dio();
    var body = {
      "latitude": widget.startPosition!.geometry!.location!.lat?.toDouble(),
      "longitude": widget.startPosition!.geometry!.location!.lng?.toDouble()
    };
    var url = "${Utils.BASE_API_URL}/transaction/searchDriver";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    if (response.statusCode == 200) {
      if (response.data['data'] != null) {
        setState(() {
          driver = Driver.fromJson(response.data['data']);
        });
      }
      return response.data;
    } else {
      throw Exception('Failed to load post');
    }
  }

  loadPosts() async {
    fetchPost().then((res) async {
      _postController.add(res);
      return res;
    });
  }

  @override
  void initState() {
    _postController = new StreamController();
    loadPosts();
    super.initState();
  }

  Future<void> createOrder() async {
    var body = {
      "driverId": driver.id,
      "fromName": widget.startPosition!.name,
      "fromCoords": [
        widget.startPosition!.geometry!.location!.lat,
        widget.startPosition!.geometry!.location!.lng
      ],
      "toName": widget.endPosition!.name,
      "toCoords": [
        widget.endPosition!.geometry!.location!.lat,
        widget.endPosition!.geometry!.location!.lng
      ],
      "cost": widget.total,
      "paymentMethod": "Dana"
    };
    Dio dio = new Dio();
    var url = "${Utils.BASE_API_URL}/transaction/orderDriver";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => userOrder()));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Null> _handleRefresh() async {
    print("asd");
    await Future.delayed(Duration(milliseconds: 1000));
    loadPosts();
  }

  // Stream<Driver> driverStream() async* {
  //   while (true) {
  //     await Future.delayed(Duration(milliseconds: 1000));
  //     var body = {
  //       "latitude": (-6.8604879108849435).toString(),
  //       "longitude": 107.58375567575885.toString()
  //     };
  //     var url = Uri.parse("${Utils.BASE_API_URL}/transaction/searchDriver");
  //     var token = await SessionManager().get("token");
  //     var res = await http.post(url, body: body, headers: {
  //       'Authorization': 'Bearer $token',
  //     });
  //     Driver someProduct = Driver.fromJson(jsonDecode(res.body())['data']);
  //     yield someProduct;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Available Driver'),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              minimum: const EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                  stream: _postController.stream,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      double lat1 = widget
                              .startPosition!.geometry!.location!.lat
                              ?.toDouble() ??
                          0.0;
                      double lon1 = widget
                              .startPosition!.geometry!.location!.lng
                              ?.toDouble() ??
                          0.0;
                      double lat2 = driver.location['coordinates'][0];
                      double lon2 = driver.location['coordinates'][1];
                      print(driver.location);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Nearest Driver Found",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver.name,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow),
                                          Text(driver.ratings.toString()),
                                        ],
                                      ),
                                      Text(
                                          '${Utils.calculateDistance(lat1, lon1, lat2, lon2).toStringAsFixed(0)} KM From You'),
                                    ],
                                  ),
                                )),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ElevatedButton(
                                  onPressed: (() {
                                    setState(() {
                                      isOrder = true;
                                      print(widget.total);
                                    });
                                    createOrder();
                                  }),
                                  child: Text(("Order").toUpperCase())))
                        ],
                      );
                    }
                    _handleRefresh();
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Searching Driver, Please Wait..."),
                      ],
                    );
                  }),
                ),
              ),
            ),
            isOrder
                ? Stack(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Opacity(
                        opacity: 0.8,
                        child: ModalBarrier(
                            dismissible: false, color: Colors.black),
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : Container()
          ],
        ));
  }
}

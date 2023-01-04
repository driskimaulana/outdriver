import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:outdriver/app_utils.dart';
import 'package:outdriver/model/listOrder.dart';
import 'package:outdriver/model/order.dart';
import 'package:outdriver/view/order_confirmed.dart';

class getOrder extends StatefulWidget {
  final bool isGetOrder;
  const getOrder({required this.isGetOrder, super.key});
  @override
  State<getOrder> createState() => _getorderstate();
}

class _getorderstate extends State<getOrder> {
  late listOrder order;
  StreamController _postsController = StreamController();
  bool isLoading = false;
  String _message = "loading...";
  double _lat = 0.0, _long = 0.0;

  @override
  void initState() {
    widget.isGetOrder ? changeOrderState() : null;
    loadPosts();
    super.initState();
  }

  void dispose() {
    widget.isGetOrder ? changeOrderState() : null;
    super.dispose();
  }

  updateLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _long = position.longitude;
      _lat = position.latitude;
    });

    var body = jsonEncode({"latitude": _lat, "longitude": _long});
    var url = Uri.parse("${Utils.BASE_API_URL}/user/refreshLocation");
    var token = await SessionManager().get("token");
    Dio dio = new Dio();
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    var response = await dio.post("${Utils.BASE_API_URL}/user/refreshLocation",
        data: body);
    print(token);
    print(body);
    print(jsonEncode(response.data));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load post');
    }
  }

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
  }

  checkAvailable(String id, Function(String id) callback) async {
    print("asdasd");
    Dio dio = new Dio();
    var body = {
      'transactionId': id,
    };
    var url = "${Utils.BASE_API_URL}/transaction/getTransactions";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    // print(token);
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    print(response.data);
    if (response.statusCode == 200) {
      if (response.data['status'] == "Success") {
        await callback(id);
        loadPosts();
      } else {
        throw Exception('Failed to load post');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  acceptOrder(String id) async {
    Dio dio = new Dio();
    var body = {
      'transactionId': id,
    };
    var url = "${Utils.BASE_API_URL}/transaction/acceptTransaction";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    // print(token);
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ConfirmedOrder()));
    } else {
      throw Exception('Failed to load post');
    }
  }

  rejectOrder(String id) async {
    Dio dio = new Dio();
    var body = {
      'transactionId': id,
    };
    var url = "${Utils.BASE_API_URL}/transaction/rejectTransaction";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    // print(token);
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load post');
    }
  }

  doneOrder(String id) async {
    Dio dio = new Dio();
    var body = {
      'transactionId': id,
    };
    var url = "${Utils.BASE_API_URL}/transaction/doneTransaction";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    // print(token);
    // var response = await http.post(url, body: body, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    print(response.data);
    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to load post');
    }
  }

  loadPosts() async {
    widget.isGetOrder ? updateLocation() : null;
    isLoading = true;
    fetchPost().then((res) async {
      _postsController.add(res);
      setState(() {
        isLoading = false;
      });
      return res;
    });
  }

  Future fetchPost() async {
    Dio dio = new Dio();
    var url = "${Utils.BASE_API_URL}/transaction/getTransactionByDriverId";
    var token = await SessionManager().get("token");
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.get(url);
    // var response = await http.get(url, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.data['data'].length > 0) {
        order = listOrder.fromJson(response.data);
        return order.order;
      } else {
        setState(() {
          _message = "No order, Load again to refresh";
        });
        return null;
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  String formatToLocalDate(DateTime dt) {
    String formatted = DateFormat.yMMMMd().add_jm().format(dt);
    return formatted;
  }

  Widget getButton(String id, String status) {
    if (status == "Waiting") {
      return Row(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              checkAvailable(id, acceptOrder);
            },
            child: Text("Terima"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              checkAvailable(id, rejectOrder);
            },
            child: Text(
              "Tolak",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      );
    } else if (status == "Accepted") {
      return TextButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          checkAvailable(id, doneOrder);
        },
        child: Text(
          "Selesai",
          style: TextStyle(color: Colors.green),
        ),
      );
    }
    return Text(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isGetOrder
            ? Text("Getting Order...")
            : Text("Order History"),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _message = "loading...";
              });
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
                              var coor =
                                  snapshot.data![index].from['coordinates'];
                              double lat1 = coor[0];
                              double lon1 = coor[1];
                              double lat2 = _lat;
                              double lon2 = _long;
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
                                                  "Customer: ${snapshot.data[index].driver['name']}"),
                                              Text(
                                                  "${Utils.calculateDistance(lat1, lon1, lat2, lon2).toStringAsFixed(0)} KM From You"),
                                              Text(snapshot.data[index].cost
                                                  .toString())
                                            ],
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          getButton(snapshot.data[index].id,
                                              snapshot.data[index].status)
                                          // TextButton(
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       isLoading = true;
                                          //     });
                                          //     acceptOrder(
                                          //         snapshot.data[index].id);
                                          //   },
                                          //   child: Text("Terima"),
                                          // ),
                                          // TextButton(
                                          //   onPressed: () {
                                          //     setState(() {
                                          //       isLoading = true;
                                          //     });
                                          //   },
                                          //   child: Text(
                                          //     "Tolak",
                                          //     style:
                                          //         TextStyle(color: Colors.red),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    )),
                              );
                            });
                      }
                      return Text(_message);
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

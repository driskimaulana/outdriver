//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outdriver/app_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:outdriver/model/order.dart';
import 'package:outdriver/pages/User/userOrder.dart';
//import 'package:outdriver/collegeinfo.dart';

class reviewFormAlreadyReviewed extends StatefulWidget {
  final Order? order;
  final double rating;
  final String review;
  const reviewFormAlreadyReviewed(this.order, this.rating, this.review,
      {super.key});
  @override
  State<reviewFormAlreadyReviewed> createState() => _loginpageState();
}

class _loginpageState extends State<reviewFormAlreadyReviewed> {
  //final titleController = TextEditingController();
  final commentController = TextEditingController();
  var ratings;

  String formatToLocalDate(DateTime dt) {
    String formatted = DateFormat.yMMMMd().add_jm().format(dt);
    return formatted;
  }

  createReview(int rating) async {
    print(rating);
    var body = {
      "transactionId": widget.order!.id,
      "driverId": widget.order!.driver["_id"],
      "rating": rating,
      "comment": commentController.text,
    };

    print("ini transaction id" + body["transactionId"]);
    print("ini driver id" + body["driverId"]);
    print(body["rating"]);
    print(body["comment"]);
    Dio dio = Dio();
    var url = "${Utils.BASE_API_URL}/review/createReview";
    print(url);
    var token = await SessionManager().get("token");
    print(token);
    dio.options.headers["Authorization"] = 'Bearer ${token}';
    var response = await dio.post(url, data: body);
    print(response);
    // var response = await http.get(url, headers: {
    //   'Authorization': 'Bearer $token',
    // });
    if (response.statusCode == 200) {
      if (response.data['data'] != null) {
        print("create review success");
      } else {
        return {'message': "empty"};
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.order!.to);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Beri Review",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(1),
          child: ListView(
            children: <Widget>[
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 44, 190, 63),
                      Color.fromARGB(255, 67, 204, 108)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.5, 0.9],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 255, 250, 250),
                          minRadius: 35.0,
                          child: Icon(Icons.call, size: 30.0),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          minRadius: 60.0,
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                AssetImage('assets/images/logo.png'),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 241, 237, 237),
                          minRadius: 35.0,
                          child: Icon(Icons.message, size: 30.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.order!.driver['name'],
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'From : ' + widget.order!.from['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'To : ' + widget.order!.to['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Date : ' + formatToLocalDate(widget.order!.date),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: RatingBar.builder(
                    initialRating: widget.rating,
                    unratedColor: Color.fromARGB(255, 177, 204, 179),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    updateOnDrag: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.black,
                        ),
                    onRatingUpdate: (rating) {
                      //print(rating);
                      ratings = rating;
                    }),
              ),
              Center(
                child: Text(
                  widget.review,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

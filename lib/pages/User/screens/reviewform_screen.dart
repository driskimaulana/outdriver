import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:outdriver/collegeinfo.dart';

class addratingspage extends StatefulWidget {
  @override
  State<addratingspage> createState() => _loginpageState();
}

class _loginpageState extends State<addratingspage> {
  final titleController = TextEditingController();
  final reviewController = TextEditingController();
  var ratings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          collegeinfopage.collegename,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Add review',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
              Center(
                child: RatingBar.builder(
                    unratedColor: Colors.grey.shade900,
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    updateOnDrag: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                    onRatingUpdate: (rating) {
                      ratings = rating;
                    }),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: titleController,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please add review';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Title',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: TextField(
                  minLines: 1,
                  maxLines: 8,
                  style: TextStyle(color: Colors.white),
                  controller: reviewController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Review (Optional)',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                      onPressed: () {
                        if (ratings == null) {
                          Fluttertoast.showToast(
                              msg: 'Please add a rating',
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              gravity: ToastGravity.BOTTOM);
                        } else if (titleController.text == '') {
                          Fluttertoast.showToast(
                              msg: 'Please add a Title to the review',
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              gravity: ToastGravity.BOTTOM);
                        } else {
                          FirebaseFirestore.instance
                              .collection(collegeinfopage.college_id)
                              .doc(collegeinfopage.emailid)
                              .set({
                            "Email": collegeinfopage.emailid,
                            "Title": titleController.text,
                            "rating": ratings,
                            "Body": reviewController.text,
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Add review',
                        style: TextStyle(color: Colors.black),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:developer';

class MyReview {
  final String comment, customerName, customerEmail;
  final double ratings;

  MyReview(this.customerName, this.customerEmail, this.comment, this.ratings);

  factory MyReview.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    final customer = json["customer"];
    return MyReview(customer["name"], customer["email"], json["comment"],
        json["rating"].toDouble());
  }
}

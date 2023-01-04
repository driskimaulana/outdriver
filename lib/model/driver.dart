import 'package:outdriver/model/user.dart';

class Driver extends User {
  var location = {};
  double ratings;
  Driver(
      {required this.location,
      required this.ratings,
      required id,
      required name,
      required email})
      : super(id: id, name: name, email: email, role: "Driver");

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        location: json['location'],
        ratings: json['ratings'],
        id: json['_id'],
        name: json['name'],
        email: json['email']);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:outdriver/model/myreview.dart';

class WebServices {
  static const String BASE_URL = "https://outdriver-backend.vercel.app/";

  Future<List<MyReview>> fetchMyReviews(String token) async {
    String endpoint = "/review/getDriverReviews";
    var url = Uri.parse(BASE_URL + endpoint);
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body["data"];
      return json.map((e) => MyReview.fromJson(e)).toList();
    } else {
      throw Exception("Unable to perform request");
    }
  }
}

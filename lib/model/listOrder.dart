import 'package:outdriver/model/order.dart';

class listOrder {
  List<Order> order = <Order>[];
  listOrder(Map<String, dynamic> json) {
    for (var val in json['data']) {
      order.add(Order.fromJson(val));
    }
  }

  factory listOrder.fromJson(Map<String, dynamic> json) {
    return listOrder(json);
  }
}

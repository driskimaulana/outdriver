class Order {
  String id;
  String status;
  int cost;
  String payment;
  DateTime date;
  var customer;
  var driver;
  var from;
  var to;

  Order(
      {required this.id,
      required this.status,
      required this.cost,
      required this.payment,
      required this.date,
      required this.customer,
      required this.driver,
      required this.from,
      required this.to});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['_id'],
        status: json['status'],
        cost: json['cost'],
        payment: json['paymentMethod'],
        date: DateTime.parse(json['createdAt']),
        customer: json['customer'],
        driver: json['driver'],
        from: json['from'],
        to: json['to']);
  }
}

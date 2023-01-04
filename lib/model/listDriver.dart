import 'package:outdriver/model/driver.dart';

class listDriver {
  List<Driver> driver = <Driver>[];
  listDriver(Map<String, dynamic> json) {
    for (var val in json['data']) {
      driver.add(Driver.fromJson(val));
    }
  }

  factory listDriver.fromJson(Map<String, dynamic> json) {
    return listDriver(json);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outdriver/view/order_confirmed.dart';

main() {
  runApp(OutDriver());
}

class OutDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConfirmedOrder(),
    );
  }
}

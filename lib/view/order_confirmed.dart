import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ConfirmedOrder());
}

class ConfirmedOrder extends StatelessWidget {
  const ConfirmedOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("OutDriver"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/amico.png",
                width: 330,
                height: 330,
              ),
              Text(
                "Silakan Berangkat!",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

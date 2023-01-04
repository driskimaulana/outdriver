import 'package:flutter/material.dart';
import 'package:outdriver/pages/Driver/home.dart';

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
                "assets/images/amico.png",
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => driverHome()),
                      (route) => false);
                },
                child: Text("Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

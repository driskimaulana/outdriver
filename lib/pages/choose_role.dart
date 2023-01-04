import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:outdriver/pages/register.dart';

class ChososeRole extends StatefulWidget {
  const ChososeRole({super.key});

  @override
  State<ChososeRole> createState() => _ChososeRoleState();
}

class _ChososeRoleState extends State<ChososeRole> {
  String role = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You are a ...",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 38,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  role = "Customer";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(
                        role: role,
                      ),
                    ),
                  );
                });
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: role == "Customer"
                      ? Colors.white
                      : Color.fromARGB(34, 0, 0, 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/user.png"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Customer",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  role = "Driver";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(
                        role: role,
                      ),
                    ),
                  );
                });
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: role == "Driver"
                      ? Colors.white
                      : Color.fromARGB(34, 0, 0, 0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/pana.png"),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Driver",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

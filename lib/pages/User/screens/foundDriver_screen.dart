import 'package:flutter/material.dart';
import 'package:google_place/src/details/details_result.dart';

class foundDriver extends StatefulWidget {
  const foundDriver(DetailsResult? startPosition, DetailsResult? endPosition,
      double distance, int total,
      {super.key});
  @override
  State<foundDriver> createState() => _founddriverstate();
}

class _founddriverstate extends State<foundDriver> {
  List<Driver> dataDriver = [
    Driver(id: "1", nama: "Udin Jalaludin", status: 0),
    Driver(id: "2", nama: "Udin Jalaludin", status: 1),
    Driver(id: "3", nama: "Udin Jalaludin", status: 1),
    Driver(id: "4", nama: "Udin Jalaludin", status: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Driver'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 70),
                itemCount: dataDriver.length,
                itemBuilder: (context, int index) {
                  return Card(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dataDriver[index].nama,
                                style: TextStyle(fontSize: 18),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {},
                                child: Text("Order"),
                              ),
                            ],
                          ),
                        )),
                  );
                })),
      ),
    );
  }
}

class Driver {
  String id;
  String nama;
  int status;

  Driver({required this.id, required this.nama, required this.status});
}

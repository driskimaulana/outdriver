import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outdriver/Driver/driverHome.dart';
import 'package:outdriver/Model/model.dart';
import 'package:provider/provider.dart';

class userHome extends StatefulWidget {
  const userHome({super.key});
  @override
  State<userHome> createState() => _userhomestate();
}

class _userhomestate extends State<userHome> {
  List<driver> dataDriver = [
    driver(id: "1", nama: "Udin Jalaludin"),
    driver(id: "2", nama: "Udin Jalaludin"),
    driver(id: "3", nama: "Udin Jalaludin"),
    driver(id: "4", nama: "Udin Jalaludin"),
    driver(id: "1", nama: "Udin Jalaludin"),
    driver(id: "2", nama: "Udin Jalaludin"),
    driver(id: "3", nama: "Udin Jalaludin"),
    driver(id: "4", nama: "Udin Jalaludin"),
    driver(id: "1", nama: "Udin Jalaludin"),
    driver(id: "2", nama: "Udin Jalaludin"),
    driver(id: "3", nama: "Udin Jalaludin"),
    driver(id: "4", nama: "Udin Jalaludin"),
    driver(id: "1", nama: "Udin Jalaludin"),
    driver(id: "2", nama: "Udin Jalaludin"),
    driver(id: "3", nama: "Udin Jalaludin"),
    driver(id: "4", nama: "Udin Jalaludin"),
    driver(id: "1", nama: "Udin Jalaludin"),
    driver(id: "2", nama: "Udin Jalaludin"),
    driver(id: "3", nama: "Udin Jalaludin"),
    driver(id: "4", nama: "Udin Jalaludin"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(''),),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: const EdgeInsets.all(50),
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 70),
                itemCount: dataDriver.length,
                itemBuilder: (context, int index) {
                  return Card(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dataDriver[index].nama,
                                style: GoogleFonts.inter(
                                    color: Colors.black, textStyle: TextStyle(fontSize: 20)
                                ),
                              ),
                              Consumer<Model>(
                                builder: (context, model, child) {
                                  return  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.white,
                                      padding: EdgeInsets.all(20),
                                      backgroundColor: Color.fromRGBO(4, 158, 10, 1),
                                    ),
                                    onPressed: () {
                                      model.idx = 1;
                                    },
                                    child: Text("Pesan"),
                                  );
                                },
                              )
                            ],
                          ),
                        )
                    ),
                  );
                }
            )
        ),
      ),
    );

  }
}

class driver {
  String id;
  String nama;

  driver({required this.id, required this.nama});
}

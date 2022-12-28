import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class userOrder extends StatefulWidget {
  const userOrder({super.key});
  @override
  State<userOrder> createState() => _userorderstate();
}

class _userorderstate extends State<userOrder> {
  List<order> dataOrder = [
    order(id: "1", nama: "Udin Jalaludin", status: 0),
    order(id: "2", nama: "Udin Jalaludin", status: 1),
    order(id: "3", nama: "Udin Jalaludin", status: 1),
    order(id: "4", nama: "Udin Jalaludin", status: 1),
  ];

  Widget getButton(int status){
    if(status == 0){
      return TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.all(20),
          minimumSize: Size(100, 40),
          backgroundColor: Colors.redAccent,
        ),
        onPressed: () {

        },
        child: Text("Batal"),
      );
    }

    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.all(20),
        minimumSize: Size(100, 40),
        backgroundColor: Color.fromRGBO(4, 158, 10, 1),
      ),
      onPressed: () {

      },
      child: Text("Selesai"),
    );
  }

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
                itemCount: dataOrder.length,
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
                                dataOrder[index].nama,
                                style: GoogleFonts.inter(
                                    color: Colors.black, textStyle: TextStyle(fontSize: 20)
                                ),
                              ),
                              getButton(dataOrder[index].status)
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

class order {
  String id;
  String nama;
  int status;

  order({required this.id, required this.nama, required this.status});
}

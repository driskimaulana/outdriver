import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outdriver/view/order_confirmed.dart';

class driverHome extends StatefulWidget {
  const driverHome({super.key});
  @override
  State<driverHome> createState() => _driverhomestate();
}

class _driverhomestate extends State<driverHome> {
  List<order> dataOrder = [
    order(id: "1", nama: "Udin Jalaludin", status: 0),
    order(id: "2", nama: "Udin Jalaludin", status: 1),
    order(id: "3", nama: "Udin Jalaludin", status: 2),
    order(id: "4", nama: "Udin Jalaludin", status: 3),
  ];

  Widget getButton(int status){
    if(status == 0){
      return TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.all(20),
          minimumSize: Size(135, 40),
          backgroundColor: Color.fromRGBO(4, 158, 10, 1),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConfirmedOrder()));
        },
        child: Text("Terima"),
      );
    }else if(status == 1){
      return TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.all(20),
          minimumSize: Size(135, 40),
          backgroundColor: Color.fromRGBO(4, 158, 10, 1),
        ),
        onPressed: () {

        },
        child: Text("Selesai"),
      );
    }else if(status == 2){
      return TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          padding: EdgeInsets.all(20),
          minimumSize: Size(135, 40),
          backgroundColor: Color.fromRGBO(4, 158, 10, 1),
        ),
        onPressed: () {

        },
        child: Text("Order Selesai"),
      );
    }

    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.all(20),
        minimumSize: Size(135, 40),
        backgroundColor: Color.fromRGBO(4, 158, 10, 1),
      ),
      onPressed: () {

      },
      child: Text("Dibatalkan"),
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

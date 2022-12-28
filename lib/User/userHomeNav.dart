import 'package:flutter/material.dart';
import 'package:outdriver/Model/model.dart';
import 'userHome.dart';
import 'package:outdriver/User/userOrder.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class userHomeNav extends StatefulWidget {
  const userHomeNav({super.key});
  @override
  State<userHomeNav> createState() => _userHomeNav();
}

class _userHomeNav extends State<userHomeNav> {

  @override
  Widget build(BuildContext context) {
    Model modelNotifier = Provider.of<Model>(context);
    return Consumer<Model>(
      builder: (context, model, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: model.halaman,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: model.idx,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: (int index){model.idx = index;}, //event saat button di tap
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    PhosphorIcons.house, // Pencil Icon
                  ),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(
                    PhosphorIcons.article, // Pencil Icon
                  ),
                  label: "Order History"),
            ],
          ),
        );
      },
    );
  }
}

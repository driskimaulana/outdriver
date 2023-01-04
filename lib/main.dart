import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'pages/splash_screen.dart';

void main() {
  runApp(LoginUiApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(4, 158, 10, .1),
  100: Color.fromRGBO(4, 158, 10, .2),
  200: Color.fromRGBO(4, 158, 10, .3),
  300: Color.fromRGBO(4, 158, 10, .4),
  400: Color.fromRGBO(4, 158, 10, .5),
  500: Color.fromRGBO(4, 158, 10, .6),
  600: Color.fromRGBO(4, 158, 10, .7),
  700: Color.fromRGBO(4, 158, 10, .8),
  800: Color.fromRGBO(4, 158, 10, .9),
  900: Color.fromRGBO(4, 158, 10, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF049E0A, color);

class LoginUiApp extends StatelessWidget {
  Color _primaryColor = HexColor('#4AA02C');
  Color _accentColor = HexColor('#6AA121');

  // Design color
  // Color _primaryColor= HexColor('#FFC867');
  // Color _accentColor= HexColor('#FF3CBD');

  // Our Logo Color
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _accentColor= HexColor('#5E18C8');

  // Our Logo Blue Color
  //Color _primaryColor= HexColor('#651BD2');
  //Color _accentColor= HexColor('#320181');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'outDriver',
      theme: ThemeData(
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: colorCustom,
      ),
      home: SplashScreen(title: 'Flutter Login UI'),
    );
  }
}

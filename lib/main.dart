import 'package:flutter/material.dart';
import 'package:outdriver/Model/model.dart';
import 'package:outdriver/User/userHomeNav.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Model(),
      child: const MyApp(),
    ),
  );
}
Map<int, Color> color =
{
  50:Color.fromRGBO(4, 158, 10, .1),
  100:Color.fromRGBO(4, 158, 10, .2),
  200:Color.fromRGBO(4, 158, 10, .3),
  300:Color.fromRGBO(4, 158, 10, .4),
  400:Color.fromRGBO(4, 158, 10, .5),
  500:Color.fromRGBO(4, 158, 10, .6),
  600:Color.fromRGBO(4, 158, 10, .7),
  700:Color.fromRGBO(4, 158, 10, .8),
  800:Color.fromRGBO(4, 158, 10, .9),
  900:Color.fromRGBO(4, 158, 10, 1),
};
MaterialColor colorCustom = MaterialColor(0xFF049E0A, color);

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: colorCustom
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return userHomeNav();
  }
}

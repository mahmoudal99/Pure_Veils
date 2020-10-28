import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pure_veils/add_order.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DateTime dateTime = DateTime.now();
  runApp(MyApp(
    dateTime: dateTime,
  ));
}

class MyApp extends StatefulWidget {

  DateTime dateTime;

  MyApp({
    Key key,
    this.dateTime,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Veils',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.white,  iconTheme: IconThemeData(color: Colors.black,)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        title: 'Pure Veils',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black, fontFamily: "Bodoni", fontSize: 28),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => CreateOrderScreen()
          ));
        },
        backgroundColor: Colors.white,
        tooltip: 'Increment',
        elevation: 15,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

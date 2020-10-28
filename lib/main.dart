import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_veils/add_order.dart';
import 'package:pure_veils/services/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/order.dart';
import 'models/profit.dart';

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
  CloudFirestore cloudFirestore = new CloudFirestore();
  String today = DateTime.now().day.toString();
  String month = DateTime.now().month.toString();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<Order>>.value(
            value: cloudFirestore.streamOrders(widget.dateTime.day.toString(),
                widget.dateTime.month.toString()),
          ),
          StreamProvider<Profit>.value(
            value: cloudFirestore.streamProfit(widget.dateTime.day.toString(),
                widget.dateTime.month.toString()),
          )
        ],
        child: MaterialApp(
          title: 'Pure Veils',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
                color: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black,
                )),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: MyHomePage(
            title: 'Pure Veils',
            orderDate: widget.dateTime,
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  DateTime orderDate;

  MyHomePage({Key key, this.title, this.orderDate}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Order> orders;
  CloudFirestore cloudFirestore = new CloudFirestore();

  _launchCaller(String phoneNumber) async {
    String url = "tel:" + phoneNumber;
    await launch(url);
  }

  bool showOrderDesc = false;

  @override
  Widget build(BuildContext context) {
    orders = Provider.of<List<Order>>(context);
    Profit profit = Provider.of<Profit>(context);

    if (profit == null) {
      setState(() {
        profit = new Profit(profit: 0.toString());
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.black, fontFamily: "Bodoni", fontSize: 28),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child: Text(
              "Total: " + profit.profit,
              style: TextStyle(color: Colors.black, fontSize: 18),
            )),
          )
        ],
      ),
      body: _showOrders(
        profit,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateOrderScreen(dateTime: widget.orderDate,)));
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

  Widget _showOrders(
    Profit profit,
  ) {
    return orders.length == 0
        ?
        // No orders widget
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        widget.orderDate.day.toString() +
                            "/" +
                            widget.orderDate.month.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.green),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: RaisedButton(
                      onPressed: () {
                        _pickDate();
                      },
                      elevation: 0,
                      color: Colors.white,
                      child: Icon(
                        Icons.calendar_today,
                        size: 22,
                        color: Color(0xffF8BBD0),
                      ),
                    ),
                  )
                ],
              ),
              Image.asset(
                "assets/delivery.jpg",
                height: 200,
                width: 200,
              ),
              Text(
                "No orders today!",
                style: TextStyle(fontSize: 20),
              ),
            ],
          )
        : SingleChildScrollView(
            // Orders column
            child: Column(
              children: [
                // Date & Calendar column
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          widget.orderDate.day.toString() +
                              "/" +
                              widget.orderDate.month.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.green),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        onPressed: () {
                          _pickDate();
                        },
                        elevation: 0,
                        color: Colors.white,
                        child: Icon(
                          Icons.calendar_today,
                          size: 22,
                          color: Color(0xffF8BBD0),
                        ),
                      ),
                    )
                  ],
                ),
                // Order Column
                Column(
                    children: orders
                        .map(
                          (order) =>
                              // Order information
                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, bottom: 20),
                                  child: Card(
                                    elevation: 10,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Name & Time
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _updateValue(
                                                    order.orderID,
                                                    "customerName",
                                                    "e.g. John Smith");
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 20),
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Text(
                                                    order.customerName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15, right: 10, left: 20),
                                              child: InkWell(
                                                onTap: () {
                                                  cloudFirestore.deleteOrder(
                                                      order,
                                                      widget.orderDate.month
                                                          .toString());
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 22,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Location & Payment Type
                                        Padding(
                                          padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 250,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.teal,
                                                      size: 22,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .only(left: 10),
                                                      child: SelectableText(
                                                        order.address,
                                                        onTap: () {
                                                          _updateValue(
                                                              order.orderID,
                                                              "address",
                                                              "e.g. Dublin 24");
                                                        },
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              order.paymentType
                                                      .contains("Cash")
                                                  ? Image.asset(
                                                      "assets/cash.png",
                                                      height: 35,
                                                      width: 35,
                                                    )
                                                  : Icon(
                                                      Icons.credit_card,
                                                      color: Colors.black,
                                                      size: 22,
                                                    ),
                                            ],
                                          ),
                                        ),
                                        // Number & Order Total
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _launchCaller(
                                                            order.phoneNumber);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Icon(
                                                          Icons.phone,
                                                          color:
                                                              Colors.blueAccent,
                                                          size: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: InkWell(
                                                          onTap: () async {
                                                            _updateValue(
                                                                order.orderID,
                                                                "phoneNumber",
                                                                "e.g. 089 494 5632");
                                                          },
                                                          child: Text(
                                                            order.phoneNumber,
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5,
                                                          top: 10,
                                                          right: 10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      "Order Total",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20,
                                                          right: 10),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Text(
                                                      "€" +
                                                          order.orderPrice
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 1),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Column(
                                        children: [
                                          Transform.scale(
                                            scale: 0.8,
                                            child: Checkbox(
                                              value: order.orderComplete,
                                              onChanged: (val) {
                                                cloudFirestore.setOrderDone(
                                                    order.orderID,
                                                    widget.orderDate.day
                                                        .toString(),
                                                    val,
                                                    widget.orderDate.month
                                                        .toString());
                                                order.orderComplete = val;
                                              },
                                            ),
                                          ),
                                          Text(
                                            "Order \nComplete",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                    order.isPaid
                                        ? Icon(
                                            Icons.done,
                                            color: Colors.green,
                                            size: 22,
                                          )
                                        : Icon(
                                            Icons.do_not_disturb_alt,
                                            color: Colors.red,
                                            size: 22,
                                          )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                        .toList()),
              ],
            ),
          );
  }

  _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (dateTime != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(
                      dateTime: dateTime,
                    )));
      });
    }
  }

  _updateValue(String id, String field, String hintText) async {
    TextEditingController textEditingController = new TextEditingController();

    await showDialog(
        context: context,
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Update Name', hintText: hintText),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('UPDATE'),
                onPressed: () {
                  cloudFirestore.updateValue(
                      id,
                      widget.orderDate.day.toString(),
                      widget.orderDate.month.toString(),
                      textEditingController.text,
                      field);
                })
          ],
        ));
  }
}

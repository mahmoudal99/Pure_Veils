import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pure_veils/services/cloud_firestore.dart';

import 'main.dart';
import 'models/order.dart';

class CreateOrderScreen extends StatefulWidget {
  DateTime dateTime;

  CreateOrderScreen({this.dateTime});

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  CloudFirestore cloudFirestore = new CloudFirestore();

  DateTime pickedDate;
  TimeOfDay time;
  var _isPaidIndex = 1;
  bool isPaid = true;
  var _paymentIndex = 1;
  int _chiffonCount = 0;
  int _crinkleCount = 0;
  int _rayonCount = 0;
  int _modalCount = 0;
  int _deliveryCount = 0;
  double _orderTotal = 0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  void _updateOrderTotal(String orderType) {
    if (orderType.contains('chiffon')) {
      setState(() {
        _orderTotal += 5.99;
      });
    } else if (orderType.contains('crinkle')) {
      setState(() {
        _orderTotal += 5.50;
      });
    } else if (orderType.contains("rayon")) {
      _orderTotal += 9.99;
    } else if (orderType.contains("modal")) {
      _orderTotal += 4.99;
    }
  }

  void _deductOrderTotal(String orderType) {
    if (orderType.contains('chiffon')) {
      setState(() {
        _orderTotal -= 5.99;
      });
    } else if (orderType.contains('crinkle')) {
      setState(() {
        _orderTotal -= 5.50;
      });
    } else if (orderType.contains("rayon")) {
      _orderTotal -= 9.99;
    } else if (orderType.contains("modal")) {
      _orderTotal -= 4.99;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Pure Veils",
          style: TextStyle(
              color: Colors.black, fontFamily: "Bodoni", fontSize: 28),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: null,
          backgroundColor: Color(0xffF8BBD0),
          label: Text(
            'Total: ' + _orderTotal.toString(),
            style: TextStyle(
                color: Colors.white, fontFamily: "Bodoni", fontSize: 16),
          )),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Customer Name",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (val) => val.isEmpty ? "Enter a name" : null,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.group,
                              size: 20,
                              color: Colors.black,
                            ),
                            border: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            hintText: 'Name',
                            hintStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Phone",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        validator: (val) => val.isEmpty ? "+353" : null,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.phone,
                              size: 20,
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            hintText: '+353',
                            hintStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Address",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        maxLines: 1,
                        controller: _addressController,
                        validator: (val) =>
                            val.isEmpty ? "Enter an address" : null,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.place,
                              size: 20,
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.grey)),
                            hintText: 'Street Address',
                            hintStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                "Orders",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.normal),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Chiffon"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        _chiffonCount != 0
                                            ? new IconButton(
                                                icon: new Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(
                                                      () => _chiffonCount--);
                                                  _deductOrderTotal("chiffon");
                                                })
                                            : new Container(),
                                        new Text(_chiffonCount.toString()),
                                        new IconButton(
                                            icon: new Icon(Icons.add),
                                            onPressed: () {
                                              setState(() => _chiffonCount++);
                                              _updateOrderTotal('chiffon');
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Cotton Crinkle"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        _crinkleCount != 0
                                            ? new IconButton(
                                                icon: new Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(
                                                      () => _crinkleCount--);
                                                  _deductOrderTotal("crinkle");
                                                })
                                            : new Container(),
                                        new Text(_crinkleCount.toString()),
                                        new IconButton(
                                            icon: new Icon(Icons.add),
                                            onPressed: () {
                                              setState(() => _crinkleCount++);
                                              _updateOrderTotal("crinkle");
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Rayon"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        _rayonCount != 0
                                            ? new IconButton(
                                                icon: new Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() => _rayonCount--);
                                                  _deductOrderTotal("rayon");
                                                })
                                            : new Container(),
                                        new Text(_rayonCount.toString()),
                                        new IconButton(
                                            icon: new Icon(Icons.add),
                                            onPressed: () {
                                              setState(() => _rayonCount++);
                                              _updateOrderTotal("rayon");
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Modal"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        _modalCount != 0
                                            ? new IconButton(
                                                icon: new Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() => _modalCount--);
                                                  _deductOrderTotal("modal");
                                                })
                                            : new Container(),
                                        new Text(_modalCount.toString()),
                                        new IconButton(
                                            icon: new Icon(Icons.add),
                                            onPressed: () {
                                              setState(() => _modalCount++);
                                              _updateOrderTotal("modal");
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Delivery Charge"),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        _deliveryCount != 0
                                            ? new IconButton(
                                                icon: new Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(
                                                      () => _deliveryCount--);
                                                  _deductOrderTotal("delivery");
                                                })
                                            : new Container(),
                                        new Text(_deliveryCount.toString()),
                                        new IconButton(
                                            icon: new Icon(Icons.add),
                                            onPressed: () {
                                              setState(() => _deliveryCount++);
                                              _updateOrderTotal("delivery");
                                            })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            child: Text('Order Day'),
                            color: Colors.white,
                            elevation: 10,
                            onPressed: () {
                              _pickDate();
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Payment Type",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.bold),
                              ),
                              DropdownButton(
                                value: _paymentIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _paymentIndex = value;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Card'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Cash'),
                                    value: 2,
                                  )
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Did Customer Pay?",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.bold),
                              ),
                              DropdownButton(
                                value: _isPaidIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _isPaidIndex = value;
                                    value == 1 ? isPaid = true : isPaid = false;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Yes'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('No'),
                                    value: 2,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 50, top: 20),
                          child: Container(
                            height: 40,
                            width: 120,
                            child: RaisedButton(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Text(
                                "Add Order",
                                style: TextStyle(fontFamily: "Bodoni"),
                              ),
                              textColor: Colors.black,
                              color: Colors.white,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  String orderTime = time.toString();
                                  orderTime = orderTime.replaceAll(
                                      RegExp('TimeOfDay'), '');
                                  orderTime = orderTime.replaceAll(
                                      RegExp("[\\[\\](){}]"), "");
                                  dynamic result = await cloudFirestore
                                      .addOrder(
                                          new Order(
                                            customerName:
                                                _nameController.text.toString(),
                                            address: _addressController.text
                                                .toString(),
                                            phoneNumber: _phoneController.text
                                                .toString(),
                                            dateTime:
                                                widget.dateTime.day.toString(),
                                            isPaid: isPaid,
                                            orderPrice: _orderTotal,
                                            paymentType: _paymentIndex == 1
                                                ? "Card"
                                                : "Cash",
                                            orderComplete: false,
                                            orderDesc: "Chiffon: " +
                                                _chiffonCount.toString() +
                                                "\nCotton Crinkle: " +
                                                _crinkleCount.toString() +
                                                "\nRayon: " +
                                                _rayonCount.toString() +
                                                "\nModal: " +
                                                _modalCount.toString(),
                                          ),
                                          widget.dateTime.month.toString())
                                      .whenComplete(() => {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    child: MyApp(
                                                      dateTime: widget.dateTime,
                                                    ),
                                                    inheritTheme: false,
                                                    duration: Duration(
                                                        milliseconds: 450),
                                                    ctx: context))
                                          });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _pickDate() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: widget.dateTime,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (dateTime != null) {
      setState(() {
        widget.dateTime = dateTime;
      });
    }
  }

}

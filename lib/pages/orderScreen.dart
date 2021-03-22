import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:http/http.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List _orderLogo = [
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    }
  ];

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final List _products = [];
  String dropdownValue = 'Beef';
  List<String> quantity;
  void initState() {
    // TODO: implement initState
    super.initState();
    _getproduct();
  }

  _getproduct() async {
    var response = await Http(url: 'products', body: {}).getWithHeader();
    log(response.body);
    if (response is String) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            response,
            textScaleFactor: .8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
        ),
      );
    } else if (response is Response) {
      if (response.statusCode != 200) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF323232),
            content: Text(
              response.body,
              textScaleFactor: .8,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 2.2 * Config.textMultiplier,
              ),
            ),
          ),
        );
      } else {
        Map<String, dynamic> body = json.decode(response.body);
        body['product'].forEach((product) {
          // List<Map<String, dynamic>> tables = [];
          // restaurant['restaurant_tables'].forEach((table) {
          //   print(table);
          //   tables.add({
          //     "id": table['id'],
          //     "name": table['name'],
          //     "description": table['description'],
          //     "status": table['status'],
          //   });
          // });
          setState(() {
            _products.add({
              "id": product['id'],
              "productname": product['product_name'],
              "productdescription": product['product_description'],
              "category": product['product_category'],
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Color(0xffeb4d4d),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Expanded(
          // child:
          Column(
            children: <Widget>[
              // child:
              Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    color: Color(0xffeb4d4d),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: 1 * Config.heightMultiplier),
                        child: Container(
                          width: 85 * Config.widthMultiplier,
                          height: 40.0,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey[800]),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.grey[800]),
                              hintText: ('Search Restaurant'),
                              hintStyle: TextStyle(
                                color: Colors.grey[800],
                                fontFamily: 'Segoe UI',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1 * Config.imageSizeMultiplier),
                        child: Image.asset('assets/images/Group 22.png'),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 2.7 * Config.heightMultiplier),
                    child: Text(
                      'Category',
                      style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5 * Config.widthMultiplier),
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      height: 1 * Config.heightMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                      value: dropdownValue,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white),
                      underline: Container(
                        height: 2,
                        color: Colors.orange[800],
                      ),
                      onChanged: (String newValue) {
                        print(newValue);
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: quantity
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 3 * Config.textMultiplier),
                            child: Text(
                              value,
                              textDirection: TextDirection.rtl,
                              // textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList()),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _orderLogo.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 10.0,
                      child: Column(
                        children: [
                          // // child:
                          Hero(
                            tag: '_orderLogo',
                            child: Stack(
                              children: [
                                Image.asset(
                                  _orderLogo[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 2.0 * Config.heightMultiplier),
                                  child: Container(
                                    width: 100,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            5 * Config.imageSizeMultiplier),
                                        bottomRight: Radius.circular(
                                            5 * Config.imageSizeMultiplier),
                                      ),
                                      color: Color(0xffEB4D4D),
                                    ),
                                    //Product Name
                                    child: Text(
                                      _products[index]['productname'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 2 * Config.textMultiplier,
                                        fontFamily: 'Segoe UI',
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16 * Config.heightMultiplier),
                                  child: Container(
                                    alignment: AlignmentGeometry.lerp(
                                        Alignment.bottomCenter,
                                        Alignment.bottomRight,
                                        0),
                                    height: 20,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xff484545),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            4 * Config.imageSizeMultiplier),
                                        bottomRight: Radius.circular(
                                            4 * Config.imageSizeMultiplier),
                                      ),
                                    ),
                                    //Product Description
                                    child: Text(
                                      _products[index]['productdescription'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 2 * Config.textMultiplier,
                                        fontFamily: 'Segoe UI',
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 19.5 * Config.heightMultiplier,
                                      left: 5 * Config.widthMultiplier),
                                  child: SmoothStarRating(
                                    borderColor: Colors.yellow,
                                    color: Colors.yellow,
                                    allowHalfRating: false,
                                    starCount: 5,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

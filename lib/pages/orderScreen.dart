import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/pages/orderWithVariants.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OrderScreen extends StatefulWidget {
  Map<String, dynamic> details;
  OrderScreen({Key key, @required this.details}) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List _products = [];
  List _categories = [];
  List<String> _categoriesNames = [];
  String dropdownValue = '';
  List<String> quantity = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.details);
    // print(widget.details['productCategories']);
    _categories = new List.from(widget.details['productCategories']);
    if (_categories.isNotEmpty) {
      _products = new List.from(_categories[0]['products']);
      dropdownValue = _categories[0]['categoriesName'];
      _categories.forEach((category) {
        _categoriesNames.add(category['categoriesName']);
      });
      // print(_categoriesNames);
    }

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _getproduct();
    // });
  }

  _category(int index) async {
    setState(() {
      _products = new List.from(_categories[index]['products']);
    });
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
          Column(
            children: <Widget>[
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
              if (_categories.length > 0)
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
                    if (_categories.length > 0)
                      Padding(
                        padding:
                            EdgeInsets.only(right: 5 * Config.widthMultiplier),
                        child: DropdownButton<String>(
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
                              // print(newValue);
                              setState(() {
                                dropdownValue = newValue;
                              });
                              _category(_categoriesNames.indexOf(newValue));
                            },
                            items: _categoriesNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 3 * Config.textMultiplier),
                                  child: Text(
                                    value,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList()),
                      ),
                  ],
                ),
              if (_products.length == 0)
                Text('No products available')
              else
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: _products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // // child:
                          FlatButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: OrderWithVariants(
                                      details: _products[index],
                                      restaurantDetails: widget.details,
                                      index: index),
                                ),
                              );
                            },
                            child: Hero(
                              tag:
                                  '_orderLogo$index${widget.details['variantID']}',
                              // tag: 'orderLogo',
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.orange,
                                ),
                                height: 160.0,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                        color: Colors.green,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          _products[index]['banner'],
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 120.0,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 1.0 * Config.heightMultiplier),
                                      child: Container(
                                        width: 100,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                5 * Config.imageSizeMultiplier),
                                            bottomRight: Radius.circular(
                                                5 * Config.imageSizeMultiplier),
                                          ),
                                        ),
                                        //Product Name
                                        child: Text(
                                          _products[index]['productName'],
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
                                          _products[index]
                                              ['productDescription'],
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
                                          top: 18.5 * Config.heightMultiplier,
                                          left: 2 * Config.widthMultiplier),
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
                            ),
                          ),
                        ],
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

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:http/http.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OrderWithVariants extends StatefulWidget {
  Map<String, dynamic> details;
  OrderWithVariants({Key key, @required this.details}) : super(key: key);
  @override
  _OrderWithVariantsState createState() => _OrderWithVariantsState();
}

class _OrderWithVariantsState extends State<OrderWithVariants> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List _variants = [];
  List _productOptions = [];
  // List _productOptItem = [];
  void initState() {
    //TODO: implement initstate
    super.initState();
    _variants = new List.from(widget.details['productVariants']);
    if (_variants.isNotEmpty) {
      _productOptions = new List.from(_variants[0]['vairantOption']);
      // _variants.forEach((variant) {
      //   _variantNames.add(variant['variantName']);
      // });
      print(_productOptions);
    }
  }

  // _variant(int index) async {
  //   setState(() {
  //     _productOptions = new List.from(_variants[index]['variantOption']);
  //   });
  // }

// List<String> variation
  _variantDialog(int index) {
    // void initState() {
    //   super.initState();
    //   _productOptions = new List.from(widget.details['variantOption']);
    // }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8 * Config.imageSizeMultiplier),
              ),
            ),
            content: Stack(
              children: <Widget>[
                Container(
                  height: 460.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8 * Config.imageSizeMultiplier),
                      topRight: Radius.circular(8 * Config.imageSizeMultiplier),
                    ),
                    color: Color(0xff323030),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 1 * Config.heightMultiplier),
                    child: Text(
                      'Variation',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 4 * Config.textMultiplier,
                          color: Color(0xffeb4d4d),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 8 * Config.heightMultiplier,
                      left: 3 * Config.widthMultiplier),
                  child: Column(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 100.0,
                        child: ListView.builder(
                            itemCount: _productOptions.length,
                            itemBuilder: (context, index) {
                              return
                                  // Column(
                                  //         children: [
                                  //           Expanded(
                                  //             child: Container(
                                  //               child:
                                  Text(
                                      _productOptions[index]['productOptName']);
                              //             ),
                              //           ),
                              //           // Card(
                              //           //   child: ListTile(
                              //           //     leading: RadioListTile(
                              //           //         // onChanged: () {
                              //           //         //   setState(() {});
                              //           //         // },
                              //           //         ),
                              //           //   ),
                              //           // ),
                              //         ],
                              //       );
                            }),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color(0xffeb4d4d),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 35.0,
            ),
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
                  alignment: Alignment.topCenter,
                  height: 165.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    color: Color(0xffeb4d4d),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 270,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffe8971d),
                        ),
                        // Insert Hero() with tag :'_orderLogo${_products[index]['productId']}
                        child: Hero(
                          tag: '_orderLogo${widget.details['variantID']}',
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.details['banner'],
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 2.0 * Config.heightMultiplier),
                                child: Container(
                                  //width must be coincide with the lenght of the Text
                                  width: 20 * Config.textMultiplier,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40.0),
                                      bottomRight: Radius.circular(40.0),
                                    ),
                                  ),
                                  //Product Name
                                  child: Text(
                                    widget.details['productName'],
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
                                    top: 15.3 * Config.heightMultiplier),
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
                                    // 'Chicken Meal with Regular Coke',
                                    widget.details['productDescription'],
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2 * Config.heightMultiplier),
              ),
              Expanded(
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                      itemCount: _variants.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 40.0,
                          child: ListTile(
                            leading: _variants[index]['variantBanner'] != null
                                ? CachedNetworkImage(
                                    imageUrl: _variants[index]['variantBanner'],
                                    fit: BoxFit.fill,
                                  )
                                : Text('No Image Loaded'),
                            title: Text(_variants[index]['variantName'],
                                textAlign: TextAlign.center),
                            subtitle: Text(
                              _variants[index]['variantDescription'],
                              textAlign: TextAlign.center,
                            ),
                            trailing: Text(
                                '₱ ${_variants[index]['variantPrice'].toString()}'),
                            onTap: () {
                              _variantDialog(index);
                            },
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

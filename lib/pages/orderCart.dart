import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCart extends StatefulWidget {
  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  TextEditingController _noteController = TextEditingController();
  SharedPreferences _sharedPreferences;
  var _cart = {};
  double _total = 0;
  double _subFee = 0;
  double _bookingFee = 0;
  double _preparationTime = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configure();
  }

  _configure() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    // _sharedPreferences.setString('cart', null);
    setState(() {
      _cart = json.decode(_sharedPreferences.getString('cart'));
    });
    print(_cart);
    _computeTotal();
  }

  _computeTotal() {
    _cart['order_request_products'].forEach((product) {
      setState(() {
        _subFee += product['price'];
      });
    });
    setState(() {
      _bookingFee = 0;
      _total = _bookingFee + _subFee;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color(0xffeb4d4d),
          title: Center(
            child: Text(
              'CART',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 5 * Config.textMultiplier,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontFamily: 'Poppins',
              ),
              textScaleFactor: 1,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1 * Config.widthMultiplier),
        child: SingleChildScrollView(
          child: Column(
          // alignment: Alignment.topCenter,
            children: [
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  if (_cart.containsKey('order_request_products'))
                  for(var product in _cart['order_request_products'])
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 1 * Config.heightMultiplier),
                    child: CardItem(product: product),
                  ),
                ],
              ),
              Divider(
                height: 4 * Config.heightMultiplier,
                color: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.only(top: 2 * Config.heightMultiplier),
                child: Container(
                  height: 20 * Config.heightMultiplier,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: 2,
                              controller: _noteController,
                              decoration: InputDecoration(
                                labelText: 'NOTE',
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 2 * Config.textMultiplier),
                                hintText: 'YOUR NOTE',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey[700]),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffFF6347),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4 * Config.widthMultiplier),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sub Fee: ${_subFee.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 1.8 * Config.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                    textScaleFactor: 1,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 2 * Config.heightMultiplier),
                                    child: Text(
                                      'Booking Fee: ${_bookingFee.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 1.8 * Config.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Poppins',
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 2 * Config.heightMultiplier),
                                    child: Text(
                                      'Grand Total: ${_total.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 1.8 * Config.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Poppins',
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: .2 * Config.heightMultiplier),
                        child: Text(
                          'Preparation Time: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 1.8 * Config.textMultiplier,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Poppins',
                          ),
                          textScaleFactor: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2 * Config.heightMultiplier),
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    ' PROCEED ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 2.4 * Config.textMultiplier,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Poppins',
                    ),
                    textScaleFactor: 1,
                  ),
                  color: Config.appColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  var product;

  CardItem({
    Key key,
    @required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 11 * Config.heightMultiplier,
            width: 22 * Config.widthMultiplier,
            // padding: EdgeInsets.all(2 * Config.imageSizeMultiplier),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(5 * Config.imageSizeMultiplier),
              ),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  product['image'],
                ),
                fit: BoxFit.fill
              )
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 3 * Config.widthMultiplier),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 27 * Config.widthMultiplier,
                child: Text(
                  product['product_name'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 2 * Config.textMultiplier,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Poppins',
                  ),
                  textScaleFactor: 1,
                ),
              ),
              SizedBox(
                height: 1 * Config.heightMultiplier,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 8 * Config.widthMultiplier,
                    height: 8 * Config.heightMultiplier,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        IconButton(
                          splashRadius: 10.0,
                          alignment: Alignment.center,
                          splashColor: Colors.red,
                          iconSize: 4 * Config.imageSizeMultiplier,
                          onPressed: () {},
                          icon: Icon(
                            Icons.remove,
                            color: Colors.black,
                            size: 5.5 * Config.imageSizeMultiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * Config.widthMultiplier),
                    child: Text(
                      product['quantity'].toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 1.8 * Config.textMultiplier,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Poppins',
                      ),
                      textScaleFactor: 1,
                    ),
                  ),
                  Container(
                    width: 5 * Config.widthMultiplier,
                    height: 5 * Config.heightMultiplier,
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        IconButton(
                          splashRadius: 10.0,
                          alignment: Alignment.centerLeft,
                          splashColor: Colors.red,
                          iconSize: 4 * Config.imageSizeMultiplier,
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 5.5 * Config.imageSizeMultiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 4 * Config.widthMultiplier,
                top: 2 * Config.heightMultiplier),
            child: RaisedButton(
              splashColor: Colors.white,
              color: Colors.grey[200],
              shape: StadiumBorder(),
              onPressed: () {},
              child: Text(
                "Product Options",
                style: TextStyle(fontSize: 1.9 * Config.textMultiplier),
                textScaleFactor: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

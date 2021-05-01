import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class OrderCart extends StatefulWidget {
  //  Map<String, dynamic> restaurantDetails;
  // int index;
  // OrderCart({
  //   Key key,@required this.restaurantDetails,
  //     @required this.index}): super(key: key);
  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  TextEditingController _noteController = TextEditingController();
  SharedPreferences _sharedPreferences;
  var _cart = {};
  // var _restaurants = {};
  double _total = 0;
  double _subFee = 0;
  double _conciergeFee = 0;
  double _priceWithConcierge = 0;
  double _priceWithMarkup = 0;
  double _markUpFee = 0;
  double _preparationTime = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configure();
  }

  _configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    // _sharedPreferences.setString('cart', null);
    setState(() {
      _cart = json.decode(_sharedPreferences.getString('cart'));
    });
    log(_cart.toString());
    _computeTotal();
  }

  _computeTotal() {
    _cart['order_request_products'].forEach((product) {
      setState(() {
        _subFee += product['price'];
        // _conciergeFee = product['concierge_percentage'];
        // _markUpFee = product['markup_percentage'];
      });
    });
    setState(() {
      // _priceWithConcierge = _subFee * _conciergeFee;
      // _priceWithMarkup = _subFee * _markUpFee;
      // _total = _subFee + _priceWithConcierge + _priceWithMarkup;
      _total = _subFee;
    });
  }

  _createOrder() async{
    Http().showLoadingOverlay(context);
    
    List order_request_products = [];
    _cart['order_request_products'].forEach((product) {
      List order_request_product_items = [];
      product['product_options'].forEach((option) {
        option['product_option_items'].forEach((item) {
          order_request_product_items.add({
            'id': item['id']
          });
        });
      });
      order_request_products.add({
        'variant_id': product['variant_id'],
        'quantity': product['quantity'],
        'note': product['note'],
        'order_request_product_items': order_request_product_items
      });
    });
    var request = {
      'restaurant_id': _cart['restaurants']['restaurant_id'],
      'booking_time': DateFormat('hh:mm:ss').format(DateTime.now()),
      'booking_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'number_of_person': '1',
      'customers_note': _noteController.text,
      'payment_method': 'COD',
      'longitude': '6.999',
      'latitude': '6.999',
      'order_request_products': order_request_products
    };
    print(request);
    var response = await Http(url: 'orderRequests', 
    body: request).postWithHeader();
    if (response is String) {
      ScaffoldMessenger.of(context).showSnackBar(
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
      print(response.body);
      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context)..showSnackBar(
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
      }
      else{
        ScaffoldMessenger.of(context)..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF323232),
            content: Text(
              'SUCCESS',
              textScaleFactor: .8,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 2.2 * Config.textMultiplier,
              ),
            ),
          ),
        );
      }
    }
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
        body: _cart.length > 0
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 1 * Config.widthMultiplier),
                child: SingleChildScrollView(
                  child: Column(
                    // alignment: Alignment.topCenter,
                    children: [
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          if (_cart.containsKey('order_request_products'))
                            for (var product in _cart['order_request_products'])
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
                        padding:
                            EdgeInsets.only(top: 2 * Config.heightMultiplier),
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
                                            fontSize:
                                                2 * Config.textMultiplier),
                                        hintText: 'YOUR NOTE',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[700]),
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
                                          horizontal:
                                              4 * Config.widthMultiplier),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Sub Fee: ${_subFee.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  1.8 * Config.textMultiplier,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: 'Poppins',
                                            ),
                                            textScaleFactor: 1,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 2 *
                                                    Config.heightMultiplier),
                                            child: Text(
                                              'Concierge Fee: ${_conciergeFee.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    1.8 * Config.textMultiplier,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Poppins',
                                              ),
                                              textScaleFactor: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 2 *
                                                    Config.heightMultiplier),
                                            child: Text(
                                              'Mark-up Fee: ${_markUpFee.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    1.8 * Config.textMultiplier,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: 'Poppins',
                                              ),
                                              textScaleFactor: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 2 *
                                                    Config.heightMultiplier),
                                            child: Text(
                                              'Grand Total: ${_total.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    1.8 * Config.textMultiplier,
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
                              // Padding(
                              //   padding:
                              //       EdgeInsets.only(top: .2 * Config.heightMultiplier),
                              //   child: Text(
                              //     'Preparation Time: ',
                              //     style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 1.8 * Config.textMultiplier,
                              //       fontWeight: FontWeight.bold,
                              //       fontStyle: FontStyle.normal,
                              //       fontFamily: 'Poppins',
                              //     ),
                              //     textScaleFactor: 1,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2 * Config.heightMultiplier),
                        child: RaisedButton(
                          onPressed: () {
                            _createOrder();
                          },
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
                ))
            : Shimmer.fromColors(
                child: ListView(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 1 * Config.widthMultiplier),
                    child: SingleChildScrollView(
                      child: Column(
                        // alignment: Alignment.topCenter,
                        children: [
                          ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1 * Config.heightMultiplier),
                                child: Container(
                                  child: Row(children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              1 * Config.heightMultiplier),
                                      child: Icon(Icons.image,
                                          size:
                                              20 * Config.imageSizeMultiplier),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              4 * Config.widthMultiplier,
                                          vertical:
                                              1 * Config.heightMultiplier),
                                      child: SizedBox(
                                        child: Container(
                                          color: Colors.green,
                                        ),
                                        width: 7 * Config.widthMultiplier,
                                        height: 3 * Config.heightMultiplier,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              4 * Config.widthMultiplier,
                                          vertical:
                                              1 * Config.heightMultiplier),
                                      child: SizedBox(
                                        child: Container(
                                          color: Colors.green,
                                        ),
                                        width: 5 * Config.widthMultiplier,
                                        height: 3 * Config.heightMultiplier,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
                                      child: RaisedButton(
                                        splashColor: Colors.white,
                                        color: Colors.grey[200],
                                        shape: StadiumBorder(),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 4 * Config.heightMultiplier,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 2 * Config.heightMultiplier),
                            child: Container(
                              height: 20 * Config.heightMultiplier,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          maxLines: 2,
                                          controller: _noteController,
                                          decoration: InputDecoration(
                                            labelText: '',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize:
                                                    2 * Config.textMultiplier),
                                            hintText: '',
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[700]),
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
                                              horizontal:
                                                  4 * Config.widthMultiplier),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: Container(
                                                  color: Colors.green,
                                                ),
                                                height:
                                                    3 * Config.heightMultiplier,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 2 *
                                                        Config
                                                            .heightMultiplier),
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.green,
                                                  ),
                                                  height: 3 *
                                                      Config.heightMultiplier,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 2 *
                                                        Config
                                                            .heightMultiplier),
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.green,
                                                  ),
                                                  height: 3 *
                                                      Config.heightMultiplier,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 2 *
                                                        Config
                                                            .heightMultiplier),
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.green,
                                                  ),
                                                  height: 3 *
                                                      Config.heightMultiplier,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       EdgeInsets.only(top: .2 * Config.heightMultiplier),
                                  //   child: Text(
                                  //     'Preparation Time: ',
                                  //     style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontSize: 1.8 * Config.textMultiplier,
                                  //       fontWeight: FontWeight.bold,
                                  //       fontStyle: FontStyle.normal,
                                  //       fontFamily: 'Poppins',
                                  //     ),
                                  //     textScaleFactor: 1,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2 * Config.heightMultiplier),
                            child: RaisedButton(
                              onPressed: () {},
                              child: Text(
                                '',
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
                    ),
                  )
                ]),
                period: Duration(seconds: 2),
                baseColor: Colors.grey,
                highlightColor: Config.appColor));
  }
}

class CardItem extends StatefulWidget {
  var product;

  CardItem({Key key, @required this.product}) : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  // List<dynamic> _productOptionItems;
  // _cartOptItems(int index) async {
  //     setState(
  //                 () {
  //                   _productOptionItems = new List.from(widget
  //                       .product['product_options']['product_option_items']);

  //                 },
  //               );
  // }

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
                      widget.product['image'],
                    ),
                    fit: BoxFit.fill)),
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
                  widget.product['product_name'],
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
                      widget.product['quantity'].toString(),
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
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setstate) => AlertDialog(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8 * Config.imageSizeMultiplier),
                          ),
                        ),
                        content: Container(
                          height: 50 * Config.heightMultiplier,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        8 * Config.imageSizeMultiplier),
                                    topRight: Radius.circular(
                                        8 * Config.imageSizeMultiplier),
                                  ),
                                  color: Color(0xff323030),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1 * Config.heightMultiplier),
                                  child: Text(
                                    'Product Options',
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
                              Expanded(
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: widget.product['product_options'].length,
                                      itemBuilder: (context, index) => Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Column(
                                                  children: [
                                                    Text(widget.product[
                                                            'product_options']
                                                        [index]['name'],
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold
                                                        ),),
                                                    Row(
                                                      children: [
                                                        for (var item in widget.product['product_options'][index]['product_option_items'])
                                                        Text('${item['name']}${widget.product['product_options'][index]['product_option_items'].indexOf(item) == widget.product['product_options'][index]['product_option_items'].length-1?'':','}'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
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

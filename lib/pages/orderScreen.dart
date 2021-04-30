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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OrderScreen extends StatefulWidget {
  Map<String, dynamic> details;
  OrderScreen({Key key, @required this.details}) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List _products = [];
  List _categories = [];
  List<String> _categoriesNames = [];
  String dropdownValue = '';
  List<String> quantity = [];
  bool _loading = false;

  void initState() {
    // log(widget.details.toString());
    // TODO: implement initState
    super.initState();
    _categories = new List.from(widget.details['productCategories']);
    if (_categories.isNotEmpty) {
      _products = new List.from(_categories[0]['products']);
      dropdownValue = _categories[0]['categoriesName'];
      _categories.forEach((category) {
        _categoriesNames.add(category['categoriesName']);
      });
      print(_categories.toString());
    }

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _getproduct();
    // });
  }

  _searchProduts(String search) {
    _products.forEach((product) {
      if (product['name']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        setState(() {
          _products.add(product);
        });
      }
    });
  }

  _category(int index) async {
    setState(() {
      _products = new List.from(_categories[index]['products']);
    });
  }

  _getProducts() async {
    var response =
        await Http(url: 'restaurants/${widget.details['id']}', body: {})
            .getWithHeader();
    if (response is String) {
      setState(() {
        _loading = false;
      });
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
      print(response.body);
      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
        });
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
        Map<String, dynamic> restaurant =
            json.decode(response.body)['restaurant'];
        List<Map<String, dynamic>> categories = [];
        restaurant['product_category'].forEach((category) {
          List<Map<String, dynamic>> product = [];
          category['products'].forEach((products) {
            List<Map<String, dynamic>> variant = [];
            products['variants'].forEach((variants) {
              List<Map<String, dynamic>> productoption = [];
              variants['product_options'].forEach((productOptions) {
                List<Map<String, dynamic>> productoptionitem = [];
                productOptions['product_option_items']
                    .forEach((productOptionItem) {
                  productoptionitem.add({
                    "productOptItmId": productOptionItem['id'],
                    "productOptItmName": productOptionItem['item_name'],
                    "productOptItmPrice": productOptionItem['price'],
                  });
                });
                productoption.add({
                  "productOptId": productOptions['id'],
                  "productOptName": productOptions['name'],
                  "productOptType": productOptions['type'],
                  "productOptSelection": productOptions['selection'],
                  "productOptionItem": productoptionitem,
                });
              });
              variant.add({
                "variantId": variants['id'],
                "variantName": variants['name'],
                "variantPrice": variants['price'],
                "variantDescription": variants['description'],
                "variantBanner": variants['image'],
                "vairantOption": productoption,
              });
            });
            product.add({
              "productId": products['id'],
              "productName": products['name'],
              "productDescription": products['description'],
              "banner": products['image'],
              "productVariants": variant,
            });
          });
          categories.add({
            "categoriesID": category['id'],
            "categoriesName": category['name'],
            "products": product,
          });
        });

        setState(() {
          _categories = new List.from(categories);
          _products = new List.from(categories[0]['products']);
          _loading = false;
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
                          height: 7 * Config.heightMultiplier,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 4 * Config.widthMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey[800]),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.grey[800]),
                              hintText: ('Search Product'),
                              hintStyle: TextStyle(
                                color: Colors.grey[800],
                                fontFamily: 'Segoe UI',
                              ),
                            ),
                            onSubmitted: (text) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _products.clear();
                              });
                              _searchProduts(text);
                            },
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
                        textScaleFactor: 1,
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
                              height: .2 * Config.heightMultiplier,
                              color: Colors.orange[800],
                            ),
                            onChanged: (String newValue) {
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
                                    textScaleFactor: 1,
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList()),
                      ),
                  ],
                ),
              Container(
                child: Expanded(
                  child: SmartRefresher(
                    enablePullDown: !_loading,
                    onRefresh: () {
                      setState(() {
                        _products.clear();
                        _loading = true;
                      });
                      _getProducts();
                      Shimmer.fromColors(
                          child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.image, size: 50.0),
                                title: SizedBox(
                                  child: Container(
                                    color: Colors.green,
                                  ),
                                  height: 20.0,
                                ),
                              );
                            },
                          ),
                          period: Duration(seconds: 2),
                          baseColor: Colors.grey,
                          highlightColor: Config.appColor);
                    },
                    physics: BouncingScrollPhysics(),
                    header: WaterDropMaterialHeader(
                      backgroundColor: Config.appColor,
                      color: Colors.white,
                      distance: 4 * Config.heightMultiplier,
                    ),
                    controller: _refreshController,
                    child: _products.length < 0
                        ? Center(
                            child: Text(
                            'No products available',
                            textScaleFactor: 1,
                          ))
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: _products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: Colors.orange,
                                        ),
                                        height: 22 * Config.heightMultiplier,
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                color: Colors.green,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.network(
                                                  _products[index]['banner'],
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 18 *
                                                      Config.heightMultiplier,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 1.0 *
                                                      Config.heightMultiplier),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: .4 *
                                                        Config
                                                            .heightMultiplier),
                                                width:
                                                    36 * Config.widthMultiplier,
                                                height:
                                                    3 * Config.heightMultiplier,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight: Radius.circular(5 *
                                                        Config
                                                            .imageSizeMultiplier),
                                                    bottomRight: Radius.circular(5 *
                                                        Config
                                                            .imageSizeMultiplier),
                                                  ),
                                                ),
                                                //Product Name
                                                child: Text(
                                                  _products[index]
                                                      ['productName'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 2 *
                                                        Config.textMultiplier,
                                                    fontFamily: 'Segoe UI',
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white,
                                                  ),
                                                  textScaleFactor: 1,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 16 *
                                                      Config.heightMultiplier),
                                              child: Container(
                                                alignment:
                                                    AlignmentGeometry.lerp(
                                                        Alignment.bottomCenter,
                                                        Alignment.bottomRight,
                                                        0),
                                                height:
                                                    3 * Config.heightMultiplier,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Color(0xff484545),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft: Radius.circular(4 *
                                                        Config
                                                            .imageSizeMultiplier),
                                                    bottomRight: Radius.circular(4 *
                                                        Config
                                                            .imageSizeMultiplier),
                                                  ),
                                                ),
                                                //Product Description
                                                child: Text(
                                                  _products[index]
                                                      ['productDescription'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 2 *
                                                        Config.textMultiplier,
                                                    fontFamily: 'Segoe UI',
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white,
                                                  ),
                                                  textScaleFactor: 1,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 18.5 *
                                                      Config.heightMultiplier,
                                                  left: 2 *
                                                      Config.widthMultiplier),
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
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

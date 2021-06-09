import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:food_booking_app/pages/orderWithVariants.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'orderCart.dart';

class OrderScreen extends StatefulWidget {
  Map<String, dynamic> details;
  var specifics;
  OrderScreen({Key key, @required this.details, @required this.specifics}) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
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
    _getProducts();
    // _categories = new List.from(widget.details['productCategories']);
    // if (_categories.isNotEmpty) {
    //   _products = new List.from(_categories[0]['products']);
    //   dropdownValue = _categories[0]['categoriesName'];
    //   _categories.forEach((category) {
    //     _categoriesNames.add(category['categoriesName']);
    //   });
    //   print(_categories.toString());
    // }
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
          content: CustomText(
            align: TextAlign.left,
            text: response,
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
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
            content: CustomText(
              align: TextAlign.left,
              text: response.body,
              color: Colors.white,
              size: 1.6,
              weight: FontWeight.normal,
            ),
          ),
        );
      } else {
        print(response.body);
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
          _categories.clear();
          _categoriesNames.clear();
          _products.clear();
          _categories = new List.from(categories);
          dropdownValue = _categories[0]['categoriesName'];
          _categories.forEach((category) {
            _categoriesNames.add(category['categoriesName']);
          });
          _products = new List.from(categories[0]['products']);
          _loading = false;
          _refreshController.refreshCompleted();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(6 * heightMultiplier),
          child: AppBar(
            backgroundColor: Color(0xffeb4d4d),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 6 * imageSizeMultiplier,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_rounded,
                  size: 6 * imageSizeMultiplier,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: OrderCart(specifics: widget.specifics)
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 2 * heightMultiplier),
                    padding: EdgeInsets.only(left: 2 * widthMultiplier, right: 2 * widthMultiplier),
                    decoration: BoxDecoration(
                      // color: Color(0xFF363636),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2 * imageSizeMultiplier),
                      border: Border.all(color: Color(0xFF707070).withOpacity(.25)),
                      boxShadow: [
                        BoxShadow(color: Color(0xFF707070).withOpacity(.25), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 3))
                      ]
                    ),
                    height: 6 * heightMultiplier,
                    width: 80 * widthMultiplier,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            enabled: true,
                            // controller: _searchController,
                            onFieldSubmitted: (text) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _products.clear();
                              });
                              _searchProduts(text);
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              focusColor: appColor,
                              prefixIconConstraints: BoxConstraints(minWidth: 11 * widthMultiplier, minHeight: 0),
                              prefixIcon: Icon(
                                Icons.sort_rounded,
                                size: 6 * imageSizeMultiplier
                              ),
                              suffixIcon: Icon(
                                Icons.search,
                                size: 6 * imageSizeMultiplier
                              ),
                              hintText: 'Search Restaurant',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontFamily: 'Metropolis',
                                color: Color(0xFFB6B7B7),
                                fontSize: 1.8 * textMultiplier,
                                fontWeight: FontWeight.normal
                              )
                            ).copyWith(isDense: true),
                            style: TextStyle(
                              fontFamily: 'Metropolis',
                              color: Colors.black,
                              fontSize: 1.8 * textMultiplier,
                              fontWeight: FontWeight.normal
                            ),
                          )
                        ),
                      ],
                    )
                  ),
                  // Padding(
                  //   padding: EdgeInsets.zero,
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.only(
                  //           bottomLeft: Radius.circular(40.0),
                  //           bottomRight: Radius.circular(40.0)),
                  //       color: Color(0xffeb4d4d),
                  //     ),
                  //     child: Column(
                  //       children: <Widget>[
                  //         Padding(
                  //           padding:
                  //               EdgeInsets.only(top: 1 * heightMultiplier),
                  //           child: Container(
                  //             width: 85 * widthMultiplier,
                  //             height: 7 * heightMultiplier,
                  //             margin: EdgeInsets.only(top: 10.0),
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: 4 * widthMultiplier),
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(10.0),
                  //               border: Border.all(color: Colors.grey[800]),
                  //             ),
                  //             child: CustomTextBox(
                  //               shadow: false,
                  //               border: true,
                  //               text: 'Search Product',
                  //               onSubmitted: (text) {
                  //                 FocusScope.of(context).unfocus();
                  //                 setState(() {
                  //                   _products.clear();
                  //                 });
                  //                 _searchProduts(text);
                  //               },
                  //               enabled: true,
                  //               obscureText: false,
                  //               padding: 8,
                  //               prefixIcon: null,
                  //               suffixIcon: null,
                  //               focusNode: null,
                  //               textInputAction: TextInputAction.done,
                  //               controller: null,
                  //               keyboardType: TextInputType.text,
                  //             ),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: EdgeInsets.all(1 * imageSizeMultiplier),
                  //           child: Image.asset('assets/images/Group 22.png'),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  if (_categories.length > 0)
                  Padding(
                    padding: EdgeInsets.only(top: 2 * heightMultiplier, left: 4 * widthMultiplier),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CustomText(
                          align: TextAlign.left,
                          text: 'Category',
                          size: 1.8,
                          weight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        if (_categories.length > 0)
                        Padding(
                          padding: EdgeInsets.only(left: 2 * widthMultiplier),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(
                              Icons.arrow_downward,
                              size: 6 * imageSizeMultiplier,
                            ),
                            iconSize: 6 * imageSizeMultiplier,
                            underline: Container(
                              height: .2 * heightMultiplier,
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
                                child: CustomText(
                                  align: TextAlign.left,
                                  text: value,
                                  color: Colors.black,
                                  size: 1.8,
                                  weight: FontWeight.normal,
                                ),
                              );
                            }).toList()
                          ),
                        )
                      ],
                    )
                  ),
                  Container(
                    child: Expanded(
                      child: SmartRefresher(
                        enablePullDown: !_loading,
                        onRefresh: () {
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
                              highlightColor: appColor);
                        },
                        physics: BouncingScrollPhysics(),
                        header: CustomHeader(builder: (context, status) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10 * imageSizeMultiplier,
                                color: appColor
                              ),
                              SizedBox(
                                height: 3 * imageSizeMultiplier,
                                width: 3 * imageSizeMultiplier,
                                child: CircularProgressIndicator(
                                  strokeWidth: .2 * imageSizeMultiplier,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              )
                            ]
                          );
                        }),
                        controller: _refreshController,
                        child: _products.length < 0
                            ? Center(
                              child: CustomText(
                                align: TextAlign.left,
                                text: 'No products available',
                                color: Colors.black,
                                size: 1.8,
                                weight: FontWeight.normal,
                              )
                            )
                            : GridView.builder(
                                shrinkWrap: true,
                                itemCount: _products.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  return CustomButton(
                                    height: 0,
                                    minWidth: 0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 2 * widthMultiplier),
                                      child: TextButton(
                                        style: ButtonStyle(
                                          padding: MaterialStateProperty.all(EdgeInsets.zero)
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType.rightToLeft,
                                              child: OrderWithVariants(
                                                  details: _products[index],
                                                  restaurantDetails: widget.details,
                                                  specifics: widget.specifics,
                                                  index: index),
                                            ),
                                          );
                                        },
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            color: Color(0xFF484545),
                                          ),
                                          height: 22 * heightMultiplier,
                                          child: Hero(
                                            tag:
                                                '_orderLogo$index${widget.details['variantID']}',
                                            // tag: 'orderLogo',
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 22 * heightMultiplier,
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
                                                      width: MediaQuery.of(context).size.width,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    // Padding(
                                                    //   padding: EdgeInsets.only(top: 4 *heightMultiplier),
                                                    //   child: Container(
                                                    //     padding: EdgeInsets.symmetric(vertical: .4 * heightMultiplier),
                                                    //     width: 20 * widthMultiplier,
                                                    //     alignment: Alignment.center,
                                                    //     decoration: BoxDecoration(
                                                    //       color: Colors.red,
                                                    //       borderRadius:
                                                    //           BorderRadius.only(
                                                    //         topRight: Radius.circular(5 * imageSizeMultiplier),
                                                    //         bottomRight: Radius.circular(5 * imageSizeMultiplier),
                                                    //       ),
                                                    //     ),
                                                    //     //Product Name
                                                    //     child: CustomText(
                                                    //       text: _products[index]['productName'],
                                                    //       align: TextAlign.center,
                                                    //       size: 1.8,
                                                    //       weight: FontWeight.bold,
                                                    //       color: Colors.white,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 1 *
                                                              heightMultiplier),
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        height:
                                                            3 * heightMultiplier,
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color: Color(0xff484545),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            bottomLeft: Radius.circular(4 * imageSizeMultiplier),
                                                            bottomRight: Radius.circular(4 * imageSizeMultiplier),
                                                          ),
                                                        ),
                                                        //Product Description
                                                        child: CustomText(
                                                          text: _products[index]['productName'],
                                                          // text: _products[index]['productDescription'],
                                                          align: TextAlign.center,
                                                          size: 1.8,
                                                          weight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ]
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    )
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
        )
      )
    );
  }
}

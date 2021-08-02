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
import 'package:food_booking_app/pages/basket.dart';
import 'package:food_booking_app/pages/orderWithVariants.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'orderCart.dart';

class OrderScreen extends StatefulWidget {
  var details;
  var specifics;
  OrderScreen({Key key, @required this.details, @required this.specifics}) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  SharedPreferences _sharedPreferences;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController _searchController = TextEditingController();
  var _restaurant = {};
  List _products = [];
  List _categories = [];
  List _selectedProductIds = [];
  int _selectedCategoryIndex = 0;
  List<String> quantity = [];
  bool _loading = false;
  int _cartQuantity = 0;
  var _cart = {};

  void initState() {
    // log(widget.details.toString());
    // TODO: implement initState
    super.initState();
    _getProducts();
  }

  _searchProduts(String search) {
    List products = [];
    
    _products.forEach((product) {
      if (product['name']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        setState(() {
          products.add(product);
        });
      }
    });

    setState(() {
      _products = new List.from(products);
    });
  }

  _category(int index) async {
    setState(() {
      _products = new List.from(_categories[index]['products']);
    });
  }

  _getProducts() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _cartQuantity = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart'))['total_items']:0;
      _selectedProductIds.clear();
      if (_sharedPreferences.getString('cart').isNotEmpty) {
        json.decode(_sharedPreferences.getString('cart'))['order_request_products'].forEach((product) {
          _selectedProductIds.add(product['product_id']);
        });
      }
      _cart = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart')):{};
    });
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

        setState(() {
          _restaurant = json.decode(response.body)['restaurant'];
          _categories.clear();
          _products.clear();
          _categories = new List.from(_restaurant['product_category']);
          _selectedCategoryIndex = 0;
          _products = new List.from(_categories[0]['products']);
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
        // backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(6 * heightMultiplier),
          child: Ink(
            width: 100 * widthMultiplier,
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(right: 4 * widthMultiplier),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    IconButton(
                      splashColor: Colors.black12.withOpacity(0.05),
                      hoverColor: Colors.black12.withOpacity(0.05),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 6 * imageSizeMultiplier,
                        color: appColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4 * widthMultiplier,),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          color: appColor,
                          align: TextAlign.center,
                          size: 3,
                          text: widget.details['name'],
                          weight: FontWeight.bold,
                        )
                      )
                    )
                  ]
                )
              )
            ),
          )
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 1 * heightMultiplier),
                child: CustomTextBox(
                  controller: _searchController, 
                  focusNode: null, 
                  text: 'Search foods', 
                  obscureText: false, 
                  enabled: true, 
                  border: true, 
                  shadow: false, 
                  onSubmitted: (text) {
                    FocusScope.of(context).unfocus();
                    _searchProduts(text);
                  }, 
                  keyboardType: TextInputType.text, 
                  textInputAction: TextInputAction.search, 
                  padding: 4, 
                  prefixIcon: null, 
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_searchController.text.length>0) {
                        _searchController.clear();
                        _getProducts();
                      }
                    },
                    icon: Icon(
                      _searchController.text.length>0?Icons.close_rounded:Icons.search,
                      size: 6 * imageSizeMultiplier
                    ),
                  ), 
                  type: 'roundedbox'
                ),
              ),
              if (_categories.length > 0)
              Ink(
                width: 100 * widthMultiplier,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Color(0xFF707070).withOpacity(.2), blurRadius: 0.2 * imageSizeMultiplier, offset: Offset(0, 3))
                  ],
                  color: Colors.white
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier),
                  child: Row(
                    children: [
                      for (var category in _categories)
                      Padding(
                        padding: EdgeInsets.only(
                          left: (_categories.indexOf(category) == 0?4:0) * widthMultiplier,
                          right: (_categories.indexOf(category) == _categories.length?0:4) * widthMultiplier,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(_selectedCategoryIndex == _categories.indexOf(category)?Colors.black.withOpacity(0.05):lightAppColor),
                            backgroundColor: MaterialStateProperty.all(_selectedCategoryIndex == _categories.indexOf(category)?appColor:Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: BorderSide(color: _selectedCategoryIndex == _categories.indexOf(category)?appColor:Colors.white),
                                borderRadius: BorderRadius.circular(1 * imageSizeMultiplier)
                              )
                            )
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedCategoryIndex = _categories.indexOf(category);
                            });
                            _category(_categories.indexOf(category));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 1 * widthMultiplier),
                            child: CustomText(
                              align: TextAlign.left,
                              text: category['name'],
                              size: 1.8,
                              weight: FontWeight.normal,
                              color: _selectedCategoryIndex == _categories.indexOf(category)?Colors.white:Color(0xFF9D9C9C),
                            ),
                          )
                        )
                      )
                    ],
                  )
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2 * heightMultiplier),
                  child: SmartRefresher(
                    enablePullDown: !_loading,
                    onRefresh: () {
                      _getProducts();
                    },
                    physics: BouncingScrollPhysics(),
                    header: MaterialClassicHeader(),
                    // header: CustomHeader(builder: (context, status) {
                    //   return Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       Icon(
                    //         Icons.circle,
                    //         size: 10 * imageSizeMultiplier,
                    //         color: appColor
                    //       ),
                    //       SizedBox(
                    //         height: 3 * imageSizeMultiplier,
                    //         width: 3 * imageSizeMultiplier,
                    //         child: CircularProgressIndicator(
                    //           strokeWidth: .2 * imageSizeMultiplier,
                    //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    //         )
                    //       )
                    //     ]
                    //   );
                    // }),
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
                        : Column(
                          children: [
                            for (var product in _products)
                            if (product['variants'].length>0)
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                                  child: CustomButton(
                                    height: 0,
                                    minWidth: 0,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(1 * imageSizeMultiplier)
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                        alignment: Alignment.center,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: OrderWithVariants(
                                                details: product,
                                                restaurantDetails: widget.details,
                                                specifics: widget.specifics,
                                                index: _products.indexOf(product)),
                                          ),
                                        ).then((value) {
                                          setState(() {
                                            _cartQuantity = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart'))['total_items']:0;
                                            _cart = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart')):{};
                                            _selectedProductIds.clear();
                                            if (_sharedPreferences.getString('cart').isNotEmpty) {
                                              json.decode(_sharedPreferences.getString('cart'))['order_request_products'].forEach((product) {
                                                _selectedProductIds.add(product['product_id']);
                                              });
                                            }
                                          });
                                        });
                                      },
                                      child: Hero(
                                        tag: '_orderLogo${product['id']}',
                                        // tag: 'orderLogo',
                                        child: Container(
                                          height: 26 * imageSizeMultiplier,
                                          width: 100 * widthMultiplier,
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: product['image'],
                                                placeholder: (context, string) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.black12,
                                                    highlightColor: Colors.black26,
                                                    child: Container(
                                                      height: 26 * imageSizeMultiplier,
                                                      width: 30 * imageSizeMultiplier,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(1 * imageSizeMultiplier), topLeft: Radius.circular(1 * imageSizeMultiplier)),
                                                        color: Color(0xFF363636),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                imageBuilder: (context, provider) {
                                                  return Container(
                                                    height: 26 * imageSizeMultiplier,
                                                    width: 30 * imageSizeMultiplier,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                                      color: Color(0xFF363636),
                                                      image: DecorationImage(
                                                        image: provider,
                                                        fit: BoxFit.cover
                                                      )
                                                    ),
                                                  );
                                                },
                                              ),
                                              Expanded(
                                                child:  Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomText(
                                                        text: product['name'],
                                                        // text: _products[index]['productDescription'],
                                                        align: TextAlign.center,
                                                        size: 1.8,
                                                        weight: FontWeight.normal,
                                                        color: Colors.black,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 1 * heightMultiplier),
                                                        child: CustomText(
                                                          text: 'From ₱ ${double.parse(product['variants'][0]['price'].toString()).toStringAsFixed(2)}',
                                                          // text: _products[index]['productDescription'],
                                                          align: TextAlign.center,
                                                          size: 1.4,
                                                          weight: FontWeight.normal,
                                                          color: Color(0xFF9D9C9C),
                                                        )
                                                      ),
                                                    ],
                                                  )
                                                )
                                              )
                                            ]
                                          )
                                        )
                                      )
                                    )
                                  )
                                ),
                                if (_selectedProductIds.contains(product['id']))
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(left: 2 * widthMultiplier),
                                    height: 4 * imageSizeMultiplier,
                                    width: 4 * imageSizeMultiplier,
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      borderRadius: BorderRadius.circular(10 * imageSizeMultiplier)
                                    ),
                                    // child:  CustomText(
                                    //   align: TextAlign.left,
                                    //   text: _cart['order_request_products'][_selectedProductIds.indexWhere((element) => _selectedProductIds.contains(product['id']))]['quantity'].toString(),
                                    //   color: Colors.black,
                                    //   size: 1.2,
                                    //   weight: FontWeight.normal,
                                    // ),
                                    // child: Icon(
                                    //   Icons.check_rounded,
                                    //   color: Colors.white,
                                    //   size: 4 * imageSizeMultiplier
                                    // ),
                                  ),
                                )
                              ]
                            )
                          ],
                        )
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomSheet: _cartQuantity>0?
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
          child: TextButton(
            onPressed: () {
              Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: BasketScren(specifics: widget.specifics,)))
              .then((value) {
                setState(() {
                  _cartQuantity = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart'))['total_items']:0;
                  _cart = _sharedPreferences.getString('cart').isNotEmpty?json.decode(_sharedPreferences.getString('cart')):{};
                  _selectedProductIds.clear();
                  if (_sharedPreferences.getString('cart').isNotEmpty) {
                    json.decode(_sharedPreferences.getString('cart'))['order_request_products'].forEach((product) {
                      _selectedProductIds.add(product['product_id']);
                    });
                  }
                });
              });
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
              minimumSize: MaterialStateProperty.all(Size.zero),
              padding: MaterialStateProperty.all(EdgeInsets.zero)
            ),
            child: Ink(
              height: 6 * heightMultiplier,
              width: 100 * widthMultiplier,
              padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                color: appColor
              ),
              // color: appColor,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 6 * imageSizeMultiplier,
                      height: 6 * imageSizeMultiplier,
                      padding: EdgeInsets.symmetric(horizontal: 1 * widthMultiplier),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                        border: Border.all(color: Colors.white)
                        // color: Colors.white
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          text: '$_cartQuantity',
                          // text: _products[index]['productDescription'],
                          align: TextAlign.center,
                          size: 1.4,
                          weight: FontWeight.normal,
                          color: Colors.white,
                        )
                      )
                    )
                  ),
                  CustomText(
                    text: 'Review basket',
                    // text: _products[index]['productDescription'],
                    align: TextAlign.center,
                    size: 1.4,
                    weight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      text: '₱ ${double.parse(_cart['total_price'].toString()).toStringAsFixed(2)}',
                      // text: _products[index]['productDescription'],
                      align: TextAlign.center,
                      size: 1.4,
                      weight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            )
          )
        )
        :
        null,
      )
    );
  }
}

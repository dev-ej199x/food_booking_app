import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/filled-button.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'orderCart.dart';

class OrderWithVariants extends StatefulWidget {
  Map<String, dynamic> details;
  Map<String, dynamic> restaurantDetails;
  int index;
  var specifics;
  OrderWithVariants(
      {Key key,
      @required this.details,
      @required this.restaurantDetails,
      @required this.specifics,
      @required this.index})
      : super(key: key);
  @override
  _OrderWithVariantsState createState() => _OrderWithVariantsState();
}

class _OrderWithVariantsState extends State<OrderWithVariants> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _loading = true;
  var _product = {};
  List _variants = [];
  List _productOptions = [];
  List _selectedIndexes = [];
  List _controllers = [];
  List _productOptItems = [];
  int _cartQuantity = 0;
  int _selectedVariantIndex = 0;
  int _quantity = 1;
  TextEditingController _noteController = TextEditingController();
  // List _productControllers = [];
  //
  //
  _getVariants() async {
    var response =
        await Http(url: 'products/${widget.details['id']}', body: {})
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
            size: 1.4,
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
              size: 1.4,
              weight: FontWeight.normal,
            ),
          ),
        );
      } else {

        setState(() {
          _product = json.decode(response.body)['product'][0];
          _variants.clear();
          _variants = new List.from(_product['variants']);
          if (_variants.isNotEmpty) {
            _variants.forEach((variant) {
              _selectedIndexes.add([]);
              variant['quantity'] = 0;
              variant['product_options'].forEach((option) {
                if (option['selection'] == 'single') _selectedIndexes[_variants.indexOf(variant)].add(-1);
                else _selectedIndexes[_variants.indexOf(variant)].add([]);
              });
              _controllers.add([]);
              // _productControllers.add([]);
            });
          }
          _loading = false;
          _refreshController.refreshCompleted();
        });
      }
    }
  }

  void initState() {
    //TODO: implement initstate
    super.initState();
    _getVariants();

    // _variants = new List.from(widget.details['productVariants']);
    // if (_variants.isNotEmpty) {
    //   _variants.forEach((variant) {
    //     variant['quantity'] = 0;
    //     _selectedIndexes.add([]);
    //     _controllers.add([]);
    //     // _productControllers.add([]);
    //   });
    // }
  }

  _addToCart(List productOptions, double productOptionsPrice) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var cart = {};
    //may cart na
    if (sharedPreferences.getString('cart').isNotEmpty) {
      cart = json.decode(sharedPreferences.getString('cart'));
      //iba yung restaurant
      if (cart['restaurant']['id'] != widget.restaurantDetails['id']) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'The Cart has already have an order. It will Ovewrite, Proceed?',
            color: Colors.white,
            size: 1.4,
            weight: FontWeight.normal,
          ),
        ));
        return;
      } 
      //same restaurant
      else {
        bool sameProduct = false;
        cart['total_price'] = 0;
        cart['total_items'] = 0;
        cart['order_request_products'].forEach((product) {
          var newproduct = {
            'product_name': widget.details['name'],
            'product_id': widget.details['id'],
            'variant_id': _variants[_selectedVariantIndex]['id'],
            'name': _variants[_selectedVariantIndex]['name'],
            'note': _noteController.text,
            'product_options': productOptions
          };
          var oldproduct = {
            'product_name': product['product_name'],
            'product_id': product['productide'],
            'variant_id': product['variant_id'],
            'name': product['name'],
            'note': product['note'],
            'product_options': product['product_options']
          };
          //same lang yung order product
          if (oldproduct.toString() == newproduct.toString()) {
            sameProduct = true;
            product['quantity'] = int.parse(product['quantity'].toString()) + _quantity;
            product['overall_price'] = (productOptionsPrice + double.parse(_variants[_selectedVariantIndex]['price'].toString())) * int.parse(product['quantity'].toString());
          }
          cart['total_price'] += product['overall_price'];
          cart['total_items'] += product['quantity'];
        });
        //iba yung order product
        if (!sameProduct) {
          cart['order_request_products'].add({
            'overall_price': (productOptionsPrice + double.parse(_variants[_selectedVariantIndex]['price'].toString())) * int.parse(_quantity.toString()),
            'specific_price': productOptionsPrice + double.parse(_variants[_selectedVariantIndex]['price'].toString()),
            'product_image': widget.details['image'],
            'variant_image': _variants[_selectedVariantIndex]['image'],
            'product_name': widget.details['name'],
            'product_id': widget.details['id'],
            'variant_id': _variants[_selectedVariantIndex]['id'],
            'name': _variants[_selectedVariantIndex]['name'],
            'quantity': _quantity,
            'note': _noteController.text,
            'product_options': productOptions,
          });
          cart['total_price'] += (productOptionsPrice + double.parse(_variants[_selectedVariantIndex]['price'].toString())) * int.parse(_quantity.toString());
          cart['total_items'] += _quantity;
        }

        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'Added to cart',
            color: Colors.white,
            size: 1.4,
            weight: FontWeight.normal,
          ),
        ));

        sharedPreferences.setString('cart', json.encode(cart));
      }
    }
    //wala pang cart
    else {
      cart = {
        'total_price': (productOptionsPrice + double.parse(_variants[_selectedVariantIndex]['price'].toString())) * int.parse(_quantity.toString()),
        'total_items': _quantity,
        'restaurant': {
          'id': widget.restaurantDetails['id'],
          'concierge_percentage': widget.restaurantDetails['concierge_percentage'],
          'markup_percentage': widget.restaurantDetails['markup_percentage'],
        },
        'order_request_products': [
          {
            'overall_price': (productOptionsPrice + double.parse(_variants[_selectedVariantIndex]['price'].toString())) * int.parse(_quantity.toString()),
            'specific_price': productOptionsPrice + double.parse(_variants[_selectedVariantIndex]['price'].toString()),
            'product_image': widget.details['image'],
            'variant_image': _variants[_selectedVariantIndex]['image'],
            'product_name': widget.details['name'],
            'product_id': widget.details['id'],
            'variant_id': _variants[_selectedVariantIndex]['id'],
            'name': _variants[_selectedVariantIndex]['name'],
            'quantity': _quantity,
            'note': _noteController.text,
            'product_options': productOptions,
          }
        ]
      };

      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF323232),
        content: CustomText(
          align: TextAlign.left,
          text: 'Added to cart',
          color: Colors.white,
          size: 1.4,
          weight: FontWeight.normal,
        ),
      ));

      sharedPreferences.setString('cart', json.encode(cart));
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
          child: Padding(
            padding: EdgeInsets.only(top: 2 * heightMultiplier),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (!_loading)
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 4 * widthMultiplier),
                        height: 66 * imageSizeMultiplier,
                        width: 70 * imageSizeMultiplier,
                        child: CachedNetworkImage(
                          imageUrl: _product['variants'][_selectedVariantIndex]['image'],
                          placeholder: (context, string) {
                            return Shimmer.fromColors(
                              baseColor: Colors.black12,
                              highlightColor: Colors.black26,
                              child: Container(
                                height: 66 * imageSizeMultiplier,
                                width: 66 * imageSizeMultiplier,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                  color: Color(0xFF363636),
                                ),
                              ),
                            );
                          },
                          errorWidget: (context, string, _) {
                            return Container(
                              height: 66 * imageSizeMultiplier,
                              width: 66 * imageSizeMultiplier,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                color: Color(0xFF363636),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    Images.iconImage,
                                  )
                                )
                              ),
                            );
                          },
                          imageBuilder: (context, provider) {
                            return Container(
                              height: 66 * imageSizeMultiplier,
                              width: 66 * imageSizeMultiplier,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: provider
                                )
                              ),
                            );
                          }
                        )
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 66 * imageSizeMultiplier,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var variant in _product['variants'])
                                TextButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size.zero),
                                    overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedVariantIndex = _product['variants'].indexOf(variant);
                                    });
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: variant['image'],
                                        placeholder: (context, string) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.black12,
                                            highlightColor: Colors.black26,
                                            child: Container(
                                              height: 14 * imageSizeMultiplier,
                                              width: 14 * imageSizeMultiplier,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                                color: Color(0xFF363636),
                                              ),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, string, _) {
                                          return Container(
                                            height: 14 * imageSizeMultiplier,
                                            width: 14 * imageSizeMultiplier,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                              color: Color(0xFF363636),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  Images.iconImage,
                                                )
                                              )
                                            ),
                                          );
                                        },
                                        imageBuilder: (context, provider) {
                                          return Container(
                                            height: 14 * imageSizeMultiplier,
                                            width: 14 * imageSizeMultiplier,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: provider
                                              )
                                            ),
                                          );
                                        }
                                      ),
                                      Container(
                                        height: 16 * imageSizeMultiplier,
                                        width: 16 * imageSizeMultiplier,
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: (_selectedVariantIndex == _product['variants'].indexOf(variant))?Colors.black:Colors.transparent,
                                            size: 4 * imageSizeMultiplier,
                                          ),
                                        )
                                      )
                                    ]
                                  )
                                ),
                              ],
                            )
                          ),
                        )
                      )
                    ],
                  ),
                  if (!_loading)
                  Padding(
                    padding: EdgeInsets.only(top: 2 * heightMultiplier, left:  4 * widthMultiplier, bottom: 1 * heightMultiplier, right: 4 * widthMultiplier),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: _variants[_selectedVariantIndex]['name'],
                                // text: _variants[_selectedVariantIndex]s[index]['productDescription'],
                                align: TextAlign.left,
                                size: 2.4,
                                weight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1 * heightMultiplier),
                                child: CustomText(
                                  text: _variants[_selectedVariantIndex]['description'],
                                  // text: _variants[_selectedVariantIndex]s[index]['productDescription'],
                                  align: TextAlign.left,
                                  size: 1.8,
                                  weight: FontWeight.normal,
                                  color: Colors.black54,
                                )
                              )
                            ]
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left:  4 * widthMultiplier, right: 4 * widthMultiplier),
                          child: CustomText(
                            text: '₱ ${double.parse(_variants[_selectedVariantIndex]['price'].toString()).toStringAsFixed(2)}',
                            // text: _products[index]['productDescription'],
                            align: TextAlign.left,
                            size: 2.4,
                            weight: FontWeight.bold,
                            color: appColor,
                          )
                        )
                      ]
                    )
                  ),
                  if (!_loading)
                  for (var option in _variants[_selectedVariantIndex]['product_options'])
                  if (!(option['product_option_items'].length==0 && option['type'] != 'required'))
                    Padding(
                      padding: EdgeInsets.only(left:  4 * widthMultiplier, right: 4 * widthMultiplier, top: 2 * heightMultiplier),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: option['name'],
                                      // text: _products[index]['productDescription'],
                                      align: TextAlign.left,
                                      size: 1.8,
                                      weight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    CustomText(
                                      text: option['selection'] == 'single'?'Select one':'Select as many as you want',
                                      // text: _products[index]['productDescription'],
                                      align: TextAlign.left,
                                      size: 1.4,
                                      weight: FontWeight.normal,
                                      color: Colors.black54,
                                    ),
                                  ]
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10 * imageSizeMultiplier),
                                  color: lightAppColor
                                ),
                                padding: EdgeInsets.symmetric(vertical: 0.4 * heightMultiplier, horizontal: 1.2 * widthMultiplier),
                                child: CustomText(
                                  text: option['type'] == 'required'?'Required':'Optional',
                                  // text: _products[index]['productDescription'],
                                  align: TextAlign.left,
                                  size: 1.2,
                                  weight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              )
                            ]
                          ),
                          for (var item in option['product_option_items'])
                          Row(
                            children: [
                              if (option['selection'] == 'single')
                              Expanded(
                                child: RadioListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  value: option['product_option_items'].indexOf(item), 
                                  groupValue: _selectedIndexes[_selectedVariantIndex][_variants[_selectedVariantIndex]['product_options'].indexOf(option)], 
                                  activeColor: appColor,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedIndexes[_selectedVariantIndex][_variants[_selectedVariantIndex]['product_options'].indexOf(option)] = option['product_option_items'].indexOf(item);
                                    });
                                  },
                                  title: CustomText(
                                    text: item['item_name'],
                                    // text: _products[index]['productDescription'],
                                    align: TextAlign.left,
                                    size: 1.4,
                                    weight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                )
                              )
                              else
                              Expanded(
                                child: CheckboxListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  value: _selectedIndexes[_selectedVariantIndex][_variants[_selectedVariantIndex]['product_options'].indexOf(option)].contains(option['product_option_items'].indexOf(item)), 
                                  activeColor: appColor,
                                  onChanged: (value) {
                                    // 
                                    if (value) {
                                      setState(() {
                                        _selectedIndexes[_selectedVariantIndex][_variants[_selectedVariantIndex]['product_options'].indexOf(option)].add(option['product_option_items'].indexOf(item));
                                      });
                                    }
                                    else {
                                      setState(() {
                                        _selectedIndexes[_selectedVariantIndex][_variants[_selectedVariantIndex]['product_options'].indexOf(option)].remove(option['product_option_items'].indexOf(item));
                                      });
                                    }
                                  },
                                  title: CustomText(
                                    text: item['item_name'],
                                    // text: _products[index]['productDescription'],
                                    align: TextAlign.left,
                                    size: 1.4,
                                    weight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                )
                              ),
                              CustomText(
                                text: '+ ${double.parse(item['price'].toString()).toStringAsFixed(2)}',
                                // text: _products[index]['productDescription'],
                                align: TextAlign.left,
                                size: 1.4,
                                weight: FontWeight.normal,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  if (!_loading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 4 * widthMultiplier),
                    child: CustomText(
                      text: 'Special Instructions',
                      // text: _products[index]['productDescription'],
                      align: TextAlign.left,
                      size: 1.8,
                      weight: FontWeight.bold,
                      color: Colors.black,
                    )
                  ),
                  if (!_loading)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier),
                    child: CustomText(
                      maxLine: 2,
                      text: 'Please tell us which foods or ingredients to avoid (such as foods that can cause allergic reactions)',
                      // text: _products[index]['productDescription'],
                      align: TextAlign.left,
                      size: 1.4,
                      weight: FontWeight.normal,
                      color: Colors.black54,
                    )
                  ),
                  if (!_loading)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                    child: CustomTextBox(
                      maxLine: 3,
                      focusNode: null,
                      type: 'roundedbox',
                      border: true,
                      textInputAction: TextInputAction.next,
                      controller: _noteController,
                      onSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      text: "e.g No pork/No shrimp",
                      obscureText: false,
                      padding: 4,
                      prefixIcon: null,
                      suffixIcon: null,
                      enabled: true,
                      shadow: false,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  )
                ]
              )
            )
          )
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal:  4 * widthMultiplier, vertical: 2 * heightMultiplier),
          child: Row(
            children: [
              Container(
                width: 32 * widthMultiplier,
                height: 6 * heightMultiplier,
                padding: EdgeInsets.symmetric(horizontal: 1 * widthMultiplier),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                  color: Colors.white
                ),
                child: Row(
                  children: [
                    CustomButton(
                      height: 0,
                      minWidth: 0,
                      child: TextButton(
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: MaterialStateProperty.all(Size.zero),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        child: Ink(
                          width: 8 * imageSizeMultiplier,
                          height: 8 * imageSizeMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                            color: appColor
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.remove_rounded,
                              color: Colors.white,
                              size: 6 * imageSizeMultiplier,
                            )
                          )
                        )
                      )
                    ),
                    Expanded(
                      child: CustomText(
                        text: _quantity.toString(),
                        // text: _products[index]['productDescription'],
                        align: TextAlign.center,
                        size: 1.4,
                        weight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    CustomButton(
                      height: 0,
                      minWidth: 0,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: MaterialStateProperty.all(Size.zero),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        child: Ink(
                          width: 8 * imageSizeMultiplier,
                          height: 8 * imageSizeMultiplier,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                            color: appColor
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 6 * imageSizeMultiplier,
                            )
                          )
                        )
                      )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier),
                  child: CustomButton(
                    height: 0,
                    minWidth: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        List product_options = [];
                        bool proceed = true;
                        double price = 0;
                        _selectedIndexes[_selectedVariantIndex].asMap().forEach((index, selected) {
                          if (proceed){
                            if (_variants[_selectedVariantIndex]['product_options'][index]['selection'] == 'single') {
                              if (_variants[_selectedVariantIndex]['product_options'][index]['type'] == 'required' && selected == -1) {
                                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                  content: CustomText(
                                    align: TextAlign.left,
                                    text: '${_variants[_selectedVariantIndex]['product_options'][index]['name']} selection is Required!',
                                    color: Colors.white,
                                    size: 1.8,
                                    weight: FontWeight.normal,
                                  ),
                                  duration: Duration(seconds: 2, milliseconds: 155),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                proceed = false;
                                return;
                              }
                              else if (selected > -1) {
                                proceed = true;
                                product_options.add({
                                  'id': _variants[_selectedVariantIndex]['product_options'][index]['id'],
                                  'name': _variants[_selectedVariantIndex]['product_options'][index]['name'],
                                  'selection': _variants[_selectedVariantIndex]['product_options'][index]['selection'],
                                  'type': _variants[_selectedVariantIndex]['product_options'][index]['type'],
                                  'product_option_items': [
                                    {
                                      'id': _variants[_selectedVariantIndex]['product_options'][index]['product_option_items'][selected]['id'],
                                      'name': _variants[_selectedVariantIndex]['product_options'][index]['product_option_items'][selected]['item_name'],
                                    }
                                  ]
                                });
                                price += double.parse(_variants[_selectedVariantIndex]['product_options'][index]['product_option_items'][selected]['price'].toString());
                              }
                              else {
                                proceed = true;
                              }
                            }
                            else {
                              if (_variants[_selectedVariantIndex]['product_options'][index]['type'] == 'required' && selected.isEmpty) {
                                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                  content: CustomText(
                                    align: TextAlign.left,
                                    text: '${_variants[_selectedVariantIndex]['product_options'][index]['name']} selection is Required!',
                                    color: Colors.white,
                                    size: 1.8,
                                    weight: FontWeight.normal,
                                  ),
                                  duration: Duration(seconds: 2, milliseconds: 155),
                                  behavior: SnackBarBehavior.floating,
                                ));
                                proceed = false;
                                return;
                              }
                              else if (selected.isNotEmpty) {
                                proceed = true;
                                List items = [];
                                selected.forEach((id) {
                                  items.add({
                                    'id': _variants[_selectedVariantIndex]['product_options'][index]['product_option_items'][id]['id'],
                                    'name': _variants[_selectedVariantIndex]['product_options'][index]['product_option_items'][id]['item_name'],
                                  });
                                  price += double.parse(_variants[_selectedVariantIndex]['product_options'][index]['product_option_items'][id]['price'].toString());
                                });
                                product_options.add({
                                  'id': _variants[_selectedVariantIndex]['product_options'][index]['id'],
                                  'name': _variants[_selectedVariantIndex]['product_options'][index]['name'],
                                  'selection': _variants[_selectedVariantIndex]['product_options'][index]['selection'],
                                  'type': _variants[_selectedVariantIndex]['product_options'][index]['type'],
                                  'product_option_items': items
                                });
                              }
                              else {
                                proceed = true;
                              }
                            }
                          }
                        });
                        if (proceed) {
                          _addToCart(
                            product_options, 
                            price
                          );
                        }
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1 * imageSizeMultiplier)
                          )
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: MaterialStateProperty.all(Size.zero),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      child: Ink(
                        padding: EdgeInsets.symmetric(horizontal: 4 * widthMultiplier),
                        height: 6 * heightMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1 * imageSizeMultiplier),
                          color: appColor
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: CustomText(
                            text: 'Add to basket',
                            // text: _products[index]['productDescription'],
                            align: TextAlign.center,
                            size: 1.4,
                            weight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        )
                      )
                    )
                  )
                ),
              )
            ],
          )
        ),
      )
    );
  }
}

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

class UpdateOrderScreen extends StatefulWidget {
  Map<String, dynamic> details;
  int index;
  UpdateOrderScreen(
      {Key key,
      @required this.details,
      @required this.index
      })
      : super(key: key);
  @override
  _UpdateOrderScreenState createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _loading = true;
  var _product = {};
  var _variant = {};
  List _selected = [];
  int _quantity = 1;
  TextEditingController _noteController = TextEditingController();
  // List _productControllers = [];
  //
  //
  _getVariants() async {
    var response =
        await Http(url: 'products/${widget.details['product_id']}', body: {})
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
          new List.from(_product['variants']).forEach((variant) {
            if (variant['id'] == widget.details['variant_id']) {
              _variant = variant;
            }
          });
          List selectedProductOptionIds = [];
          List selectedProductOptions = [];
          widget.details['product_options'].forEach((option) {
            selectedProductOptionIds.add(option['id']);
            selectedProductOptions.add(option);
          });
          _variant['product_options'].forEach((option) {
            bool found = false;
            List selectedItems = [];
            selectedProductOptionIds.forEach((selectedOption) {
              if (!found) {
                if (selectedOption == option['id']) {
                  found = true;
                  List itemIds = [];
                  option['product_option_items'].forEach((item) {
                    itemIds.add(item['id']);
                  });
                  selectedProductOptions[selectedProductOptionIds.indexOf(selectedOption)]['product_option_items'].forEach((selectedItem) {
                    itemIds.forEach((id) {
                      if (id == selectedItem['id']) {
                        selectedItems.add(itemIds.indexOf(id));
                      }
                    });
                  });
                  if (option['selection'] == 'single') _selected.add(selectedItems[0]);
                  else _selected.add(selectedItems);
                }
              }
            });
            if (!found) {
              if (option['selection'] == 'single') _selected.add(-1);
              else _selected.add([]);
            }
          });
          // _productControllers.add([]);
          _loading = false;
          _refreshController.refreshCompleted();
        });
      }
    }
  }

  void initState() {
    //TODO: implement initstate
    super.initState();
    _noteController.text = widget.details['note'];
    _quantity = widget.details['quantity'];
    _getVariants();

    // _variants = new List.from(widget.details['productVariants']);
    // if (_variants.isNotEmpty) {
    //   _variants.forEach((variant) {
    //     variant['quantity'] = 0;
    //     _selected.add([]);
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
      
      bool sameProduct = false;
      cart['total_price'] = cart['total_price'] - cart['order_request_products'][widget.index]['overall_price'];
      cart['total_items'] = cart['total_items'] - cart['order_request_products'][widget.index]['quantity'];
      cart['order_request_products'][widget.index] = {
        'overall_price': (productOptionsPrice + double.parse(_variant['price'].toString())) * int.parse(_quantity.toString()),
        'specific_price': productOptionsPrice + double.parse(_variant['price'].toString()),
        'product_image': widget.details['product_image'],
        'variant_image': _variant['image'],
        'product_name': widget.details['product_name'],
        'product_id': widget.details['product_id'],
        'variant_id': _variant['id'],
        'name': _variant['name'],
        'quantity': _quantity,
        'note': _noteController.text,
        'product_options': productOptions,
      };
      cart['total_price'] += cart['order_request_products'][widget.index]['overall_price'];
      cart['total_items'] += cart['order_request_products'][widget.index]['quantity'];

      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF323232),
        content: CustomText(
          align: TextAlign.left,
          text: 'Updated basket',
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
                          text: widget.details['product_name'],
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (!_loading)
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 4 * widthMultiplier),
                    height: 66 * imageSizeMultiplier,
                    width: 70 * imageSizeMultiplier,
                    child: CachedNetworkImage(
                      imageUrl: _variant['image'],
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
                                text: _variant['name'],
                                // text: _variants[index]['productDescription'],
                                align: TextAlign.left,
                                size: 2.4,
                                weight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 1 * heightMultiplier),
                                child: CustomText(
                                  text: _variant['description'],
                                  // text: _variants[index]['productDescription'],
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
                            text: '₱ ${double.parse(_variant['price'].toString()).toStringAsFixed(2)}',
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
                  for (var option in _variant['product_options'])
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
                                groupValue: _selected[_variant['product_options'].indexOf(option)], 
                                activeColor: appColor,
                                onChanged: (value) {
                                  setState(() {
                                    _selected[_variant['product_options'].indexOf(option)] = option['product_option_items'].indexOf(item);
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
                                value: _selected[_variant['product_options'].indexOf(option)].contains(option['product_option_items'].indexOf(item)), 
                                activeColor: appColor,
                                onChanged: (value) {
                                  // 
                                  if (value) {
                                    setState(() {
                                      _selected[_variant['product_options'].indexOf(option)].add(option['product_option_items'].indexOf(item));
                                    });
                                  }
                                  else {
                                    setState(() {
                                      _selected[_variant['product_options'].indexOf(option)].remove(option['product_option_items'].indexOf(item));
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: 'Special Instructions',
                        // text: _products[index]['productDescription'],
                        align: TextAlign.left,
                        size: 1.8,
                        weight: FontWeight.bold,
                        color: Colors.black,
                      )
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
                        _selected.asMap().forEach((index, selected) {
                          if (proceed){
                            if (_variant['product_options'][index]['selection'] == 'single') {
                              if (_variant['product_options'][index]['type'] == 'required' && selected == -1) {
                                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                  content: CustomText(
                                    align: TextAlign.left,
                                    text: '${_variant['product_options'][index]['name']} selection is Required!',
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
                                  'id': _variant['product_options'][index]['id'],
                                  'name': _variant['product_options'][index]['name'],
                                  'selection': _variant['product_options'][index]['selection'],
                                  'type': _variant['product_options'][index]['type'],
                                  'product_option_items': [
                                    {
                                      'id': _variant['product_options'][index]['product_option_items'][selected]['id'],
                                      'name': _variant['product_options'][index]['product_option_items'][selected]['item_name'],
                                    }
                                  ]
                                });
                                price += double.parse(_variant['product_options'][index]['product_option_items'][selected]['price'].toString());
                              }
                              else {
                                proceed = true;
                              }
                            }
                            else {
                              if (_variant['product_options'][index]['type'] == 'required' && selected.isEmpty) {
                                _scaffoldKey.currentState.showSnackBar(new SnackBar(
                                  content: CustomText(
                                    align: TextAlign.left,
                                    text: '${_variant['product_options'][index]['name']} selection is Required!',
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
                                    'id': _variant['product_options'][index]['product_option_items'][id]['id'],
                                    'name': _variant['product_options'][index]['product_option_items'][id]['item_name'],
                                  });
                                  price += double.parse(_variant['product_options'][index]['product_option_items'][id]['price'].toString());
                                });
                                product_options.add({
                                  'id': _variant['product_options'][index]['id'],
                                  'name': _variant['product_options'][index]['name'],
                                  'selection': _variant['product_options'][index]['selection'],
                                  'type': _variant['product_options'][index]['type'],
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
                            text: 'Update basket',
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

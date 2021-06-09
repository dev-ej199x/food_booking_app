import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
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
  bool _loading = false;
  List _variants = [];
  List _productOptions = [];
  List _selected = [];
  List _controllers = [];
  List _productOptItems = [];
  int _cartQuantity = 0;
  // List _productControllers = [];
  //
  //
  _getVariants() async {
    var response =
        await Http(url: 'products/${widget.details['productId']}', body: {})
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
        Map<String, dynamic> product = json.decode(response.body)['product'][0];
        List<Map<String, dynamic>> variant = [];
        product['variants'].forEach((variants) {
          List<Map<String, dynamic>> productoption = [];
          variants['product_options']?.forEach((productOptions) {
            List<Map<String, dynamic>> productoptionitem = [];
            productOptions['product_option_items'].forEach((productOptionItem) {
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

        setState(() {
          _variants.clear();
          _variants = new List.from(variant);
          if (_variants.isNotEmpty) {
            _variants.forEach((variant) {
              variant['quantity'] = 0;
              _selected.add([]);
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
    //     _selected.add([]);
    //     _controllers.add([]);
    //     // _productControllers.add([]);
    //   });
    // }
  }

  _variantDialog(int count) {
    TextEditingController _noteController = TextEditingController();
    TextEditingController _productController = TextEditingController();
    _productController.text = '1';
    print(_selected[count]);

    setState(() {
      _selected[count].clear();
      _productOptions = new List.from(_variants[count]['vairantOption']);
      if (_productOptions.length>0)
      _productOptItems = new List.from(_productOptions[count]['productOptionItem']);
      else _productOptItems.clear();

      if (_productOptions.length>0) {
        _productOptions.forEach((option) {
          if (option['productOptSelection'] == 'single')
            _selected[count].add(-1);
          else
            _selected[count].add([]);
        });
      }

      _controllers[count].clear();
      if (_controllers[count].isEmpty) {
        _productOptions.forEach((option) {
          List<TextEditingController> controllers = [];
          option['productOptionItem'].forEach((item) {
            TextEditingController _controller = TextEditingController();
            _controller.text = '0';
            controllers.add(_controller);
          });
          _controllers[count].add(controllers);
        });
      }
    });
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setstate) => AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8 * imageSizeMultiplier),
              ),
            ),
            content: Container(
              width: 100 * widthMultiplier,
              height: 60 * heightMultiplier,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8 * imageSizeMultiplier), topRight: Radius.circular(8 * imageSizeMultiplier),),
                      color: Color(0xff323030),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2.4 * heightMultiplier),
                      child: CustomText(
                        text: 'Variation',
                        align: TextAlign.center,
                        size: 3,
                        color: Color(0xffeb4d4d),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3 * widthMultiplier),
                                child: CustomText(
                                  text: _variants[count]['variantName'],
                                  align: TextAlign.center,
                                  size: 2.4,
                                  weight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2 * widthMultiplier),
                                child: CustomText(
                                  text: '₱ ${_variants[count]['variantPrice'].toString()}.00',
                                  align: TextAlign.center,
                                  weight: FontWeight.normal,
                                  size: 1.6,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                height: 10 * heightMultiplier,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: 2 * widthMultiplier,
                                        bottom: 1 * heightMultiplier,
                                      ),
                                      child: Container(
                                        width: 13 * widthMultiplier,
                                        height: 4 * heightMultiplier,
                                        child: MaterialButton(
                                          minWidth: 2.0,
                                          child: Icon(Icons.arrow_drop_up),
                                          onPressed: () {
                                            int _priceValue = int.parse(
                                                _variants[count]['variantPrice']
                                                    .toString());
                                            int currentValue = int.parse(
                                                _productController.text);
                                            setState(() {
                                              _priceValue =
                                                  _priceValue + _priceValue;
                                              currentValue++;
                                              _productController.text =
                                                  (currentValue)
                                                      .toString(); // incrementing value
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 1 * widthMultiplier),
                                      child: Container(
                                        width: 5 * widthMultiplier,
                                        height: 1 * heightMultiplier,
                                        child: TextFormField(
                                          controller: _productController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none
                                          ),
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: false,
                                                  signed: false),
                                          inputFormatters: <TextInputFormatter>[
                                            WhitelistingTextInputFormatter
                                                .digitsOnly
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: 3 * widthMultiplier),
                                      child: Container(
                                        height: 3 * heightMultiplier,
                                        width: 12 * widthMultiplier,
                                        child: MaterialButton(
                                          minWidth: 2.0,
                                          child: Icon(Icons.arrow_drop_down),
                                          onPressed: () {
                                            int _priceValue = int.parse(
                                                _variants[count]['variantPrice']
                                                    .toString());
                                            int currentValue = int.parse(
                                                _productController.text);
                                            setState(
                                              () {
                                                _priceValue =
                                                    _priceValue - _priceValue;
                                                currentValue--;
                                                _productController.text =
                                                    (currentValue)
                                                        .toString(); // decrementing value
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_productOptions.length>0)
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _productOptions.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                if (_productOptions[index]['productOptionItem'].isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                  child: Divider(
                                    height: 0,
                                    color: Colors.red,
                                  )
                                ),
                                if (_productOptions[index]['productOptionItem'].isNotEmpty)
                                  CustomText(
                                    align: TextAlign.left,
                                    text: 'Select ${_productOptions[index]['productOptName']}${_productOptions[index]['productOptSelection'] == 'single' ? '' : '(s)'}',
                                    size: 2,
                                    weight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                if (_productOptions[index]['productOptSelection'] ==
                                    'single')
                                  Container(
                                    child: ListView.builder(
                                      physics:
                                          NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _productOptions[
                                                  index]
                                              ['productOptionItem']
                                          .length,
                                      itemBuilder:
                                          (context, itemindex) => Row(
                                        children: [
                                          Expanded(
                                              child: RadioListTile(
                                            // value: _productOptions[index]['productOptionItem'][itemindex]['productOptItmId'] + itemindex,
                                            value: itemindex,
                                            groupValue:
                                                _selected[count]
                                                    [index],
                                            title: CustomText(
                                              align: TextAlign.left,
                                              text: _productOptions[index]['productOptionItem'][itemindex]['productOptItmName'],
                                              color: Colors.black,
                                              size: 1.8,
                                              weight: FontWeight.normal,
                                            ),
                                            secondary: CustomText(
                                              align: TextAlign.left,
                                              text: '₱ ${double.parse(_productOptions[index]['productOptionItem'][itemindex]['productOptItmPrice'].toString()).toStringAsFixed(2)}',
                                              color: Colors.black,
                                              size: 1.6,
                                              weight: FontWeight.normal,
                                            ),
                                            onChanged:
                                                (valuechanged) {
                                              setstate(() {
                                                _selected[count]
                                                        [index] =
                                                    valuechanged;
                                              });
                                              setState(() {
                                                _selected[count]
                                                        [index] =
                                                    valuechanged;
                                              });
                                            },
                                          )),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  ListView.builder(
                                    physics:
                                        NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _productOptions[index]
                                            ['productOptionItem']
                                        .length,
                                    itemBuilder:
                                        (context, itemindex) =>
                                            CheckboxListTile(
                                      value: _selected[count][index]
                                          .asMap()
                                          .containsValue(itemindex),
                                      title: CustomText(
                                        align: TextAlign.left,
                                        text: _productOptions[index]['productOptionItem'][itemindex]['productOptItmName'],
                                        color: Colors.black,
                                        size: 1.8,
                                        weight: FontWeight.normal,
                                      ),
                                      onChanged: (valuechanged) {
                                        if (valuechanged) {
                                          setstate(
                                            () {
                                              _selected[count][index]
                                                  .add(itemindex);
                                            },
                                          );

                                          // setState(
                                          //   () {
                                          //     _selected[count][index]
                                          //         .add(itemindex);
                                          //   },
                                          // );
                                        } else {
                                          setstate(
                                            () {
                                              _selected[count][index]
                                                  .remove(itemindex);
                                            },
                                          );
                                          // setState(
                                          //   () {
                                          //     _selected[count][index]
                                          //         .remove(itemindex);
                                          //   },
                                          // );
                                        }
                                      },
                                    ),
                                  )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                            child: Divider(
                              height: 0,
                              color: Colors.red,
                            )
                          ),
                          CustomText(
                            align: TextAlign.left,
                            text: 'Add delivery note',
                            size: 2,
                            weight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier),
                            child: CustomTextBox(
                              type: 'roundedbox',
                              shadow: false,
                              border: true,
                              controller: _noteController,
                              text: 'NOTE',
                              enabled: true,
                              obscureText: false,
                              padding: 8,
                              prefixIcon: null,
                              suffixIcon: null,
                              focusNode: null,
                              onSubmitted: (value) {},
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                            )
                          ),
                          // Spacer(),
                        ],
                      ),
                    )
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(
                            8 * imageSizeMultiplier),
                        bottomLeft: Radius.circular(
                            8 * imageSizeMultiplier),
                      ),
                      color: Color(0xff323030),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 2 * heightMultiplier,
                          horizontal: 7 * widthMultiplier),
                      child: CustomButton(
                        height: 0,
                        minWidth: 0,
                        child: TextButton(
                          onPressed: () {
                            List product_options = [];
                            bool proceed = true;
                            double price = 0;
                            _selected[count]
                                .asMap()
                                .forEach((index, selected) {
                              if (proceed) {
                                if (_productOptions[index]
                                        ['productOptSelection'] ==
                                    'single') {
                                  //pag required tapos walang pinili
                                  if (_productOptions[index]
                                              ['productOptType'] ==
                                          'required' &&
                                      selected <= -1) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(new SnackBar(
                                      content: CustomText(
                                        align: TextAlign.left,
                                        text: '${_productOptions[index]['productOptName']} Selection is Required!',
                                        color: Colors.white,
                                        size: 1.8,
                                        weight: FontWeight.normal,
                                      ),
                                      duration: Duration(
                                          seconds: 2, milliseconds: 155),
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                    proceed = false;
                                    return;
                                  }
                                  //pag may pinili
                                  else if (selected > -1) {
                                    proceed = true;
                                    product_options.add({
                                      'id': _productOptions[index]
                                          ['productOptId'],
                                      'name': _productOptions[index]
                                          ['productOptName'],
                                      'selection': _productOptions[index]
                                          ['productOptSelection'],
                                      'type': _productOptions[index]
                                          ['productOptType'],
                                      'product_option_items': [
                                        {
                                          'id': _productOptions[index][
                                                      'productOptionItem']
                                                  [selected]
                                              ['productOptItmId'],
                                          'name': _productOptions[index][
                                                      'productOptionItem']
                                                  [selected]
                                              ['productOptItmName'],
                                        }
                                      ]
                                    });
                                    price += double.parse(_productOptions[index]
                                            ['productOptionItem']
                                        [selected]['productOptItmPrice'].toString());
                                  }
                                  //pag walang pinili pero d naman sya required
                                  else {
                                    proceed = true;
                                  }
                                }
                                if (_productOptions[index]
                                        ['productOptSelection'] ==
                                    'multiple') {
                                  //pag required tapos walang pinili
                                  if (_productOptions[index]
                                              ['productOptType'] ==
                                          'required' &&
                                      selected.length == 0) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(new SnackBar(
                                      content: CustomText(
                                        align: TextAlign.left,
                                        text: '${_productOptions[index]['productOptName']} Selection is Required!',
                                        color: Colors.white,
                                        size: 1.8,
                                        weight: FontWeight.normal,
                                      ),
                                      duration: Duration(
                                          seconds: 2, milliseconds: 155),
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                    proceed = false;
                                    return;
                                  }
                                  //pag may pinili
                                  else if (selected.length > 0) {
                                    proceed = true;
                                    List product_option_items = [];
                                    selected.forEach((id) {
                                      product_option_items.add({
                                        'id': _productOptions[index]
                                                ['productOptionItem'][id]
                                            ['productOptItmId'],
                                        'name': _productOptions[index]
                                                ['productOptionItem'][id]
                                            ['productOptItmName']
                                      });
                                      price += double.parse(_productOptions[index]
                                              ['productOptionItem'][id]
                                          ['productOptItmPrice'].toString());
                                    });
                                    product_options.add({
                                      'id': _productOptions[index]
                                          ['productOptId'],
                                      'name': _productOptions[index]
                                          ['productOptName'],
                                      'selection': _productOptions[index]
                                          ['productOptSelection'],
                                      'type': _productOptions[index]
                                          ['productOptType'],
                                      'product_option_items':
                                          product_option_items
                                    });
                                  }
                                  //pag walang pinili pero d naman sya required
                                  else {
                                    proceed = true;
                                  }
                                }
                              }
                            });
                            if (proceed) {
                              _addToCart(
                                _variants[count]['variantName'],
                                _variants[count]['variantId'],
                                int.parse(_productController.text),
                                _noteController.text,
                                product_options,
                                (price +
                                        double.parse(_variants[count]
                                            ['variantPrice'].toString())) *
                                    int.parse(_productController.text),
                              );
                            }
                          },
                          // color: Color(0xffE44D36),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(
                          //       10 * imageSizeMultiplier),
                          // ),
                          child: CustomText(
                            text: 'ADD TO CART',
                            align: TextAlign.center,
                            size: 2,
                            color: Colors.white,
                            weight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              )
            )
          )
        );
      },
    );
  }
  
  _addToCart(String variantName, int variantId, int quantity, String note,
      List productOptions, double price) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var cart = {};
    if (sharedPreferences.getString('cart') != null &&
        sharedPreferences.get('cart') != 'null') {
      cart = json.decode(sharedPreferences.getString('cart'));
      if (cart['restaurants']['restaurant_id'] !=
          widget.restaurantDetails['id']) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'The Cart has already have an order. It will Ovewrite, Proceed?',
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          ),
        ));
        return;
      } else {
        bool samecart = false;
        cart['order_request_products'].forEach((cart) {
          var newcart = {
            'product_name': widget.details['productName'],
            'variant_id': variantId,
            'name': variantName,
            'note': note,
            'product_options': productOptions
          };
          var oldcart = {
            'product_name': cart['product_name'],
            'variant_id': cart['variant_id'],
            'name': cart['name'],
            'note': cart['note'],
            'product_options': cart['product_options']
          };
          if (oldcart.toString() == newcart.toString()) {
            samecart = true;
            cart['quantity'] =
                int.parse(cart['quantity'].toString()) + quantity;
          }
        });
        if (!samecart) {
          cart['order_request_products'].add({
            'price': price,
            'image': widget.details['banner'],
            'product_name': widget.details['productName'],
            'variant_id': variantId,
            'name': variantName,
            'quantity': quantity,
            'note': note,
            'product_options': productOptions,
          });
        }

        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'Added to cart',
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          ),
        ));

        sharedPreferences.setString('cart', json.encode(cart));
        log(sharedPreferences.getString('cart'));
      }
    } else {
      cart = {
        'restaurants': {
          'restaurant_id': widget.restaurantDetails['id'],
          'conciergePercentage':
              widget.restaurantDetails['concierge_percentage'],
          'markupPercentage': widget.restaurantDetails['markup_percentage'],
        },
        'order_request_products': [
          {
            'price': price,
            'image': widget.details['banner'],
            'product_name': widget.details['productName'],
            'variant_id': variantId,
            'name': variantName,
            'quantity': quantity,
            'note': note,
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
          size: 1.6,
          weight: FontWeight.normal,
        ),
      ));

      sharedPreferences.setString('cart', json.encode(cart));
      log(sharedPreferences.getString('cart'));
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
          preferredSize: Size.fromHeight(32 * heightMultiplier),
          child: Column(
            children: [
              AppBar(
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
              Container(
                alignment: Alignment.topCenter,
                height: 24 * heightMultiplier,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0)
                  ),
                  color: Color(0xffeb4d4d),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 50 * widthMultiplier,
                      height: 16 * heightMultiplier,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4 * imageSizeMultiplier),
                        color: Color(0xffe8971d),
                      ),
                      // Insert Hero() with tag :'_orderLogo${_products[index]['productId']}
                      child: Hero(
                        tag: '_orderLogo${widget.index}${widget.details['variantID']}',
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4 * imageSizeMultiplier)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4 * imageSizeMultiplier),
                                child: Image.network(
                                  widget.details['banner'],
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Spacer(),
                                Container(
                                  alignment: Alignment.center,
                                  height: 3 * heightMultiplier,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Color(0xff484545),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(4 * imageSizeMultiplier),
                                      bottomRight: Radius.circular(4 * imageSizeMultiplier),
                                    ),
                                  ),
                                  //Product Description
                                  child: CustomText(
                                    // 'Chicken Meal with Regular Coke',
                                    text: widget.details['productName'],
                                    align: TextAlign.center,
                                    size: 2,
                                    weight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ]
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          // 'Chicken Meal with Regular Coke',
                          text: widget.details['productDescription'],
                          align: TextAlign.center,
                          size: 1.8,
                          weight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      )
                    )
                  ],
                ),
              ),
            ]
          )
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
          child: SmartRefresher(
            enablePullDown: !_loading,
            onRefresh: () {
              _getVariants();
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
            child: 
            _variants.length == 0?
            Center(
              child: CustomText(
                align: TextAlign.left,
                text: 'No products available',
                color: Colors.black,
                size: 1.8,
                weight: FontWeight.normal,
              )
            )
            :
            ListView.builder(
              shrinkWrap: true,
              itemCount: _variants.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1 * imageSizeMultiplier,
                  child: ListTile(
                    leading: _variants[index]['variantBanner'] != null? 
                    CachedNetworkImage(
                      imageUrl: _variants[index]['variantBanner'],
                      width: 20 * imageSizeMultiplier,
                      fit: BoxFit.fill,
                    )
                    : 
                    CustomText(
                      align: TextAlign.left,
                      text: 'No Image Loaded',
                      color: Colors.black,
                      size: 1.8,
                      weight: FontWeight.normal,
                    ),
                    title: CustomText(
                      text: _variants[index]['variantName'],
                      color: Colors.black,
                      size: 1.8,
                      weight: FontWeight.normal,
                      align: TextAlign.center
                    ),
                    subtitle: CustomText(
                      text: _variants[index]['variantDescription'],
                      color: Colors.black,
                      size: 1.8,
                      weight: FontWeight.normal,
                      align: TextAlign.center,
                    ),
                    trailing: CustomText(
                      align: TextAlign.left,
                      text: '₱ ${_variants[index]['variantPrice'].toString()}.00',
                      color: Colors.black,
                      size: 1.8,
                      weight: FontWeight.normal,
                    ),
                    onTap: () {
                      _variantDialog(index);
                    },
                  ),
                );
              },
            )
          ),
        )
      )
    );
  }
}

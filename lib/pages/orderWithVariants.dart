import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OrderWithVariants extends StatefulWidget {
  Map<String, dynamic> details;
  Map<String, dynamic> restaurantDetails;
  int index;
  OrderWithVariants(
      {Key key,
      @required this.details,
      @required this.restaurantDetails,
      @required this.index})
      : super(key: key);
  @override
  _OrderWithVariantsState createState() => _OrderWithVariantsState();
}

class _OrderWithVariantsState extends State<OrderWithVariants> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
    print('products/${widget.details['productId']}');
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
        Map<String, dynamic> product = json.decode(response.body)['product'];
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
          _variants = new List.from(variant);
          _loading = false;
        });
      }
    }
  }

  void initState() {
    log(widget.details.toString());

    //TODO: implement initstate
    super.initState();

    // _products = new List.from(widget.details['products']);
    // if (_product.isNotEmpty) {

    // }
    _variants = new List.from(widget.details['productVariants']);
    if (_variants.isNotEmpty) {
      _variants.forEach((variant) {
        variant['quantity'] = 0;
        _selected.add([]);
        _controllers.add([]);
        // _productControllers.add([]);
      });
    }
  }

  // _variant(int index) async {
  //   setState(
  //     () {
  //       _productOption = new List.from(_variants[index]['variantOption']);
  //     },
  //   );
  // }

// List<String> variation
  _variantDialog(int count) {
    TextEditingController _noteController = TextEditingController();
    TextEditingController _productController = TextEditingController();
    _productController.text = '1';

    setState(() {
      _selected[count].clear();
      // _products = new List.from(_categories[count]['products']);
      _productOptions = new List.from(_variants[count]['vairantOption']);
      _productOptItems =
          new List.from(_productOptions[count]['productOptionItem']);
      // _productOptItems[count]['productOptItmPrice'] =
      // if (_productControllers.isEmpty) {
      //   _productOptions.forEach((option) {
      //     TextEditingController _productController = TextEditingController();
      //     _productControllers.add(_productController);
      //   });
      // }

      if (_selected[count].isEmpty) {
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
                      Radius.circular(8 * Config.imageSizeMultiplier),
                    ),
                  ),
                  content: Container(
                    height: 460.0,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3 * Config.widthMultiplier),
                              child: Text(
                                _variants[count]['variantName'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 3 * Config.textMultiplier,
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2 * Config.widthMultiplier),
                              child: Text(
                                '₱ ${_variants[count]['variantPrice'].toString()}.00',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 2 * Config.textMultiplier,
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2 * Config.heightMultiplier),
                              child: Container(
                                height: 10 * Config.heightMultiplier,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 1 * Config.heightMultiplier,
                                      ),
                                      child: Container(
                                        width: 55,
                                        height: 20,
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
                                          left: 1 * Config.widthMultiplier),
                                      child: Container(
                                        width: 25,
                                        height: 15,
                                        child: TextFormField(
                                          controller: _productController,
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
                                    Container(
                                      height: 20,
                                      width: 55,
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10 * Config.heightMultiplier,
                          color: Colors.grey[350],
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
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _productOptions.length,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  Container(
                                    //  color: Color(0xffFF6347),
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 1 * Config.heightMultiplier),
                                      child: Column(
                                        children: [
                                          if (_productOptions[index]
                                                  ['productOptionItem']
                                              .isNotEmpty)
                                            Divider(
                                              height: 0,
                                              color: Colors.red,
                                            ),
                                          if (_productOptions[index]
                                                  ['productOptionItem']
                                              .isNotEmpty)
                                            Text(
                                              'Select ${_productOptions[index]['productOptName']}${_productOptions[index]['productOptSelection'] == 'single' ? '' : '(s)'}',
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 3.2 *
                                                      Config.textMultiplier,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          if (_productOptions[index]
                                                  ['productOptSelection'] ==
                                              'single')
                                            Container(
                                              child: ListView.builder(
                                                // physics: ScrollPhysics(),
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
                                                      value: _productOptions[
                                                                          index]
                                                                      [
                                                                      'productOptionItem']
                                                                  [itemindex][
                                                              'productOptItmId'] +
                                                          itemindex,
                                                      groupValue:
                                                          _selected[count]
                                                              [index],
                                                      title: Text(_productOptions[
                                                                      index][
                                                                  'productOptionItem']
                                                              [itemindex][
                                                          'productOptItmName']),
                                                      secondary: Text(
                                                          '₱ ${_productOptions[index]['productOptionItem'][itemindex]['productOptItmPrice'].toString()}.00'),
                                                      onChanged:
                                                          (valuechanged) {
                                                        setstate(
                                                          () {
                                                            _selected[count]
                                                                    [index] =
                                                                valuechanged;
                                                          },
                                                        );
                                                        setState(
                                                          () {
                                                            _selected[count]
                                                                    [index] =
                                                                valuechanged;
                                                          },
                                                        );
                                                      },
                                                    )),
                                                    Container(
                                                      height: 11 *
                                                          Config
                                                              .heightMultiplier,
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: 1 *
                                                                Config
                                                                    .heightMultiplier,
                                                            horizontal: 1 *
                                                                Config
                                                                    .widthMultiplier),
                                                        child: Center(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom: 1 *
                                                                      Config
                                                                          .heightMultiplier,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: 55,
                                                                  height: 20,
                                                                  child:
                                                                      MaterialButton(
                                                                    minWidth:
                                                                        2.0,
                                                                    child: Icon(
                                                                        Icons
                                                                            .arrow_drop_up),
                                                                    onPressed:
                                                                        () {
                                                                      int _priceValue =
                                                                          int.parse(
                                                                              _productOptions[index]['productOptionItem'][itemindex]['productOptItmPrice'].toString());
                                                                      int currentValue =
                                                                          int.parse(
                                                                              _controllers[count][index][itemindex].text);
                                                                      // if (currentValue ==
                                                                      //     0) {
                                                                      //   _productOptions[index]['productOptionItem']
                                                                      //       [
                                                                      //       itemindex] = _productOptions[index]
                                                                      //           ['productOptionItem']
                                                                      //       [
                                                                      //       itemindex];
                                                                      // }
                                                                      setState(
                                                                          () {
                                                                        _priceValue =
                                                                            _priceValue +
                                                                                _priceValue;
                                                                        currentValue++;
                                                                        _productOptions[index]['productOptionItem'][itemindex]['productOptItmPrice'] =
                                                                            (_priceValue).toString();
                                                                        _controllers[count][index][itemindex].text =
                                                                            (currentValue).toString(); // incrementing value
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: 1 *
                                                                        Config
                                                                            .widthMultiplier),
                                                                child:
                                                                    Container(
                                                                  width: 25,
                                                                  height: 15,
                                                                  child:
                                                                      TextFormField(
                                                                    controller: _controllers[count]
                                                                            [
                                                                            index]
                                                                        [
                                                                        itemindex],
                                                                    keyboardType: TextInputType.numberWithOptions(
                                                                        decimal:
                                                                            false,
                                                                        signed:
                                                                            false),
                                                                    inputFormatters: <
                                                                        TextInputFormatter>[
                                                                      WhitelistingTextInputFormatter
                                                                          .digitsOnly
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 20,
                                                                width: 55,
                                                                child:
                                                                    MaterialButton(
                                                                  minWidth: 2.0,
                                                                  child: Icon(Icons
                                                                      .arrow_drop_down),
                                                                  onPressed:
                                                                      () {
                                                                    int _priceValue =
                                                                        int.parse(
                                                                            _productOptions[index]['productOptionItem'][itemindex]['productOptItmPrice'].toString());
                                                                    int currentValue =
                                                                        int.parse(
                                                                            _controllers[count][index][itemindex].text);
                                                                    setState(
                                                                      () {
                                                                        _priceValue =
                                                                            _priceValue -
                                                                                _priceValue;
                                                                        currentValue--;
                                                                        _productOptions[index]['productOptionItem'][itemindex]['productOptItmPrice'] =
                                                                            (_priceValue).toString();
                                                                        _controllers[count][index][itemindex].text =
                                                                            (currentValue).toString(); // decrementing value
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          else
                                            ListView.builder(
                                              // physics: ScrollPhysics(),
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
                                                title: Text(_productOptions[
                                                                index][
                                                            'productOptionItem']
                                                        [itemindex]
                                                    ['productOptItmName']),
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
                                          // if (_productOptions[index]
                                          //         ['productOptType'] ==
                                          //     'required')
                                          //   if (_productOptions[index]
                                          //           ['productOptName'] ==
                                          //       'Add-ons')
                                          //     ListView.builder()
                                          //   else
                                          //     Text(
                                          //         'This Product Has no Add-ons'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(
                                  8 * Config.imageSizeMultiplier),
                              bottomLeft: Radius.circular(
                                  8 * Config.imageSizeMultiplier),
                            ),
                            color: Color(0xff323030),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 2 * Config.heightMultiplier,
                                horizontal: 7 * Config.widthMultiplier),
                            child: ButtonTheme(
                              height: 5 * Config.heightMultiplier,
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4 * Config.widthMultiplier),
                                onPressed: () {
                                  List product_options = [];
                                  bool proceed = false;
                                  _selected[count]
                                      .asMap()
                                      .forEach((index, selected) {
                                    if (_productOptions[index]
                                            ['productOptSelection'] ==
                                        'single') {
                                      if (_productOptions[index]
                                              ['productOptType'] ==
                                          'required') {
                                        if (selected.runtimeType.toString() ==
                                            "int") {
                                          if (selected <= -1) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(new SnackBar(
                                              content: Text(
                                                  'Single Selection is Required!'),
                                              duration: Duration(
                                                  seconds: 2,
                                                  milliseconds: 155),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                            proceed = !proceed;
                                          } else {
                                            proceed = true;
                                            product_options.add({
                                              'id': _productOptions[
                                                      _selected[index]
                                                          .indexOf(selected)]
                                                  ['productOptId'],
                                              'name': _productOptions[
                                                      _selected[index]
                                                          .indexOf(selected)]
                                                  ['productOptName'],
                                              'product_option_items': [
                                                {
                                                  'id': _productOptItems[
                                                          _selected[index]
                                                              .indexOf(
                                                                  selected)]
                                                      ['productOptItmId'],
                                                  'name': _productOptItems[
                                                          _selected[index]
                                                              .indexOf(
                                                                  selected)]
                                                      ['productOptItmName'],
                                                }
                                              ]
                                            });
                                          }
                                        }
                                      } else {
                                        proceed = true;
                                        product_options.add({
                                          'id': _productOptions[_selected[count]
                                                  .indexOf(selected)]
                                              ['productOptId'],
                                          'name': _productOptions[
                                                  _selected[count]
                                                      .indexOf(selected)]
                                              ['productOptName'],
                                          'product_option_items': [
                                            {
                                              'id': _productOptItems[
                                                      _selected[count]
                                                          .indexOf(selected)]
                                                  ['productOptItmId'],
                                              'name': _productOptItems[
                                                      _selected[count]
                                                          .indexOf(selected)]
                                                  ['productOptItmName'],
                                            }
                                          ]
                                        });
                                      }
                                    }
                                    if (_productOptions[index]
                                            ['productOptSelection'] ==
                                        'multiple') {
                                      if (_productOptions[index]
                                              ['productOptType'] ==
                                          'required') {
                                        if (selected.runtimeType.toString() ==
                                            "List<dynamic>") {
                                          if (selected.length == 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(new SnackBar(
                                              content: Text(
                                                  'Multi Selection is Required!'),
                                              duration: Duration(
                                                  seconds: 2,
                                                  milliseconds: 155),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                            proceed = !proceed;
                                          } else {
                                            proceed = true;
                                            List product_option_items = [];
                                            selected.forEach((id) {
                                              product_option_items.add({
                                                'id': _productOptItems[
                                                        _selected[count]
                                                            .indexOf(selected)]
                                                    ['productOptItmId'],
                                                'name': _productOptItems[
                                                        _selected[count]
                                                            .indexOf(selected)]
                                                    ['productOptItmName']
                                              });
                                            });
                                            product_options.add({
                                              'id': _productOptions[
                                                      _selected[count]
                                                          .indexOf(selected)]
                                                  ['productOptId'],
                                              'name': _productOptions[
                                                      _selected[count]
                                                          .indexOf(selected)]
                                                  ['productOptName'],
                                              'product_option_items':
                                                  product_option_items
                                            });
                                          }
                                        }
                                      } else {
                                        proceed = true;
                                        List product_option_items = [];
                                        selected.forEach((id) {
                                          product_option_items.add({
                                            'id': _productOptItems[
                                                    _selected[count]
                                                        .indexOf(selected)]
                                                ['productOptItmId'],
                                            'name': _productOptItems[
                                                    _selected[count]
                                                        .indexOf(selected)]
                                                ['productOptItmName']
                                          });
                                        });
                                        product_options.add({
                                          'id': _productOptions[_selected[count]
                                                  .indexOf(selected)]
                                              ['productOptId'],
                                          'name': _productOptions[
                                                  _selected[count]
                                                      .indexOf(selected)]
                                              ['productOptName'],
                                          'product_option_items':
                                              product_option_items
                                        });
                                      }
                                    }
                                  });
                                  if (proceed) {
                                    _addToCart(
                                        _variants[count]['variantName'],
                                        _variants[count]['variantId'],
                                        int.parse(_productController.text),
                                        _noteController.text,
                                        product_options);
                                  }
                                },
                                color: Color(0xffE44D36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10 * Config.imageSizeMultiplier),
                                ),
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      'ADD TO CART',
                                      textAlign: TextAlign.center,
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 2.8 * Config.textMultiplier,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
      },
    );
  }
  //     'restaurant_id' => 'required|exists:restaurants,id',
//     'longitude' => 'required|string',            -> customer's
//     'latitude' => 'required|string',             -> customer's
//     'distance' => 'required|numeric',            -> later na sa cart
//     'customers_note' => 'nullable|string',       -> later na sa cart
//     'booking_time' => null,                      -> later na sa cart
//     'sub_total' => null,                         -> later na sa cart
//     'discounted_sub_total' => null,              -> later na sa cart
//     'concierge_fee' => null,                     -> later na sa cart
//     'grand_total' => null,                       -> later na sa cart
//     'markup' => 0,                               -> later na sa cart
//     'address' => null,                           -> customer's address

// /** Order Request Product Model */
// // Product
// 'order_request_products' => 'required|array|min:1',
// 'order_request_products.*.variant_id' => 'required|exists:products,id',
// 'order_request_products.*.quantity' => 'required|numeric|min:1',
// 'order_request_products.*.note' => 'nullable|string',
// 'order_request_products.*.product_options' => 'sometimes|array',
// 'order_request_products.*.product_options.*.id' => 'required|exists:product_options,id',
// 'order_request_products.*.product_options.*.product_option_items' => 'required|array',
// 'order_request_products.*.product_options.*.product_option_items.*' => 'required|exists:product_option_items,id',

  // _checkCartCount() async {
  //   int count = 0;
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.getString('cart') != null) {
  //     Map<String, dynamic> cart =
  //         json.decode(sharedPreferences.getString('cart'));
  //     if (cart['id'] == widget.restaurantDetails) {
  //       List<dynamic> items = cart['items'];
  //       items.forEach((element) {
  //         count += element['quantity'];
  //       });
  //     }
  //   }
  //   setState(() {
  //     _cartQuantity = count;
  //   });
  // }

  _addToCart(String variantName, int variantId, int quantity, String note,
      List productOptions) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var cart = {};
    if (sharedPreferences.getString('cart') != null &&
        sharedPreferences.get('cart') != 'null') {
      cart = json.decode(sharedPreferences.getString('cart'));
      if (cart['restaurant_id'] != widget.restaurantDetails['id']) {
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            'The Cart has already have an order. It will Ovewrite, Proceed?',
            textScaleFactor: .8,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
        );
        return;
      } else {
        cart['order_request_products'].add({
          'product_name': widget.details['productName'],
          'variant_id': variantId,
          'name': variantName,
          'quantity': quantity,
          'note': note,
          'product_options': productOptions
        });
        await sharedPreferences.setString('cart', json.encode(cart));
      }
    } else {
      cart = {
        'restaurant_id': widget.restaurantDetails['id'],
        'order_request_products': [
          {
            'product_name': widget.details['productName'],
            'variant_id': variantId,
            'name': variantName,
            'quantity': quantity,
            'note': note,
            'product_options': productOptions
          }
        ]
      };

      await sharedPreferences.setString('cart', json.encode(cart));
    }
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
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xffe8971d),
                        ),
                        // Insert Hero() with tag :'_orderLogo${_products[index]['productId']}
                        child: Hero(
                          tag:
                              '_orderLogo${widget.index}${widget.details['variantID']}',
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.green,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    widget.details['banner'],
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fill,
                                  ),
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
              Container(
                  child: Expanded(
                child: SmartRefresher(
                    enablePullDown: !_loading,
                    onRefresh: () {
                      setState(() {
                        _variants.clear();
                        _loading = true;
                      });
                      _getVariants();
                    },
                    physics: BouncingScrollPhysics(),
                    header: WaterDropMaterialHeader(
                      backgroundColor: Config.appColor,
                      color: Colors.white,
                      distance: 4 * Config.heightMultiplier,
                    ),
                    controller: _refreshController,
                    child: _variants.length == 0
                        ? Center(child: Text('No products available'))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _variants.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 40.0,
                                child: ListTile(
                                  leading: _variants[index]['variantBanner'] !=
                                          null
                                      ? CachedNetworkImage(
                                          imageUrl: _variants[index]
                                              ['variantBanner'],
                                          width:
                                              20 * Config.imageSizeMultiplier,
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
                                      '₱ ${_variants[index]['variantPrice'].toString()}.00'),
                                  onTap: () {
                                    _variantDialog(index);
                                  },
                                ),
                              );
                            },
                          )),
              ))
            ],
          ),
        ],
      ),
    );
  }
}

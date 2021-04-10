import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:http/http.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OrderWithVariants extends StatefulWidget {
  Map<String, dynamic> details;
  int index;
  OrderWithVariants({Key key, @required this.details, @required this.index})
      : super(key: key);
  @override
  _OrderWithVariantsState createState() => _OrderWithVariantsState();
}

class _OrderWithVariantsState extends State<OrderWithVariants> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List _variants = [];
  List _productOptions = [];
  List _selected = [];
  TextEditingController _controller = TextEditingController();
  void initState() {
    //TODO: implement initstate
    super.initState();

    _variants = new List.from(widget.details['productVariants']);
    if (_variants.isNotEmpty) {
      _variants.forEach((variant) {
        variant['quantity'] = 0;
        _selected.add([]);
      });
    }
  }

  // _variant(int index) async {
  //   setState(
  //     () {
  //       _productOption = new List.from(_variants[index]['variantOption']);
  //     },
  //   );
  //   print(_productOption);
  // }

// List<String> variation
  _variantDialog(int count) {
    print(count);
    setState(() {
      // _selected[count].clear();
      _productOptions = new List.from(_variants[count]['vairantOption']);
      if (_selected[count].isEmpty) {
        _productOptions.forEach((option) {
          if (option['productOptSelection'] == 'single')
            _selected[count].add(-1);
          else
            _selected[count].add([]);
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
                                          top: 2 * Config.heightMultiplier),
                                      child: Column(
                                        children: [
                                          // Insert here Quantity of the Item
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
                                            )
                                          else
                                            SizedBox(
                                              width: 0,
                                              height: 0,
                                            ),
                                          if (_productOptions[index]
                                                  ['productOptSelection'] ==
                                              'single')
                                            Container(
                                              child: ListView.builder(
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
                                                      onChanged:
                                                          (valuechanged) {
                                                        print(_selected[count]
                                                            [index]);
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
                                                    Expanded(
                                                      child: Container(
                                                        height: 10 *
                                                            Config
                                                                .heightMultiplier,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              vertical: 1 *
                                                                  Config
                                                                      .heightMultiplier,
                                                              horizontal: 3 *
                                                                  Config
                                                                      .widthMultiplier),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 50,
                                                                height: 20,
                                                                child:
                                                                    MaterialButton(
                                                                  minWidth: 2.0,
                                                                  child: Icon(Icons
                                                                      .arrow_drop_up),
                                                                  onPressed:
                                                                      () {
                                                                    int currentValue =
                                                                        int.parse(
                                                                            _controller.text);
                                                                    setState(
                                                                        () {
                                                                      currentValue++;
                                                                      _controller
                                                                              .text =
                                                                          (currentValue)
                                                                              .toString(); // incrementing value
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 30,
                                                                height: 15,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _controller,
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
                                                              Container(
                                                                height: 20,
                                                                width: 50,
                                                                child:
                                                                    MaterialButton(
                                                                  minWidth: 2.0,
                                                                  child: Icon(Icons
                                                                      .arrow_drop_down),
                                                                  onPressed:
                                                                      () {
                                                                    int currentValue =
                                                                        int.parse(
                                                                            _controller.text);
                                                                    setState(
                                                                      () {
                                                                        print(
                                                                            "Setting state");
                                                                        currentValue--;
                                                                        _controller.text =
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
                                                    setState(
                                                      () {
                                                        _selected[count][index]
                                                            .add(itemindex);
                                                      },
                                                    );
                                                  } else {
                                                    setstate(
                                                      () {
                                                        _selected[count][index]
                                                            .remove(itemindex);
                                                      },
                                                    );
                                                    setState(
                                                      () {
                                                        _selected[count][index]
                                                            .remove(itemindex);
                                                      },
                                                    );
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
                                onPressed: () {},
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
                          tag:
                              '_orderLogo${widget.index}${widget.details['variantID']}',
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: _variants.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 40.0,
                    child: ListTile(
                      leading: _variants[index]['variantBanner'] != null
                          ? CachedNetworkImage(
                              imageUrl: _variants[index]['variantBanner'],
                              width: 10 * Config.imageSizeMultiplier,
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
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

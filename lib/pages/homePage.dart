// import 'package:carousel_pro/carousel_pro.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/pages/login.dart';
import 'package:food_booking_app/pages/orderScreen.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:date_format/date_format.dart';

import 'dart:math' as math;

import '../defaults/config.dart';
import '../defaults/config.dart';
import '../defaults/http.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  RefreshController _refreshController =
      RefreshController(initialLoadStatus: LoadStatus.loading);
  TextEditingController _quantity = TextEditingController();
  TextEditingController _datedPick = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController = TextEditingController();
  String _hour, _minute, _time;
  String _setTime, _setDate;
  String dateTime;
  List _restaurants = [];
  String dropdownValue = '';
  DateTime pickDate;
  bool _loading = false;

  @override
  void initState() {
    _datedPick.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    // TODO: implement initState
    super.initState();

    pickDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEstablishments();
    });
  }

  _onTheGo(int index) {
    _quantity.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              // backgroundColor: Color(0xff747473),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(3 * Config.imageSizeMultiplier),
                ),
              ),
              content: Container(
                height: 35 * Config.widthMultiplier,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'No. of Person\'s',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 2.2 * Config.textMultiplier,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10 * Config.widthMultiplier),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10 * Config.widthMultiplier),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        controller: _quantity,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                          decimal: false,
                                          signed: true,
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 8 * Config.heightMultiplier,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width:
                                                    .2 * Config.widthMultiplier,
                                              ),
                                            ),
                                          ),
                                          child: InkWell(
                                            child: Icon(
                                              Icons.arrow_drop_up,
                                              size: 7.5 *
                                                  Config.imageSizeMultiplier,
                                            ),
                                            onTap: () {
                                              int currentValue =
                                                  int.parse(_quantity.text);
                                              setState(() {
                                                currentValue++;
                                                _quantity.text = (currentValue)
                                                    .toString(); // incrementing value
                                              });
                                            },
                                          ),
                                        ),
                                        InkWell(
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            size: 7.5 *
                                                Config.imageSizeMultiplier,
                                          ),
                                          onTap: () {
                                            int currentValue =
                                                int.parse(_quantity.text);
                                            setState(() {
                                              currentValue--;
                                              _quantity.text = (currentValue > 0
                                                      ? currentValue
                                                      : 0)
                                                  .toString(); // decrementing value
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10 * Config.widthMultiplier,
                          right: 10 * Config.widthMultiplier,
                        ),
                        child: ButtonTheme(
                          height: 5 * Config.heightMultiplier,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * Config.widthMultiplier),
                            onPressed: () {
                              // print(_restaurants[index]);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: OrderScreen(
                                    details: _restaurants[index],
                                  ),
                                ),
                              );
                            },
                            color: Color(0xffE44D36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10 * Config.imageSizeMultiplier),
                            ),
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Proceed",
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 2.2 * Config.textMultiplier,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: pickDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null)
      setState(() {
        pickDate = date;
        _datedPick.text = DateFormat.yMd().format(pickDate);
      });
  }

  _pickTime() async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  _booking(int index) {
    _quantity.clear();
    _timeController.clear();
    _datedPick.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // backgroundColor: Color(0xff747473),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * Config.imageSizeMultiplier),
              ),
            ),
            content: Container(
              height: 60 * Config.widthMultiplier,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'No. of Person\'s',
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 2.2 * Config.textMultiplier,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10 * Config.widthMultiplier),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10 * Config.widthMultiplier),
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8.0),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      controller: _quantity,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: false,
                                        signed: true,
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        WhitelistingTextInputFormatter
                                            .digitsOnly
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 8 * Config.heightMultiplier,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width:
                                                  .2 * Config.widthMultiplier,
                                            ),
                                          ),
                                        ),
                                        child: InkWell(
                                          child: Icon(
                                            Icons.arrow_drop_up,
                                            size: 7.5 *
                                                Config.imageSizeMultiplier,
                                          ),
                                          onTap: () {
                                            int currentValue =
                                                int.parse(_quantity.text);
                                            setState(() {
                                              currentValue++;
                                              _quantity.text = (currentValue)
                                                  .toString(); // incrementing value
                                            });
                                          },
                                        ),
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          size:
                                              7.5 * Config.imageSizeMultiplier,
                                        ),
                                        onTap: () {
                                          int currentValue =
                                              int.parse(_quantity.text);
                                          setState(() {
                                            currentValue--;
                                            _quantity.text = (currentValue > 0
                                                    ? currentValue
                                                    : 0)
                                                .toString(); // decrementing value
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Book Time',
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 2.2 * Config.textMultiplier,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      color: Colors.red,
                      height: 68,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Expanded(
                          Column(
                            children: <Widget>[
                              Text(
                                'Choose Date',
                                style: TextStyle(
                                    fontSize: 2.5 * Config.textMultiplier,
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2),
                                textScaleFactor: 1,
                              ),
                              InkWell(
                                onTap: () {
                                  _pickDate();
                                },
                                child: Container(
                                  width: 25 * Config.widthMultiplier,
                                  height: 3 * Config.heightMultiplier,
                                  margin: EdgeInsets.only(top: 1),
                                  alignment: Alignment.bottomCenter,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 2 * Config.textMultiplier),
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    controller: _datedPick,
                                    onSaved: (String val) {
                                      _setDate = val;
                                    },
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      // labelText: 'Date',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Choose Time',
                                style: TextStyle(
                                    fontSize: 2.5 * Config.textMultiplier,
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2),
                                textScaleFactor: 1,
                              ),
                              InkWell(
                                onTap: () {
                                  _pickTime();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 1),
                                  width: 25 * Config.widthMultiplier,
                                  height: 3 * Config.heightMultiplier,
                                  alignment: Alignment.center,
                                  decoration:
                                      BoxDecoration(color: Colors.grey[200]),
                                  child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 2 * Config.textMultiplier),
                                    textAlign: TextAlign.center,
                                    onSaved: (String val) {
                                      _setTime = val;
                                    },
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    controller: _timeController,
                                    decoration: InputDecoration(
                                      disabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      // labelText: 'Time',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10 * Config.widthMultiplier,
                          right: 10 * Config.widthMultiplier,
                          top: .5 * Config.heightMultiplier),
                      child: ButtonTheme(
                        height: 5 * Config.heightMultiplier,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4 * Config.widthMultiplier),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child:
                                    OrderScreen(details: _restaurants[index]),
                              ),
                            );
                          },
                          color: Color(0xffE44D36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10 * Config.imageSizeMultiplier),
                          ),
                          child: Container(
                            child: Center(
                              child: Text(
                                "Proceed",
                                textScaleFactor: 1,
                                style: TextStyle(
                                    fontSize: 2.2 * Config.textMultiplier,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _createAlertDialog(int index) {
    return showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(.6),
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            // backgroundColor: Color(0xff747473),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * Config.imageSizeMultiplier),
              ),
            ),
            content: Container(
              width: 70 * Config.widthMultiplier,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2 * Config.heightMultiplier,
                        horizontal: .5 * Config.widthMultiplier),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTheGo(index);
                      },
                      // color: Color(0xffD32F2F),
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xfff96167),
                        ),
                      ),
                      child: Text(
                        'On the Go',
                        style: TextStyle(
                          fontSize: 2.5 * Config.textMultiplier,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2 * Config.heightMultiplier,
                        horizontal: .5 * Config.widthMultiplier),
                    child: Text(
                      'OR',
                      style: TextStyle(
                          color: Color(0xffFF6347),
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                      textScaleFactor: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2 * Config.heightMultiplier,
                        horizontal: .5 * Config.widthMultiplier),
                    child: ElevatedButton(
                      onPressed: () {
                        _booking(index);
                      },
                      style: ButtonStyle(
                        shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(10),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xfff96167),
                        ),
                      ),
                      child: Text(
                        'Book',
                        style: TextStyle(
                            fontSize: 2.5 * Config.textMultiplier,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins'),
                        textScaleFactor: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getEstablishments() async {
    if (!_loading) Http().showLoadingOverlay(context);
    var response = await Http(url: 'restaurants', body: {}).getWithHeader();

    if (response is String) {
      if (!_loading) Navigator.pop(context);
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
        if (!_loading) Navigator.pop(context);
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
        Map<String, dynamic> body = json.decode(response.body);
        print(response.body);
        List<Map<String, dynamic>> restaurants = [];
        body['restaurant'].forEach((restaurant) {
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
            log(product.toString());
            categories.add({
              "categoriesID": category['id'],
              "categoriesName": category['name'],
              "products": product,
            });
          });
          restaurants.add({
            "id": restaurant['id'],
            "name": restaurant['name'],
            "opentime": restaurant['opening_time'],
            "closetime": restaurant['closing_time'],
            "latitude": restaurant['latitude'],
            "longitude": restaurant['longitude'],
            "address": restaurant['address'],
            "images": restaurant['image'],
            "max_persons_per_restaurant": 10,
            "productCategories": categories,
          });
        });
        if (!_loading) Navigator.pop(context);
        setState(() {
          _restaurants = new List.from(restaurants);
          _loading = false;
        });
      }
    }
  }

  _logout() async {
    SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
    _sharedPreference.clear();
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: LoginScreen(
              from: null,
            )),
        (route) => false);
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
          leading: FlatButton(
              onPressed: () {
                _logout();
              },
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(Icons.logout))),
        ),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: 100.0,
                width: double.infinity,
                child: CarouselSlider.builder(
                  itemCount: _restaurants.length,
                  options: CarouselOptions(
                    height: 150.0,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    autoPlay: true,
                  ),
                  itemBuilder:
                      (BuildContext context, int itemIndex, int index) =>
                          Image.network(_restaurants[itemIndex]['images']),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 6 * Config.heightMultiplier,
                    width: 80 * Config.widthMultiplier,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10 * Config.heightMultiplier),
                    padding: EdgeInsets.symmetric(
                        horizontal: 4 * Config.widthMultiplier),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(2 * Config.imageSizeMultiplier),
                      // border: Border.all(color: Colors.grey[800]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.4),
                          offset: Offset(0, 1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey[800]),
                          hintText: ('Search Restaurant'),
                          hintStyle: TextStyle(
                            color: Colors.grey[800],
                            fontFamily: 'Poppins',
                          ),
                        ).copyWith(isDense: true)),
                  ),
                ),
              )
            ],
          ),
          // Establishment Banner
          Padding(
            padding: EdgeInsets.only(
                top: 1 * Config.heightMultiplier,
                left: 8 * Config.widthMultiplier,
                right: 8 * Config.widthMultiplier),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Featured Restaurant',
                    style: TextStyle(
                        fontSize: 2 * Config.textMultiplier,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff707070)),
                    textScaleFactor: 1,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All Featured',
                      textScaleFactor: 1,
                      style: TextStyle(
                          fontSize: 1.2 * Config.textMultiplier,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          color: Color(0xff707070)),
                    ),
                  ),
                ]),
          ),
          // featured restaurant information
          Padding(
            padding: EdgeInsets.only(
              top: 2 * Config.heightMultiplier,
            ),
            child: Container(
              height: 18 * Config.heightMultiplier,
              width: double.infinity,
              child: CarouselSlider.builder(
                itemCount: _restaurants.length,
                options: CarouselOptions(
                    enlargeCenterPage: true, viewportFraction: .7),
                itemBuilder: (BuildContext context, int itemIndex, int index) =>
                    Image.network(_restaurants[itemIndex]['images']),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
                top: 1 * Config.heightMultiplier,
                left: 8 * Config.widthMultiplier,
                right: 8 * Config.widthMultiplier),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Nearby Restaurants',
                  style: TextStyle(
                      fontSize: 2 * Config.textMultiplier,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      color: Color(0xff707070)),
                  textScaleFactor: 1,
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All Nearby',
                    style: TextStyle(
                        fontSize: 1.2 * Config.textMultiplier,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        color: Color(0xff707070)),
                    textScaleFactor: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
              child: Expanded(
                  child: SmartRefresher(
                      enablePullDown: !_loading,
                      onRefresh: () {
                        setState(() {
                          _restaurants.clear();
                          _loading = true;
                        });
                        _getEstablishments();
                      },
                      physics: BouncingScrollPhysics(),
                      header: WaterDropMaterialHeader(
                        backgroundColor: Config.appColor,
                        color: Colors.white,
                        distance: 4 * Config.heightMultiplier,
                      ),
                      controller: _refreshController,
                      child: _restaurants.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: _restaurants.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1 * Config.heightMultiplier,
                                    horizontal: 4 * Config.widthMultiplier),
                                child: FlatButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    _createAlertDialog(index);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          2 * Config.imageSizeMultiplier)),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1 * Config.heightMultiplier,
                                        horizontal:
                                            0.4 * Config.widthMultiplier),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            Colors.orange.shade900,
                                            Colors.white60
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            2 * Config.imageSizeMultiplier)),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 2 *
                                                      Config.widthMultiplier),
                                              child: Image.network(
                                                _restaurants[index]['images'],
                                                fit: BoxFit.fill,
                                                width: 35 *
                                                    Config.imageSizeMultiplier,
                                                height: 10 *
                                                    Config.imageSizeMultiplier,
                                              ),
                                            ),
                                            // SizedBox(width: 27.0),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 1.8 *
                                                      Config.widthMultiplier),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    _restaurants[index]['name'],
                                                    style: TextStyle(
                                                      fontSize: 1.9 *
                                                          Config.textMultiplier,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.white,
                                                    ),
                                                    textScaleFactor: 1,
                                                  ),
                                                  Text(
                                                    '${_restaurants[index]['opentime']} - ${_restaurants[index]['closetime']}',
                                                    style: TextStyle(
                                                      fontSize: 1.4 *
                                                          Config.textMultiplier,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.white,
                                                    ),
                                                    textScaleFactor: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.5 *
                                                    Config.widthMultiplier),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                SmoothStarRating(
                                                  starCount: 5,
                                                  color: Colors.yellow,
                                                  borderColor: Colors.black,
                                                  defaultIconData:
                                                      Icons.star_border_rounded,
                                                  filledIconData:
                                                      Icons.star_rounded,
                                                  halfFilledIconData:
                                                      Icons.star_half_rounded,
                                                ),
                                                Text(
                                                  _restaurants[index]
                                                      ['address'],
                                                  style: TextStyle(
                                                    fontSize: 2 *
                                                        Config.textMultiplier,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.normal,
                                                    color: Colors.white,
                                                  ),
                                                  textScaleFactor: 1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                              'No restaurants to show',
                              textScaleFactor: 1,
                            )))))
        ],
      ),
    );
  }
}

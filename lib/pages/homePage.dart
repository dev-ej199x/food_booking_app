// import 'package:carousel_pro/carousel_pro.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:intl/intl.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:shimmer/shimmer.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  SharedPreferences _sharedPreferences;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  RefreshController _refreshController =
      RefreshController(initialLoadStatus: LoadStatus.loading);
  TextEditingController _quantity = TextEditingController(text: '1');
  TextEditingController _datedPick = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController = TextEditingController();
  String _hour, _minute, _time;
  String _setTime, _setDate;
  String dateTime;
  List _featuredRestaurants = [];
  List _nearbyRestaurants = [];
  List _restaurants = [];
  List _banners = [];
  String dropdownValue = '';
  DateTime pickDate;
  bool _loading = false;
  // AnimationController _animate1;
  // AnimationController _animate2;
  // AnimationController _animate3;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  _animate1 = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 100),
    // ); 
    // _animate2 = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 100),
    // ); 
    // _animate3 = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 100),
    // ); 
    // _animate1.forward();
    _datedPick.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    pickDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEstablishments();
    });
  }

  _searchRestaurants(String search) {
    _restaurants.forEach((restaurant) {
      if (restaurant['name']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        setState(() {
          _restaurants.add(restaurant);
        });
      }
    });
  }

  _onTheGoDialog(int index) {
    _quantity.text = '1';
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // backgroundColor: Color(0xff747473),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * imageSizeMultiplier),
              ),
            ),
            content: Container(
              height: 35 * widthMultiplier,
              child: Center(
                child: Column(
                  children: <Widget>[
                    CustomText(
                      align: TextAlign.left,
                      text: 'No. of Persons',
                      size: 1.6,
                      color: Colors.black,
                      weight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10 * widthMultiplier),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10 * widthMultiplier),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: _quantity,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: false,
                                        signed: true,
                                      ),
                                      enabled: true,
                                      obscureText: false,
                                      focusNode: null,
                                      onSubmitted: (value) {},
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 8 * heightMultiplier,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        child: Icon(
                                          Icons.arrow_drop_up,
                                          size: 8 * imageSizeMultiplier,
                                        ),
                                        onTap: () {
                                          int currentValue =
                                              int.parse(_quantity.text);
                                          if(currentValue+1<=int.parse(_restaurants[index]['max_persons_per_restaurant'].toString()))
                                          setState(() {
                                            currentValue++;
                                            _quantity.text = (currentValue)
                                                .toString(); // incrementing value
                                          });
                                        },
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          size: 8 * imageSizeMultiplier,
                                        ),
                                        onTap: () {
                                          int currentValue =
                                              int.parse(_quantity.text);
                                          if (currentValue > 1)
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
                        left: 10 * widthMultiplier,
                        right: 10 * widthMultiplier,
                      ),
                      child: ButtonTheme(
                        height: 5 * heightMultiplier,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4 * widthMultiplier),
                          onPressed: () {
                            _sharedPreferences.setString('cart', null);
                            try{
                              if (int.parse(_quantity.text)%1==0 && int.parse(_quantity.text)<=int.parse(_restaurants[index]['max_persons_per_restaurant'].toString())) {
                                Navigator.pop(context);
                                // print(_restaurants[index]);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: 
                                      OrderScreen(details: _restaurants[index], 
                                      specifics: {
                                        'type': 'otg',
                                        'people': int.parse(_quantity.text),
                                      }
                                    ),
                                  ),
                                );
                              }
                            }
                            catch(error) {}
                          },
                          color: Color(0xffE44D36),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10 * imageSizeMultiplier),
                          ),
                          child: Container(
                            child: Center(
                              child: CustomText(
                                align: TextAlign.left,
                                text: "Proceed",
                                size: 1.6,
                                color: Colors.white,
                                weight: FontWeight.bold,
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
      },
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
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

  _bookingDialog(int index) {
    _quantity.text = '1';
    _datedPick.text = DateFormat('MMMM dd, yyyy').format(DateTime.now().add(Duration(days: 1)));
    _timeController.text = DateFormat('HH:mm a').format(DateTime.now());
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // backgroundColor: Color(0xff747473),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * imageSizeMultiplier),
              ),
            ),
            content: Container(
              height: 60 * widthMultiplier,
              child: Center(
                child: Column(
                  children: <Widget>[
                    CustomText(
                      align: TextAlign.left,
                      text: 'No. of Person\'s',
                      size: 1.6,
                      color: Colors.black,
                      weight: FontWeight.bold
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10 * widthMultiplier),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10 * widthMultiplier),
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: _quantity,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                        decimal: false,
                                        signed: true,
                                      ),
                                      enabled: true,
                                      obscureText: false,
                                      focusNode: null,
                                      onSubmitted: (value) {},
                                      textInputAction: TextInputAction.done,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 8 * heightMultiplier,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      InkWell(
                                        child: Icon(
                                          Icons.arrow_drop_up,
                                          size: 8 * imageSizeMultiplier,
                                        ),
                                        onTap: () {
                                          int currentValue =
                                              int.parse(_quantity.text);
                                          if(currentValue+1<=int.parse(_restaurants[index]['max_persons_per_restaurant'].toString()))
                                          setState(() {
                                            currentValue++;
                                            _quantity.text = (currentValue)
                                                .toString(); // incrementing value
                                          });
                                        },
                                      ),
                                      InkWell(
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          size: 8 * imageSizeMultiplier,
                                        ),
                                        onTap: () {
                                          int currentValue =
                                              int.parse(_quantity.text);
                                          if (currentValue > 1)
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
                    CustomText(
                      align: TextAlign.left,
                      text: 'Book for date',
                      size: 1.8,
                      color: Colors.black,
                      weight: FontWeight.bold
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * widthMultiplier),
                            child: TextField(
                              onTap: () {
                                _pickDate();
                              },
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType:
                                  TextInputType.numberWithOptions(
                                decimal: false,
                                signed: true,
                              ),
                              readOnly: true,
                              enabled: true,
                              obscureText: false,
                              focusNode: null,
                              textInputAction: TextInputAction.done,
                              controller: _datedPick,
                              onSubmitted: (String val) {
                                _setDate = val;
                              },
                            )
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * widthMultiplier, vertical: 1 * heightMultiplier),
                            child: TextField(
                              onTap: () {
                                _pickTime();
                              },
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType:
                                  TextInputType.numberWithOptions(
                                decimal: false,
                                signed: true,
                              ),
                              readOnly: true,
                              enabled: true,
                              obscureText: false,
                              focusNode: null,
                              textInputAction: TextInputAction.done,
                              controller: _timeController,
                              onSubmitted: (String val) {
                                _setDate = val;
                              },
                            )
                          ),
                        ),
                      ]
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 10 * widthMultiplier,
                          right: 10 * widthMultiplier,
                          top: .5 * heightMultiplier),
                      child: ButtonTheme(
                        height: 5 * heightMultiplier,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4 * widthMultiplier),
                          onPressed: () {
                            _sharedPreferences.setString('cart', null);
                            print(_timeController.text);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child:
                                  OrderScreen(details: _restaurants[index], 
                                  specifics: {
                                    'type': 'booking',
                                    'people': int.parse(_quantity.text),
                                    'date': _datedPick.text,
                                    'time': _timeController.text
                                  }
                                ),
                              ),
                            );
                          },
                          color: Color(0xffE44D36),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10 * imageSizeMultiplier),
                          ),
                          child: Container(
                            child: Center(
                              child: CustomText(
                                  align: TextAlign.left,
                                  text: "Proceed",
                                  size: 1.6,
                                  color: Colors.white,
                                  weight: FontWeight.bold),
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

  _onTheGoorBooking(int index) {
    return showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(.6),
        builder: (context) {
          return AlertDialog(
            // backgroundColor: Colors.transparent,
            backgroundColor: Color(0xff484545),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3 * imageSizeMultiplier),
              ),
            ),
            content: Container(
              width: 70 * widthMultiplier,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2 * heightMultiplier,
                        horizontal: .5 * widthMultiplier),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _onTheGoDialog(index);
                      },
                      // color: Color(0xffD32F2F),
                      style: ButtonStyle(
                        // shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(2 * imageSizeMultiplier),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xfff96167),
                        ),
                      ),
                      child: CustomText(
                        align: TextAlign.left,
                        text: 'On the Go',
                        size: 2,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2 * heightMultiplier,
                        horizontal: .5 * widthMultiplier),
                    child: CustomText(
                      align: TextAlign.left,
                      text: 'OR',
                      color: Color(0xffFF6347),
                      size: 1.4,
                      weight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 2 * heightMultiplier,
                        horizontal: .5 * widthMultiplier),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _bookingDialog(index);
                      },
                      style: ButtonStyle(
                        // shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(2 * imageSizeMultiplier),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xfff96167),
                        ),
                      ),
                      child: CustomText(
                        align: TextAlign.left,
                        text: 'Book',
                        size: 2,
                        weight: FontWeight.bold,
                        color: Colors.white,
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
    _sharedPreferences = await SharedPreferences.getInstance();
    // if (!_loading) Http().showLoadingOverlay(context);
    var response = await Http(url: 'restaurants', body: {}).getWithHeader();

    if (response is String) {
      // if (!_loading) Navigator.pop(context);
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
        // if (!_loading) Navigator.pop(context);
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
        Map<String, dynamic> body = json.decode(response.body);
        setState(() {
          _restaurants.clear();
          _restaurants = new List.from(body['restaurant']);
          _refreshController.refreshCompleted();
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
    return WillPopScope(
      onWillPop: () {},
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(10 * heightMultiplier),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 4 * widthMultiplier, right: 4 * widthMultiplier, top: 2 * heightMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Hello,', 
                          color: Colors.black38, 
                          size: 1.8, 
                          weight: FontWeight.normal, 
                          align: TextAlign.center
                        ),
                        CustomText(
                          text: 'Username !', 
                          color: Colors.black, 
                          size: 2.2, 
                          weight: FontWeight.bold, 
                          align: TextAlign.center
                        )
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        print('a');
                      },
                      icon: Icon(
                        Icons.notifications_rounded,
                        color: appColor,
                        size: 6 * imageSizeMultiplier,
                      )
                    )
                  ]
                )
              ),
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
              _scaffoldKey.currentState.removeCurrentSnackBar();
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: !_loading,
                    onRefresh: () {
                      _getEstablishments();
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
                    child:  SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_restaurants.length > 0)
                          for (var restaurant in _restaurants)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1 * heightMultiplier,
                                horizontal: 4 * widthMultiplier),
                            child: CustomButton(
                              height: 0,
                              minWidth: 0,
                              child: TextButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2 * imageSizeMultiplier)
                                    ),
                                  ),
                                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  alignment: Alignment.center,
                                ),
                                onPressed: () {
                                  _onTheGoorBooking(_restaurants.indexOf(restaurant));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 26 * heightMultiplier,
                                      width: 100 * widthMultiplier,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(2 * imageSizeMultiplier),
                                        boxShadow: [
                                          BoxShadow(color: Color(0xFF707070).withOpacity(.5), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 2))
                                        ],
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: CachedNetworkImageProvider(
                                            restaurant['image'],
                                          ),
                                        )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              text: restaurant['name'], 
                                              color: Colors.black, 
                                              size: 1.8, 
                                              weight: FontWeight.bold, 
                                              align: TextAlign.left
                                            )
                                          ),
                                          SmoothStarRating(
                                            color: appColor,
                                            borderColor: appColor,
                                            filledIconData: Icons.star_rounded,
                                            halfFilledIconData: Icons.star_half_rounded,
                                            defaultIconData: Icons.star_outline_rounded,
                                            allowHalfRating: true,
                                            starCount: 5,
                                            size: 3 * imageSizeMultiplier,
                                            rating: restaurant['rating']??1.5,
                                            isReadOnly: true,
                                          )
                                        ]
                                      )
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CustomText(
                                          text: 'Open now', 
                                          color: appColor, 
                                          size: 1.2, 
                                          weight: FontWeight.normal, 
                                          align: TextAlign.left
                                        ),
                                        CustomText(
                                          text: '\t\t\t●\t\t\t', 
                                          color: appColor, 
                                          size: .6, 
                                          weight: FontWeight.normal, 
                                          align: TextAlign.left
                                        ),
                                        Expanded(
                                          child: CustomText(
                                            text: restaurant['address'], 
                                            color: Colors.black, 
                                            size: 1.2, 
                                            weight: FontWeight.normal, 
                                            align: TextAlign.left
                                          )
                                        ),
                                      ]
                                    )
                                  ]
                                )
                              )
                            )
                          )
                          else
                          Padding(
                            padding: EdgeInsets.only(top: 2 * heightMultiplier),
                            // alignment: Alignment.center,
                            child: CustomText(
                              align: TextAlign.left,
                              text: 'No restaurants to show',
                              color: Colors.black,
                              size: 1.8,
                              weight: FontWeight.normal,
                            ),
                          ),
                        ]
                      )
                    )
                  )
                )
              ],
            )
          )
        )
      )
    );
  }
}

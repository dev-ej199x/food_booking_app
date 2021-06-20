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
  List _restaurants = [];
  List _banners = [];
  String dropdownValue = '';
  DateTime pickDate;
  bool _loading = false;
  bool _loadedBanners = false;
  bool _loadedFeatured = false;
  bool _loadedAll = false;
  int _currentBannerIndex = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datedPick.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    pickDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEstablishments();
    });
  }

  _getEstablishments() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _getAdBanners();
    await _getFeaturedEstablishments();
    var response = await Http(url: 'restaurants', body: {}).getWithHeader();

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
          _loadedAll = true;
          _refreshController.refreshCompleted();
          _loading = false;
        });
      }
    }
  }

  _getFeaturedEstablishments() async {
    var response = await Http(url: 'featuredRestaurants', body: {}).getWithHeader();

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
          _featuredRestaurants.clear();
          _featuredRestaurants = new List.from(body['featuredRestaurant']);
          _loadedFeatured = true;
          _refreshController.refreshCompleted();
          _loading = false;
        });
      }
    }
  }

  _getAdBanners() async {
    var response = await Http(url: 'ad-banners', body: {}).getWithHeader();

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
          _banners.clear();
          _banners = new List.from(body['banners']);
          _loadedBanners = true;
          _refreshController.refreshCompleted();
          _loading = false;
        });
      }
    }
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

  _onTheGoorBooking(var restaurant) {
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
              width: 60 * widthMultiplier,
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
                        _onTheGoDialog(restaurant);
                      },
                      // color: Color(0xffD32F2F),
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                        // shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(2 * imageSizeMultiplier),
                        backgroundColor: MaterialStateProperty.all(
                          appColor,
                        ),
                      ),
                      child: CustomText(
                        align: TextAlign.left,
                        text: 'On the Go',
                        size: 2,
                        weight: FontWeight.normal,
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
                      color: appColor,
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
                        _bookingDialog(restaurant);
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                        // shadowColor: MaterialStateProperty.all(Colors.red),
                        elevation: MaterialStateProperty.all(2 * imageSizeMultiplier),
                        backgroundColor: MaterialStateProperty.all(
                          appColor,
                        ),
                      ),
                      child: CustomText(
                        align: TextAlign.left,
                        text: 'Booking',
                        size: 2,
                        weight: FontWeight.normal,
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
    );
  }

  _onTheGoDialog(var restaurant) {
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
              width: 60 * widthMultiplier,
              height: 16 * heightMultiplier,
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
                            print({'details': restaurant, 
                                  'specifics': {
                                    'type': 'otg',
                                    'people': int.parse(_quantity.text),
                                  }});
                            try{
                            _sharedPreferences.setString('cart', '');
                            Navigator.pop(context);
                            // print(_restaurants[index]);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: 
                                  OrderScreen(details: restaurant, 
                                  specifics: {
                                    'type': 'otg',
                                    'people': int.parse(_quantity.text),
                                  }
                                ),
                              ),
                            );
                            }
                            catch(e) {
                              print(e);
                            }
                          },
                          color: appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(2 * imageSizeMultiplier),
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
              )
            ),
          );
        });
      },
    );
  }

  _bookingDialog(var restaurant) {
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
              width: 60 * widthMultiplier,
              height: 26 * heightMultiplier,
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
                            print(_sharedPreferences.getString('token'));
                            _sharedPreferences.setString('cart', '');
                            print(_timeController.text);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child:
                                  OrderScreen(details: restaurant, 
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
                          color: appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(2 * imageSizeMultiplier),
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

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: appColor,
              accentColor: appColor,
              colorScheme: ColorScheme.light(primary: appColor),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
              ),
          ),
          child: child,
        );
      },
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
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: appColor,
              accentColor: appColor,
              colorScheme: ColorScheme.light(primary: appColor),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary
              ),
          ),
          child: child,
        );
      },
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
            preferredSize: Size.fromHeight(7 * heightMultiplier),
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
                          if (_loadedBanners)
                          if (_banners.length > 0)
                          Container(
                            padding: EdgeInsets.only(top: 2 * heightMultiplier),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Color(0xFF707070).withOpacity(.3), blurRadius: 0.6 * imageSizeMultiplier, offset: Offset(0, -0.6)),
                                BoxShadow(color: Color(0xFF707070).withOpacity(.5), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 2))
                              ],
                              color: Colors.white
                            ),
                            child: Column(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 20 * heightMultiplier,
                                    viewportFraction: 1,
                                    onPageChanged: (value, reason) {
                                      setState(() {
                                        _currentBannerIndex = value;
                                      });
                                    },
                                  ),
                                  items: _banners.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.amber
                                          ),
                                          child: Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: i['banner_image'],
                                                fit: BoxFit.cover,
                                                width: MediaQuery.of(context).size.width,
                                                placeholder: (context, string) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.black12,
                                                    highlightColor: Colors.black26,
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 2 * heightMultiplier),
                                                      height: 20 * heightMultiplier,
                                                      width: double.infinity, 
                                                      color: Color(0xFF363636),
                                                    ),
                                                  );
                                                },
                                                errorWidget: (context, string, _) {
                                                  return Container(
                                                    padding: EdgeInsets.only(top: 2 * heightMultiplier),
                                                    height: 20 * heightMultiplier,
                                                    width: double.infinity, 
                                                    color: Color(0xFF363636),
                                                  );
                                                },
                                              ),
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    for (int x = 0; x<_banners.length; x++)
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 0.5 * heightMultiplier, horizontal: 0.2 * widthMultiplier),
                                                      child: Icon(
                                                        Icons.circle,
                                                        color: _currentBannerIndex == x?Colors.black:Colors.grey,
                                                        size: 2 * imageSizeMultiplier
                                                      )
                                                    )
                                                  ],
                                                )
                                              )
                                            ]
                                          )
                                        );
                                      },
                                    );
                                  }).toList(),
                                )
                              ]
                            )
                          )
                          else
                          Container(),
                          if (_loadedFeatured)
                          if (_featuredRestaurants.length > 0)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: (_banners.length > 0 && _loadedBanners?2:0) * heightMultiplier),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Color(0xFF707070).withOpacity(.3), blurRadius: 0.6 * imageSizeMultiplier, offset: Offset(0, -0.6)),
                                BoxShadow(color: Color(0xFF707070).withOpacity(.5), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 2))
                              ],
                              color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                  left: 4 * widthMultiplier, right: 4 * widthMultiplier, top: 1 * heightMultiplier,),
                                  child: CustomText(
                                    text: 'Featured Restaurants', 
                                    color: Colors.black, 
                                    size: 1.6, 
                                    weight: FontWeight.normal, 
                                    align: TextAlign.left
                                  )
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                  bottom: 2 * widthMultiplier),
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (var featuredRestaurant in _featuredRestaurants)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 1 * heightMultiplier,
                                              bottom: 1 * heightMultiplier,
                                              left: (_featuredRestaurants.indexOf(featuredRestaurant) == 0?4:0) * widthMultiplier,
                                              right: (_featuredRestaurants.indexOf(featuredRestaurant) == _featuredRestaurants.length-1?0:4) * widthMultiplier),
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
                                                _onTheGoorBooking(featuredRestaurant['restaurant']);
                                              },
                                              child: Container(
                                                height: 18 * heightMultiplier,
                                                width: 28 * widthMultiplier,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 12 * heightMultiplier,
                                                      width: 28 * widthMultiplier,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(topRight: Radius.circular(1 * imageSizeMultiplier), topLeft: Radius.circular(1 * imageSizeMultiplier)),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: CachedNetworkImageProvider(
                                                            featuredRestaurant['image'],
                                                          ),
                                                        )
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 0.5 * heightMultiplier, horizontal: 2 * widthMultiplier),
                                                      child: CustomText(
                                                        text: '${featuredRestaurant['restaurant']['name']}', 
                                                        color: Colors.black, 
                                                        size: 1.2, 
                                                        weight: FontWeight.bold, 
                                                        align: TextAlign.left
                                                      )
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(bottom: 0.5 * heightMultiplier, left: 2 * widthMultiplier, right: 2 * widthMultiplier),
                                                      child: CustomText(
                                                        text: 'Open now', 
                                                        color: appColor, 
                                                        size: 1.2, 
                                                        weight: FontWeight.normal, 
                                                        align: TextAlign.left
                                                      ),
                                                    )
                                                  ]
                                                )
                                              )
                                            )
                                          )
                                        ),
                                      ]
                                    )
                                  )
                                )
                              ]
                            )
                          )
                          else
                          Container(),
                          if (_loadedAll)
                          if (_restaurants.length > 0)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: (((_banners.length > 0 && _loadedBanners) || (_featuredRestaurants.length > 0 && _loadedFeatured))?2:0) * heightMultiplier),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Color(0xFF707070).withOpacity(.3), blurRadius: 0.6 * imageSizeMultiplier, offset: Offset(0, -0.6)),
                                BoxShadow(color: Color(0xFF707070).withOpacity(.5), blurRadius: 1 * imageSizeMultiplier, offset: Offset(0, 2))
                              ],
                              color: Colors.white
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                  left: 4 * widthMultiplier, right: 4 * widthMultiplier, top: 1 * heightMultiplier,),
                                  child: CustomText(
                                    text: 'All Restaurants', 
                                    color: Colors.black, 
                                    size: 1.6, 
                                    weight: FontWeight.normal, 
                                    align: TextAlign.left
                                  )
                                ),
                                for (var restaurant in _restaurants)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1 * heightMultiplier,
                                      horizontal: 4 * widthMultiplier),
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
                                        _onTheGoorBooking(restaurant);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 26 * heightMultiplier,
                                            width: 100 * widthMultiplier,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(1 * imageSizeMultiplier), topLeft: Radius.circular(1 * imageSizeMultiplier)),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: CachedNetworkImageProvider(
                                                  restaurant['image'],
                                                ),
                                              )
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier, horizontal: 2 * widthMultiplier),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: CustomText(
                                                    text: '${restaurant['name']}', 
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
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 1 * heightMultiplier, left: 2 * widthMultiplier, right: 2 * widthMultiplier),
                                            child: Row(
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
                                          )
                                        ]
                                      )
                                    )
                                  )
                                )
                              ]
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
                          )
                          else
                          Container()
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

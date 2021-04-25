import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../defaults/config.dart';
import '../defaults/config.dart';
import '../defaults/http.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Position _currentPosition;
  String _currentAddress;
  SharedPreferences _sharedPreferences;

  bool _hidePassword = true;

  FocusNode _passwordFocus = FocusNode();
  FocusNode _retypePasswordFocus = FocusNode();
  FocusNode _firstNameFocus = FocusNode();
  FocusNode _numberFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();
  FocusNode _userNameFocus = FocusNode();

  TextEditingController _username = TextEditingController();

  TextEditingController _firstnameController = TextEditingController();

  TextEditingController _numberController = TextEditingController();

  TextEditingController _retypePasswordController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _addressController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    _configure();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: false)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
      print(_currentPosition);
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.street},${place.locality}, ${place.country}";
      });
      print(_currentAddress);
    } catch (e) {
      print(e);
    }
  }

  _configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  _check() async {
    Pattern pattern =
        r'^[a-zA-Z0-9]([._](?![._])|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$';
    RegExp regex = new RegExp(pattern);
    FocusScope.of(context).unfocus();
    if (_firstnameController.text.isEmpty ||
        _username.text.isEmpty ||
        _retypePasswordController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            'Fill all fields properly!',
            textScaleFactor: .8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
        ),
      );
      return;
    }
    if (_username.text.isNotEmpty && !regex.hasMatch(_username.text)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            'This Username is not valid ',
            textScaleFactor: .8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
        ),
      );
      return;
    }

    // _numberController.text.length  <= 11
    if (_username.text.length < 8 || _passwordController.text.length < 8) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            '${_username.text.length < 8 ? "Username" : "Password"} must be at least 8 characters',
            textScaleFactor: .8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
        ),
      );
      return;
    }
    _signUp();
  }

  _signUp() async {
    _getCurrentLocation();
    Http().showLoadingOverlay(context);
    var response = await Http(url: 'signup', body: {
      'username': _username.text,
      'password': _passwordController.text,
      'password_confirmation': _passwordController.text,
      'name': _firstnameController.text,
      'number': _numberController.text,
      'address': _currentAddress.toString(),
      'longitude': _currentPosition.longitude.toString(),
      'latitude': _currentPosition.latitude.toString(),
    }).postNoHeader();
    if (response is String) {
      Navigator.pop(context);
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
      Map<String, dynamic> body = json.decode(response.body);
      if (response.statusCode == 200) {
        _login();
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            'Done',
            textScaleFactor: .8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
        );
      } else {
        if (body.containsKey('errors')) {
          Navigator.pop(context);
          Map<String, dynamic> errors = body['errors'];
          errors.keys.forEach((e) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color(0xFF323232),
                content: Text(
                  body['errors'][e][0],
                  textScaleFactor: .8,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.2 * Config.textMultiplier,
                  ),
                ),
              ),
            );
            return;
          });
        }
      }
    }
  }

  _login() async {
    Http().showLoadingOverlay(context);
    var response = await Http(url: 'login', body: {
      'username': _username.text,
      'password': _passwordController.text
    }).postNoHeader();

    if (response is String) {
      Navigator.pop(context);
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
        Navigator.pop(context);
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
        if (body.containsKey('token')
            // && body['user']['role'] == 'CUSTOMER'
            ) {
          _sharedPreferences.setString('token', body['token']);
          _sharedPreferences.setInt(
            'id',
            int.parse(
              body['user']['id'].toString(),
            ),
          );
          _sharedPreferences.setString('username', body['user']['username']);
          _sharedPreferences.setString('role', body['user']['role']);
          // _sharedPreferences.setInt('role-id', body['user']['profile']['id']);
          // await FirebaseSettings().updateToken();
          Navigator.of(context).pop();
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: DashBoard(),
            ),
          );
        } else if (!body.containsKey('token') && body.containsKey('message')) {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: Text(
                body['message'],
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
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: Text(
                'Invalid Credentials',
                textScaleFactor: .8,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 2.2 * Config.textMultiplier,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 17 * Config.heightMultiplier),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.signUp),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x29000000),
                      offset: Offset(0, -5),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      color: Color(0xffeb4d4d),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 5 * Config.textMultiplier,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 1.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x29000000),
                                    offset: Offset(0, -5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 1 * Config.heightMultiplier),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
                                      child: Container(
                                        width: 100 * Config.widthMultiplier,
                                        height: 5 * Config.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10 * Config.imageSizeMultiplier),
                                          color: const Color(0xffffffff),
                                          border: Border.all(
                                            width: 1.0,
                                            color: const Color(0x40707070),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4 *
                                                      Config.widthMultiplier),
                                              child: Icon(
                                                Icons.person_outline_rounded,
                                                size: 5 *
                                                    Config.imageSizeMultiplier,
                                                color: Color(0xff908787),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller:
                                                    _firstnameController,
                                                focusNode: _firstNameFocus,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _addressFocus);
                                                },
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 2.2 *
                                                      Config.textMultiplier,
                                                ),
                                                decoration: new InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black
                                                        .withOpacity(.4),
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  hintText: "Fullname",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                ).copyWith(isDense: true),
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
                                      child: Container(
                                        width: 100 * Config.widthMultiplier,
                                        height: 5 * Config.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10 * Config.imageSizeMultiplier),
                                          color: const Color(0xffffffff),
                                          border: Border.all(
                                            width: 1.0,
                                            color: const Color(0x40707070),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4 *
                                                      Config.widthMultiplier),
                                              child: Icon(
                                                Icons.location_city,
                                                size: 5 *
                                                    Config.imageSizeMultiplier,
                                                color: Color(0xff908787),
                                              ),
                                            ),
                                            if (_currentAddress != null)
                                              Text(
                                                _currentAddress,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 1.7 *
                                                      Config.textMultiplier,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
                                      child: Container(
                                        width: 100 * Config.widthMultiplier,
                                        height: 5 * Config.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10 * Config.imageSizeMultiplier),
                                          color: const Color(0xffffffff),
                                          border: Border.all(
                                            width: 1.0,
                                            color: const Color(0x40707070),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4 *
                                                      Config.widthMultiplier),
                                              child: Icon(
                                                Icons.contact_phone_outlined,
                                                size: 5 *
                                                    Config.imageSizeMultiplier,
                                                color: Color(0xff908787),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _numberController,
                                                focusNode: _numberFocus,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _retypePasswordFocus);
                                                },
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 2.2 *
                                                      Config.textMultiplier,
                                                ),
                                                decoration: new InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black
                                                        .withOpacity(.4),
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  hintText: "Phone Number",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                ).copyWith(isDense: true),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
                                      child: Container(
                                        width: 100 * Config.widthMultiplier,
                                        height: 5 * Config.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10 * Config.imageSizeMultiplier),
                                          color: const Color(0xffffffff),
                                          border: Border.all(
                                            width: 1.0,
                                            color: const Color(0x40707070),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4 *
                                                      Config.widthMultiplier),
                                              child: Icon(
                                                Icons.alternate_email_rounded,
                                                size: 5 *
                                                    Config.imageSizeMultiplier,
                                                color: Color(0xff908787),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _username,
                                                focusNode: _userNameFocus,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _passwordFocus);
                                                },
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 2.2 *
                                                      Config.textMultiplier,
                                                ),
                                                decoration: new InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black
                                                        .withOpacity(.4),
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  hintText: "Username",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                ).copyWith(isDense: true),
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
                                      child: Container(
                                        width: 100 * Config.widthMultiplier,
                                        height: 5 * Config.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10 * Config.imageSizeMultiplier),
                                          color: const Color(0xffffffff),
                                          border: Border.all(
                                            width: 1.0,
                                            color: const Color(0x40707070),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4 *
                                                      Config.widthMultiplier),
                                              child: Icon(
                                                Icons.lock_open_rounded,
                                                size: 5 *
                                                    Config.imageSizeMultiplier,
                                                color: Color(0xff908787),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _passwordController,
                                                focusNode: _passwordFocus,
                                                obscureText: _hidePassword,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _retypePasswordFocus);
                                                },
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 2.2 *
                                                      Config.textMultiplier,
                                                ),
                                                decoration: new InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black
                                                        .withOpacity(.4),
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  hintText: "Password",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                ).copyWith(isDense: true),
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 0 *
                                                      Config.widthMultiplier),
                                              child: FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _hidePassword =
                                                        !_hidePassword;
                                                  });
                                                },
                                                child: Icon(_hidePassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
                                      child: Container(
                                        width: 100 * Config.widthMultiplier,
                                        height: 5 * Config.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10 * Config.imageSizeMultiplier),
                                          color: const Color(0xffffffff),
                                          border: Border.all(
                                            width: 1.0,
                                            color: const Color(0x40707070),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0x29000000),
                                              offset: Offset(0, 3),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4 *
                                                      Config.widthMultiplier),
                                              child: Icon(
                                                Icons.lock_open_rounded,
                                                size: 5 *
                                                    Config.imageSizeMultiplier,
                                                color: Color(0xff908787),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller:
                                                    _retypePasswordController,
                                                focusNode: _retypePasswordFocus,
                                                obscureText: _hidePassword,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: Colors.black,
                                                  fontSize: 2.2 *
                                                      Config.textMultiplier,
                                                ),
                                                decoration: new InputDecoration(
                                                  hintStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.black
                                                        .withOpacity(.4),
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                  ),
                                                  hintText: "Re-type Password",
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  border: InputBorder.none,
                                                ).copyWith(isDense: true),
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 0 *
                                                      Config.widthMultiplier),
                                              child: FlatButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _hidePassword =
                                                        !_hidePassword;
                                                  });
                                                },
                                                child: Icon(_hidePassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              8 * Config.widthMultiplier,
                                          vertical:
                                              1 * Config.heightMultiplier),
                                      child: ButtonTheme(
                                        height: 7 * Config.heightMultiplier,
                                        child: RaisedButton(
                                          onPressed: () {
                                            _check();
                                          },
                                          color: Color(0xffeb4d4d),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10 *
                                                    Config.imageSizeMultiplier),
                                          ),
                                          splashColor:
                                              Colors.white.withOpacity(.4),
                                          child: Container(
                                            child: Center(
                                              child: Text(
                                                "Save",
                                                textScaleFactor: 1,
                                                style: TextStyle(
                                                    fontSize: 2.2 *
                                                        Config.textMultiplier,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //       horizontal:
                                    //           8 * Config.widthMultiplier,
                                    //       vertical:
                                    //           1 * Config.heightMultiplier),
                                    //   child: ButtonTheme(
                                    //     height: 7 * Config.heightMultiplier,
                                    //     child: RaisedButton(
                                    //       onPressed: () {
                                    //         _getCurrentLocation();
                                    //       },
                                    //       color: Color(0xffeb4d4d),
                                    //       shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(
                                    //             10 *
                                    //                 Config.imageSizeMultiplier),
                                    //       ),
                                    //       splashColor:
                                    //           Colors.white.withOpacity(.4),
                                    //       child: Container(
                                    //         child: Center(
                                    //           child: Text(
                                    //             "Get Address",
                                    //             textScaleFactor: 1,
                                    //             style: TextStyle(
                                    //                 fontSize: 2.2 *
                                    //                     Config.textMultiplier,
                                    //                 color: Colors.white,
                                    //                 fontWeight:
                                    //                     FontWeight.bold),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
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
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/filled-button.dart';
import 'package:food_booking_app/defaults/firebase_settings.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/location.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
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
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  SharedPreferences _sharedPreferences;

  bool _hidePassword = true;

  FocusNode _passwordFocus = FocusNode();
  FocusNode _retypePasswordFocus = FocusNode();
  FocusNode _nameFocus = FocusNode();
  FocusNode _numberFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();
  FocusNode _userNameFocus = FocusNode();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _retypePasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  LocationData _locationData;

  void initState() {
    // TODO: implement initState
    super.initState();
    _configure();
  }

  _configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    await _getLocation();
  }

  _getLocation() async{
    WidgetsBinding.instance.addPostFrameCallback((_) async {Http().showLoadingOverlay(context);});
    var data = await CustomLocator().getLocation();
    if (data != 'Service not enabled' && data != 'Permission denied') {
      _locationData = data;
      await _reverseGeocode(_locationData);
      Navigator.pop(context);
    }
    else{
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            'Can\'t fetch location',
            textScaleFactor: .8,
            style: TextStyle(
              color: Colors.white,
              fontSize: 2.2 * textMultiplier,
              fontFamily: 'Poppins'
            )
          )
        )
      );
    }
  }

  _reverseGeocode(LocationData loc) async{
    final coordinates = new Coordinates(loc.latitude, loc. longitude);
    await Geocoder.google('AIzaSyBv6XJUF7GFim1QVmVMoEG23jSaa5BF12w').findAddressesFromCoordinates(coordinates)
    .then((google) {
      setState(() {
        _addressController.text = google.first.addressLine == ''? 'Zamboanga City':google.first.addressLine;
      });
    })
    .catchError((error) async {
      await Geocoder.local.findAddressesFromCoordinates(coordinates)
      .then((local) {
        setState(() {
          _addressController.text = local.first.addressLine == ''? 'Zamboanga City':local.first.addressLine;
        });
      });
    });
  }

  _check() async {
    Pattern pattern =
        r'^[a-zA-Z0-9]([._](?![._])|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$';
    RegExp regex = new RegExp(pattern);
    FocusScope.of(context).unfocus();
    if (
      _usernameController.text.isEmpty ||
      _nameController.text.isEmpty ||
      _numberController.text.isEmpty ||
      _retypePasswordController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _addressController.text.isEmpty
    ) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'Fill all fields properly!',
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          ),
        ),
      );
      return;
    }
    if (_usernameController.text.isNotEmpty && !regex.hasMatch(_usernameController.text)) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'This Username is not valid ',
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          ),
        ),
      );
      return;
    }

    // _numberController.text.length  <= 11
    if (_usernameController.text.length < 8 || _passwordController.text.length < 8) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: '${_usernameController.text.length < 8 ? "Username" : "Password"} must be at least 8 characters',
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          ),
        ),
      );
      return;
    }

    if (_passwordController.text.compareTo(_retypePasswordController.text) != 0) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'Passwords don\'t match',
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          ),
        ),
      );
      return;
    }

    _signUp();
  }

  _signUp() async {
    Http().showLoadingOverlay(context);
    var response = await Http(url: 'signup', body: {
      'username': _usernameController.text,
      'password': _passwordController.text,
      'password_confirmation': _passwordController.text,
      'name': _nameController.text,
      'number': _numberController.text,
      'address': _addressController.text.toString(),
      'longitude': _locationData.longitude.toString(),
      'latitude': _locationData.latitude.toString(),
    }).postNoHeader();
    if (response is String) {
      Navigator.pop(context);
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
      Map<String, dynamic> body = json.decode(response.body);
      if (response.statusCode == 200) {
        _login();
      } else {
        if (body.containsKey('errors')) {
          Navigator.pop(context);
          Map<String, dynamic> errors = body['errors'];
          errors.keys.forEach((e) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color(0xFF323232),
                content: CustomText(
                  align: TextAlign.left,
                  text: body['errors'][e][0],
                  color: Colors.white,
                  size: 1.6,
                  weight: FontWeight.normal,
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
    var response = await Http(url: 'login', body: {
      'username': _usernameController.text,
      'password': _passwordController.text
    }).postNoHeader();

    if (response is String) {
      Navigator.pop(context);
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
        Navigator.pop(context);
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
        if (body.containsKey('token')) {
          _sharedPreferences.setString('token', body['token']);
          await FirebaseSettings().updateToken();
          _sharedPreferences.setInt('id', int.parse(body['user']['id'].toString()));
          _sharedPreferences.setString('username', body['user']['username']);
          _sharedPreferences.setString('role', body['user']['role']);
          _sharedPreferences.setInt('role-id', body['user']['customer']['id']);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: DashBoard()));
        }
        else if (!body.containsKey('token') && body.containsKey('message')) {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: CustomText(
                align: TextAlign.left,
                text: body['message'],
                color: Colors.white,
                size: 1.6,
                weight: FontWeight.normal,
              ),
            ),
          );
        } else {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: CustomText(
                align: TextAlign.left,
                text: 'Invalid Credentials',
                color: Colors.white,
                size: 1.6,
                weight: FontWeight.normal,
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
              _scaffoldKey.currentState.removeCurrentSnackBar();
            },
            child: Container(
              padding: EdgeInsets.only(top: 17 * heightMultiplier),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.signUp),
                  fit: BoxFit.fill,
                ),
              ),
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3 * heightMultiplier),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                        color: appColor,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(0, -5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2 * heightMultiplier,
                            horizontal: 4 * widthMultiplier),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: CustomText(
                                text: 'Sign Up',
                                align:TextAlign.center,
                                size: 4,
                                weight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child: CustomTextBox(
                                        type: 'roundedbox',
                                        shadow: true,
                                        border: true,
                                        textInputAction:
                                            TextInputAction.next,
                                        controller: _nameController,
                                        focusNode: _nameFocus,
                                        onSubmitted: (value) {
                                          FocusScope.of(context).requestFocus(_addressFocus);
                                        },
                                        text: "Fullname",
                                        keyboardType: TextInputType.text,
                                        enabled: true,
                                        obscureText: false,
                                        padding: 8,
                                        prefixIcon: Icon(
                                          Icons.person_outline_rounded,
                                          size: 6 * imageSizeMultiplier,
                                        ),
                                        suffixIcon: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child: CustomTextBox(
                                        type: 'roundedbox',
                                        shadow: true,
                                        border: true,
                                        textInputAction:
                                            TextInputAction.next,
                                        controller: _addressController,
                                        focusNode: _addressFocus,
                                        onSubmitted: (value) {
                                          FocusScope.of(context).requestFocus(_numberFocus);
                                        },
                                        text: "Address",
                                        keyboardType: TextInputType.text,
                                        enabled: true,
                                        obscureText: false,
                                        padding: 8,
                                        prefixIcon: Icon(
                                          Icons.location_city_rounded,
                                          size: 6 * imageSizeMultiplier,
                                        ),
                                        suffixIcon: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child: CustomTextBox(
                                        type: 'roundedbox',
                                        shadow: true,
                                        border: true,
                                        textInputAction:
                                            TextInputAction.next,
                                        controller: _numberController,
                                        focusNode: _numberFocus,
                                        onSubmitted: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(
                                                  _userNameFocus);
                                        },
                                        text: "Phone Number",
                                        keyboardType: TextInputType.number,
                                        enabled: true,
                                        obscureText: false,
                                        padding: 8,
                                        prefixIcon: Icon(
                                          Icons.contact_phone_outlined,
                                          size: 6 * imageSizeMultiplier
                                        ),
                                        suffixIcon: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child: CustomTextBox(
                                        type: 'roundedbox',
                                        shadow: true,
                                        border: true,
                                        textInputAction:
                                            TextInputAction.next,
                                        controller: _usernameController,
                                        focusNode: _userNameFocus,
                                        onSubmitted: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(
                                                  _passwordFocus);
                                        },
                                        text: "Username",
                                        keyboardType: TextInputType.text,
                                        enabled: true,
                                        obscureText: false,
                                        padding: 8,
                                        prefixIcon: Icon(
                                          Icons.alternate_email_rounded,
                                          size: 6 * imageSizeMultiplier
                                        ),
                                        suffixIcon: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child: CustomTextBox(
                                        type: 'roundedbox',
                                        shadow: true,
                                        border: true,
                                        textInputAction:
                                            TextInputAction.next,
                                        controller: _passwordController,
                                        focusNode: _passwordFocus,
                                        onSubmitted: (value) {
                                          FocusScope.of(context)
                                              .requestFocus(
                                                  _retypePasswordFocus);
                                        },
                                        text: "Password",
                                        keyboardType: TextInputType.text,
                                        enabled: true,
                                        obscureText: false,
                                        padding: 8,
                                        prefixIcon: Icon(
                                          Icons.lock_open_rounded,
                                          size: 6 * imageSizeMultiplier
                                        ),
                                        suffixIcon: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child:  CustomTextBox(
                                        type: 'roundedbox',
                                        shadow: true,
                                        border: true,
                                        textInputAction:
                                            TextInputAction.next,
                                        controller:
                                            _retypePasswordController,
                                        focusNode: _retypePasswordFocus,
                                        onSubmitted: (value) {
                                          FocusScope.of(context)
                                              .unfocus();
                                        },
                                        text: "Re-type Password",
                                        keyboardType: TextInputType.text,
                                        enabled: true,
                                        obscureText: false,
                                        padding: 8,
                                        prefixIcon: Icon(
                                          Icons.lock_open_rounded,
                                          size: 6 * imageSizeMultiplier
                                        ),
                                        suffixIcon: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                                      child: FilledCustomButton(
                                        type: 'roundedbox',
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          _scaffoldKey.currentState.removeCurrentSnackBar();
                                          _check();
                                        },
                                        padding: 6,
                                        text: 'Signup',
                                        color: Color(0xFF464444),
                                      )
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).viewInsets.bottom
                                    )
                                  ],  
                                ),
                              )
                            ),
                          ]
                        )
                      )
                    ),
                  ),
                ],
            ),
          ),
        )
      )
    );
  }
}

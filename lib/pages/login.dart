import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/flutter_setting.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  String from;
  LoginScreen({Key key, @required this.from});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  SharedPreferences _sharedPreferences;

  FocusNode _passwordFocus = FocusNode();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _hidePassword = true;

  _check() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      _login();
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text('Fill up fields properly',
              textScaleFactor: .8,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 2.2 * Config.textMultiplier,
              ))));
    }
  }

  _login() async {
    Http().showLoadingOverlay(context);
    var response = await Http(url: 'login', body: {
      'email': _emailController.text,
      'password': _passwordController.text
    }).postNoHeader();
    print(response.body);

    if (response is String) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(response,
              textScaleFactor: .8,
              style: TextStyle(
                color: Colors.white,
                fontSize: 2.2 * Config.textMultiplier,
              ))));
    } else if (response is Response) {
      if (response.statusCode != 200) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF323232),
            content: Text(response.body,
                textScaleFactor: .8,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 2.2 * Config.textMultiplier,
                ))));
      } else {
        Map<String, dynamic> body = json.decode(response.body);
        if (body['data'].containsKey('token') &&
            body['data']['user']['role'] == 'CUSTOMER') {
          _sharedPreferences.setString('token', body['data']['token']);
          _sharedPreferences.setInt(
              'id', int.parse(body['data']['user']['id'].toString()));
          _sharedPreferences.setString(
              'username', body['data']['user']['username']);
          _sharedPreferences.setString('role', body['data']['user']['role']);
          // _sharedPreferences.setInt('role-id', body['data']['user']['profile']['id']);
          await FirebaseSettings().updateToken();
          Navigator.of(context).pop();
          await _loadCustomerDetails();
        } else if (!body['data'].containsKey('token') &&
            body.containsKey('message')) {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: Text(body['message'],
                  textScaleFactor: .8,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 2.2 * Config.textMultiplier,
                  ))));
        } else {
          Navigator.of(context).pop();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color(0xFF323232),
              content: Text('Invalid Credentials',
                  textScaleFactor: .8,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 2.2 * Config.textMultiplier,
                  ))));
        }
      }
    }
  }
  _loadCustomerDetails() async {
    var response = await Http(url: 'customer', body: null).getWithHeader();

    if (response is String) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(response,
              textScaleFactor: .8,
              style: TextStyle(
                color: Colors.white,
                fontSize: 2.2 * Config.textMultiplier,
              ))));
    } else if (response is Response) {
      Map<String, dynamic> list = json.decode(response.body);
      _sharedPreferences.setString('name', list['data']['customer']['name']);
    }
    if (widget.from == 'cart')
      Navigator.pop(context);
    else
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: DashBoard()),
          ModalRoute.withName('/'));
  }

  _configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();
    _sharedPreferences.setBool('not-first-open', false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _configure();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // if (widget.from == 'cart') Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(top: 33 * Config.heightMultiplier),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.bannerImagesLogin),
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
                      topRight: Radius.circular(40.0)),
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
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    color: Color(0xffeb4d4d),
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
                        horizontal: 8 * Config.widthMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 33.0),
                          child: Text(
                            'FOOD BOOKING',
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 5 * Config.textMultiplier,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.all(3 * Config.imageSizeMultiplier),
                          child: Container(
                            width: 80 * Config.widthMultiplier,
                            height: 37.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              color: const Color(0xffffffff),
                              border: Border.all(
                                  width: 1.0, color: const Color(0x40707070)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4 * Config.widthMultiplier),
                                  child: Image.asset(
                                    Images.emailIcon,
                                    width: 5 * Config.imageSizeMultiplier,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _emailController,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocus);
                                    },
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 2.2 * Config.textMultiplier,
                                    ),
                                    decoration: new InputDecoration(
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black.withOpacity(.4),
                                        fontSize: 2.2 * Config.textMultiplier,
                                      ),
                                      labelStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 2.2 * Config.textMultiplier,
                                      ),
                                      hintText: "Email",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                    ).copyWith(isDense: true),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: 80 * Config.widthMultiplier,
                            height: 37.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.0),
                              color: const Color(0xffffffff),
                              border: Border.all(
                                  width: 1.0, color: const Color(0x40707070)),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4 * Config.widthMultiplier),
                                  child: Image.asset(
                                    Images.lockIcon,
                                    width: 5 * Config.imageSizeMultiplier,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    obscureText: _hidePassword,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 2.2 * Config.textMultiplier,
                                    ),
                                    decoration: new InputDecoration(
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black.withOpacity(.4),
                                        fontSize: 2.2 * Config.textMultiplier,
                                      ),
                                      labelStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 2.2 * Config.textMultiplier,
                                      ),
                                      hintText: "Password",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                    ).copyWith(isDense: true),
                                    keyboardType: TextInputType.text,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 1 * Config.widthMultiplier),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontFamily: 'Poppins', color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1 * Config.heightMultiplier),
                          child: FlatButton(
                            splashColor: Color(0xffeb4d4d),
                            child: Container(
                              width: 50 * Config.widthMultiplier,
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x29000000),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text("Login",
                                    style: TextStyle(
                                        color: Color(0x29000000),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 1 * Config.widthMultiplier),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Login in with:',
                                style: TextStyle(
                                    fontFamily: 'Poppins', color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 1 * Config.heightMultiplier),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                Images.fbIcon,
                                width: 15 * Config.imageSizeMultiplier,
                              ),
                              Image.asset(
                                Images.twitIcon,
                                width: 15 * Config.imageSizeMultiplier,
                              ),
                              Image.asset(
                                Images.googleIcon,
                                width: 15 * Config.imageSizeMultiplier,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: 0 * Config.heightMultiplier),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Want to Create an Account?',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Click Here!',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white),
                                  ),
                                ),
                              ]),
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

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/flutter_setting.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/pages/dashBoard.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashBoard.dart';
import 'dashBoard.dart';
import 'signUp.dart';

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
  FocusNode _usernameFocus = FocusNode();

  TextEditingController _usernameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  bool _hidePassword = true;

  _check() async {
    FocusScope.of(context).unfocus();
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      _login();
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text(
            'Fill up fields properly',
            textScaleFactor: .8,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 2.2 * Config.textMultiplier,
            ),
          ),
          // action: SnackBarAction(
          //   label: 'Login',
          //   onPressed: () {},
          // ),
        ),
      );
    }
  }

  _login() async {
    Http().showLoadingOverlay(context);
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

  _configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool('not-first-open', false);
    if (_sharedPreferences.getString('token') != null) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: DashBoard(),
        ),
      );
    }
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
        if (widget.from == 'cart') Navigator.pop(context);
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
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
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
                        vertical: 2 * Config.heightMultiplier,
                        horizontal: 4 * Config.widthMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: 2 * Config.heightMultiplier,
                              bottom: 2 * Config.heightMultiplier),
                          child: Text(
                            'FOOD BOOKING',
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 4 * Config.textMultiplier,
                              color: const Color(0xffffffff),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1 * Config.heightMultiplier,
                              horizontal: 4 * Config.widthMultiplier),
                          child: Container(
                            width: 100 * Config.widthMultiplier,
                            height: 6 * Config.heightMultiplier,
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
                                    controller: _usernameController,
                                    focusNode: _usernameFocus,
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
                                      hintText: "Username",
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                    ).copyWith(isDense: true),
                                    keyboardType: TextInputType.text,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 1 * Config.heightMultiplier,
                              horizontal: 4 * Config.widthMultiplier),
                          child: Container(
                            width: 100 * Config.widthMultiplier,
                            height: 6 * Config.heightMultiplier,
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
                                    textAlignVertical: TextAlignVertical.center,
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
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _hidePassword?Icons.visibility:Icons.visibility_off,
                                        ),
                                        color: Colors.black,
                                        focusColor: Colors.black,
                                        hoverColor: Colors.black,
                                        highlightColor: Colors.black,
                                        onPressed: () {
                                          setState(() {
                                            _hidePassword = !_hidePassword;
                                          });
                                        },
                                      ),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 4 * Config.widthMultiplier),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ButtonTheme(
                              height: 0,
                              minWidth: 0,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4 * Config.widthMultiplier),
                          child: ButtonTheme(
                              height: 7 * Config.heightMultiplier,
                              child: RaisedButton(
                                onPressed: () {
                                  _check();
                                },
                                color: Color(0xFF464444),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10 * Config.imageSizeMultiplier),
                                ),
                                splashColor: Colors.white.withOpacity(.4),
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      textScaleFactor: 1,
                                      style: TextStyle(
                                          fontSize: 2.2 * Config.textMultiplier,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              right: 1 * Config.widthMultiplier,
                              top: 1 * Config.heightMultiplier),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Login with:',
                              textScaleFactor: 1,
                              style: TextStyle(
                                  fontSize: 1.6 * Config.textMultiplier,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Poppins',
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 4 * Config.widthMultiplier,
                              right: 4 * Config.widthMultiplier),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1 * Config.widthMultiplier),
                                  child: FlatButton(
                                      onPressed: () {},
                                      shape: CircleBorder(),
                                      child: Image.asset(
                                        Images.fbIcon,
                                        width: 15 * Config.imageSizeMultiplier,
                                        height: 15 * Config.imageSizeMultiplier,
                                      ))),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1 * Config.widthMultiplier),
                                  child: FlatButton(
                                      onPressed: () {},
                                      shape: CircleBorder(),
                                      child: Image.asset(
                                        Images.twitIcon,
                                        width: 15 * Config.imageSizeMultiplier,
                                        height: 15 * Config.imageSizeMultiplier,
                                      ))),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 1 * Config.widthMultiplier),
                                  child: FlatButton(
                                      onPressed: () {},
                                      shape: CircleBorder(),
                                      child: Image.asset(
                                        Images.googleIcon,
                                        width: 15 * Config.imageSizeMultiplier,
                                        height: 15 * Config.imageSizeMultiplier,
                                      ))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 0.3 * Config.heightMultiplier),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Want to Create an Account?',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 1.4 * Config.textMultiplier,
                                      fontFamily: 'Poppins',
                                      color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: SignUpScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Click Here!',
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontSize: 1.4 * Config.textMultiplier,
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

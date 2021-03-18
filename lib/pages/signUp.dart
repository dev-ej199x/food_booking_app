import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../defaults/config.dart';
import '../defaults/config.dart';
import '../defaults/http.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  SharedPreferences _sharedPreferences;

  FocusNode _passwordFocus = FocusNode();
  FocusNode _retypePasswordFocus = FocusNode();
  FocusNode _firstNameFocus = FocusNode();
  FocusNode _lastNameFocus = FocusNode();
  FocusNode _userNameFocus = FocusNode();

  TextEditingController _username = TextEditingController();

  TextEditingController _lastnameContorller = TextEditingController();

  TextEditingController _firstnameController = TextEditingController();

  TextEditingController _retypePasswordController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  _check() async {
    FocusScope.of(context).unfocus();
    if (_username.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _firstnameController.text.isNotEmpty &&
        _lastnameContorller.text.isNotEmpty &&
        _retypePasswordController.text.isNotEmpty) {
      // _signUp();
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
        ),
      );
    }
  }

  // _signUp() async {
  //   Http().showLoadingOverlay(context);
  //       var response = await Http(url: 'signUp', body: {
  //     'username': _username.text,
  //     'password': _passwordController.text
  //   }).postNoHeader();
  //   log(response.body);

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.signUp),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(top: 17 * Config.heightMultiplier),
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
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0)),
                      color: Color(0xffeb4d4d),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
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
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 4 * Config.heightMultiplier),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 1 * Config.heightMultiplier,
                                          horizontal:
                                              8 * Config.widthMultiplier),
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
                                                          _lastNameFocus);
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
                                                  hintText: "Fistname",
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
                                                controller: _lastnameContorller,
                                                focusNode: _lastNameFocus,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _userNameFocus);
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
                                                  hintText: "Lastname",
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
                                              borderRadius:
                                                  BorderRadius.circular(10 *
                                                      Config
                                                          .imageSizeMultiplier),
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
                                          )),
                                    ),
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
        )),
      ),
    );
  }
}

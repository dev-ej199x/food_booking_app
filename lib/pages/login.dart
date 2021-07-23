import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/filled-button.dart';
import 'package:food_booking_app/defaults/firebase_settings.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
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
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

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
          content: CustomText(
            weight: FontWeight.normal,
            align: TextAlign.left,
            text: 'Fill up fields properly',
            color: Colors.white,
            size: 1.6,
          ),
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
          content: CustomText(
            weight: FontWeight.normal,
            align: TextAlign.left,
            text: response,
            color: Colors.white,
            size: 1.6,
          ),
        ),
      );
    } else if (response is Response) {
      print(response.body);
      if (response.statusCode != 200) {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF323232),
            content: CustomText(
              weight: FontWeight.normal,
              align: TextAlign.left,
              text: response.body,
              color: Colors.white,
              size: 1.6,
            ),
          ),
        );
      } else {
        Map<String, dynamic> body = json.decode(response.body);
        if (body.containsKey('token')
            // && body['user']['role'] == 'CUSTOMER'
            ) {
          _sharedPreferences.setString('token', body['token']);
          await FirebaseSettings().updateToken();
          _sharedPreferences.setInt(
            'id',
            int.parse(
              body['user']['id'].toString(),
            ),
          );
          _sharedPreferences.setString('username', body['user']['username']);
          _sharedPreferences.setString('role', body['user']['role']);
          _sharedPreferences.setInt('role-id', body['user']['customer']['id']);
          print('ROLE ID NYA TO: ${body['user']['customer']['id']}');
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
              content: CustomText(
                weight: FontWeight.normal,
                align: TextAlign.left,
                text: body['message'],
                color: Colors.white,
                size: 1.6,
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
                weight: FontWeight.normal,
                align: TextAlign.left,
                text: 'Invalid Credentials',
                color: Colors.white,
                size: 1.6,
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
      child: ScaffoldMessenger(
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
              padding: EdgeInsets.only(top: 33 * heightMultiplier),
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
                              padding: EdgeInsets.only(
                                  top: 2 * heightMultiplier,
                                  bottom: 2 * heightMultiplier),
                              child: CustomText(
                                weight: FontWeight.normal,
                                align: TextAlign.left,
                                text: 'CHEEBOOK',
                                size: 4,
                                color: const Color(0xffffffff),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                              child: CustomTextBox(
                                type: 'roundedbox',
                                border: false,
                                textInputAction: TextInputAction.next,
                                controller: _usernameController,
                                focusNode: _usernameFocus,
                                onSubmitted: (value) {
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocus);
                                },
                                text: "Username",
                                obscureText: false,
                                padding: 6,
                                prefixIcon: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 6 * imageSizeMultiplier,
                                ),
                                suffixIcon: null,
                                enabled: true,
                                shadow: true,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                              child: CustomTextBox(
                                type: 'roundedbox',
                                border: false,
                                textInputAction: TextInputAction.done,
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                obscureText: _hidePassword,
                                onSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _hidePassword? Icons.visibility : Icons.visibility_off,
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
                                text: "Password",
                                enabled: true,
                                shadow: true,
                                padding: 6,
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  size: 6 * imageSizeMultiplier,
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4 * widthMultiplier),
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
                                    child: CustomText(
                                      weight: FontWeight.normal,
                                      align: TextAlign.left,
                                      text: 'Forgot Password?',
                                      color: Colors.white,
                                      size: 1.6,
                                    ),
                                  ),
                                ),
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
                                text: 'Login',
                                color: Color(0xFF464444),
                              )
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //       right: 1 * widthMultiplier,
                            //       top: 1 * heightMultiplier),
                            //   child: Align(
                            //     alignment: Alignment.center,
                            //     child: CustomText(
                            //       weight: FontWeight.normal,
                            //       align: TextAlign.left,
                            //       text: 'Login with:',
                            //       size: 1.6,
                            //       color: Colors.white
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.only(
                            //       left: 4 * widthMultiplier,
                            //       right: 4 * widthMultiplier),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 1 * widthMultiplier),
                            //           child: FlatButton(
                            //               onPressed: () {},
                            //               shape: CircleBorder(),
                            //               child: Image.asset(
                            //                 Images.fbIcon,
                            //                 width: 15 * imageSizeMultiplier,
                            //                 height: 15 * imageSizeMultiplier,
                            //               ))),
                            //       Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 1 * widthMultiplier),
                            //           child: FlatButton(
                            //               onPressed: () {},
                            //               shape: CircleBorder(),
                            //               child: Image.asset(
                            //                 Images.twitIcon,
                            //                 width: 15 * imageSizeMultiplier,
                            //                 height: 15 * imageSizeMultiplier,
                            //               ))),
                            //       Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               horizontal: 1 * widthMultiplier),
                            //           child: FlatButton(
                            //               onPressed: () {},
                            //               shape: CircleBorder(),
                            //               child: Image.asset(
                            //                 Images.googleIcon,
                            //                 width: 15 * imageSizeMultiplier,
                            //                 height: 15 * imageSizeMultiplier,
                            //               ))),
                            //     ],
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 0.3 * heightMultiplier),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      weight: FontWeight.normal,
                                      align: TextAlign.left,
                                      text: 'Want to Create an Account?',
                                      size: 1.4,
                                      color: Colors.white,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        _scaffoldKey.currentState.removeCurrentSnackBar();
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.rightToLeft,
                                            child: SignUpScreen(),
                                          ),
                                        );
                                      },
                                      child: CustomText(
                                        weight: FontWeight.normal,
                                        align: TextAlign.left,
                                        text: 'Click Here!',
                                        size: 1.4,
                                        color: Colors.white,
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
        )
      )
    );
  }
}

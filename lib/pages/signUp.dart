import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  SharedPreferences _sharedPreferences;

  FocusNode _passwordFocus = FocusNode();

  TextEditingController _username = TextEditingController();

  TextEditingController _lastnameContorller = TextEditingController();

  TextEditingController _firstnaameController = TextEditingController();

  TextEditingController _retypePasswordController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
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
                                      top: 2 * Config.heightMultiplier),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(
                                            3 * Config.imageSizeMultiplier),
                                        child: Container(
                                          width: 80 * Config.widthMultiplier,
                                          height: 37.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            color: const Color(0xffffffff),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0x40707070)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x29000000),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 3 * Config.textMultiplier),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: _lastnameContorller,
                                            onFieldSubmitted: (value) {
                                              FocusScope.of(context)
                                                  .requestFocus(_passwordFocus);
                                            },
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.black,
                                              fontSize:
                                                  2.2 * Config.textMultiplier,
                                            ),
                                            decoration: new InputDecoration(
                                              hintStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.black
                                                    .withOpacity(.4),
                                                fontSize:
                                                    2.2 * Config.textMultiplier,
                                              ),
                                              labelStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize:
                                                    2.2 * Config.textMultiplier,
                                              ),
                                              hintText: "Lastname",
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              border: InputBorder.none,
                                            ).copyWith(isDense: true),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            3 * Config.imageSizeMultiplier),
                                        child: Container(
                                          width: 80 * Config.widthMultiplier,
                                          height: 37.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            color: const Color(0xffffffff),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0x40707070)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x29000000),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          padding: EdgeInsets.only(
                                              left: 3 * Config.textMultiplier),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: _firstnaameController,
                                            onFieldSubmitted: (value) {
                                              FocusScope.of(context)
                                                  .requestFocus(_passwordFocus);
                                            },
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.black,
                                              fontSize:
                                                  2.2 * Config.textMultiplier,
                                            ),
                                            decoration: new InputDecoration(
                                              hintStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: Colors.black
                                                    .withOpacity(.4),
                                                fontSize:
                                                    2.2 * Config.textMultiplier,
                                              ),
                                              labelStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize:
                                                    2.2 * Config.textMultiplier,
                                              ),
                                              hintText: "Firstname",
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              border: InputBorder.none,
                                            ).copyWith(isDense: true),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            3 * Config.imageSizeMultiplier),
                                        child: Container(
                                          width: 80 * Config.widthMultiplier,
                                          height: 37.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            color: const Color(0xffffffff),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0x40707070)),
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
                                                child: Image.asset(
                                                  Images.emailIcon,
                                                  width: 5 *
                                                      Config
                                                          .imageSizeMultiplier,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  controller: _username,
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
                                                  decoration:
                                                      new InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      fontSize: 2.2 *
                                                          Config.textMultiplier,
                                                    ),
                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 2.2 *
                                                          Config.textMultiplier,
                                                    ),
                                                    hintText: "Email",
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    border: InputBorder.none,
                                                  ).copyWith(isDense: true),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            3 * Config.imageSizeMultiplier),
                                        child: Container(
                                          width: 80 * Config.widthMultiplier,
                                          height: 37.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            color: const Color(0xffffffff),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0x40707070)),
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
                                                child: Image.asset(
                                                  Images.lockIcon,
                                                  width: 5 *
                                                      Config
                                                          .imageSizeMultiplier,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  controller:
                                                      _passwordController,
                                                  focusNode: _passwordFocus,
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
                                                  decoration:
                                                      new InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      fontSize: 2.2 *
                                                          Config.textMultiplier,
                                                    ),
                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                            3 * Config.imageSizeMultiplier),
                                        child: Container(
                                          width: 80 * Config.widthMultiplier,
                                          height: 37.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            color: const Color(0xffffffff),
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color(0x40707070)),
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
                                                child: Image.asset(
                                                  Images.lockIcon,
                                                  width: 5 *
                                                      Config
                                                          .imageSizeMultiplier,
                                                ),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  controller:
                                                      _passwordController,
                                                  focusNode: _passwordFocus,
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
                                                  decoration:
                                                      new InputDecoration(
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      fontSize: 2.2 *
                                                          Config.textMultiplier,
                                                    ),
                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 2.2 *
                                                          Config.textMultiplier,
                                                    ),
                                                    hintText:
                                                        "Re-type Password",
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
                                        padding: EdgeInsets.all(
                                            3 * Config.imageSizeMultiplier),
                                        child: ButtonTheme(
                                          minWidth: 230.0,
                                          height: 37.0,
                                          splashColor: Color(0xffeb4d4d),
                                          child: RaisedButton(
                                            color: Color(0xffeb4d4d),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            onPressed: () {},
                                            child: Text("Save",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
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
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/cupertino.dart';

// import 'package:flutter/material.dart';
// import 'package:food_booking_app/defaults/appbar.dart';
// import 'package:food_booking_app/defaults/config.dart';
// import 'package:food_booking_app/defaults/flutter_setting.dart';
// import 'package:food_booking_app/defaults/http.dart';
// import 'package:food_booking_app/pages/LoginSample.dart';
// import 'package:food_booking_app/defaults/images.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:page_transition/page_transition.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
//   SharedPreferences _sharedPreferences;

//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();

//   FocusNode _usernameFocus = FocusNode();
//   FocusNode _passwordFocus = FocusNode();
//   FocusNode _emailFocus = FocusNode();

//   bool _agree = true;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _configure();
//   }

//   _configure() async {
//     _sharedPreferences = await SharedPreferences.getInstance();
//   }

//   _check() {
//     Pattern pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = new RegExp(pattern);
//     if (!_agree) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Color(0xFF323232),
//           content: Text('Read and agree to the terms and conditions',
//               textScaleFactor: .8,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2.2 * Config.textMultiplier,
//               ))));
//       return;
//     }
//     if (!regex.hasMatch(_emailController.text)) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Color(0xFF323232),
//           content: Text('Email must be a valid email',
//               textScaleFactor: .8,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2.2 * Config.textMultiplier,
//               ))));
//       return;
//     }
//     if (_usernameController.text.length < 8 ||
//         _passwordController.text.length < 8) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Color(0xFF323232),
//           content: Text(
//               '${_usernameController.text.length < 8 ? "Username" : "Password"} must be at least 8 characters',
//               textScaleFactor: .8,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2.2 * Config.textMultiplier,
//               ))));
//       return;
//     }
//     if (_usernameController.text.isEmpty ||
//         _passwordController.text.isEmpty ||
//         _emailController.text.isEmpty) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Color(0xFF323232),
//           content: Text('Fill all fields properly!',
//               textScaleFactor: .8,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2.2 * Config.textMultiplier,
//               ))));
//       return;
//     }
//     _signUp();
//   }

//   _signUp() async {
//     Http().showLoadingOverlay(context);
//     var response = await Http(url: 'public/customers', body: {
//       'username': _usernameController.text,
//       'email': _emailController.text,
//       'password': _passwordController.text,
//       'password_confirmation': _passwordController.text,
//       'contact_number': _sharedPreferences.getString('contact-number'),
//     }).postNoHeader();

//     if (response is String) {
//       Navigator.pop(context);
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Color(0xFF323232),
//           content: Text(response,
//               textScaleFactor: .8,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2.2 * Config.textMultiplier,
//               ))));
//     } else if (response is Response) {
//       Map<String, dynamic> body = json.decode(response.body);
//       if (response.statusCode == 200) {
//         _login();
//       } else {
//         if (body.containsKey('errors')) {
//           Map<String, dynamic> errors = body['errors'];
//           errors.keys.forEach((e) {
//             _scaffoldKey.currentState.showSnackBar(SnackBar(
//                 behavior: SnackBarBehavior.floating,
//                 backgroundColor: Color(0xFF323232),
//                 content: Text(body['errors'][e][0],
//                     textScaleFactor: .8,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 2.2 * Config.textMultiplier,
//                     ))));
//             return;
//           });
//         }
//       }
//     }
//   }

//   _login() async {
//     Http().showLoadingOverlay(context);
//     var response = await Http(url: 'login', body: {
//       'email': _emailController.text,
//       'password': _passwordController.text
//     }).postNoHeader();

//     if (response is String) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Color(0xFF323232),
//           content: Text(response,
//               textScaleFactor: .8,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2.2 * Config.textMultiplier,
//               ))));
//     } else if (response is Response) {
//       if (response.statusCode != 200) {
//         Navigator.pop(context);
//         _scaffoldKey.currentState.showSnackBar(SnackBar(
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Color(0xFF323232),
//             content: Text(response.body,
//                 textScaleFactor: .8,
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   color: Colors.white,
//                   fontSize: 2.2 * Config.textMultiplier,
//                 ))));
//       } else {
//         Map<String, dynamic> body = json.decode(response.body);
//         if (body['data'].containsKey('token')) {
//           _sharedPreferences.setString('token', body['data']['token']);
//           _sharedPreferences.setInt('id', body['data']['user']['id']);
//           _sharedPreferences.setString(
//               'username', body['data']['user']['username']);
//           _sharedPreferences.setString('role', body['data']['user']['role']);
//           // _sharedPreferences.setInt('role-id', body['data']['user']['profile']['id']);
//           await FirebaseSettings().updateToken();
//           Navigator.of(context).pop();
//           if (body['data']['user']['role'] == 'CUSTOMER')
//             await _loadCustomerDetails();
//         } else if (body.containsKey('message')) {
//           Navigator.of(context).pop();
//           _scaffoldKey.currentState.showSnackBar(SnackBar(
//               behavior: SnackBarBehavior.floating,
//               backgroundColor: Color(0xFF323232),
//               content: Text(body['message'],
//                   textScaleFactor: .8,
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     color: Colors.white,
//                     fontSize: 2.2 * Config.textMultiplier,
//                   ))));
//         }
//       }
//     }
//   }

//   _loadCustomerDetails() async {
//     var response = await Http(url: 'customer', body: null).getWithHeader();

//     if (response is String) {
//       _scaffoldKey.currentState.showSnackBar(SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: Color(0xFF323232),
//           content: Text(response,
//               textScaleFactor: .8,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 2.2 * Config.textMultiplier,
//               ))));
//     } else if (response is Response) {
//       Map<String, dynamic> list = json.decode(response.body);
//       _sharedPreferences.setString('name', list['data']['customer']['name']);
//     }

//     // Navigator.push(
//     //     context,
//     //     PageTransition(
//     //         type: PageTransitionType.rightToLeft,
//     //         child: SamplePage()));
//   }

//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () {
//           Navigator.pop(context);
//           Navigator.push(
//               context,
//               PageTransition(
//                   type: PageTransitionType.rightToLeft, child: LoginScreen(from: null,)));
//         },
//         child: Scaffold(
//             key: _scaffoldKey,
//             backgroundColor: Colors.white,
//             resizeToAvoidBottomInset: false,
//             appBar: CustomAppBar(
//                 height: 30 * Config.heightMultiplier,
//                 alignment: Alignment.topCenter,
//                 child: Stack(children: [
//                   Image.asset(
//                     Images.tryImage,
//                     color: Colors.black.withOpacity(.4),
//                     colorBlendMode: BlendMode.luminosity,
//                     height: 30 * Config.heightMultiplier,
//                     width: 100 * Config.widthMultiplier,
//                     fit: BoxFit.fill,
//                   ),
//                   SafeArea(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                               padding: EdgeInsets.only(
//                                   left: 2 * Config.widthMultiplier,
//                                   right: 2 * Config.widthMultiplier,
//                                   top: 6 * Config.heightMultiplier),
//                               child: ButtonTheme(
//                                   materialTapTargetSize:
//                                       MaterialTapTargetSize.shrinkWrap,
//                                   padding: EdgeInsets.zero,
//                                   height: 0,
//                                   minWidth: 0,
//                                   child: FlatButton(
//                                     padding: EdgeInsets.zero,
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       Navigator.push(
//                                           context,
//                                           PageTransition(
//                                               type: PageTransitionType
//                                                   .rightToLeft,
//                                               child: LoginScreen(from: null,)));
//                                     },
//                                     shape: CircleBorder(),
//                                     child: Icon(
//                                       Icons.arrow_back_ios_rounded,
//                                       color: Colors.white,
//                                       size: 10 * Config.imageSizeMultiplier,
//                                     ),
//                                   ))),
//                           Padding(
//                               padding: EdgeInsets.only(
//                                 left: 14 * Config.widthMultiplier,
//                                 top: 2 * Config.heightMultiplier,
//                                 right: 10 * Config.widthMultiplier,
//                               ),
//                               child: Text(
//                                 'Sign Up',
//                                 textScaleFactor: .8,
//                                 style: TextStyle(
//                                   fontFamily: 'Satisfy',
//                                   fontSize: 3.6 * Config.textMultiplier,
//                                   color: Colors.white,
//                                 ),
//                               )),
//                           Padding(
//                               padding: EdgeInsets.only(
//                                 left: 14 * Config.widthMultiplier,
//                                 top: 1 * Config.heightMultiplier,
//                                 right: 10 * Config.widthMultiplier,
//                               ),
//                               child: Text(
//                                 'Please fill-up the form for more information',
//                                 textScaleFactor: .8,
//                                 style: TextStyle(
//                                   fontFamily: 'Raleway',
//                                   fontSize: 2.6 * Config.textMultiplier,
//                                   color: Colors.white,
//                                 ),
//                               )),
//                         ]),
//                   )
//                 ])),
//             body: SafeArea(
//                 bottom: false,
//                 left: false,
//                 right: false,
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                           child: SingleChildScrollView(
//                               child: Padding(
//                                   padding: EdgeInsets.only(
//                                       bottom: 4 * Config.heightMultiplier,
//                                       left: 10 * Config.widthMultiplier,
//                                       right: 10 * Config.widthMultiplier),
//                                   child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         // Padding(
//                                         //     padding: EdgeInsets.only(
//                                         //         top: 4 *
//                                         //             Config.heightMultiplier),
//                                         //     child: Container(
//                                         //         width: 100 *
//                                         //             Config.widthMultiplier,
//                                         //         height:
//                                         //             8 * Config.heightMultiplier,
//                                         //         padding: EdgeInsets.symmetric(
//                                         //             horizontal: 4 *
//                                         //                 Config.widthMultiplier),
//                                         //         decoration: BoxDecoration(
//                                         //           borderRadius:
//                                         //               BorderRadius.circular(
//                                         //                   20.0),
//                                         //           color: Colors.white,
//                                         //           border: Border.all(
//                                         //             width: 2.0,
//                                         //             color: Colors.black
//                                         //                 .withOpacity(0.22),
//                                         //           ),
//                                         //         ),
//                                         //         child: Row(children: [
//                                         //           Expanded(
//                                         //               child: TextFormField(
//                                         //                   textInputAction:
//                                         //                       TextInputAction
//                                         //                           .next,
//                                         //                   controller:
//                                         //                       _firstNameController,
//                                         //                   onFieldSubmitted:
//                                         //                       (value) {
//                                         //                     FocusScope.of(
//                                         //                             context)
//                                         //                         .requestFocus(
//                                         //                             _lastNameFocus);
//                                         //                   },
//                                         //                   style: TextStyle(
//                                         //                     fontFamily:
//                                         //                         'Poppins',
//                                         //                     color: Colors.black,
//                                         //                     fontSize: 2.2 *
//                                         //                         Config
//                                         //                             .textMultiplier,
//                                         //                   ),
//                                         //                   decoration:
//                                         //                       new InputDecoration(
//                                         //                     hintStyle:
//                                         //                         TextStyle(
//                                         //                       fontFamily:
//                                         //                           'Poppins',
//                                         //                       color: Colors
//                                         //                           .black
//                                         //                           .withOpacity(
//                                         //                               .4),
//                                         //                       fontSize: 2.2 *
//                                         //                           Config
//                                         //                               .textMultiplier,
//                                         //                     ),
//                                         //                     labelStyle:
//                                         //                         TextStyle(
//                                         //                       fontFamily:
//                                         //                           'Poppins',
//                                         //                       fontWeight:
//                                         //                           FontWeight
//                                         //                               .bold,
//                                         //                       color:
//                                         //                           Colors.black,
//                                         //                       fontSize: 2.2 *
//                                         //                           Config
//                                         //                               .textMultiplier,
//                                         //                     ),
//                                         //                     hintText:
//                                         //                         "First Name",
//                                         //                     enabledBorder:
//                                         //                         InputBorder
//                                         //                             .none,
//                                         //                     focusedBorder:
//                                         //                         InputBorder
//                                         //                             .none,
//                                         //                     border: InputBorder
//                                         //                         .none,
//                                         //                   ).copyWith(
//                                         //                           isDense:
//                                         //                               true),
//                                         //                   keyboardType:
//                                         //                       TextInputType
//                                         //                           .text)),
//                                         //         ]))),
//                                         // Padding(
//                                         //     padding: EdgeInsets.only(
//                                         //         top: 1 *
//                                         //             Config.heightMultiplier),
//                                         //     child: Container(
//                                         //         width: 100 *
//                                         //             Config.widthMultiplier,
//                                         //         height:
//                                         //             8 * Config.heightMultiplier,
//                                         //         padding: EdgeInsets.symmetric(
//                                         //             horizontal: 4 *
//                                         //                 Config.widthMultiplier),
//                                         //         decoration: BoxDecoration(
//                                         //           borderRadius:
//                                         //               BorderRadius.circular(
//                                         //                   20.0),
//                                         //           color: Colors.white,
//                                         //           border: Border.all(
//                                         //             width: 2.0,
//                                         //             color: Colors.black
//                                         //                 .withOpacity(0.22),
//                                         //           ),
//                                         //         ),
//                                         //         child: Row(children: [
//                                         //           Expanded(
//                                         //               child: TextFormField(
//                                         //                   textInputAction:
//                                         //                       TextInputAction
//                                         //                           .next,
//                                         //                   controller:
//                                         //                       _lastNameController,
//                                         //                   focusNode:
//                                         //                       _lastNameFocus,
//                                         //                   onFieldSubmitted:
//                                         //                       (value) {
//                                         //                     FocusScope.of(
//                                         //                             context)
//                                         //                         .requestFocus(
//                                         //                             _emailFocus);
//                                         //                   },
//                                         //                   style: TextStyle(
//                                         //                     fontFamily:
//                                         //                         'Poppins',
//                                         //                     color: Colors.black,
//                                         //                     fontSize: 2.2 *
//                                         //                         Config
//                                         //                             .textMultiplier,
//                                         //                   ),
//                                         //                   decoration:
//                                         //                       new InputDecoration(
//                                         //                     hintStyle:
//                                         //                         TextStyle(
//                                         //                       fontFamily:
//                                         //                           'Poppins',
//                                         //                       color: Colors
//                                         //                           .black
//                                         //                           .withOpacity(
//                                         //                               .4),
//                                         //                       fontSize: 2.2 *
//                                         //                           Config
//                                         //                               .textMultiplier,
//                                         //                     ),
//                                         //                     labelStyle:
//                                         //                         TextStyle(
//                                         //                       fontFamily:
//                                         //                           'Poppins',
//                                         //                       fontWeight:
//                                         //                           FontWeight
//                                         //                               .bold,
//                                         //                       color:
//                                         //                           Colors.black,
//                                         //                       fontSize: 2.2 *
//                                         //                           Config
//                                         //                               .textMultiplier,
//                                         //                     ),
//                                         //                     hintText:
//                                         //                         "Last Name",
//                                         //                     enabledBorder:
//                                         //                         InputBorder
//                                         //                             .none,
//                                         //                     focusedBorder:
//                                         //                         InputBorder
//                                         //                             .none,
//                                         //                     border: InputBorder
//                                         //                         .none,
//                                         //                   ).copyWith(
//                                         //                           isDense:
//                                         //                               true),
//                                         //                   keyboardType:
//                                         //                       TextInputType
//                                         //                           .text)),
//                                         //         ]))),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: 1 *
//                                                     Config.heightMultiplier),
//                                             child: Container(
//                                                 width: 100 *
//                                                     Config.widthMultiplier,
//                                                 height:
//                                                     8 * Config.heightMultiplier,
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 4 *
//                                                         Config.widthMultiplier),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0),
//                                                   color: Colors.white,
//                                                   border: Border.all(
//                                                     width: 2.0,
//                                                     color: Colors.black
//                                                         .withOpacity(0.22),
//                                                   ),
//                                                 ),
//                                                 child: Row(children: [
//                                                   Expanded(
//                                                       child: TextFormField(
//                                                     textInputAction:
//                                                         TextInputAction.next,
//                                                     controller:
//                                                         _emailController,
//                                                     focusNode: _emailFocus,
//                                                     onFieldSubmitted: (value) {
//                                                       FocusScope.of(context)
//                                                           .requestFocus(
//                                                               _usernameFocus);
//                                                     },
//                                                     style: TextStyle(
//                                                       fontFamily: 'Poppins',
//                                                       color: Colors.black,
//                                                       fontSize: 2.2 *
//                                                           Config.textMultiplier,
//                                                     ),
//                                                     decoration:
//                                                         new InputDecoration(
//                                                       hintStyle: TextStyle(
//                                                         fontFamily: 'Poppins',
//                                                         color: Colors.black
//                                                             .withOpacity(.4),
//                                                         fontSize: 2.2 *
//                                                             Config
//                                                                 .textMultiplier,
//                                                       ),
//                                                       labelStyle: TextStyle(
//                                                         fontFamily: 'Poppins',
//                                                         fontWeight:
//                                                             FontWeight.bold,
//                                                         color: Colors.black,
//                                                         fontSize: 2.2 *
//                                                             Config
//                                                                 .textMultiplier,
//                                                       ),
//                                                       hintText: "Email",
//                                                       enabledBorder:
//                                                           InputBorder.none,
//                                                       focusedBorder:
//                                                           InputBorder.none,
//                                                       border: InputBorder.none,
//                                                     ).copyWith(isDense: true),
//                                                     keyboardType: TextInputType
//                                                         .emailAddress,
//                                                   )),
//                                                 ]))),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: 1 *
//                                                     Config.heightMultiplier),
//                                             child: Container(
//                                                 width: 100 *
//                                                     Config.widthMultiplier,
//                                                 height:
//                                                     8 * Config.heightMultiplier,
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 4 *
//                                                         Config.widthMultiplier),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0),
//                                                   color: Colors.white,
//                                                   border: Border.all(
//                                                     width: 2.0,
//                                                     color: Colors.black
//                                                         .withOpacity(0.22),
//                                                   ),
//                                                 ),
//                                                 child: Row(children: [
//                                                   Expanded(
//                                                       child: TextFormField(
//                                                           textInputAction:
//                                                               TextInputAction
//                                                                   .next,
//                                                           controller:
//                                                               _usernameController,
//                                                           focusNode:
//                                                               _usernameFocus,
//                                                           onFieldSubmitted:
//                                                               (value) {
//                                                             FocusScope.of(
//                                                                     context)
//                                                                 .requestFocus(
//                                                                     _passwordFocus);
//                                                           },
//                                                           style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             color: Colors.black,
//                                                             fontSize: 2.2 *
//                                                                 Config
//                                                                     .textMultiplier,
//                                                           ),
//                                                           decoration:
//                                                               new InputDecoration(
//                                                             hintStyle:
//                                                                 TextStyle(
//                                                               fontFamily:
//                                                                   'Poppins',
//                                                               color: Colors
//                                                                   .black
//                                                                   .withOpacity(
//                                                                       .4),
//                                                               fontSize: 2.2 *
//                                                                   Config
//                                                                       .textMultiplier,
//                                                             ),
//                                                             labelStyle:
//                                                                 TextStyle(
//                                                               fontFamily:
//                                                                   'Poppins',
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 2.2 *
//                                                                   Config
//                                                                       .textMultiplier,
//                                                             ),
//                                                             hintText:
//                                                                 "Username",
//                                                             enabledBorder:
//                                                                 InputBorder
//                                                                     .none,
//                                                             focusedBorder:
//                                                                 InputBorder
//                                                                     .none,
//                                                             border: InputBorder
//                                                                 .none,
//                                                           ).copyWith(
//                                                                   isDense:
//                                                                       true),
//                                                           keyboardType:
//                                                               TextInputType
//                                                                   .text)),
//                                                 ]))),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: 1 *
//                                                     Config.heightMultiplier),
//                                             child: Container(
//                                                 width: 100 *
//                                                     Config.widthMultiplier,
//                                                 height:
//                                                     8 * Config.heightMultiplier,
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 4 *
//                                                         Config.widthMultiplier),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           20.0),
//                                                   color: Colors.white,
//                                                   border: Border.all(
//                                                     width: 2.0,
//                                                     color: Colors.black
//                                                         .withOpacity(0.22),
//                                                   ),
//                                                 ),
//                                                 child: Row(children: [
//                                                   Expanded(
//                                                       child: TextFormField(
//                                                           textInputAction:
//                                                               TextInputAction
//                                                                   .done,
//                                                           controller:
//                                                               _passwordController,
//                                                           focusNode:
//                                                               _passwordFocus,
//                                                           onFieldSubmitted:
//                                                               (value) {
//                                                             FocusScope.of(
//                                                                     context)
//                                                                 .unfocus();
//                                                           },
//                                                           style: TextStyle(
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                             color: Colors.black,
//                                                             fontSize: 2.2 *
//                                                                 Config
//                                                                     .textMultiplier,
//                                                           ),
//                                                           decoration:
//                                                               new InputDecoration(
//                                                             hintStyle:
//                                                                 TextStyle(
//                                                               fontFamily:
//                                                                   'Poppins',
//                                                               color: Colors
//                                                                   .black
//                                                                   .withOpacity(
//                                                                       .4),
//                                                               fontSize: 2.2 *
//                                                                   Config
//                                                                       .textMultiplier,
//                                                             ),
//                                                             labelStyle:
//                                                                 TextStyle(
//                                                               fontFamily:
//                                                                   'Poppins',
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold,
//                                                               color:
//                                                                   Colors.black,
//                                                               fontSize: 2.2 *
//                                                                   Config
//                                                                       .textMultiplier,
//                                                             ),
//                                                             hintText:
//                                                                 "Password",
//                                                             enabledBorder:
//                                                                 InputBorder
//                                                                     .none,
//                                                             focusedBorder:
//                                                                 InputBorder
//                                                                     .none,
//                                                             border: InputBorder
//                                                                 .none,
//                                                           ).copyWith(
//                                                                   isDense:
//                                                                       true),
//                                                           keyboardType:
//                                                               TextInputType
//                                                                   .text)),
//                                                 ]))),
//                                         Align(
//                                             alignment: Alignment.centerLeft,
//                                             child: Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                     vertical: 2 *
//                                                         Config
//                                                             .heightMultiplier),
//                                                 child: ButtonTheme(
//                                                     padding: EdgeInsets.zero,
//                                                     materialTapTargetSize:
//                                                         MaterialTapTargetSize
//                                                             .shrinkWrap,
//                                                     height: 0,
//                                                     minWidth: 0,
//                                                     child: FlatButton(
//                                                         onPressed: () {
//                                                           setState(() {
//                                                             _agree = !_agree;
//                                                           });
//                                                         },
//                                                         child: Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Container(
//                                                                 width: 4.5 *
//                                                                     Config
//                                                                         .imageSizeMultiplier,
//                                                                 height: 4.5 *
//                                                                     Config
//                                                                         .imageSizeMultiplier,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   color: _agree
//                                                                       ? Config
//                                                                           .appColor
//                                                                       : Colors
//                                                                           .white,
//                                                                   border: _agree
//                                                                       ? null
//                                                                       : Border
//                                                                           .all(
//                                                                           width:
//                                                                               1.0,
//                                                                           color:
//                                                                               Colors.black,
//                                                                         ),
//                                                                 )),
//                                                             Padding(
//                                                                 padding: EdgeInsets.only(
//                                                                     left: 1 *
//                                                                         Config
//                                                                             .widthMultiplier),
//                                                                 child: Column(
//                                                                     mainAxisAlignment:
//                                                                         MainAxisAlignment
//                                                                             .start,
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     children: [
//                                                                       Text(
//                                                                         'I agree to the',
//                                                                         textScaleFactor:
//                                                                             .8,
//                                                                         style:
//                                                                             TextStyle(
//                                                                           fontFamily:
//                                                                               'Raleway',
//                                                                           fontSize:
//                                                                               2.2 * Config.textMultiplier,
//                                                                           color:
//                                                                               Colors.black,
//                                                                         ),
//                                                                         textAlign:
//                                                                             TextAlign.left,
//                                                                       ),
//                                                                       // ButtonTheme(
//                                                                       //     materialTapTargetSize: MaterialTapTargetSize
//                                                                       //         .shrinkWrap,
//                                                                       //     padding: EdgeInsets
//                                                                       //         .zero,
//                                                                       //     height:
//                                                                       //         0,
//                                                                       //     minWidth:
//                                                                       //         0,
//                                                                       //     child: FlatButton(
//                                                                       //         onPressed: () {
//                                                                       //           Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: TermsScreen()));
//                                                                       //         },
//                                                                       //         child: Text(
//                                                                       //           'Terms and Condition',
//                                                                       //           textScaleFactor: .8,
//                                                                       //           style: TextStyle(
//                                                                       //             decoration: TextDecoration.underline,
//                                                                       //             fontFamily: 'Raleway',
//                                                                       //             fontSize: 2.2 * Config.textMultiplier,
//                                                                       //             color: Colors.black,
//                                                                       //           ),
//                                                                       //           textAlign: TextAlign.left,
//                                                                       //         ))),
//                                                                     ]))
//                                                           ],
//                                                         ))))),
//                                         Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: (Config.isMobilePortrait
//                                                         ? 4
//                                                         : 1) *
//                                                     Config.heightMultiplier),
//                                             child: ButtonTheme(
//                                                 minWidth: 100 *
//                                                     Config.widthMultiplier,
//                                                 height:
//                                                     8 * Config.heightMultiplier,
//                                                 child: FlatButton(
//                                                   onPressed: () {
//                                                     _check();
//                                                   },
//                                                   color: Config.appColor,
//                                                   shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             20.0),
//                                                   ),
//                                                   child: Text(
//                                                     'Submit',
//                                                     textScaleFactor: .8,
//                                                     style: TextStyle(
//                                                         fontFamily: 'Poppins',
//                                                         fontSize: 2.2 *
//                                                             Config
//                                                                 .textMultiplier,
//                                                         color: Colors.white,
//                                                         fontWeight:
//                                                             FontWeight.w100),
//                                                   ),
//                                                 ))),
//                                         SizedBox(
//                                           height: MediaQuery.of(context)
//                                               .viewInsets
//                                               .bottom,
//                                         ),
//                                       ]))))
//                     ]))));
//   }
// }

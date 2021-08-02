import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/filled-button.dart';
import 'package:food_booking_app/defaults/firebase_settings.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences _sharedPreferences;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _numberFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();
  Color _editColor = Colors.green;
  bool _edit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCustomers();
    });
  }

  _getCustomers() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    Http().showLoadingOverlay(context);
    var response = await Http(url: 'user/profile', body: {}).getWithHeader();
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
        Navigator.pop(context);
        Map<String, dynamic> body = json.decode(response.body);
        setState(() {
          _nameController.text = body['user']['name'];
          _numberController.text = body['user']['number'];
          _addressController.text = body['user']['address'];
        });
      }
    }
  }

  _check() async {
    if (_numberController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _addressController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: 'Fill all fields properly',
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          )
        )
      );
      return;
    }
    _update();
  }

  _update() async {
    var response = await Http(url: 'profile/${_sharedPreferences.getInt('role-id')}/update', body: {
      'name': _nameController.text,
      'number': _numberController.text,
      'address': _addressController.text
    }).putWithHeader();
    if (response is String) {
      // Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: CustomText(
            align: TextAlign.left,
            text: response,
            color: Colors.white,
            size: 1.6,
            weight: FontWeight.normal,
          )
        )
      );
    } else if (response is Response) {
      if (response.statusCode != 200) {
        Map<String, dynamic> body = json.decode(response.body);
        // Navigator.pop(context);
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
            )
          )
        );
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF323232),
            content: CustomText(
              align: TextAlign.left,
              text: 'Successfully Updated!',
              color: Colors.white,
              size: 1.6,
              weight: FontWeight.normal,
            )
          )
        );
        setState(() {
          _edit = false;
        });
      }
    }
  }

  _showLogoutDialog() {
    showDialog(context: context,
      barrierColor: Colors.black.withOpacity(.4),
      builder: (_) => new AlertDialog(
        backgroundColor: Colors.white,
        title: CustomText(
          text: 'Logout',
          size: 1.8,
          align: TextAlign.left,
          color: Colors.black,
          weight: FontWeight.bold,
        ),
        content: CustomText(
          text: 'Are you sure?',
          size: 1.6,
          align: TextAlign.left,
          color: Colors.black,
          weight: FontWeight.normal,
        ),
        actions: [
          FlatButton(
            child: CustomText(
              text: 'No',
              size: 1.5,
              align: TextAlign.left,
              color: appColor,
              weight: FontWeight.bold,
            ),
            onPressed:  () {
              FocusScope.of(context).unfocus();
              _scaffoldKey.currentState.removeCurrentSnackBar();
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: CustomText(
              text: 'Yes',
              size: 1.5,
              align: TextAlign.left,
              color: appColor,
              weight: FontWeight.bold,
            ),
            onPressed:  () {
              FocusScope.of(context).unfocus();
              _scaffoldKey.currentState.removeCurrentSnackBar();
              _logout();
            },
          ),
        ],
      )
    );
  }

  _logout() async {
    FirebaseSettings().revokeToken();
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
            preferredSize: Size.fromHeight(6 * heightMultiplier),
            child: Ink(
              width: 100 * widthMultiplier,
              color: Colors.white,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 2 * heightMultiplier),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          color: appColor,
                          align: TextAlign.center,
                          size: 3,
                          text: 'PROFILE',
                          weight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          splashColor: Colors.black12.withOpacity(0.05),
                          hoverColor: Colors.black12.withOpacity(0.05),
                          icon: Icon(
                            Icons.logout,
                            size: 6 * imageSizeMultiplier,
                            color: appColor,
                          ),
                          onPressed: () {
                            _showLogoutDialog();
                          },
                        ),
                      )
                    ]
                  )
                )
              ),
            )
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 2 * heightMultiplier),
                child: CustomButton(
                  height: 0,
                  minWidth: 0,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _edit = !_edit;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          align: TextAlign.center,
                          color: Colors.black,
                          size: 1.6,
                          text: _edit?'Cancle Edit':'Edit Profile',
                          weight: FontWeight.bold,
                        ),
                        Icon(
                          _edit?Icons.close_rounded:Icons.edit,
                          size: 4 * imageSizeMultiplier,
                          color: Colors.black,
                        )
                      ]
                    )
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: 2 * heightMultiplier),
                child: CustomTextBox(
                  type: 'roundedbox',
                  enabled: _edit ? true : false,
                  controller: _nameController,
                  focusNode: _nameFocus,
                  onSubmitted: (text) {
                    FocusScope.of(context)
                        .requestFocus(_numberFocus);
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  border: true,
                  obscureText: false,
                  padding: 8,
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                    size: 6 * imageSizeMultiplier,
                    color: appColor,
                  ),
                  shadow: _edit,
                  suffixIcon: null,
                  text: 'Name',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: 2 * heightMultiplier),
                child: CustomTextBox(
                  type: 'roundedbox',
                  enabled: _edit ? true : false,
                  controller: _numberController,
                  onSubmitted: (text) {
                    FocusScope.of(context)
                        .requestFocus(_addressFocus);
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  border: true,
                  obscureText: false,
                  padding: 8,
                  prefixIcon: Icon(
                    Icons.contact_phone_rounded,
                    size: 6 * imageSizeMultiplier,
                    color: appColor,
                  ),
                  shadow: _edit,
                  suffixIcon: null,
                  text: 'Contact Number',
                  focusNode: _numberFocus,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: 2 * heightMultiplier),
                child: CustomTextBox(
                  type: 'roundedbox',
                  enabled: _edit ? true : false,
                  controller: _addressController,
                  onSubmitted: (text) {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  border: true,
                  obscureText: false,
                  padding: 8,
                  prefixIcon: Icon(
                    Icons.location_city,
                    size: 6 * imageSizeMultiplier,
                    color: appColor,
                  ),
                  shadow: _edit,
                  suffixIcon: null,
                  text: 'Address',
                  focusNode: _addressFocus,
                )
              ),
              if (_edit)
              FilledCustomButton(
                type: 'roundedbox',
                text: 'Save',
                color: appColor,
                onPressed: () {
                  _check();
                },
                padding: 8,
              )
            ],
          ),
        )
      )
    );
  }
}

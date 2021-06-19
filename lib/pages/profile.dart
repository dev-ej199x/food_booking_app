import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/filled-button.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/defaults/textbox.dart';
import 'package:http/http.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
    var response = await Http(url: 'user/profile', body: {
      'name': _nameController.text,
      'number': _numberController.text,
      'address': _addressController.text
    }).putWithHeader();
    if (response is String) {
      Navigator.pop(context);
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
        Navigator.pop(context);
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
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30 * heightMultiplier),
        child: Column(
          children: [
            AppBar(
              backgroundColor: appColor,
              elevation: 0,
              title: Padding(
                padding: EdgeInsets.only(top: 2 * heightMultiplier),
                child: Center(
                  child: CustomText(
                    text: 'Profile',
                    align:TextAlign.center,
                    color: Colors.white,
                    size: 5,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 13 * heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    color: Color(0xFFED1F56),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4 * heightMultiplier),
                  height: 18 * heightMultiplier,
                  width: 18 * heightMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.red),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 5,
                        color: Colors.white.withOpacity(.4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.red,
                    size: 14 * imageSizeMultiplier,
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Container(
                //     margin: EdgeInsets.only(top: 10 * heightMultiplier, right: 4 * widthMultiplier),
                //     width: 6 * heightMultiplier,
                //     height: 6 * heightMultiplier,
                //     decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(width: 3, color: !_edit ? Colors.white : Colors.red),
                //         color: !_edit ? Colors.red : Colors.white),
                //     child: IconButton(
                //         padding: EdgeInsets.only(
                //             bottom: 0 * heightMultiplier,
                //             right: 0 * widthMultiplier),
                //         iconSize: 18,
                //         onPressed: () {
                //           _edit = !_edit;
                //           setState(() {
                //             // _edit
                //             //     ? FocusScope.of(context)
                //             //         .requestFocus(_nameFocus)
                //             //     :
                //             FocusScope.of(context).unfocus();
                //           });
                //           _check();
                //           // if (_edit == true) {
                //           //   FocusScope.of(context)
                //           //       .requestFocus(_nameFocus);
                //           //   _edit = !_edit;
                //           // } else {
                //           //   FocusScope.of(context).unfocus();
                //           //   _edit = _edit;
                //           // }
                //         },
                //         icon: Icon(Icons.edit, size: 3 * heightMultiplier,),
                //         color: !_edit ? Colors.white : Colors.red)
                //   ),
                // ),
              ],
            ),
          ]
        ),
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
                      color: Colors.red,
                      size: 1.8,
                      text: _edit?'Cancle Edit':'Edit Profile',
                      weight: FontWeight.bold,
                    ),
                    Icon(
                      _edit?Icons.close_rounded:Icons.edit,
                      size: 4 * imageSizeMultiplier,
                      color: Colors.red,
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
                color: Colors.red,
              ),
              shadow: true,
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
                color: Colors.red,
              ),
              shadow: true,
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
                color: Colors.red,
              ),
              shadow: true,
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

            },
            padding: 8,
          )
        ],
      ),
    );
  }
}

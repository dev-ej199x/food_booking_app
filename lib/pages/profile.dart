import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF323232),
          content: Text('Fill all fields properly',
              textScaleFactor: .8,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 2.2 * Config.textMultiplier,
                  fontFamily: 'Poppins'))));
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
          content: Text(response,
              textScaleFactor: .8,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 2.2 * Config.textMultiplier,
                  fontFamily: 'Poppins'))));
    } else if (response is Response) {
      if (response.statusCode != 200) {
        Map<String, dynamic> body = json.decode(response.body);
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF323232),
            content: Text(body['message'],
                textScaleFactor: .8,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.2 * Config.textMultiplier,
                    fontFamily: 'Poppins'))));
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
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Color(0xffeb4d4d),
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(top: 2 * Config.heightMultiplier),
            child: Center(
              child: Text(
                'Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 5 * Config.textMultiplier,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Poppins',
                ),
                textScaleFactor: 1,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 19 * Config.heightMultiplier,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    color: Color(0xffeb4d4d),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 30 * Config.widthMultiplier,
                      top: 7 * Config.heightMultiplier),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: 20 * Config.heightMultiplier,
                        width: 45 * Config.widthMultiplier,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 3, color: Colors.red),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 5,
                              color: Colors.white,
                            ),
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/ProfileSample.png')),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 7 * Config.widthMultiplier,
                          height: 5 * Config.heightMultiplier,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3, color: Colors.white),
                              color: !_edit ? Colors.red : Colors.green),
                          child: IconButton(
                              padding: EdgeInsets.only(
                                  bottom: 0 * Config.heightMultiplier,
                                  right: 0 * Config.widthMultiplier),
                              iconSize: 18,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                _check();
                                setState(() {
                                  _edit = !_edit;
                                });
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 1 * Config.heightMultiplier),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 2 * Config.heightMultiplier),
                          child: Container(
                            alignment: Alignment.center,
                            height: 5.5 * Config.heightMultiplier,
                            width: 85 * Config.widthMultiplier,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    10 * Config.imageSizeMultiplier),
                              ),
                              border: Border.all(
                                width: 1.0,
                                color: const Color(0x40707070),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4 * Config.widthMultiplier),
                                  child: Image.asset(
                                    Images.profileSample,
                                    height: 5 * Config.heightMultiplier,
                                    width: 5 * Config.imageSizeMultiplier,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    enabled: _edit ? true : false,
                                    controller: _nameController,
                                    focusNode: _nameFocus,
                                    onFieldSubmitted: (text) {
                                      FocusScope.of(context)
                                          .requestFocus(_numberFocus);
                                    },
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                            hintText: 'Name',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontFamily: 'Metropolis',
                                                color: Color(0xFFB6B7B7),
                                                fontSize:
                                                    1.8 * Config.textMultiplier,
                                                fontWeight: FontWeight.normal))
                                        .copyWith(isDense: true),
                                    style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        color: Colors.black,
                                        fontSize: 1.8 * Config.textMultiplier,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 2 * Config.heightMultiplier),
                          child: Container(
                            alignment: Alignment.center,
                            height: 5.5 * Config.heightMultiplier,
                            width: 85 * Config.widthMultiplier,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                    10 * Config.imageSizeMultiplier),
                              ),
                              border: Border.all(
                                width: 1.0,
                                color: const Color(0x40707090),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4 * Config.widthMultiplier),
                                  child: Icon(
                                    Icons.contact_phone_rounded,
                                    size: 4 * Config.imageSizeMultiplier,
                                    color: Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    enabled: _edit ? true : false,
                                    controller: _numberController,
                                    onFieldSubmitted: (text) {
                                      FocusScope.of(context)
                                          .requestFocus(_addressFocus);
                                    },
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                            hintText: 'Number',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontFamily: 'Metropolis',
                                                color: Color(0xFFB6B7B7),
                                                fontSize:
                                                    1.8 * Config.textMultiplier,
                                                fontWeight: FontWeight.normal))
                                        .copyWith(isDense: true),
                                    style: TextStyle(
                                        fontFamily: 'Metropolis',
                                        color: Colors.black,
                                        fontSize: 1.8 * Config.textMultiplier,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 5.5 * Config.heightMultiplier,
                          width: 85 * Config.widthMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10 * Config.imageSizeMultiplier),
                            ),
                            border: Border.all(
                              width: .2 * Config.widthMultiplier,
                              color: const Color(0x40707090),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4 * Config.widthMultiplier),
                                child: Icon(
                                  Icons.location_city,
                                  size: 4 * Config.imageSizeMultiplier,
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  enabled: _edit ? true : false,
                                  controller: _addressController,
                                  onFieldSubmitted: (text) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                          hintText: 'Adress',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              fontFamily: 'Metropolis',
                                              color: Color(0xFFB6B7B7),
                                              fontSize:
                                                  1.8 * Config.textMultiplier,
                                              fontWeight: FontWeight.normal))
                                      .copyWith(isDense: true),
                                  style: TextStyle(
                                      fontFamily: 'Metropolis',
                                      color: Colors.black,
                                      fontSize: 1.8 * Config.textMultiplier,
                                      fontWeight: FontWeight.normal),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 55.0 * Config.heightMultiplier),
                  child: Container(
                    alignment: Alignment.center,
                    height: 5 * Config.heightMultiplier,
                    width: 50 * Config.widthMultiplier,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0)),
                      color: Color(0xffeb4d4d),
                    ),
                    child: Text(
                      'Purchase History',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: Colors.white,
                        fontSize: 2 * Config.textMultiplier,
                        fontWeight: FontWeight.bold,
                      ),
                      textScaleFactor: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:food_booking_app/defaults/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'config.dart';
import 'images.dart';

class Http {
  SharedPreferences _sharedPreferences;
  // String ip = 'http://192.168.1.10:8000';
  // String ip = 'http://192.168.68.110:8000';
  String ip = 'http://139.59.75.22';
  // String ip = 'http://192.168.1.75:8000';
  // String ip = 'http://192.168.1.109:8000';
  final String url;
  final dynamic body;
  
  Http({this.url, this.body});

  postWithHeader() async {
    var _response;
    try{
      _sharedPreferences = await SharedPreferences.getInstance();
      await http.post('$ip/api/v1/$url',
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ' + _sharedPreferences.getString('token')
      }).then((response) {
        _response = response;
      });
    }
    on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  postNoHeader() async {
    var _response;
    try{
      await http.post('$ip/api/v1/$url',
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
      }).then((response) {
        _response = response;
      });
    }
    on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  putWithHeader() async {
    var _response;
    try{
      _sharedPreferences = await SharedPreferences.getInstance();
      await http.put('$ip/api/v1/$url',
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ' + _sharedPreferences.getString('token')
      }).then((response) {
        _response = response;
      });
    }
    on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  putNoHeader() async {
    var _response;
    try{
      await http.put('$ip/api/v1/$url',
      body: body).then((response) {
        _response = response;
      });
    }
    on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  getWithHeader() async {
    var _response;
    try{
      _sharedPreferences = await SharedPreferences.getInstance();
      await http.get('$ip/api/v1/$url',
      headers: {
        'Accept': 'application/json',
        'authorization': 'Bearer ' + _sharedPreferences.getString('token')
      }).then((response) {
        _response = response;
      });
    }
    on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  getNoHeader() async {
    var _response;
    try{
      await http.get('$ip/api/v1/$url')
      .then((response) {
        _response = response;
      });
    }
    on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  showNoConnection(String text, GlobalKey<ScaffoldState> key) {
    key.currentState.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF323232),
        content: Text(
          text,
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

  logout() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    var response = await Http(url: 'logout', body: null).postWithHeader();
    _sharedPreferences.clear();
    _sharedPreferences.setBool('not-first-open', false);
    return response;
  }

  // showLoadingOverlay(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => WillPopScope(
  //       onWillPop: () {
  //         Navigator.pop(context);
  //       },
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           height: 40 * imageSizeMultiplier,
  //           width: 20 * imageSizeMultiplier,
  //           color: Colors.transparent,
  //           child: Center(
  //             child: Container(
  //               height: 10 * imageSizeMultiplier,
  //               width: 10 * imageSizeMultiplier,
  //               child: CircularProgressIndicator(),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  showLoadingOverlay(BuildContext context){
    showDialog(
      barrierColor: Colors.black.withOpacity(.6),
      context: context,
      // barrierDismissible: false,
      barrierDismissible: true,
      builder: (_) => WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Center(
            child: Container(
              height: 23 * imageSizeMultiplier,
              width: 23 * imageSizeMultiplier,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2 * imageSizeMultiplier)
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 23 * imageSizeMultiplier,
                    width: 23 * imageSizeMultiplier,
                    child: CircularProgressIndicator(backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation<Color>(appColor.withOpacity(.6)), strokeWidth: 3 * imageSizeMultiplier)
                  ),
                  Container(
                    height: 20 * imageSizeMultiplier,
                    width: 20 * imageSizeMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10 * imageSizeMultiplier),
                    ),
                  ),
                  Container(
                    height: 14 * imageSizeMultiplier,
                    width: 14 * imageSizeMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10 * imageSizeMultiplier),
                      image: DecorationImage(
                        scale: .1,
                        image: AssetImage(
                          Images.iconImage,
                          // height: 12 * Config.imageSizeMultiplier,
                          // width: 12 * imageSizeMultiplier,
                        ),
                        fit: BoxFit.fitWidth
                      )
                    ),
                  ),
                ]
              )
            )
          )
        )
      )
    );
  }
}
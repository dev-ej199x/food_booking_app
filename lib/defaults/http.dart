import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Http {
  SharedPreferences _sharedPreferences;
  // String ip = 'http://192.168.1.109:8000';
  final String url;
  final dynamic body;

  Http({this.url, this.body});

  postWithHeader() async {
    var _response;
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await http.post('https://reqres.in/api/$url', body: json.encode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ' + _sharedPreferences.getString('token')
      }).then((response) {
        _response = response;
      });
    } on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  postNoHeader() async {
    var _response;
    try {
      await http.post('https://reqres.in/api/$url', body: body).then((response) {
        _response = response;
      });
    } on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  patchWithHeader() async {
    var _response;
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await http.patch('https://reqres.in/api/$url', body: json.encode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ' + _sharedPreferences.getString('token')
      }).then((response) {
        _response = response;
      });
    } on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  putWithHeader() async {
    var _response;
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await http.put('https://reqres.in/api/$url', body: json.encode(body), headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer ' + _sharedPreferences.getString('token')
      }).then((response) {
        _response = response;
      });
    } on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  putNoHeader() async {
    var _response;
    try {
      await http.put('https://reqres.in/api/$url', body: body).then((response) {
        _response = response;
      });
    } on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  getWithHeader() async {
    var _response;
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      await http.get('https://reqres.in/api/$url', headers: {
        'Accept': 'application/json',
        'authorization': 'Bearer ' + _sharedPreferences.getString('token')
      }).then((response) {
        _response = response;
      });
    } on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  getNoHeader() async {
    var _response;
    try {
      await http.get('https://reqres.in/api/$url').then((response) {
        _response = response;
      });
    } on SocketException {
      _response = 'Please check your connection.';
    }
    return _response;
  }

  showLoadingOverlay(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
            onWillPop: () {
              Navigator.pop(context);
            },
            child: Material(
              type: MaterialType.transparency,
            )));
  }
}

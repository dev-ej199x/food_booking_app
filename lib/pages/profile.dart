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
        print(response.body);
        Navigator.pop(context);
        Map<String, dynamic> body = json.decode(response.body);
        setState(() {
          _nameController.text = body['user']['name'];
          _numberController.text = body['user']['number'];
          _addressController.text = body['user']['address'];
        });
        print(_nameController.text);
      }
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
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 190.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    color: Color(0xffeb4d4d),
                  ),
                ),
                Container(
                  height: 37 * Config.heightMultiplier,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 140,
                    backgroundColor: Colors.red,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(Images.profileSample),
                      radius: 130.0,
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 14 * Config.heightMultiplier),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 2 * Config.heightMultiplier),
                        child: Container(
                          alignment: Alignment.topCenter,
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10 * Config.imageSizeMultiplier),
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
                                  onFieldSubmitted: (text) {},
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
                          alignment: Alignment.topCenter,
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10 * Config.imageSizeMultiplier),
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
                                child: Image.asset(
                                  Images.profileSample,
                                  height: 5 * Config.heightMultiplier,
                                  width: 5 * Config.imageSizeMultiplier,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  enabled: _edit ? true : false,
                                  controller: _numberController,
                                  focusNode: _nameFocus,
                                  onFieldSubmitted: (text) {},
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
                        alignment: Alignment.topCenter,
                        height: 40,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10 * Config.imageSizeMultiplier),
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
                              child: Image.asset(
                                Images.profileSample,
                                height: 5 * Config.heightMultiplier,
                                width: 5 * Config.imageSizeMultiplier,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                enabled: _edit ? true : false,
                                controller: _addressController,
                                focusNode: _nameFocus,
                                onFieldSubmitted: (text) {},
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
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

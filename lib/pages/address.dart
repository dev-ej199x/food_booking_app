import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  //  Map<String, dynamic> details;
  // int index;

  // AddressScreen({Key key, @required this.details, @required this.index}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // Completer<GoogleMapController> _mapController = Completer();

  // SharedPreferences _sharedPreferences;

  // FocusNode _noteFocus = FocusNode();

  // TextEditingController _addressController = TextEditingController();
  // TextEditingController _noteController = TextEditingController();

  // int _selectedLabel = -1;
  // final Set<Marker> _markers = {};

  // CameraPosition _userLocation = CameraPosition(
  //   target: LatLng(15.0387778, 120.6792002),
  //   zoom: 17,
  // );

  Marker marker;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
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
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(Images.addressBack),
                fit: BoxFit.fill,
              )),
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15 * heightMultiplier),
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                          text: 'Welcome to',
                            size: 3,
                            color: Colors.white,
                            weight: FontWeight.bold,
                            align: TextAlign.left,
                          ),
                          CustomText(
                          text: 'Food Booking App',
                            size: 5,
                            color: Colors.white,
                            weight: FontWeight.bold,
                            align: TextAlign.left,
                          ),
                          CustomText(
                          text: 'Want\'s to know your location',
                            size: 2,
                            color: Colors.white,
                            weight: FontWeight.bold,
                            align: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 0 * heightMultiplier),
                            child: ButtonTheme(
                              minWidth: 280.0,
                              height: 37.0,
                              splashColor: Colors.white,
                              child: RaisedButton(
                                color: const Color(0xffeb4d4d),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                
                                ),
                                onPressed: () {},
                                child: CustomText(
                                  text: "Use my Current Location",
                                  color: Colors.white,
                                  weight: FontWeight.bold,
                                  align: TextAlign.left,
                                  size: 1.8,
                                )
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: ButtonTheme(
                              minWidth: 230.0,
                              height: 37.0,
                              splashColor: Color(0xffeb4d4d),
                              child: RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.0),
                                  
                                ),
                                onPressed: () {},
                                child: CustomText(
                                  text: "Select Manually",
                                  color: Color(0xffeb4d4d),
                                  weight: FontWeight.bold,
                                  align: TextAlign.left,
                                  size: 1.8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        )
      ),
    );
  }
}

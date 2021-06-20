import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  RefreshController _refreshController = RefreshController();
  List _orders = [];
  bool _loading = true;

  @override
  void initState() { 
    super.initState();
    _getOrders();
  }
  
  _getOrders() async {
    var response =
        await Http(url: 'orderRequests', body: {})
            .getWithHeader();

    if (response is String) {
      setState(() {
        _loading = false;
      });
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
      print(response.body);
      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
        });
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
        print(response.body);

        setState(() {
          _orders.clear();
          _orders = json.decode(response.body)['orderRequest'];
          _loading = false;
          _refreshController.refreshCompleted();
        });
        print(_orders[0]['status']);
      }
    }
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
            preferredSize: Size.fromHeight(16 * heightMultiplier),
            child: Container(
              alignment: Alignment.center,
              height: 16 * heightMultiplier,
              width: 100 * widthMultiplier,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0)),
                color: appColor,
              ),
              child: SafeArea(
                child: CustomText(
                  text: 'Orders',
                  size: 3,
                  weight: FontWeight.bold,
                  align: TextAlign.left,
                  color: Colors.white,
                ),
              )
            ),
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).unfocus();
              _scaffoldKey.currentState.removeCurrentSnackBar();
            },
            child: SmartRefresher(
              enablePullDown: !_loading,
              onRefresh: () {
                _getOrders();
              },
              physics: BouncingScrollPhysics(),
              header: CustomHeader(builder: (context, status) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10 * imageSizeMultiplier,
                      color: appColor
                    ),
                    SizedBox(
                      height: 3 * imageSizeMultiplier,
                      width: 3 * imageSizeMultiplier,
                      child: CircularProgressIndicator(
                        strokeWidth: .2 * imageSizeMultiplier,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    )
                  ]
                );
              }),
              controller: _refreshController,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_orders.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          text: 'No orders to show',
                          align: TextAlign.left,
                          color: Colors.black,
                          size: 1.8,
                          weight: FontWeight.bold,
                        )
                      )
                    )
                    else
                    for (var order in _orders)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                        width: 100 * widthMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2 * imageSizeMultiplier),
                          color: Color(0xFF2D2A2A)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 4 * widthMultiplier),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: order['restaurant']['image'],
                                    fit: BoxFit.cover,
                                    height: 30 * imageSizeMultiplier,
                                    width: 30 * imageSizeMultiplier,
                                  ),
                                ]
                              )
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: order['restaurant']['name'],
                                    align: TextAlign.left,
                                    color: Colors.white,
                                    size: 2,
                                    weight: FontWeight.bold,
                                  ),
                                  CustomText(
                                    text: '₱ ${order['grand_total'].toStringAsFixed(2)}',
                                    align: TextAlign.left,
                                    color: Colors.white,
                                    size: 1.6,
                                    weight: FontWeight.normal,
                                  ),
                                  CustomText(
                                    text: '${order['booking_date']} ${order['booking_time']}',
                                    align: TextAlign.left,
                                    color: Colors.white,
                                    size: 1.6,
                                    weight: FontWeight.normal,
                                  ),
                                  CustomText(
                                    text: order['status']['name'],
                                    align: TextAlign.left,
                                    color: order['status']['name'] == 'DELIVERED'?Colors.green:Colors.red,
                                    size: 1.6,
                                    weight: FontWeight.normal,
                                  ),
                                ]
                              )
                            )
                          ],
                        ),
                      )
                    )
                  ]
                )
              )
            )
          )
        )
      )
    );
  }
}

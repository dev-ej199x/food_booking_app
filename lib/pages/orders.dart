import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/button.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/pages/viewOrder.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getOrders();
    });
  }
  
  _getOrders() async {
    Http().showLoadingOverlay(context);
    var response =
        await Http(url: 'orderRequests', body: {})
            .getWithHeader();

    if (response is String) {
      setState(() {
        _loading = false;
        Navigator.pop(context);
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
      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
          Navigator.pop(context);
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

        setState(() {
          _orders.clear();
          _orders = json.decode(response.body)['orderRequest'];
          _loading = false;
          Navigator.pop(context);
          _refreshController.refreshCompleted();
        });
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
            preferredSize: Size.fromHeight(6 * heightMultiplier),
            child: Ink(
              width: 100 * widthMultiplier,
              color: Colors.white,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 2 * heightMultiplier),
                  child: CustomText(
                    color: appColor,
                    align: TextAlign.center,
                    size: 3,
                    text: 'ORDERS',
                    weight: FontWeight.bold,
                  )
                )
              ),
            )
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
              header: MaterialClassicHeader(),
              // header: CustomHeader(builder: (context, status) {
              //   return Stack(
              //     alignment: Alignment.center,
              //     children: [
              //       Icon(
              //         Icons.circle,
              //         size: 10 * imageSizeMultiplier,
              //         color: appColor
              //       ),
              //       SizedBox(
              //         height: 3 * imageSizeMultiplier,
              //         width: 3 * imageSizeMultiplier,
              //         child: CircularProgressIndicator(
              //           strokeWidth: .2 * imageSizeMultiplier,
              //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              //         )
              //       )
              //     ]
              //   );
              // }),
              controller: _refreshController,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_loading)
                    Container()
                    else
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
                          weight: FontWeight.normal,
                        )
                      )
                    )
                    else
                    for (var order in _orders)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                      child: CustomButton(
                        height: 0,
                        minWidth: 0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(Colors.black12.withOpacity(0.05)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(1 * imageSizeMultiplier)
                              ),
                            ),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            alignment: Alignment.center,
                          ),
                          onPressed: () {
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ViewOrderScren(details: order,)))
                            .then((response) {
                              _getOrders();
                            });
                          },
                          child: Ink(
                            color: Colors.white,
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
                                        color: Colors.black,
                                        size: 1.8,
                                        weight: FontWeight.bold,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 0.5 * heightMultiplier),
                                        child: CustomText(
                                          text: '₱  ${order['grand_total'].toStringAsFixed(2)}',
                                          align: TextAlign.left,
                                          color: Colors.black,
                                          size: 1.4,
                                          weight: FontWeight.normal,
                                        )
                                      ),
                                      CustomText(
                                        text: '${DateFormat('MMMM dd, yyyy').format(DateFormat('yyyy-MM-dd').parse(order['booking_date'].toString()))} ${DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(order['booking_time'].toString()))}',
                                        align: TextAlign.left,
                                        color: Colors.black,
                                        size: 1.4,
                                        weight: FontWeight.normal,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 0.5 * heightMultiplier),
                                        child: CustomText(
                                          text: order['status']['name'],
                                          align: TextAlign.left,
                                          color: order['status']['name'] == 'DELIVERED'?Colors.green:Colors.red,
                                          size: 1.6,
                                          weight: FontWeight.normal,
                                        )
                                      ),
                                    ]
                                  )
                                )
                              ],
                            ),
                          )
                        )
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

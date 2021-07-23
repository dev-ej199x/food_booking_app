import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/http.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  RefreshController _refreshController = RefreshController();
  List _notifications = [];
  bool _loading = true;

  @override
  void initState() { 
    super.initState();
    _getNotifications();
  }
  
  _getNotifications() async {
    var response =
        await Http(url: 'notifications', body: {})
            .getWithHeader();

            print(response.body);

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
          _notifications = List.from(json.decode(response.body));
          _loading = false;
        });
        print(_notifications);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
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
                padding: EdgeInsets.only(right: 4 * widthMultiplier),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    IconButton(
                      splashColor: Colors.black12.withOpacity(0.05),
                      hoverColor: Colors.black12.withOpacity(0.05),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 6 * imageSizeMultiplier,
                        color: appColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4 * widthMultiplier,),
                      child: Align(
                        alignment: Alignment.center,
                        child: CustomText(
                          color: appColor,
                          align: TextAlign.center,
                          size: 3,
                          text: 'Notification',
                          weight: FontWeight.bold,
                        )
                      )
                    )
                  ]
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
              setState(() {
                _notifications.clear();
                _loading = true;
              });
              _getNotifications();
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
                  if (_notifications.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                    child: Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        text: 'No notifications to show',
                        align: TextAlign.left,
                        color: Colors.black,
                        size: 1.8,
                        weight: FontWeight.normal,
                      )
                    )
                  )
                  else
                  for (var notif in _notifications)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2 * heightMultiplier, horizontal: 4 * widthMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: notif['data']['title'],
                          align: TextAlign.left,
                          color: Colors.black,
                          size: 2,
                          weight: FontWeight.bold,
                        ),
                        CustomText(
                          text: notif['data']['body'],
                          align: TextAlign.left,
                          color: Color(0xFF222455).withOpacity(.5),
                          size: 1.8,
                          weight: FontWeight.normal,
                        ),
                      ],
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}

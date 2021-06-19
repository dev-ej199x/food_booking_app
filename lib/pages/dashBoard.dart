import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/appbar.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/text.dart';
import 'package:food_booking_app/pages/homePage.dart';
import 'package:food_booking_app/pages/navigation.dart';
import 'package:food_booking_app/pages/notification.dart';
import 'package:food_booking_app/pages/profile.dart';
import 'package:food_booking_app/pages/search.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'orderCart.dart';
import 'orders.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  int _selectedItemIndex = 0;
  PageController _dashBoardController = PageController(initialPage: 0);

  _logout() async {
    SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
    _sharedPreference.clear();
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: LoginScreen(
            from: null,
          )
        ),
        (route) => false
      );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
            _scaffoldKey.currentState.removeCurrentSnackBar();
          },
          child: Stack(
            children: [
              PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _dashBoardController,
                itemCount: 5,
                onPageChanged: (page) {
                  setState(() {
                    _selectedItemIndex = page;
                  });
                },
                itemBuilder: (BuildContext context, int itemIndex) {
                  return buildBody(itemIndex);
                }
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 8 * heightMultiplier,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // color: appColor,
                    // borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                    boxShadow: [
                      BoxShadow(color: Color(0xFF707070).withOpacity(.3), blurRadius: 0.6 * imageSizeMultiplier, offset: Offset(0, -0.6))
                    ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // buildNavBarItem(Icons.notifications_active_outlined, 0, 'Notifications'),
                      buildNavBarItem(Icons.list_alt_outlined, 0, 'Browse'),
                      buildNavBarItem(Icons.search_outlined, 1, 'Search'),
                      buildNavBarItem(Icons.receipt_long_outlined, 2, 'Orders'),
                      buildNavBarItem(Icons.person_outline, 3, 'Account'),
                      // buildNavBarItem(Icons.logout, 4, 'Logout'),
                    ],
                  ),
                )
              )
            ]
          )
        )
      )
    );
  }

  buildBody(int index) {
    switch (index) {
      // case 0:
      // //   return NavigationScreen();
      // //   break;
      // // case 1:
      //   return NotificationPage();
      //   break;
      case 0:
        return HomePage();
        break;
      case 1:
        return SearchScreen();
        break;
      case 2:
        return OrdersScreen();
        break;
      case 3:
        return Profile();
        break;
    }
  }

  Widget buildNavBarItem(IconData icon, int index, String text) {
    return FlatButton(
      onPressed: () {
        // if (index == 4) {
        //   _logout();
        // }
        // else {
          setState(() {
            _selectedItemIndex = index;
            _dashBoardController.jumpToPage(index);
          });
        // }
      },
      height: 14 * imageSizeMultiplier,
      minWidth: 10 * imageSizeMultiplier,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedItemIndex == index?appColor:Colors.black26,
            size: 6 * imageSizeMultiplier,
            // size: (index == _selectedItemIndex ? 8 : 6) * imageSizeMultiplier,
          ),
          CustomText(
            text: text, 
            color:  _selectedItemIndex == index?appColor:Colors.black26,
            size: 1.2, 
            weight: FontWeight.normal, 
            align: TextAlign.center
          )
        ]
      )
    );
  }
}

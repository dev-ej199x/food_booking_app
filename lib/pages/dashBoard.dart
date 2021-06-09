import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/appbar.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/pages/homePage.dart';
import 'package:food_booking_app/pages/navigation.dart';
import 'package:food_booking_app/pages/notification.dart';
import 'package:food_booking_app/pages/profile.dart';
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
  int _selectedItemIndex = 2;
  PageController _dashBoardController = PageController(initialPage: 2);

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
          child: PageView.builder(
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
        ),
        bottomNavigationBar: Row(
          children: <Widget>[
            // buildNavBarItem(Icons.assistant_navigation, 0),
            buildNavBarItem(Icons.notifications_active_outlined, 0),
            buildNavBarItem(Icons.fact_check_rounded, 1),
            buildNavBarItem(Icons.home, 2),
            buildNavBarItem(Icons.person_outline, 3),
            buildNavBarItem(Icons.logout, 4),
          ],
        ),
      )
    );
  }

  buildBody(int index) {
    switch (index) {
      case 0:
      //   return NavigationScreen();
      //   break;
      // case 1:
        return NotificationPage();
        break;
      case 1:
        return OrdersScreen();
        break;
      case 2:
        return HomePage();
        break;
      case 3:
        return Profile();
        break;
    }
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return FlatButton(
      onPressed: () {
        if (index == 4) {
          _logout();
        }
        else {
          setState(() {
            _selectedItemIndex = index;
            _dashBoardController.jumpToPage(index);
          });
        }
      },
      height: 60,
      minWidth: MediaQuery.of(context).size.width / 5,
      color: index == _selectedItemIndex ? Colors.white : Color(0xffeb4d4d),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Icon(
        icon,
        size: (index == _selectedItemIndex ? 8 : 6) * imageSizeMultiplier,
      )
    );
  }
}

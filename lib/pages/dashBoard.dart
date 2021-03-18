import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/appbar.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/pages/homePage.dart';
import 'package:food_booking_app/pages/navigation.dart';
import 'package:food_booking_app/pages/notification.dart';
import 'package:food_booking_app/pages/profile.dart';

import 'cart.dart';
import 'orderCart.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedItemIndex = 2;
  PageController _dashBoardController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: PageView.builder(
          controller: _dashBoardController,
          itemCount: 5,
          onPageChanged: (page) {
            setState(() {
              _selectedItemIndex = page;
            });
          },
          itemBuilder: (BuildContext context, int itemIndex) {
            return buildBody(itemIndex);
          }),
      bottomNavigationBar: Row(
        children: <Widget>[
          buildNavBarItem(Icons.assistant_navigation, 0),
          buildNavBarItem(Icons.notifications_active_outlined, 1),
          buildNavBarItem(Icons.home, 2),
          buildNavBarItem(Icons.shopping_cart_outlined, 3),
          buildNavBarItem(Icons.person_outline, 4),
        ],
      ),
    );
  }

  buildBody(int index) {
    switch (index) {
      case 0:
        return NavigationScreen();
        break;
      case 1:
        return NotificationPage();
        break;
      case 2:
        return HomePage();
        break;
      case 3:
        return OrderCart();
        break;
      case 4:
        return Profile();
        break;
    }
  }

  Widget buildNavBarItem(
    IconData icon,
    int index,
  ) {
    return FlatButton(
        onPressed: () {
          setState(() {
            _selectedItemIndex = index;
            _dashBoardController.jumpToPage(index);
          });
        },
        height: 60,
        minWidth: MediaQuery.of(context).size.width / 5,
        color: index == _selectedItemIndex ? Colors.white : Color(0xffeb4d4d),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Icon(
          icon,
          size: (index == _selectedItemIndex ? 10 : 6) *
              Config.imageSizeMultiplier,
        ));
  }
}

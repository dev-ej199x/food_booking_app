import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarScreen extends StatefulWidget {
  @override
  _AppBarStateScreen createState() => _AppBarStateScreen();
}

class _AppBarStateScreen extends State<AppBarScreen>{


  // Size get preferredSize => Size.fromHeight(height);
  int _selectedItemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  Row(
        children: <Widget> [

          buildNavBarItem(Icons.assistant_navigation,0),
          buildNavBarItem(Icons.notifications_active_outlined, 1),
          buildNavBarItem(Icons.home,2),
          buildNavBarItem(Icons.shopping_cart_outlined,3),
          buildNavBarItem(Icons.person_outline,4),
        ],
      );
  }

  Widget buildNavBarItem(IconData icon,int index,) {
    return GestureDetector(
      onTap: (){
        setState((){
          _selectedItemIndex = index;
        });
      },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width/5,
            decoration: BoxDecoration(
              color: index ==  _selectedItemIndex ? Colors.white: Color(0xFFED1F56),
            ),
            child: Icon(icon)
          ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List _orderLogo = [
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    },
    {
      "image": "assets/images/OrderLogo.png",
    }
  ];

  String dropdownValue = 'Beef';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Color(0xffeb4d4d),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Expanded(
          // child:
          Column(
            children: <Widget>[
              // child:
              Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)),
                    color: Color(0xffeb4d4d),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: 1 * Config.heightMultiplier),
                        child: Container(
                          width: 85 * Config.widthMultiplier,
                          height: 40.0,
                          margin: EdgeInsets.only(top: 10.0),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey[800]),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.grey[800]),
                              hintText: ('Search Restaurant'),
                              hintStyle: TextStyle(
                                color: Colors.grey[800],
                                fontFamily: 'Segoe UI',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(1 * Config.imageSizeMultiplier),
                        child: Image.asset('assets/images/Group 22.png'),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 2.7 * Config.heightMultiplier),
                    child: Text(
                      'Variations',
                      style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5 * Config.widthMultiplier),
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      height: 1 * Config.heightMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.orange[800],
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>[
                      'Beef',
                      'Chicken',
                      'Pork',
                      'Vegies',
                      'Apetizer',
                      'Salad',
                      'Dessert'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _orderLogo.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 10.0,
                      // child: Column(
                      //   children: [
                      child: Hero(
                        tag: _orderLogo[index]['name'],
                        child: Column(
                          children: [
                            GridTile(
                              child: Image.asset(
                                _orderLogo[index]['image'],
                                fit: BoxFit.cover,
                                width: 200,
                                height: 140,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //   ],
                      // ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

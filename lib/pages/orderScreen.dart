import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String dropdownValue = '';
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
        ),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child:
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
                                icon:
                                    Icon(Icons.search, color: Colors.grey[800]),
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
                          padding:
                              EdgeInsets.all(1 * Config.imageSizeMultiplier),
                          child: Container(
                            height: 110,
                            width: 230,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey[800]),
                              image: DecorationImage(
                                  image: AssetImage(Images.orderBanner),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Variations',
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 3.0)),
                      Expanded(
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          height: 4 * Config.heightMultiplier,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(1),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Beef',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 1 * Config.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Pork',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 1 * Config.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Chicken',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 1 * Config.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                  'One',
                                  'Two',
                                  'Free',
                                  'Four'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

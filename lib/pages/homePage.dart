// import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

_createAlertDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xff484545),
          content: Form(
            child: Row(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'On the Go',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Text(
                    'OR',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins'),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'Book',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

class _HomePageState extends State<HomePage> {
  final List _sampleOrderInfo = [
    {
      "name": "Open",
      "vacancy": "Vacant",
      "time": "Time",
      "distance": "Km",
    }
  ];
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            children: <Widget>[
              Container(
                height: 100.0,
                width: double.infinity,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    enlargeCenterPage: false,
                    viewportFraction: 1,
                    autoPlay: true,
                  ),
                  items: [
                    Image.asset(
                      'assets/images/Mask Group 2.png',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                    Image.asset(
                      'assets/images/Restaurant.jpg',
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return i;
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: Container(
                  height: 40.0,
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
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
              // Establishment Banner
              SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Featured Restaurant',
                                style: TextStyle(
                                    fontSize: 2 * Config.textMultiplier,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff707070)),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'See All Featured',
                                  style: TextStyle(
                                      fontSize: 1 * Config.textMultiplier,
                                      fontFamily: 'Segoe UI',
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff707070)),
                                ),
                              ),
                            ]),
                      ),
                      // featured restaurant information
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          child: CarouselSlider(
                            options: CarouselOptions(
                                enlargeCenterPage: true, viewportFraction: .7),
                            items: [
                              Image.asset(
                                'assets/images/CoffeeShop.png',
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                              Image.asset(
                                'assets/images/Restaurant.jpg',
                                fit: BoxFit.fill,
                                width: double.infinity,
                              ),
                              Image.asset(
                                'assets/images/Pastry.jpg',
                                fit: BoxFit.fill,
                                width: double.infinity,
                              )
                            ].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return i;
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Nearby Restaurants',
                              style: TextStyle(
                                  fontSize: 2 * Config.textMultiplier,
                                  fontFamily: 'Segoe UI',
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xff707070)),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'See All Nearby',
                                style: TextStyle(
                                    fontSize: 1 * Config.textMultiplier,
                                    fontFamily: 'Segoe UI',
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xff707070)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 200.0,
                        width: 400.0,
                        padding: EdgeInsets.all(5.0),
                        // child: GestureDetector(
                        //   onTap: () {
                        //     _createAlertDialog(context);
                        //   },
                        child: Expanded(
                          child: ListView.builder(
                            itemCount: _sampleOrderInfo.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  vertical: 2 * Config.heightMultiplier,
                                  horizontal: 3 * Config.widthMultiplier),
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  color: Color(0xff707070),
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2 * Config.heightMultiplier,
                                      horizontal: 3 * Config.widthMultiplier),
                                  child: Row(
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width:
                                                2 * Config.imageSizeMultiplier,
                                            height:
                                                2 * Config.imageSizeMultiplier,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    Images.sampleOrderBanner),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    _sampleOrderInfo[index]
                                                        .name,
                                                    style: TextStyle(
                                                      fontSize: 1 *
                                                          Config.textMultiplier,
                                                      fontFamily: 'Segoe UI',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    'At',
                                                    style: TextStyle(
                                                      fontSize: 1 *
                                                          Config.textMultiplier,
                                                      fontFamily: 'Segoe UI',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    _sampleOrderInfo[index]
                                                        .time,
                                                    style: TextStyle(
                                                      fontSize: 1 *
                                                          Config.textMultiplier,
                                                      fontFamily: 'Segoe UI',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                _sampleOrderInfo[index].vacant,
                                                style: TextStyle(
                                                  fontSize:
                                                      1 * Config.textMultiplier,
                                                  fontFamily: 'Segoe UI',
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                      child: Row(
                                        children: <Widget>[
                                          SmoothStarRating(
                                          ),
                                          Text(
                                                _sampleOrderInfo[index].distance,
                                                style: TextStyle(
                                                  fontSize:
                                                      1 * Config.textMultiplier,
                                                  fontFamily: 'Segoe UI',
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                        ],
                                      ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

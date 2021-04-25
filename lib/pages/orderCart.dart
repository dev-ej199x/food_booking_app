import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';

class OrderCart extends StatefulWidget {
  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  TextEditingController _noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color(0xffeb4d4d),
          title: Center(
            child: Text(
              'CART',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 5 * Config.textMultiplier,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontFamily: 'Poppins',
              ),
              textScaleFactor: 1,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1 * Config.widthMultiplier),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 30 * Config.heightMultiplier,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20 * Config.heightMultiplier),
              child: Divider(
                height: 4 * Config.heightMultiplier,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 22 * Config.heightMultiplier),
              child: Container(
                height: 28 * Config.heightMultiplier,
                child: ListView(
                  shrinkWrap: false,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * Config.heightMultiplier),
                      child: CardItem(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * Config.heightMultiplier),
                      child: CardItem(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * Config.heightMultiplier),
                      child: CardItem(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1 * Config.heightMultiplier),
                      child: CardItem(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 48 * Config.heightMultiplier),
              child: Divider(
                height: 4 * Config.heightMultiplier,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 52 * Config.heightMultiplier),
              child: Container(
                height: 20 * Config.heightMultiplier,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 2,
                            controller: _noteController,
                            decoration: InputDecoration(
                              labelText: 'NOTE',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 2 * Config.textMultiplier),
                              hintText: 'YOUR NOTE',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[700]),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffFF6347),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4 * Config.widthMultiplier),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 1 * Config.widthMultiplier,
                                  ),
                                  child: Text(
                                    'Grand Total: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 1.8 * Config.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                    textScaleFactor: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 2 * Config.heightMultiplier),
                                  child: Text(
                                    'Sub Fee: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 1.8 * Config.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                    textScaleFactor: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 2 * Config.heightMultiplier),
                                  child: Text(
                                    'Booking Fee: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 1.8 * Config.textMultiplier,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Poppins',
                                    ),
                                    textScaleFactor: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: .2 * Config.heightMultiplier),
                      child: Text(
                        'Preparation Time: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 1.8 * Config.textMultiplier,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Poppins',
                        ),
                        textScaleFactor: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 69 * Config.heightMultiplier),
              child: RaisedButton(
                onPressed: () {},
                child: Text(
                  ' PROCEED ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 2.4 * Config.textMultiplier,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Poppins',
                  ),
                  textScaleFactor: 1,
                ),
                color: Config.appColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 11 * Config.heightMultiplier,
            width: 22 * Config.widthMultiplier,
            padding: EdgeInsets.all(2 * Config.imageSizeMultiplier),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(5 * Config.imageSizeMultiplier),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 3 * Config.widthMultiplier),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 27 * Config.widthMultiplier,
                child: Text(
                  'Product Name and thier Price',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 2 * Config.textMultiplier,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Poppins',
                  ),
                  textScaleFactor: 1,
                ),
              ),
              SizedBox(
                height: 1 * Config.heightMultiplier,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 8 * Config.widthMultiplier,
                    height: 8 * Config.heightMultiplier,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        IconButton(
                          splashRadius: 10.0,
                          alignment: Alignment.center,
                          splashColor: Colors.red,
                          iconSize: 4 * Config.imageSizeMultiplier,
                          onPressed: () {},
                          icon: Icon(
                            Icons.remove,
                            color: Colors.black,
                            size: 5.5 * Config.imageSizeMultiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2 * Config.widthMultiplier),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 1.8 * Config.textMultiplier,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Poppins',
                      ),
                      textScaleFactor: 1,
                    ),
                  ),
                  Container(
                    width: 5 * Config.widthMultiplier,
                    height: 5 * Config.heightMultiplier,
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        IconButton(
                          splashRadius: 10.0,
                          alignment: Alignment.centerLeft,
                          splashColor: Colors.red,
                          iconSize: 4 * Config.imageSizeMultiplier,
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 5.5 * Config.imageSizeMultiplier,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 4 * Config.widthMultiplier,
                top: 2 * Config.heightMultiplier),
            child: RaisedButton(
              splashColor: Colors.white,
              color: Colors.grey[200],
              shape: StadiumBorder(),
              onPressed: () {},
              child: Text(
                "Product Options",
                style: TextStyle(fontSize: 1.9 * Config.textMultiplier),
                textScaleFactor: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

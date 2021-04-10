import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';

class OrderCart extends StatefulWidget {
  @override
  _OrderCartState createState() => _OrderCartState();
}

class _OrderCartState extends State<OrderCart> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xffFF6347)),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: AppBar(
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Text('Order Cart'),
                  Text('Order History'),
                ],
              ),
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
                ),
              ),
            ),
          ),
          body: TabBarView(children: <Widget>[
            columnList(),
            columnList(),
          ]),
        ),
      ),
    );
  }
}

Widget columnList() {
  TextEditingController _noteController = TextEditingController();
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 1 * Config.widthMultiplier),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: <Widget>[
            SizedBox(
              height: 18.0,
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 1 * Config.heightMultiplier),
              child: CardItem(),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 1 * Config.heightMultiplier),
              child: CardItem(),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 1 * Config.heightMultiplier),
              child: CardItem(),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Divider(
            height: 20,
            color: Colors.red,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 150),
          child: TextField(
            maxLines: 2,
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'NOTE',
              hintStyle: TextStyle(
                  color: Colors.grey[400], fontSize: 2 * Config.textMultiplier),
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
        Padding(
          padding: EdgeInsets.only(top: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 1.0 * Config.heightMultiplier),
                    child: Text('Preparation Time: '),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.0 * Config.widthMultiplier,
                        top: 1 * Config.heightMultiplier),
                    child: Text('Grand Total: '),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2 * Config.heightMultiplier),
                child: Text('Sub Fee: '),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2 * Config.heightMultiplier),
                child: Text('Booking Fee: '),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 490),
          child: RaisedButton(
            onPressed: () {
              print('Button Clicked');
            },
            child: Text(' PROCEED '),
            color: Colors.deepOrange[400],
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
          ),
        ),
      ],
    ),
  );
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
            height: 80,
            width: 80,
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
                width: 100.0,
                child: Text(
                  'Product Name and thier Price',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 2 * Config.textMultiplier,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        IconButton(
                          splashRadius: 10.0,
                          alignment: Alignment.center,
                          splashColor: Colors.red,
                          iconSize: 10.0,
                          onPressed: () {},
                          icon: Icon(
                            Icons.remove,
                            color: Colors.black,
                            size: 20,
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
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        IconButton(
                          splashRadius: 10.0,
                          alignment: Alignment.center,
                          splashColor: Colors.red,
                          iconSize: 10.0,
                          onPressed: () {},
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 20,
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
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

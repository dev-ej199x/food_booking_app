import 'package:flutter/material.dart';
import 'package:food_booking_app/defaults/config.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5 * Config.imageSizeMultiplier)),
      content: Form(
        child: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            Container(
              height: 460.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(43.0),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(43.0),
                  topRight: Radius.circular(43.0),
                ),
                color: Color(0xff323030),
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2 * Config.heightMultiplier),
                child: Text(
                  'Payment Method',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 3 * Config.textMultiplier,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.5 * Config.heightMultiplier),
              child: Text(
                'Payment Address',
                textScaleFactor: 1,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 2 * Config.textMultiplier,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
                //Here is the maping of address API
              ),
              // Note Adjust the padding after inserting the address
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 20 * Config.heightMultiplier,
                  bottom: 10 * Config.heightMultiplier),
              child: Container(
                height: 180,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3 * Config.widthMultiplier),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Payment Cards',
                            textAlign: TextAlign.center,
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 1 * Config.textMultiplier,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          // Widgets of Different Bank Cards
                          RaisedButton(
                            color: Color(0xff3CE78C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Cash",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textScaleFactor: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 20,
                      color: Colors.grey[700],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Item Fee: ',
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 1.6 * Config.textMultiplier),
                          ),
                          Text(
                            'Booking Fee: ',
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 1.6 * Config.textMultiplier),
                          ),
                          Text(
                            'Grand Fee: ',
                            textScaleFactor: 1,
                            style: TextStyle(
                                fontSize: 1.6 * Config.textMultiplier),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 48 * Config.heightMultiplier,
                  left: 20 * Config.widthMultiplier),
              child: RaisedButton(
                elevation: 5,
                color: Color(0xffFC4646),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                onPressed: () {},
                child: Text("SUBMIT",
                    textScaleFactor: 1,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 55 * Config.heightMultiplier,
                  left: 20 * Config.widthMultiplier),
              child: RaisedButton(
                elevation: 5,
                color: Color(0xffFC4646),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                onPressed: () {},
                child: Text("CANCEL",
                    textScaleFactor: 1,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Row(
//   children: <Widget>[
//     Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: 3 * Config.widthMultiplier),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Text(
//             'Payment Cards',
//             textAlign: TextAlign.center,
//             textScaleFactor: 1,
//             style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 1 * Config.textMultiplier,
//                 color: Colors.blueAccent,
//                 fontWeight: FontWeight.bold),
//           ),
//           // Widgets of Different Bank Cards
//           RaisedButton(
//             color: Color(0xff3CE78C),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(100.0),
//             ),
//             onPressed: () {},
//             child: Text("Cash",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: 3 * Config.widthMultiplier),
//       child: Container(
//         width: 1.0,
//         height: 113.0,
//         color: Color(0xffCEC9C9),
//       ),
//     ),
//     Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: 3 * Config.widthMultiplier),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 'Sub Fee',
//                 textAlign: TextAlign.center,
//                 textScaleFactor: 1,
//                 style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 2 * Config.textMultiplier,
//                     color: Colors.blueAccent,
//                     fontWeight: FontWeight.bold),
//               ),
//               // Insert here API of payment
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 'Service Fee',
//                 textAlign: TextAlign.center,
//                 textScaleFactor: 1,
//                 style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 2 * Config.textMultiplier,
//                     color: Colors.blueAccent,
//                     fontWeight: FontWeight.bold),
//               ),
//               // Insert here API of payment
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Text(
//                 'Grand Total',
//                 textAlign: TextAlign.center,
//                 textScaleFactor: 1,
//                 style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 2 * Config.textMultiplier,
//                     color: Colors.blueAccent,
//                     fontWeight: FontWeight.bold),
//               ),
//               // Insert here API of payment
//             ],
//           ),
//         ],
//       ),
//     )
//   ],
// ),
// Padding(
//   padding:
//       EdgeInsets.symmetric(vertical: 3 * Config.heightMultiplier),
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: <Widget>[
//       RaisedButton(
//         color: Color(0xffFC4646),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(100.0),
//         ),
//         onPressed: () {},
//         child: Text("Submit",
//             style: TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//       RaisedButton(
//         color: Color(0xffFC4646),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(100.0),
//         ),
//         onPressed: () {},
//         child: Text("Cancel",
//             style: TextStyle(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//       ),
//     ],
//   ),
// ),

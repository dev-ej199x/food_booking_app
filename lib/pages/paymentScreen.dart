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
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.5 * Config.heightMultiplier),
              child: Text(
                'Delivery Address',
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
                  top: 16 * Config.heightMultiplier,
                  bottom: 10 * Config.heightMultiplier),
              child: Text(
                'Land Mark',
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 2 * Config.textMultiplier,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
                //Here is the maping of address API
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 24 * Config.heightMultiplier),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3 * Config.widthMultiplier),
                  ),
                  Column(
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
                        child: Text("Cash",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            )
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

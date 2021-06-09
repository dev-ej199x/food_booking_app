// import 'package:flutter/material.dart';
// import 'package:food_booking_app/defaults/config.dart';
// import 'package:food_booking_app/defaults/images.dart';
// import 'package:food_booking_app/defaults/text.dart';

// class PaymentEndScreen extends StatefulWidget {
//   @override
//   _PaymentEndScreenState createState() => _PaymentEndScreenState();
// }

// class _PaymentEndScreenState extends State<PaymentEndScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: Form(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(43.0),
//           ),
//           child: Center(
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.only(bottom: 100.0),
//                   color: Color(0xff323030),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(43.0),
//                       topRight: Radius.circular(43.0),
//                     ),
//                   ),
//                   child: CustomText(
//                     'Payment Method',
//                     align.center,
//                       fontFamily: 'Poppins',
//                       size: 5,
//                       color: const Color(0xffffffff),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 221,
//                   width: 175,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(image: AssetImage(Images.thankYou)),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       vertical: 3 * heightMultiplier),
//                   child: CustomText(
//                     'THANK YOU!',
//                       fontFamily: 'Poppins',
//                       size: 6,
//                       color: const Color(0xff5F5959),
//                       weightight.bold,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                       vertical: 2 * heightMultiplier,
//                       horizontal: 8 * widthMultiplier),
//                   child: ButtonTheme(
//                       height: 5 * heightMultiplier,
//                       child: RaisedButton(
//                         onPressed: () {},
//                         color: Color(0xFFFC4646),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(
//                               10 * imageSizeMultiplier),
//                         ),
//                         splashColor: Colors.white.withOpacity(.4),
//                         child: Container(
//                           child: Center(
//                             child: CustomText(
//                               "Done",
//                                   size: 3,
//                                   color: Colors.white,
//                                   weightight.bold),
//                             ),
//                           ),
//                         ),
//                       )),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

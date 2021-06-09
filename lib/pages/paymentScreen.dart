// import 'package:flutter/material.dart';
// import 'package:food_booking_app/defaults/config.dart';
// import 'package:food_booking_app/defaults/text.dart';

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: Colors.transparent,
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5 * imageSizeMultiplier)),
//       content: Form(
//         child: Stack(
//           fit: StackFit.loose,
//           children: <Widget>[
//             Container(
//               height: 460.0,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(43.0),
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(43.0),
//                   topRight: Radius.circular(43.0),
//                 ),
//                 color: Color(0xff323030),
//               ),
//               child: Padding(
//                 padding:
//                     EdgeInsets.symmetric(vertical: 2 * heightMultiplier),
//                 child: CustomText(
//                   'Payment Method',
//                   aligner,
//                       fontFamily: 'Poppins',
//                       size: 3,
//                       color: Colors.white,
//                       weightntWeight.bold),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 8.5 * heightMultiplier),
//               child: CustomText(
//                 'Payment Address',
//                     fontFamily: 'Poppins',
//                     size: 2,
//                     color: Colors.blueAccent,
//                     weightntWeight.bold),
//                 //Here is the maping of address API
//               ),
//               // Note Adjust the padding after inserting the address
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                   top: 20 * heightMultiplier,
//                   bottom: 10 * heightMultiplier),
//               child: Container(
//                 height: 180,
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 3 * widthMultiplier),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           CustomText(
//                             'Payment Cards',
//                             aligner,
//                                 fontFamily: 'Poppins',
//                                 size: 1,
//                                 color: Colors.blueAccent,
//                                 weightntWeight.bold),
//                           ),
//                           // Widgets of Different Bank Cards
//                           RaisedButton(
//                             color: Color(0xff3CE78C),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(100.0),
//                             ),
//                             onPressed: () {},
//                             child: CustomText(
//                               "Cash",
//                                   color: Colors.white,
//                                   weightntWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     VerticalDivider(
//                       width: 20,
//                       color: Colors.grey[700],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 1),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CustomText(
//                             'Item Fee: ',
//                                 size: 1.6),
//                           ),
//                           CustomText(
//                             'Booking Fee: ',
//                                 size: 1.6),
//                           ),
//                           CustomText(
//                             'Grand Fee: ',
//                                 size: 1.6),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                   top: 48 * heightMultiplier,
//                   left: 20 * widthMultiplier),
//               child: RaisedButton(
//                 elevation: 5,
//                 color: Color(0xffFC4646),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(100.0),
//                 ),
//                 onPressed: () {},
//                 child: CustomText("SUBMIT",
//                         color: Colors.white, weightntWeight.bold)),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                   top: 55 * heightMultiplier,
//                   left: 20 * widthMultiplier),
//               child: RaisedButton(
//                 elevation: 5,
//                 color: Color(0xffFC4646),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(100.0),
//                 ),
//                 onPressed: () {},
//                 child: CustomText("CANCEL",
//                         color: Colors.white, weightntWeight.bold)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Row(
// //   children: <Widget>[
// //     Padding(
// //       padding: EdgeInsets.symmetric(
// //           horizontal: 3 * widthMultiplier),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: <Widget>[
// //           CustomText(
// //             'Payment Cards',
// //             aligner,
// //                 fontFamily: 'Poppins',
// //                 size: 1,
// //                 color: Colors.blueAccent,
// //                 weightntWeight.bold),
// //           ),
// //           // Widgets of Different Bank Cards
// //           RaisedButton(
// //             color: Color(0xff3CE78C),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(100.0),
// //             ),
// //             onPressed: () {},
// //             child: CustomText("Cash",
// //                     color: Colors.white,
// //                     weightntWeight.bold)),
// //           ),
// //         ],
// //       ),
// //     ),
// //     Padding(
// //       padding: EdgeInsets.symmetric(
// //           horizontal: 3 * widthMultiplier),
// //       child: Container(
// //         width: 1.0,
// //         height: 113.0,
// //         color: Color(0xffCEC9C9),
// //       ),
// //     ),
// //     Padding(
// //       padding: EdgeInsets.symmetric(
// //           horizontal: 3 * widthMultiplier),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: <Widget>[
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: <Widget>[
// //               CustomText(
// //                 'Sub Fee',
// //                 aligner,
// //                     fontFamily: 'Poppins',
// //                     size: 2,
// //                     color: Colors.blueAccent,
// //                     weightntWeight.bold),
// //               ),
// //               // Insert here API of payment
// //             ],
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: <Widget>[
// //               CustomText(
// //                 'Service Fee',
// //                 aligner,
// //                     fontFamily: 'Poppins',
// //                     size: 2,
// //                     color: Colors.blueAccent,
// //                     weightntWeight.bold),
// //               ),
// //               // Insert here API of payment
// //             ],
// //           ),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: <Widget>[
// //               CustomText(
// //                 'Grand Total',
// //                 aligner,
// //                     fontFamily: 'Poppins',
// //                     size: 2,
// //                     color: Colors.blueAccent,
// //                     weightntWeight.bold),
// //               ),
// //               // Insert here API of payment
// //             ],
// //           ),
// //         ],
// //       ),
// //     )
// //   ],
// // ),
// // Padding(
// //   padding:
// //       EdgeInsets.symmetric(vertical: 3 * heightMultiplier),
// //   child: Column(
// //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //     children: <Widget>[
// //       RaisedButton(
// //         color: Color(0xffFC4646),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(100.0),
// //         ),
// //         onPressed: () {},
// //         child: CustomText("Submit",
// //                 color: Colors.white, weightntWeight.bold)),
// //       ),
// //       RaisedButton(
// //         color: Color(0xffFC4646),
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(100.0),
// //         ),
// //         onPressed: () {},
// //         child: CustomText("Cancel",
// //                 color: Colors.white, weightntWeight.bold)),
// //       ),
// //     ],
// //   ),
// // ),

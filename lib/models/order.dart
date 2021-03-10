import 'package:flutter/material.dart';

class OrderModel {
  final id;
  final total;
  final orderFee;
  final grandTotal;
  final code;
  final establishment;
  final status;
  final String createdAt;

  OrderModel(
      {@required this.id,
      @required this.total,
      @required this.orderFee,
      @required this.grandTotal,
      @required this.code,
      @required this.establishment,
      @required this.status,
      this.createdAt});
}

import 'package:flutter/material.dart';
import 'package:food_booking_app/models/addOn.dart';

class OrderItemModel {
  final id;
  final name;
  final variantName;
  final price;
  final quantity;
  final total;
  List<AddOnModel> addons;

  OrderItemModel({
    @required this.id,
    @required this.name,
    @required this.variantName,
    @required this.price,
    @required this.quantity,
    @required this.total,
    @required this.addons,
  });
}

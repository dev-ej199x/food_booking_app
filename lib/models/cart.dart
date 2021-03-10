import 'package:flutter/material.dart';
// import 'package:lib/models/addOn.dart';

import 'addOn.dart';

class CartModel {
  final id;
  final dbId;
  final name;
  final variantId;
  final price;
  List<int> addons;
  List<AddOnModel> addOnModel;
  int quantity;

  CartModel(
      {@required this.id,
      @required this.dbId,
      @required this.name,
      @required this.price,
      @required this.quantity,
      @required this.variantId,
      @required this.addons,
      @required this.addOnModel});
}

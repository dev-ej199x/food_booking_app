import 'package:flutter/material.dart';
import 'package:food_booking_app/models/productOptItems.dart';

class OrderRequest {
  final int productId;
  final int productOptId;
  final String productOptName;
  final int quantity;
  final String note;
  final List<ProductOptItems> productOptItems;

  OrderRequest(
      {@required this.productId,
      @required this.productOptId,
      @required this.productOptName,
      @required this.quantity,
      @required this.note,
      @required this.productOptItems});
}

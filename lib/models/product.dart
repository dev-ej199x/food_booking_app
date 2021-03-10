import 'package:flutter/material.dart';

class ProductModel {
  final id;
  final name;
  final image;
  final String price;
  final description;

  ProductModel(
      {@required this.id,
      @required this.name,
      @required this.image,
      @required this.price,
      @required this.description});
}

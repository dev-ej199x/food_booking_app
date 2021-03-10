import 'package:flutter/material.dart';

class AddOnModel {
  final id;
  final name;
  double price;
  bool selected;
  
  AddOnModel({@required this.id, @required this.name, @required this.price, @required this.selected});
}
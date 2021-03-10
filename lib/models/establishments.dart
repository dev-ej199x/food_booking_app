import 'dart:html';

import 'package:flutter/material.dart';
import 'package:food_booking_app/models/foodCategories.dart';

class EstablishmentModels {
  int id;
  String name;
  String profileImage;
  String bannerImage;
  String distance;
  String openOrClose;
  double orderFee;
  double minimumPurchase;
  double latitude;
  double longtitude;
  int reviewsCount;
  double rating;
  List<dynamic> tags;
  List<Categories> categories;
  Map<String, dynamic> schedules;

  EstablishmentModels({
    @required this.id,
    @required this.name,
    @required this.profileImage,
    @required this.bannerImage,
    @required this.distance,
    @required this.openOrClose,
    @required this.orderFee,
    @required this.minimumPurchase,
    @required this.latitude,
    @required this.longtitude,
    @required this.reviewsCount,
    @required this.rating,
    @required this.tags,
    @required this.categories,
    @required this.schedules,
  });
}

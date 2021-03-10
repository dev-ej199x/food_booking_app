import 'package:flutter/material.dart';

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String orderDone;
  final int customerOrderId;

  NotificationModel(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.customerOrderId,
      @required this.orderDone});
}

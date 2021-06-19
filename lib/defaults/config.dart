import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

double _screenWidth;
double _screenHeight;
double _blockWidth = 0;
double _blockHeight = 0;

double textMultiplier;
double imageSizeMultiplier;
double heightMultiplier;
double widthMultiplier;
bool isPortrait = true;
bool isMobilePortrait = false;

Color appColor = Color(0xFFED1F56);
// Color lightAppColor = Color(0xFFED1F56);
// Color appColor = Color(0xFFFEB4D4D);

//text size / 7.2

class Config {
  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
  }

  checkShopOpenorClose(Map<String, dynamic> schedule) {
    String openOrClose = 'Close';
    DateTime openTime;
    DateTime closeTime;
    switch(DateTime.now().weekday) {
      case DateTime.sunday:
        openTime = new DateFormat("HH:mm:ss").parse(schedule['sunday_from']);
        closeTime = new DateFormat("HH:mm:ss").parse(schedule['sunday_to']);
        break;
      case DateTime.monday:
        openTime = new DateFormat("HH:mm:ss").parse(schedule['monday_from']);
        closeTime = new DateFormat("HH:mm:ss").parse(schedule['monday_to']);
        break;
      case DateTime.tuesday:
        openTime = new DateFormat("HH:mm:ss").parse(schedule['tuesday_from']);
        closeTime = new DateFormat("HH:mm:ss").parse(schedule['tuesday_to']);
        break;
      case DateTime.wednesday:
        openTime = new DateFormat("HH:mm:ss").parse(schedule['wednesday_from']);
        closeTime = new DateFormat("HH:mm:ss").parse(schedule['wednesday_to']);
        break;
      case DateTime.thursday:
        openTime = new DateFormat("HH:mm:ss").parse(schedule['thursday_from']);
        closeTime = new DateFormat("HH:mm:ss").parse(schedule['thursday_to']);
        break;
      case DateTime.friday:
        openTime = new DateFormat("HH:mm:ss").parse(schedule['friday_from']);
        closeTime = new DateFormat("HH:mm:ss").parse(schedule['friday_to']);
        break;
      case DateTime.saturday:
        openTime = new DateFormat("HH:mm:ss").parse(schedule['saturday_from']);
        closeTime = new DateFormat("HH:mm:ss").parse(schedule['saturday_to']);
        break;
    }
    if (DateTime.now().hour > openTime.hour && DateTime.now().hour < closeTime.hour)
      openOrClose = 'Open';
    if (DateTime.now().hour == openTime.hour && DateTime.now().minute >= openTime.minute)
      openOrClose = 'Open';
    if (DateTime.now().hour == closeTime.hour && DateTime.now().minute < closeTime.minute)
      openOrClose = 'Open';

    return openOrClose;
  }
}

import 'package:location/location.dart';

class CustomLocator {
  Location location = new Location();

  getLocation() async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return 'Service not enabled';
      }
      else {
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED || _permissionGranted == PermissionStatus.DENIED_FOREVER) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return 'Permission denied';
      }
    }
    else {
    }
    if (_serviceEnabled && _permissionGranted == PermissionStatus.GRANTED) {
      _locationData = await location.getLocation();
      if (_locationData == null)
        return null;
      else
        return _locationData;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_booking_app/defaults/config.dart';
import 'package:food_booking_app/defaults/images.dart';
import "package:latlong/latlong.dart";
// import 'package:flutter_map/src/layer/marker_layer.dart' as marker;

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.addressBack),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: 40.0,
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(color: Colors.grey[800]),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey[800]),
                        hintText: ('Search Restaurant'),
                        hintStyle: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(2 * Config.imageSizeMultiplier),
                  child: Container(
                    height: 500.0,
                    width: 350.0,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.grey)),
                    child: new FlutterMap(
                      options: new MapOptions(
                          center:
                              new LatLng(6.919956174032439, 122.08145288614394),
                          minZoom: 15.0),
                      layers: [
                        new TileLayerOptions(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/dev-19ej96/ckltmmqqc0uq117o06jeg0hsy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZGV2LTE5ZWo5NiIsImEiOiJja2x0bWkyZGcwN3RhMndvNHZuZGtna3RnIn0.Y5dYQ72j-vQ-yPkU9UPJtQ',
                            additionalOptions: {
                              'accessToken':
                                  'pk.eyJ1IjoiZGV2LTE5ZWo5NiIsImEiOiJja2x0bWkyZGcwN3RhMndvNHZuZGtna3RnIn0.Y5dYQ72j-vQ-yPkU9UPJtQ',
                              'id': 'mapbox.mapbox-streets-v8'
                            }),
                        new MarkerLayerOptions(markers: [
                          Marker(
                            width: 45.0,
                            height: 45.0,
                            point:
                                LatLng(6.9055497094699705, 122.07840707170523),
                            builder: (context) => Container(
                              child: IconButton(
                                icon: Icon(Icons.location_on),
                                color: Colors.red,
                                iconSize: 20.0,
                                onPressed: () {
                                },
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

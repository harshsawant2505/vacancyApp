import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

List<Map> parkingSpots = [];

double latitude = 0, longitude = 0;


Future<double> getDistance(GeoPoint place,MapController controller) async {
  double dis = 0;
  GeoPoint g = GeoPoint(latitude: latitude, longitude: longitude);

  try {
    RoadInfo road = await controller.drawRoad(
      g,
      place,
      roadType: RoadType.car,
      roadOption: RoadOption(
        roadColor: Colors.white.withOpacity(0),
      ),
    );
    print('yoooo ${road.distance}');
    dis = road.distance ?? 0;
  } catch (e) {
    print('error ${e.toString()}');
  }

  return dis;
}

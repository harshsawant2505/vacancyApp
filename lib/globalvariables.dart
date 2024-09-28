import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:logger/logger.dart';

List<Map> parkingSpots = [];

Logger logger = Logger();

double latitude = 0, longitude = 0;
final mapController = MapController.withPosition(
  initPosition: GeoPoint(
    latitude: 15.5010, // Placeholder coordinates
    longitude: 73.8294, // Placeholder coordinates
  ),
);

Future<double> getDistance(GeoPoint place) async {
  double dis = 0;
  GeoPoint g = GeoPoint(latitude: 15, longitude: 73);

  try {
    print("entered");
    RoadInfo road = await mapController.drawRoad(
      g,
      place,
      roadType: RoadType.car,
      roadOption: RoadOption(
        roadColor: Colors.white.withOpacity(0),
      ),
    );
    logger.d('yoooo ${road.distance}');
    dis = road.distance ?? 0;
  } catch (e) {
    logger.d('error ${e.toString()}');
  }

  return dis;
}

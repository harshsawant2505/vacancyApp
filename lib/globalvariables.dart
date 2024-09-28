import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';
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
    logger.d("Entered");
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

class DistanceCalculator {
  final Distance distance = Distance();

  // Function to calculate and format the distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    LatLng point1 = LatLng(lat1, lon1);
    LatLng point2 = LatLng(lat2, lon2);

    // Calculate the distance in kilometers
    double calculatedDistanceKm =
        distance.as(LengthUnit.Kilometer, point1, point2);

    // Format the distance to 3 decimal places and append " km"
    return calculatedDistanceKm;
  }
}

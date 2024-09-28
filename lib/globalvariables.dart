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

class DistanceCalculator {
  final Distance distance = const Distance();

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

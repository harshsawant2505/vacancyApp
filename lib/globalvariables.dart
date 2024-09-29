import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

List<Map> parkingSpots = [],closets=[];
bool isLoading = true;

Map<String, dynamic> token = {};
final MapController mapController = MapController();

Logger logger = Logger();

class CustomDistanceCalculator {
  final Distance distance = const Distance();

  // Function to calculate and format the distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    LatLng point1 = LatLng(lat1, lon1);
    LatLng point2 = LatLng(lat2, lon2);

    // Calculate the distance in kilometers
    double calculatedDistanceKm = distance.as(LengthUnit.Meter, point1, point2);

    // Format the distance to 3 decimal places and append " km"
    return calculatedDistanceKm * 1.91 / 1000;
  }
}

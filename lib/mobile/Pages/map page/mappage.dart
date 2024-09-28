import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController.withPosition(
    initPosition: GeoPoint(
      latitude: 15.5010,
      longitude: 73.8294,
    ),
  );
  Logger logger = Logger();

  // Function to get user's current location and add a marker
  Future<void> addUserLocationMarker() async {
    try {
      // Check location permission and request if needed
      await mapController.enableTracking();
      // Get user's current location
      GeoPoint currentLocation = await mapController.myLocation();
      // Add a marker at user's location
      await mapController.addMarker(
        currentLocation,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.person_pin_circle,
            color: Colors.blue,
            size: 48,
          ),
        ),
      );
    } catch (e) {
      logger.e("ERROR: $e");
      Fluttertoast.showToast(
          msg: "Something went wrong!", toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
        controller: mapController,
        osmOption: OSMOption(
          userTrackingOption: const UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
          zoomOption: const ZoomOption(
            initZoom: 8,
            minZoomLevel: 3,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(
                Icons.location_history_rounded,
                color: Colors.red,
                size: 48,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(
                Icons.double_arrow,
                size: 48,
              ),
            ),
          ),
          roadConfiguration: const RoadOption(
            roadColor: Colors.yellowAccent,
          ),
        ));
  }
}

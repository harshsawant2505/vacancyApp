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
      latitude: 34.0522, // Latitude for Downtown LA
      longitude: -118.2437, // Longitude for Downtown LA
    ),
  );
  Logger logger = Logger();

  // Function to add a static marker at Downtown LA
  Future<void> _addStaticMarker() async {
    GeoPoint downtownLA = GeoPoint(latitude: 34.0522, longitude: -118.2437);
    try {
      await mapController.addMarker(
        downtownLA,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_pin,
            color: Colors.blue,
            size: 48,
          ),
        ),
      );
      logger.d("Marker added");
    } catch (e) {
      logger.e("ERROR: $e");
    }
  }

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
      logger.d('User location: $currentLocation');
    } catch (e) {
      logger.e("ERROR: $e");
      Fluttertoast.showToast(
          msg: "Something went wrong!", toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    mapController.dispose();
    super.dispose();
    addUserLocationMarker();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 500)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Once delay is done, render the map
          return SizedBox(
            child: OSMFlutter(
              controller: mapController,
              onMapIsReady: (isReady) async {
                if (isReady) {
                  logger.d("MAP READY");

                  await _addStaticMarker();
                } else {
                  logger.d("MAP not ready");
                }
              },
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  initZoom: 12, // Zoom level to properly view the marker
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
              ),
            ),
          );
        }
        // Display a loading indicator while waiting for the Future
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

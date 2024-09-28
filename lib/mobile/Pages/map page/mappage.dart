import 'package:bits_hackathon/globalvariables.dart';
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
      latitude: 15.5010, // Placeholder coordinates
      longitude: 73.8294, // Placeholder coordinates
    ),
  );

  Logger logger = Logger();

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    mapController.dispose();
    super.dispose();
  }

  // Function to enable user tracking (without adding a duplicate marker)
  Future<void> _enableUserTracking() async {
    try {
      // Enable user tracking
      await mapController.enableTracking();
      latitude = mapController.initPosition!.latitude;
      longitude = mapController.initPosition!.longitude;
    } catch (e) {
      logger.e("ERROR enabling user tracking: $e");
      Fluttertoast.showToast(
          msg: "Something went wrong while enabling user tracking!",
          toastLength: Toast.LENGTH_LONG);
    }
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
                  await _enableUserTracking(); // Enable user tracking
                } else {
                  logger.d("MAP not ready");
                }
              },
              osmOption: OSMOption(
                zoomOption: const ZoomOption(
                  initZoom: 12, // Zoom level to properly view the markers
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

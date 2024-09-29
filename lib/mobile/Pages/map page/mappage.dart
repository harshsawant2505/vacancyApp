// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:logger/logger.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   final mapController = MapController.withPosition(
//     initPosition: GeoPoint(
//       latitude: 15.5010, // Placeholder coordinates
//       longitude: 73.8294, // Placeholder coordinates
//     ),
//   );

//   Logger logger = Logger();

//   @override
//   void dispose() {
//     // Dispose the controller when the widget is disposed
//     mapController.dispose();
//     super.dispose();
//   }

//   // Function to enable user tracking (without adding a duplicate marker)
//   Future<void> _enableUserTracking() async {
//     try {
//       // Enable user tracking
//       await mapController.enableTracking();
//     } catch (e) {
//       logger.e("ERROR enabling user tracking: $e");
//       Fluttertoast.showToast(
//           msg: "Something went wrong while enabling user tracking!",
//           toastLength: Toast.LENGTH_LONG);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Future.delayed(const Duration(milliseconds: 500)),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           // Once delay is done, render the map
//           return SizedBox(
//             child: OSMFlutter(
//               controller: mapController,
//               onMapIsReady: (isReady) async {
//                 if (isReady) {
//                   logger.d("MAP READY");
//                   await _enableUserTracking(); // Enable user tracking
//                 } else {
//                   logger.d("MAP not ready");
//                 }
//               },
//               osmOption: OSMOption(
//                 zoomOption: const ZoomOption(
//                   initZoom: 12, // Zoom level to properly view the markers
//                   minZoomLevel: 3,
//                   maxZoomLevel: 19,
//                   stepZoom: 1.0,
//                 ),
//                 userLocationMarker: UserLocationMaker(
//                   personMarker: const MarkerIcon(
//                     icon: Icon(
//                       Icons.location_history_rounded,
//                       color: Colors.red,
//                       size: 48,
//                     ),
//                   ),
//                   directionArrowMarker: const MarkerIcon(
//                     icon: Icon(
//                       Icons.double_arrow,
//                       size: 48,
//                     ),
//                   ),
//                 ),
//                 roadConfiguration: const RoadOption(
//                   roadColor: Colors.yellowAccent,
//                 ),
//               ),
//             ),
//           );
//         }
//         // Display a loading indicator while waiting for the Future
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }
// }

import 'dart:async';
import 'dart:ui';
import 'package:bits_hackathon/globalvariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';

import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart'; // Import geolocator

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng myPoint;
  bool isLoading = false;
  bool userLocationSet = false; // To track if user location is set

  @override
  void initState() {
    myPoint = defaultPoint;
    _determinePosition(); // Get current location on start
    super.initState();
  }

  final defaultPoint = const LatLng(15.41, 73.49);

  List listOfPoints = [];
  List<LatLng> points = [];
  List<Marker> markers = [];

  // Create a Distance object to calculate the distance between points
  final Distance distance = const Distance();

  Future<void> getCoordinates(LatLng lat1, LatLng lat2) async {
    setState(() {
      isLoading = true;
    });

    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248889618e0c2774db982906c820449f1aa',
    );

    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate:
          ORSCoordinate(latitude: lat1.latitude, longitude: lat1.longitude),
      endCoordinate:
          ORSCoordinate(latitude: lat2.latitude, longitude: lat2.longitude),
    );

    final List<LatLng> routePoints = routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();

    setState(() {
      points = routePoints;
      isLoading = false;
    });
  }

  // void _handleTap(LatLng latLng) {
  //   if (userLocationSet) {
  //     setState(() {
  //       if (markers.length < 2) {
  //         markers.add(
  //           Marker(
  //             point: latLng,
  //             width: 80,
  //             height: 80,
  //             child: IconButton(
  //               onPressed: () {},
  //               icon: const Icon(Icons.location_on),
  //               color: Colors.red,
  //               iconSize: 45,
  //             ),
  //           ),
  //         );
  //       }

  //       if (markers.length == 2) {
  //         // Add a slight delay before showing the process effect
  //         Future.delayed(const Duration(milliseconds: 500), () {
  //           setState(() {
  //             isLoading = true;
  //           });
  //         });

  //         getCoordinates(markers[0].point, markers[1].point);

  //         // Calculate the distance between the two points in kilometers
  //         final double calculatedDistanceKm = distance.as(
  //           LengthUnit.Kilometer,
  //           markers[0].point,
  //           markers[1].point,
  //         );

  //         if (calculatedDistanceKm < 1) {
  //           // If the distance is less than 1 kilometer, show it in meters
  //           final double calculatedDistanceMeters = distance.as(
  //             LengthUnit.Meter,
  //             markers[0].point,
  //             markers[1].point,
  //           );
  //           print(
  //               "Distance: ${calculatedDistanceMeters.toStringAsFixed(2)} meters");
  //         } else {
  //           // Otherwise, show the distance in kilometers
  //           print("Distance: ${calculatedDistanceKm.toStringAsFixed(2)} km");
  //         }

  //         // Calculate the bounds that contain the two marked points
  //         LatLngBounds bounds = LatLngBounds.fromPoints(
  //             markers.map((marker) => marker.point).toList());
  //         // Perform a zoom out so that the bounds fit the screen
  //         mapController.fitBounds(bounds);
  //       }
  //     });
  //   } else {
  //     print("User location is not set yet.");
  //   }
  // }

  // Function to get the user's current location
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      // Add the user's current location as the first marker
      LatLng userLocation = LatLng(position.latitude, position.longitude);
      markers.add(
        Marker(
          point: userLocation,
          width: 80,
          height: 80,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.my_location),
            color: Colors.blue,
            iconSize: 45,
          ),
        ),
      );
      userLocationSet = true;
      mapController.move(userLocation, 16.5); // Move to the user's location
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialZoom: 16,
              initialCenter: myPoint,
              // onTap: (tapPosition, latLng) => _handleTap(latLng),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(
                markers: markers,
              ),
              
              PolylineLayer(
                polylineCulling: false,
                polylines: [
                  Polyline(
                    points: points,
                    color: Colors.black,
                    strokeWidth: 5,
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: isLoading,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

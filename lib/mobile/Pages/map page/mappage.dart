import 'dart:async';
import 'dart:ui';
import 'package:bits_hackathon/globalvariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:latlong2/latlong.dart';

import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

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
      mapController.move(userLocation, 16.5);
      Fluttertoast.showToast(
          webPosition: "bottom center",
          msg: "Location might not be 100% accurate.",
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          webBgColor: "red",
          textColor: Colors.black87);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
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
    );
  }
}

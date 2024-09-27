import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final List<LatLng> locations = [
    const LatLng(37.7749, -122.4194), // San Francisco
    const LatLng(34.0522, -118.2437), // Los Angeles
    const LatLng(40.7128, -74.0060), // New York
    // Add more locations as needed
  ];

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        
      ],
    );
  }
}

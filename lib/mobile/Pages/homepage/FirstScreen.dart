import 'dart:convert';
import 'package:bits_hackathon/global%20widgets/parkingcard.dart';
import 'package:bits_hackathon/global%20widgets/searchbar.dart';
import 'package:bits_hackathon/globalvariables.dart';
import 'package:bits_hackathon/mobile/Pages/map%20page/mappage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as h;

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController controller = TextEditingController();

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  void loadAgain() {
    setState(() {
      parkingSpots = parkingSpots;
    });
    // print(parkingSpots);
  }

  List<List<String>> gpsList = [];

  Future<void> getAllData() async {
    const url = "http://localhost:3001/allparkingdetails";

    try {
      final res = await h.get(Uri.parse(url));
      // print(res.body);

      if (res.statusCode == 200) {
        List<dynamic> data = json.decode(res.body);

        // Assuming each parking spot has 'latitude' and 'longitude' keys
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        gpsList = data.map((spot) {
          String gpsString = spot['gps']; // Get the GPS string
          List<String> splitGps =
              gpsString.split(' '); // Split the string by comma
          return splitGps
              .map((val) => (val))
              .toList(); // Convert to double and return
        }).toList();

        // Print the list of gps coordinates
        print(
            gpsList); // Output: [[15.2993, 74.124], [15.4966, 74.0505], [15.3916, 73.818]]

        // print("this is sorted:  $parkingSpots");
        setState(() {});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<List<dynamic>> sortedCoordinates = [];

  Future<void> _getCurrentLocationAndSortCoordinates() async {
    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("is it here ${gpsList.length}");
    double currentLat = position.latitude;
    double currentLon = position.longitude;

    for (var value in gpsList) {
      print(value);
      if (value[0].isEmpty) {
        print('skipped');
      } else {
        print('lol');
        double distance = DistanceCalculator().calculateDistance(
            currentLat,
            currentLon,
            double.tryParse(value[0]) ?? 0,
            double.tryParse(value[1]) ?? 0);
        print(distance);
        sortedCoordinates.add([value[0], value[1], distance]);
      }
    }

    // Sort by distance (the third element in the sublist)
    print('so it worked? $sortedCoordinates');
    sortedCoordinates.sort((a, b) => a[2].compareTo(b[2]));

    // Keep only the lat/lon coordinates for output
    sortedCoordinates = sortedCoordinates
        .map((coords) => [coords[0], coords[1], coords[2]])
        .toList();
    print("The man: ");
    print(sortedCoordinates);
    setState(() {}); // Update the UI
  }

  @override
  void initState() {
    super.initState();
    getAllData();
    checkLocationPermission();
    _getCurrentLocationAndSortCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            MainSearchBar(
              controller: controller,
              func: loadAgain,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2 - 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: const Center(
                child: MapScreen(),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2 - 30,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: parkingSpots.isEmpty
                  ? const Center(
                      child: Text("No result found"),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: parkingSpots.length,
                      itemBuilder: (context, index) {
                        return ParkingCard(
                          entry: parkingSpots[index],
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

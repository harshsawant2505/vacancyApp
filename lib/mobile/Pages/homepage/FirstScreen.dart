import 'dart:convert';
import 'package:bits_hackathon/global%20widgets/parkingcard.dart';
import 'package:bits_hackathon/global%20widgets/searchbar.dart';
import 'package:bits_hackathon/globalvariables.dart';
import 'package:bits_hackathon/mobile/Pages/map%20page/mappage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> setSession(Map<String, dynamic> token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', jsonEncode(token));
    print("In the set session");
   final temp =  setSession({"data":"the ses"});
    print(temp);
  }

  Future<String?> getSession() async {
    print("infffffffffffffffffffffffff");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('session_token');
  }

  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
  }

  void loadAgain() {
    setState(() {
      parkingSpots = parkingSpots;
    });
    // print(parkingSpots);
  }

  void getgetsession() async {
   
    final s = await getSession();
 
    token = json.decode(s ?? '{"data":"none"}');
    print(token);
    
    // token = {"data":"user"};
  }

  List<List<String>> gpsList = [];

  Future<void> getAllData() async {
    const url = "https://node-api-5kc9.onrender.com/allparkingdetails";

    try {
      final res = await h.get(Uri.parse(url));
      // print(res.body);

      if (res.statusCode == 200) {
        List<dynamic> data = json.decode(res.body);

        gpsList = data.map((spot) {
          String gpsString = spot['gps'];
          List<String> splitGps =
              gpsString.split(' '); // Split the string by comma
          return splitGps.map((val) => (val)).toList();
        }).toList();

        //final List
        logger.d(gpsList);

        setState(() {});
      }
    } catch (e) {
      logger.e("ERROR: ${e.toString()}");
    }
  }

  List<List<dynamic>> sortedCoordinates = [];

  Future<void> _getCurrentLocationAndSortCoordinates() async {
    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
    double currentLat = position.latitude;
    double currentLon = position.longitude;

    for (var value in gpsList) {
      if (value[0].isEmpty) {
        logger.d("Skipped one value");
      } else {
        double distance = CustomDistanceCalculator().calculateDistance(
            currentLat,
            currentLon,
            double.tryParse(value[0]) ?? 0,
            double.tryParse(value[1]) ?? 0);
        logger.d(distance);
        sortedCoordinates.add([value[0], value[1], distance]);
      }
    }

    sortedCoordinates.sort((a, b) => a[2].compareTo(b[2]));

    // Keep only the lat/lon coordinates for output
    sortedCoordinates = sortedCoordinates
        .map((coords) => [coords[0], coords[1], coords[2]])
        .toList();
    parkingSpots.clear();
    logger.d("Sorted: ${sortedCoordinates.toString()}");

    for (int i = 0; i < 10 && i < sortedCoordinates.length; i++) {
      final lat = sortedCoordinates[i][0];
      final lon = sortedCoordinates[i][1];

      try {
        const url = "https://node-api-5kc9.onrender.com/getCorrespondingData";
        final res = await h.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({'lat': lat, 'lon': lon}), // Encode the Map to JSON
        );

        if (res.statusCode == 200) {
          final Map something = json.decode(res.body);
          parkingSpots.add(something);
          logger.d(parkingSpots.toString());
        }
      } catch (e) {
        logger.e("ERROR: ${e.toString()}");
      }
    }
    setState(() {
      parkingSpots = parkingSpots;
    });
  }

  @override
  void initState() {
    print("Init hit");
    getgetsession();
    checkLocationPermission();
    getAllData();
    _getCurrentLocationAndSortCoordinates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: const Center(
                child: MapScreen(),
              ),
            ),
            MainSearchBar(
              controller: controller,
              func: loadAgain,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 1.9,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: parkingSpots.isEmpty
                    ? const Center(
                        child: Text("No result found"),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount:
                            controller.text.isEmpty ? 10 : parkingSpots.length,
                        itemBuilder: (context, index) {
                          print(parkingSpots[index]);
                          return ParkingCard(
                            entry: parkingSpots[index],
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

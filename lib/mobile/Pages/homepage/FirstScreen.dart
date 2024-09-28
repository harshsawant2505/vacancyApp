// ignore_for_file: file_names

import 'dart:convert';

import 'package:bits_hackathon/global%20widgets/parkingcard.dart';
import 'package:bits_hackathon/global%20widgets/searchbar.dart';
import 'package:bits_hackathon/globalvariables.dart';
import 'package:bits_hackathon/mobile/Pages/map%20page/mappage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController controller = TextEditingController();

  get http => null;

  Future<void> checkLocationPermission() async {
    //function to check the user permission if it's granted or not.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  void loadAgain() {
    setState(() {
      parkingSpots = parkingSpots;
    });
    print(parkingSpots);
  }

  // void getAllData() async {
  //   const url = "http://localhost:8000/getAllParkingSpots";

  //   try {
  //     // final res = await http.post(Uri.parse(url), body: {"city": name});
  //     final res = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode(jsonData), // Encode the Map to JSON
  //     );

  //     if (res.statusCode == 200) {
  //       String newlist = json.decode(res.body);
  //       List<dynamic> listOfMaps = json.decode(newlist);
  //       List<Map<String, dynamic>> castedList =
  //           List<Map<String, dynamic>>.from(listOfMaps);

  //       parkingSpots.clear();
  //       parkingSpots.addAll(castedList);
  //       setState(() {
  //         parkingSpots = parkingSpots;
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getAllData();
    checkLocationPermission();
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
                child: MapPage(),
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

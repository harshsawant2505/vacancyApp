import 'package:bits_hackathon/globalvariables.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingCard extends StatefulWidget {
  final Map entry;
  const ParkingCard({super.key, required this.entry});

  @override
  State<ParkingCard> createState() => _ParkingCardState();
}

class _ParkingCardState extends State<ParkingCard> {
  double dis = 0, lat = 0, lon = 0;
  Logger logger = Logger();
  void getdis() async {
    Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));
    dis = CustomDistanceCalculator()
        .calculateDistance(position.latitude, position.longitude, lat, lon);
    logger.d("Distance: $dis");
    setState(() {
      dis = dis;
    });
  }

  void goToMaps() async {
    final url = "https://www.google.com/maps?q=$lat,$lon";

    try {
      launchUrl(Uri.parse(url));
    } catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }
  }

  @override
  void initState() {
    print('entered');
    lat = double.tryParse(widget.entry['gps'].toString().split(' ').first) ?? 0;
    lon = double.tryParse(widget.entry['gps'].toString().split(' ').last) ?? 0;
    getdis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final newplace = LatLng(lat, lon);
        mapController.move(newplace, 20);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entry['place'],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Text(
                            "${dis.toStringAsFixed(2)} km",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            widget.entry['type'],
                            style: TextStyle(
                                fontSize: 14,
                                color: widget.entry['type']
                                            .toString()
                                            .toLowerCase() ==
                                        'paid'
                                    ? Colors.red
                                    : Colors.green),
                          ),
                        ],
                      ),
                      const Text(
                        "Vacancies:",
                        style: TextStyle(fontSize: 14),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.local_taxi_outlined,
                                color:
                                    (widget.entry['4w'].toString() == "null" ||
                                            widget.entry['4w'] == 0)
                                        ? Colors.red
                                        : Colors.green,
                              ),
                              Text(
                                "${widget.entry['4w'].toString() == "null" ? '0' : widget.entry['4w']}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: (widget.entry['4w'].toString() ==
                                                "null" ||
                                            widget.entry['4w'] == 0)
                                        ? Colors.red
                                        : Colors.green),
                              )
                            ],
                          ),
                          const SizedBox(width: 15),
                          Column(
                            children: [
                              Icon(
                                Icons.pedal_bike_rounded,
                                color:
                                    (widget.entry['2w'].toString() == "null" ||
                                            widget.entry['2w'] == 0)
                                        ? Colors.red
                                        : Colors.green,
                              ),
                              Text(
                                "${widget.entry['2w'].toString() == "null" ? '0' : widget.entry['2w']}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: (widget.entry['2w'].toString() ==
                                                "null" ||
                                            widget.entry['2w'] == 0)
                                        ? Colors.red
                                        : Colors.green),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: goToMaps,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.lightBlue[300]),
                              child: const Text("Start traveling"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

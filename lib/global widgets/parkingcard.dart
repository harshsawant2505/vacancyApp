import 'package:bits_hackathon/globalvariables.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingCard extends StatefulWidget {
  final Map entry;
  final double dis;
  const ParkingCard({super.key, required this.entry, required this.dis});

  @override
  State<ParkingCard> createState() => _ParkingCardState();
}

class _ParkingCardState extends State<ParkingCard> {
  Logger logger = Logger();

  void goToMaps() async {
    final url =
        "https://www.google.com/maps?q=${double.tryParse(widget.entry['gps'].toString().split(' ').first) ?? 0},${double.tryParse(widget.entry['gps'].toString().split(' ').last) ?? 0}";

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final newplace = LatLng(
            double.tryParse(widget.entry['gps'].toString().split(' ').first) ??
                0,
            double.tryParse(widget.entry['gps'].toString().split(' ').last) ??
                0);
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
                            "${widget.dis.toStringAsFixed(2)} km",
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
                                "${widget.entry['4w'].toString() == "null" ? '0' : widget.entry['4w'] - widget.entry['4w_occ']}",
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
                                "${widget.entry['2w'].toString() == "null" ? '0' : widget.entry['2w'] - widget.entry['2w_occ']}",
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

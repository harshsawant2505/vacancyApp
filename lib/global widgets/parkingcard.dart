import 'package:flutter/material.dart';

class ParkingCard extends StatefulWidget {
  final Map entry;
  const ParkingCard({super.key, required this.entry});

  @override
  State<ParkingCard> createState() => _ParkingCardState();
}

class _ParkingCardState extends State<ParkingCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                            "100m",
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
                          )
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

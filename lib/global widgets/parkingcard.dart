import 'package:flutter/material.dart';

class ParkingCard extends StatefulWidget {
  final String title, distance;
  final int vacancy;
  const ParkingCard(
      {super.key,
      required this.title,
      required this.distance,
      required this.vacancy});

  @override
  State<ParkingCard> createState() => _ParkingCardState();
}

class _ParkingCardState extends State<ParkingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.distance}m",
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      "${widget.vacancy} spots remaining",
                      style: const TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

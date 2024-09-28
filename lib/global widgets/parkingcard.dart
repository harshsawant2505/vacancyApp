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
  bool paid = true;
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
                        widget.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.distance}m",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            paid ? "Paid" : "Free",
                            style: TextStyle(
                                fontSize: 14,
                                color: paid ? Colors.red : Colors.green),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.vacancy} spots remaining",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.green),
                      ),
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

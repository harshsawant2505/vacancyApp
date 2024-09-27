// ignore_for_file: file_names

import 'package:bits_hackathon/global%20widgets/parkingcard.dart';
import 'package:bits_hackathon/global%20widgets/searchbar.dart';
import 'package:bits_hackathon/mobile/Pages/map%20page/mappage.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(alignment: Alignment.topLeft, children: [
        Container(
          height: MediaQuery.of(context).size.height / 2 + 10,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
          child: const Center(
            child: MapPage(),
          ),
        ),
        MainSearchBar(controller: controller),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height / 2 + 10,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 17),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ParkingCard(
                      title:
                          "$index park with a fucking long name that should break it",
                      distance: "${index * 100}",
                      vacancy: 100);
                }),
          ),
        )
      ]),
    ));
  }
}

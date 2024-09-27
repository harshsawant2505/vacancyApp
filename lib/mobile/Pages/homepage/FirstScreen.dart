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
      body: Stack(alignment: Alignment.topCenter, children: [
        //put map inside
        Container(
          height: MediaQuery.of(context).size.height / 2 + 10,
          width: MediaQuery.of(context).size.width-10,
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
            width: MediaQuery.of(context).size.width - 10,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: ListView.builder(
                itemCount: 5 + 1, //+1 for index
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox(height: 10);
                  }
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

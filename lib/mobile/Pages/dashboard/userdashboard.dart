import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Dashboard"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 15),
            children: const [
              Text(
                "Name",
                style: TextStyle(fontSize: 25),
              ),
              Text("email@email.com"),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return const MyVehicle();
              })
        ],
      ),
    );
  }
}

class MyVehicle extends StatelessWidget {
  const MyVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            children: [
              Text(
                "Car model",
                style: TextStyle(fontSize: 17),
              ),
              Text("Number")
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Help and Service",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: const Column(
        children: [
          Center(
            child: Text(
              "Help lines numbers and options.",
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}

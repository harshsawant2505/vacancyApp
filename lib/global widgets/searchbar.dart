import 'dart:convert';

import 'package:bits_hackathon/mobile/Pages/dashboard/dashboardpopup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MainSearchBar extends StatefulWidget {
  final TextEditingController controller;

  const MainSearchBar({super.key, required this.controller});

  @override
  State<MainSearchBar> createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  List<Map> parkingSpots = [];
  void getData(String name) async {
    const url = "http://localhost:8000/getParkingSpots";
    final Map<String, dynamic> jsonData = {
      'city': name,
    };

    try {
      // final res = await http.post(Uri.parse(url), body: {"city": name});
      final res = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData), // Encode the Map to JSON
      );

      if (res.statusCode == 200) {
        print(res.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 12, vertical: MediaQuery.of(context).size.height / 70),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(200),
        child: SizedBox(
          height: 50,
          child: Stack(
            children: [
              TextField(
                controller: widget.controller,
                cursorColor: Colors.black,
                cursorWidth: 1,
                onSubmitted: (value) {
                  getData(value);
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                      gapPadding: 30,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                    ),
                    hintText: "Search"),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showBottomSheet(
                            context: context,
                            builder: (context) {
                              return const AccountPopUp();
                            });
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(width: 7),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool ispassword;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.icon,
      this.ispassword = false});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(15),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.ispassword,
          cursorColor: Colors.black,
          cursorWidth: 1,
          decoration: InputDecoration(
              prefixIcon: Icon(
                widget.icon,
                color: Colors.grey,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                gapPadding: 30,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              hintText: widget.hint),
        ),
      ),
    );
  }
}

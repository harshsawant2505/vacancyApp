import 'dart:convert';

import 'package:bits_hackathon/globalvariables.dart';
import 'package:bits_hackathon/mobile/Pages/dashboard/dashboardpopup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MainSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback func, func2;

  const MainSearchBar(
      {super.key,
      required this.controller,
      required this.func,
      required this.func2});

  @override
  State<MainSearchBar> createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  Future<void> getData(String name) async {
    const url = "https://node-api-5kc9.onrender.com/parkingdetails";
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
        List<dynamic> listOfMaps = json.decode(res.body);
        List<Map<String, dynamic>> castedList =
            List<Map<String, dynamic>>.from(listOfMaps);

        parkingSpots.clear();
        print("got searched data");
        setState(() {
          isLoading = false;
          parkingSpots.addAll(castedList);
        });
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
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
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    print('getting searched data');
                    isLoading = true;
                    widget.func2();
                    await getData(value);
                    parkingSpots.forEach((map) {
                      isLoading = false;
                    });
                    setState(() {
                      parkingSpots = parkingSpots;
                      print(parkingSpots);
                    });
                  }
                },
                onChanged: (value) {
                  if (value.isEmpty) {
                    print('getting all data from search');
                    widget.func();
                    setState(() {});
                  }
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
        color: Colors.grey.shade200,
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

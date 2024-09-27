import 'package:flutter/material.dart';

class MainSearchBar extends StatefulWidget {
  final TextEditingController controller;
  const MainSearchBar({super.key, required this.controller});

  @override
  State<MainSearchBar> createState() => _MainSearchBarState();
}

class _MainSearchBarState extends State<MainSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(200),
        child: TextField(
          controller: widget.controller,
          cursorColor: Colors.black,
          cursorWidth: 1,
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
      ),
    );
  }
}

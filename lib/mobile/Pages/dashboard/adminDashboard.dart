import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as h;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final controller = TextEditingController();
  List<Map> gpsList = [];
  void getData(String name) async {
    const url = "https://node-api-5kc9.onrender.com/parkingdetails";
    final Map<String, dynamic> jsonData = {
      'city': name,
    };
    try {
      final res = await h.post(
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

        gpsList.clear();
        gpsList.addAll(castedList);
        setState(() {
          gpsList = gpsList;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    print("entered");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Police DashBoard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownMenu(
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 'panaji', label: "Panaji"),
                    DropdownMenuEntry(value: 'porvorim', label: "Porvorim"),
                    DropdownMenuEntry(value: 'vasco', label: "Vasco"),
                    DropdownMenuEntry(value: 'bicholim', label: "Bicholim"),
                    DropdownMenuEntry(value: 'calangute', label: "Calangute"),
                    DropdownMenuEntry(value: 'mopa', label: "Mopa"),
                    DropdownMenuEntry(value: 'Anjuna', label: "Anjuna"),
                    DropdownMenuEntry(value: 'mapusa', label: "Mapusa"),
                    DropdownMenuEntry(value: 'quepem', label: "Quepem"),
                    DropdownMenuEntry(value: 'canacona', label: "Canacona"),
                    DropdownMenuEntry(value: 'colva', label: "Colva"),
                    DropdownMenuEntry(value: 'curchorem', label: "Curchorem"),
                  ],
                  onSelected: (value) {
                    setState(() {
                      String lol = value!;
                      getData(lol);
                    });
                  },
                  hintText: "Location",
                  width: MediaQuery.of(context).size.width - 20,
                  controller: controller,
                ),
                Visibility(
                    visible: gpsList.isNotEmpty,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "4 wheelers",
                          style: TextStyle(fontSize: 20),
                        ),
                        Graph(
                          gpsList: gpsList,
                          type: '4w',
                          occtype: '4w_occ',
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "2 wheelers",
                          style: TextStyle(fontSize: 20),
                        ),
                        Graph(
                          gpsList: gpsList,
                          type: '2w',
                          occtype: '2w_occ',
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Graph extends StatefulWidget {
  final List<Map> gpsList;
  final String type, occtype;
  const Graph(
      {super.key,
        required this.gpsList,
        required this.type,
        required this.occtype});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.only(bottom: 3),
          width: MediaQuery.of(context).size.width - 16,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).size.width -
                35,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.gpsList.length,
              itemBuilder: (context, index) {
                double percent = (widget.gpsList[index][widget.type] -
                    widget.gpsList[index][widget.occtype]) /
                    widget.gpsList[index][widget.type] !=
                    0
                    ? widget.gpsList[index][widget.type]
                    : 1;
                if (percent > 1.00) {
                  percent = 1.00;
                }
                return GraphBar(
                  entry: widget.gpsList[index],
                  percent: percent,
                );
              }),
        ),
      ),
    );
  }
}

class GraphBar extends StatefulWidget {
  final Map entry;
  final double percent;
  const GraphBar({super.key, required this.entry, required this.percent});

  @override
  State<GraphBar> createState() => _GraphBarState();
}

class _GraphBarState extends State<GraphBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              widget.entry['place'],
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: MediaQuery.of(context).size.width - 30,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(6)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: widget.percent == 0
                        ? 5
                        : (widget.percent * MediaQuery.of(context).size.width) -
                        43,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: widget.percent >= 0.50
                          ? Colors.green
                          : widget.percent >= 0.25
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ),
                Text(
                  "${(widget.percent * 100).toStringAsFixed(0)}%",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
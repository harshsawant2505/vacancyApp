import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchWebsite(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        centerTitle: true,
        title: const Text(
          "Help and Service",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Help lines numbers and options.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("Police emergency number: 100"),
                onTap: () {
                  _makePhoneCall('tel:100');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("Senior citizen helpline: 1090"),
                onTap: () {
                
                  _makePhoneCall('tel:1090');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("Women helpline number: 1091"),
                onTap: () {
                  _makePhoneCall('tel:1091');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("Anti terror helpline: 1093"),
                onTap: () {
                  _makePhoneCall('tel:1093');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("SP SPCR: 2425534"),
                onTap: () {
                  _makePhoneCall('tel:2425534');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("Ambulance: 108"),
                onTap: () {
                  _makePhoneCall('tel:108');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("Fire Department: 101"),
                onTap: () {
                  _makePhoneCall('tel:101');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text("Child Helpline number: 1098"),
                onTap: () {
                  _makePhoneCall('tel:1098');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.mail),
                title: const Text("Traffic cell Email"),
                onTap: () async {
                  FlutterEmailSender.send(Email(
                      body: "",
                      recipients: ['complaint@goapolice.gov.in'],
                      isHTML: true));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.web_asset_rounded),
                title: const Text(
                    "Goa-Police website: https://citizen.goapolice.gov.in/"),
                onTap: () {
                  _launchWebsite("https://citizen.goapolice.gov.in/");
                },
                //complaint@goapolice.gov.in
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text(
                    "DGP (Director General of Police) Goa office number: 2428360"),
                onTap: () {
                  _makePhoneCall('tel:2428360');
                },
                //complaint@goapolice.gov.in
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                tileColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                leading: const Icon(Icons.call),
                title: const Text(
                    "IGP (Inspector General of Police) Goa office number: 2428738"),
                onTap: () {
                  _makePhoneCall('tel:2429738');
                },
                //complaint@goapolice.gov.in
              ),
            ),
          ],
        ),
      ),
    );
  }
}
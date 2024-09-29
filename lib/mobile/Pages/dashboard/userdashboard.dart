
import 'package:bits_hackathon/globalvariables.dart';
import 'package:bits_hackathon/mobile/Pages/homepage/FirstScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});


  Future<void> clearSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
  }

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
            padding: const EdgeInsets.all(15),
            children:[
              Text(
                token['name'],
                style: TextStyle(fontSize: 25), 
              ),
              Text(
                token['type'],
             
              ),
              Text(token['email']), 
               Text("Phone number: ${token['phNo']}"),

               ElevatedButton(
              onPressed: () {
                  clearSession();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return const FirstScreen();
                  }));
              },
              child:  const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
             
             
              ),
            ),
            ],
          ),
         
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

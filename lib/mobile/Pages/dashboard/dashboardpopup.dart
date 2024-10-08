import 'package:bits_hackathon/globalvariables.dart';
import 'package:bits_hackathon/mobile/Pages/complaints%20pages/complaints.dart';
import 'package:bits_hackathon/mobile/Pages/dashboard/adminDashboard.dart';
import 'package:bits_hackathon/mobile/Pages/dashboard/userdashboard.dart';
import 'package:bits_hackathon/mobile/Pages/loginpage.dart';
import 'package:flutter/material.dart';

class AccountPopUp extends StatelessWidget {
  const AccountPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.55,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              token['type'] == "none"
                  ? Row(
                      children: [
                        const Text("Not logged in "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const LoginPage();
                            }));
                          },
                          child: const Text(
                            "sign up/in your account",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    )
                  :  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                           token['name'],
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          token['email'],
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
              Visibility(
                visible: token['type'] != 'none',
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Dashboard();
                    }));
                  },
                  child: const MenuButton(
                      icon: Icons.account_circle, text: "Account"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ComplaintsPage();
                  }));
                },
                child: const MenuButton(icon: Icons.feedback, text: "Complain"),
              ),
              Visibility(
                visible: token['type'] == 'police',
                //TODO: to be replaced with the initState condition when connected to backend
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AdminDashboard();
                    }));
                  },
                  child: const MenuButton(
                      icon: Icons.local_police, text: "Police DashBoard"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const MenuButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(text),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:bits_hackathon/mobile/Pages/dashboard/userdashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountPopUp extends StatelessWidget {
  const AccountPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
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
              const Text(
                "name here",
                style: TextStyle(fontSize: 20),
              ),
              const Text(
                "email@email.com",
                style: TextStyle(fontSize: 13),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "working", toastLength: Toast.LENGTH_SHORT);
                },
                child: const MenuButton(
                    icon: Icons.account_circle, text: "Your account"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const MenuButton(icon: Icons.call, text: "Complain"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                      msg: "working", toastLength: Toast.LENGTH_SHORT);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return const Dashboard();
                      }));
                },
                child: const MenuButton(
                    icon: Icons.account_circle, text: "Account"),
              ),
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
        const Divider(),
        Row(
          children: [
            Icon(icon),
            const Spacer(),
            Text(text),
            const Spacer(flex: 5),
          ],
        ),
      ],
    );
  }
}
